# Preview composition

The Preview is rendered by the shared renderer, `node ../scripts/Render-Preview.cjs` from the repository root, from
`Art/Preview.config.json`. It captures at 896 x 504 after the image and fonts load, verifies platform fonts, and writes
`Mod/About/Preview.png`. Its diagnostics (layout HTML, QA report, background-only picture) go under `Art/.render/`,
which git ignores: they are regenerated, not kept.

Tracked inputs, all in `Art/`:

- `Preview.config.json`: title hierarchy, copy, panel, echo and ModIcon placement, palette.
- `Preview-source.png`: the text-free illustration (the former `Preview.png`, byte-identical).
- `echo.png`: final-size transparent line-art, redrawn from the in-game
  `Mod/Textures/DustBunny/Bunny/Dust_Bunny_east.png` sprite. Apart from its final resize, its pixels and alpha are
  preserved: no threshold, morphology, cleanup or directional fade.
- `ModIcon-source.png`: the source of the ModIcon badge placed in the Preview's corner.

Tracked outputs: `Mod/About/Preview.png` (shipped), `Art/Gallery/0-preview.png` (byte-for-byte copy of it),
`Art/Preview.ico` and `Art/ModIcon.ico` (local folder icons, never inside `Mod/`).

After every render, inspect the full-size Preview and a 268 px thumbnail, refresh `Gallery/0-preview.png` and regenerate
`Art/Preview.ico` from the delivered Preview. The 2026-09 local renderer (`preview.html`, `render-preview.cjs`,
`preview-palette.json`) and its QA files were removed on 2026-10-02: git history has them.
