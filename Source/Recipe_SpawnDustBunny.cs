using System.Collections.Generic;
using RimWorld;
using Verse;

namespace DustBunnies
{
    /// <summary>
    /// The whole mod, in one method: a recipe whose output is a live animal rather than an item.
    ///
    /// Notify_IterationCompleted is the right hook and still is in 1.6. Toils_Recipe's
    /// FinishRecipeAndStartStoringProduct calls it through Bill_Production, after the ingredients
    /// have been consumed and the (here empty) product list has been made, and before the job
    /// ends. The bill doer is standing on the crafting spot at that moment, which is where the
    /// bunny appears.
    /// </summary>
    public class Recipe_SpawnDustBunny : RecipeWorker
    {
        public override void Notify_IterationCompleted(Pawn billDoer, List<Thing> ingredients)
        {
            base.Notify_IterationCompleted(billDoer, ingredients);

            // Spawned covers the map being null. Nothing in vanilla calls this with an unspawned
            // doer, but the cost of being wrong here is a null map passed straight to GenSpawn.
            if (billDoer == null || !billDoer.Spawned)
            {
                return;
            }

            Pawn bunny = PawnGenerator.GeneratePawn(DustBunniesDefOf.DustBunny, billDoer.Faction);
            GenSpawn.Spawn(bunny, billDoer.Position, billDoer.Map, Rot4.Random);
        }
    }
}
