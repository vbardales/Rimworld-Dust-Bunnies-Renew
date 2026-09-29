// Cuts the near-black square background out of Mod/About/ModIcon.png (it is not actually transparent:
// alpha channel reads 255 everywhere) by chroma-keying the uniform background colour, with a soft edge
// so the ring stays clean. Writes Art/ModIcon-cutout.png. Run: node Art/cutout-icon.cjs
const sharp = require('sharp');
const path = require('path');

const root = path.join(__dirname, '..');
const iconPath = path.join(root, 'Mod/About/ModIcon.png');
const outPath = path.join(root, 'Art/ModIcon-cutout.png');

const BG = [14, 4, 0]; // sampled from all four corners
const HARD = 16;  // below this distance: fully transparent
const SOFT = 45;  // above this distance: fully opaque; ramp between HARD and SOFT

async function main() {
  const { data, info } = await sharp(iconPath).raw().ensureAlpha().toBuffer({ resolveWithObject: true });
  const out = Buffer.from(data);
  for (let i = 0; i < data.length; i += 4) {
    const dr = data[i] - BG[0];
    const dg = data[i + 1] - BG[1];
    const db = data[i + 2] - BG[2];
    const dist = Math.sqrt(dr * dr + dg * dg + db * db);
    let alpha;
    if (dist <= HARD) alpha = 0;
    else if (dist >= SOFT) alpha = 255;
    else alpha = Math.round(((dist - HARD) / (SOFT - HARD)) * 255);
    out[i + 3] = Math.min(data[i + 3], alpha);
  }
  await sharp(out, { raw: { width: info.width, height: info.height, channels: 4 } }).png().toFile(outPath);
  console.log('wrote', outPath);
}

main().catch((e) => { console.error(e); process.exit(1); });
