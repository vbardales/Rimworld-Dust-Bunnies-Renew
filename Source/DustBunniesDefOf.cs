using RimWorld;
using Verse;

namespace DustBunnies
{
    /// <summary>
    /// The original held its PawnKindDef in a static field initialised inline with
    /// <c>DefDatabase&lt;PawnKindDef&gt;.GetNamed("DustBunny", true)</c>. That runs whenever the
    /// CLR first touches the type, which is not a moment this mod controls, and a failure there
    /// surfaces as a TypeInitializationException with the real cause buried two levels down.
    /// A [DefOf] class is bound by DefOfHelper.RebindAllDefOfs once the database is complete,
    /// and again after any reload, which is what this needs.
    /// </summary>
    [DefOf]
    public static class DustBunniesDefOf
    {
        public static PawnKindDef DustBunny;

        static DustBunniesDefOf()
        {
            DefOfHelper.EnsureInitializedInCtor(typeof(DustBunniesDefOf));
        }
    }
}
