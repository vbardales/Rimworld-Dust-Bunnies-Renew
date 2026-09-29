// Composites Art/ModIcon-cutout.png (produced by _tools/cutout-icon.cjs) onto Mod/About/Preview.png,
// popping out of the emptier corner of the scene, rotated, its side and bottom edges bleeding off
// the frame. Run: node _tools/overlay-icon.cjs [left|right]
// 'left' tilts +15deg (bottom-left corner); 'right' tilts -15deg (bottom-right corner).
const sharp = require('sharp');
const path = require('path');

const root = path.resolve(__dirname, '..');
const previewPath = path.join(root, 'Mod/About/Preview.png');
const iconPath = path.join(root, 'Art/ModIcon-cutout.png');

const CORNER = process.argv[2] || 'left';
const ANGLE = CORNER === 'left' ? 15 : -15;
const ICON_SIZE = 260; // square, before rotation

async function main() {
  const previewBuffer = await sharp(previewPath).toBuffer();
  const { width: W, height: H } = await sharp(previewBuffer).metadata();

  const rotated = await sharp(iconPath)
    .resize(ICON_SIZE, ICON_SIZE, { kernel: 'lanczos3' })
    .rotate(ANGLE, { background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();
  const rm = await sharp(rotated).metadata();

  const overflowFrac = 0.28; // how much of the icon's outer edge bleeds past the side
  const left = CORNER === 'left'
    ? Math.round(-rm.width * overflowFrac)
    : Math.round(W - rm.width * (1 - overflowFrac));
  const top = Math.round(H - rm.height * 0.78); // how much bleeds past the bottom

  await sharp(previewBuffer)
    .composite([{ input: rotated, left, top }])
    .png()
    .toFile(previewPath);

  console.log(`corner=${CORNER} angle=${ANGLE} icon=${rm.width}x${rm.height} left=${left} top=${top} canvas=${W}x${H}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
