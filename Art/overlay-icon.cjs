// Composites the cut-out ModIcon onto Preview.png, popping out of the emptier corner, rotated,
// overflowing past the side and bottom edges. Run: node Art/overlay-icon.cjs
const sharp = require('sharp');
const path = require('path');

const root = path.join(__dirname, '..');
const previewPath = path.join(root, 'Mod/About/Preview.png');
const iconPath = path.join(root, 'Art/ModIcon-cutout.png');
const outPath = path.join(root, 'Art/preview-with-icon-preview.png');

const CORNER = process.argv[2] || 'left'; // 'left' (+15deg) or 'right' (-15deg)
const ANGLE = CORNER === 'left' ? 15 : -15;
const ICON_SIZE = 220; // square, before rotation

async function main() {
  const preview = sharp(previewPath);
  const { width: W, height: H } = await preview.metadata();

  const rotated = await sharp(iconPath)
    .resize(ICON_SIZE, ICON_SIZE, { kernel: 'lanczos3' })
    .rotate(ANGLE, { background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();
  const rm = await sharp(rotated).metadata();

  // Bottom corner, popping out: most of the icon's outer (left or right) and bottom edge overflow past the frame.
  const overflowFrac = 0.28;
  let left;
  if (CORNER === 'left') {
    left = Math.round(-rm.width * overflowFrac);
  } else {
    left = Math.round(W - rm.width * (1 - overflowFrac));
  }
  const top = Math.round(H - rm.height * 0.78);

  await sharp(previewPath)
    .composite([{ input: rotated, left, top }])
    .png()
    .toFile(outPath);

  console.log(`corner=${CORNER} angle=${ANGLE} icon=${rm.width}x${rm.height} left=${left} top=${top} canvas=${W}x${H}`);
  console.log('wrote', outPath);
}

main().catch((e) => { console.error(e); process.exit(1); });
