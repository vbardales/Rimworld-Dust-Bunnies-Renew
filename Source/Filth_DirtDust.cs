using RimWorld;
using Verse;
using Verse.AI;

namespace DustBunnies
{
    /// <summary>
    /// Dirt filth that leaves one Dust behind when a colonist sweeps it away.
    ///
    /// Vanilla destroys a filth when its thickness reaches zero: the cleaning job calls
    /// Filth.ThinFilth, which destroys the thing. Rain, time and animals also destroy filth, and none of those
    /// may give Dust, so the yield is conditional on a pawn running the Clean job on this very thing at that moment.
    /// The class replaces Filth_Dirt's thingClass through Patches/FilthDirtDust.xml, guarded so that a def
    /// another mod has already given its own class is left alone.
    /// </summary>
    public class Filth_DirtDust : Filth
    {
        public override void Destroy(DestroyMode mode = DestroyMode.Vanish)
        {
            Map map = Map;
            IntVec3 cell = Position;
            bool swept = Spawned && IsBeingCleaned(map);

            base.Destroy(mode);

            if (swept && DustBunniesDefOf.Dust != null)
            {
                Thing dust = ThingMaker.MakeThing(DustBunniesDefOf.Dust);
                dust.stackCount = 1;
                GenPlace.TryPlaceThing(dust, cell, map, ThingPlaceMode.Near);
            }
        }

        private bool IsBeingCleaned(Map map)
        {
            if (map == null)
            {
                return false;
            }

            var pawns = map.mapPawns.AllPawnsSpawned;
            for (int i = 0; i < pawns.Count; i++)
            {
                Job job = pawns[i].CurJob;
                if (job != null && job.def == JobDefOf.Clean && job.targetA.Thing == this)
                {
                    return true;
                }
            }

            return false;
        }
    }
}
