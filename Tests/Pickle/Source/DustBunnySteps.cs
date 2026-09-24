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

        private static ThingDef AnimalDef(PickleContext ctx, string defName)
        {
            var def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Assert(def != null, $"no ThingDef named {defName}");
            ctx.Assert(def.race != null, $"{defName} is not a race");
            return def;
        }

        /// <summary>The defNames of the surgeries an animal def is offered, sorted so two lists compare.</summary>
        private static List<string> Surgeries(ThingDef animal)
        {
            return animal.AllRecipes.Where(r => r.IsSurgery).Select(r => r.defName).OrderBy(n => n).ToList();
        }

        /// <summary>
        /// A Dog Said... Animal Prosthetics 2 files every animal in category lists, and adds surgeries by
        /// listing an animal in a recipe's recipeUsers. No surgery is named here on purpose: the recipes come
        /// from elsewhere and their names are not this mod's to know. The assertion compares what the dust
        /// bunny is offered with what a reference animal of the category it should be in is offered, so it
        /// holds whatever ADS 2 calls its recipes, and it fails saying which surgeries differ.
        /// </summary>
        [Then("Dust Bunnies Renew: the dust bunny is offered the same surgeries as the {string}")]
        public void SameSurgeriesAs(PickleContext ctx, string referenceDefName)
        {
            var mine = Surgeries(AnimalDef(ctx, KindDefName));
            var theirs = Surgeries(AnimalDef(ctx, referenceDefName));
            ctx.Assert(mine.Count > 0,
                "the dust bunny is offered no surgery at all: ADS 2 is not loaded, or this mod's patch ran after ADS 2 copied its lists");
            ctx.Assert(mine.SequenceEqual(theirs),
                $"the dust bunny is offered {mine.Count} surgeries and the {referenceDefName} {theirs.Count}. Only the dust bunny: [{string.Join(", ", mine.Except(theirs))}]. Only the {referenceDefName}: [{string.Join(", ", theirs.Except(mine))}]");
        }

        /// <summary>The other half: a category-1 animal is not offered what only a category-3 animal is.</summary>
        [Then("Dust Bunnies Renew: the {string} is offered surgeries the dust bunny is not")]
        public void OfferedMoreThan(PickleContext ctx, string biggerDefName)
        {
            var mine = Surgeries(AnimalDef(ctx, KindDefName));
            var bigger = Surgeries(AnimalDef(ctx, biggerDefName));
            var extra = bigger.Except(mine).ToList();
            ctx.Assert(extra.Count > 0,
                $"the {biggerDefName} is offered no surgery the dust bunny is not: the dust bunny got the whole of the {biggerDefName}'s category, and bionics on it were not the intent");
        }
    }
}
