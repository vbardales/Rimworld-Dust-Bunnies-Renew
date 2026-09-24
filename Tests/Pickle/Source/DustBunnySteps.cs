using System.Collections.Generic;
using System.Linq;
using RimWorks.Pickle;
using RimWorld;
using Verse;

namespace DustBunnies.PickleSteps
{
    /// <summary>
    /// What no stock Pickle step reaches about this mod: that the DefOf class really bound the pawn kind
    /// the recipe worker spawns, whose side a made animal is on, what the living animal measures, and
    /// whether the game will let it be trained.
    ///
    /// Every phrase starts with "Dust Bunnies Renew:". Pickle matches steps on their text alone, across
    /// every suite loaded in a run, so an unprefixed phrase can collide with another suite's.
    ///
    /// Every measurement is taken from the LIVING animal, never from its def. That is the point of the
    /// suite's numbers: a def has no life stage, so its information card says the base body size of 0.2,
    /// while the animal's only life stage is AnimalBaby, factor 0.2, which makes it 0.04. The description
    /// once claimed the figure read off the def.
    /// </summary>
    [PickleSteps]
    public sealed class DustBunnySteps
    {
        private const string KindDefName = "DustBunny";

        private static Map Map(PickleContext ctx)
        {
            ctx.Require(Find.CurrentMap != null, "load a map before invoking a Dust Bunnies Renew step");
            return Find.CurrentMap;
        }

        private static List<Pawn> Bunnies(PickleContext ctx)
        {
            return Map(ctx).mapPawns.AllPawnsSpawned
                .Where(p => p.kindDef != null && p.kindDef.defName == KindDefName)
                .ToList();
        }

        /// <summary>The one spawned dust bunny. Two would make every later step ambiguous.</summary>
        private static Pawn TheBunny(PickleContext ctx)
        {
            var found = Bunnies(ctx);
            ctx.Assert(found.Count == 1, $"expected exactly one spawned dust bunny, found {found.Count}");
            return found[0];
        }

        private static string Describe(Pawn pawn)
        {
            string faction = pawn.Faction == null ? "no faction" : pawn.Faction.Name;
            return $"{pawn.LabelShort} ({faction}) at {pawn.Position}";
        }

        /// <summary>
        /// The recipe worker reads DustBunniesDefOf.DustBunny. A [DefOf] that did not bind is null, and the
        /// worker would then spawn nothing after consuming a hundred dust. Read by reflection, so this
        /// companion needs no reference to the mod's own assembly.
        /// </summary>
        [Then("Dust Bunnies Renew: the DefOf class has bound the dust bunny")]
        public void DefOfBound(PickleContext ctx)
        {
            var type = GenTypes.GetTypeInAnyAssembly("DustBunnies.DustBunniesDefOf");
            ctx.Assert(type != null, "DustBunnies.DustBunniesDefOf is not loaded: the mod's assembly did not load");
            var field = type.GetField("DustBunny");
            ctx.Assert(field != null, "DustBunniesDefOf has no field named DustBunny: it was renamed");
            var value = field.GetValue(null) as PawnKindDef;
            ctx.Assert(value != null,
                "DustBunniesDefOf.DustBunny is null: DefOfHelper did not bind it, so the recipe worker would spawn nothing");
            ctx.Assert(value.defName == KindDefName, $"DustBunniesDefOf.DustBunny is {value.defName}, expected {KindDefName}");
        }

        [Then("Dust Bunnies Renew: the map holds {int} dust bunny/bunnies")]
        public void MapHolds(PickleContext ctx, int expected)
        {
            var found = Bunnies(ctx);
            ctx.Assert(found.Count == expected,
                $"expected {expected} spawned dust bunnies, found {found.Count}: {string.Join("; ", found.Select(Describe))}");
        }

        /// <summary>
        /// A made animal takes the faction of whoever made it: the worker passes the bill doer's faction to
        /// PawnGenerator. A null faction there would leave a wild animal standing beside the colonist.
        /// </summary>
        [Then("Dust Bunnies Renew: the dust bunny belongs to the colony")]
        public void BelongsToColony(PickleContext ctx)
        {
            var bunny = TheBunny(ctx);
            ctx.Assert(bunny.Faction == Faction.OfPlayer, $"{Describe(bunny)} is not the colony's");
        }

        [Then("Dust Bunnies Renew: the dust bunny body size is between {float} and {float}")]
        public void BodySizeBetween(PickleContext ctx, float low, float high)
        {
            var bunny = TheBunny(ctx);
            float size = bunny.BodySize;
            var stage = bunny.ageTracker.CurLifeStage;
            ctx.Assert(size >= low && size <= high,
                $"body size is {size:F3}: life stage {stage.defName} factor {stage.bodySizeFactor} x base {bunny.RaceProps.baseBodySize}; expected {low} to {high}");
        }

        [Then("Dust Bunnies Renew: the dust bunny stat {string} is between {float} and {float}")]
        public void StatBetween(PickleContext ctx, string statDefName, float low, float high)
        {
            var stat = DefDatabase<StatDef>.GetNamedSilentFail(statDefName);
            ctx.Assert(stat != null, $"no StatDef named {statDefName}");
            var bunny = TheBunny(ctx);
            float value = bunny.GetStatValue(stat);
            ctx.Assert(value >= low && value <= high,
                $"{statDefName} of the living dust bunny is {value:F3}, expected {low} to {high}");
        }

        /// <summary>
        /// Training is gated by trainability and by a minimum body size, read from the living pawn. The
        /// refusal comes with its reason, so a "too small" says so instead of reading as a missing tab.
        /// </summary>
        [Then("Dust Bunnies Renew: the dust bunny can be assigned training {string}")]
        public void CanTrain(PickleContext ctx, string trainableDefName)
        {
            var trainable = DefDatabase<TrainableDef>.GetNamedSilentFail(trainableDefName);
            ctx.Assert(trainable != null, $"no TrainableDef named {trainableDefName}");
            var bunny = TheBunny(ctx);
            ctx.Require(bunny.training != null, "the dust bunny has no training tracker");
            AcceptanceReport report = bunny.training.CanAssignToTrain(trainable, out bool visible);
            ctx.Assert(report.Accepted,
                $"training {trainableDefName} is refused (shown to the player: {visible}): {report.Reason}");
        }

        /// <summary>
        /// The animal's name is written on two defs, the ThingDef and the PawnKindDef, and the player reads
        /// either. Both must carry the text of the language the pass runs in.
        /// </summary>
        [Then("Dust Bunnies Renew: the dust bunny animal is labelled {string}")]
        public void AnimalLabelled(PickleContext ctx, string expected)
        {
            var thing = DefDatabase<ThingDef>.GetNamedSilentFail(KindDefName);
            var kind = DefDatabase<PawnKindDef>.GetNamedSilentFail(KindDefName);
            ctx.Assert(thing != null, $"no ThingDef named {KindDefName}");
            ctx.Assert(kind != null, $"no PawnKindDef named {KindDefName}");
            ctx.Assert(thing.label == expected, $"the ThingDef {KindDefName} is labelled \"{thing.label}\", expected \"{expected}\"");
            ctx.Assert(kind.label == expected, $"the PawnKindDef {KindDefName} is labelled \"{kind.label}\", expected \"{expected}\"");
        }
    }
}
