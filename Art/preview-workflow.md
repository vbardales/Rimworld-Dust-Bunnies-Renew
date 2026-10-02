# Preview composition

Run `node ../scripts/Render-Preview.cjs` from the repository root. The shared renderer captures
at 896 x 504 after the image and fonts load, verifies platform fonts, and writes the final PNG,
HTML and QA artifacts.

- `Preview.png`: retained text-free illustration, byte-identical to `Preview-source.png`.
- `preview-copy.json`: exact title hierarchy, copy, panel, echo and ModIcon placement.
- `echo.png`: final-size transparent line-art, redrawn from the real in-game
  `Mod/Textures/DustBunny/Bunny/Dust_Bunny_east.png` sprite. Apart from its final resize, the
  generated pixels and alpha are preserved: no threshold, morphology, cleanup or directional fade.
- `ModIcon-cutout.png`: preserved high-resolution true-alpha source. `ModIcon-badge.png` is its
  alpha-trimmed composition derivative; no useful interior pixels are removed.
- `preview-palette.json`: the only source of overlay colours.
- `Preview-layout.html`, `preview-qa.json` and `Preview-background-qa.png`: shared-renderer QA artifacts.
- `Gallery/0-preview.png`: byte-for-byte copy of `Mod/About/Preview.png`.

The former local HTML and renderer remain historical evidence only. After every render, inspect
the full-size preview and a 268 px thumbnail, refresh the gallery copy and regenerate
`Art/Preview.ico` from the final delivered preview.
