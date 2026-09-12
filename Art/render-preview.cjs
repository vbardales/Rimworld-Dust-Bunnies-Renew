// Requires playwright and sharp on NODE_PATH. Uses installed Chrome by default.
// node Art/render-preview.cjs [chrome executable]
const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const {chromium} = require('playwright');
const sharp = require('sharp');
const root = path.resolve(__dirname, '..');
const qa = path.join(__dirname, 'preview-qa');
const luminance = rgb => rgb.map(c=>c/255).map(c=>c<=.04045?c/12.92:((c+.055)/1.055)**2.4)
  .reduce((sum,c,i)=>sum+c*[.2126,.7152,.0722][i],0);
const contrast = (a,b) => (Math.max(a,b)+.05)/(Math.min(a,b)+.05);
const hexL = hex => luminance(hex.slice(1).match(/../g).map(c=>parseInt(c,16)));
(async()=> {
  fs.mkdirSync(qa,{recursive:true});
  const server = http.createServer((req,res)=> {
    const file = path.resolve(root, '.'+decodeURIComponent(req.url.split('?')[0]));
    if(!file.startsWith(root+path.sep)) {res.writeHead(403).end();return;}
    fs.readFile(file,(error,bytes)=> {
      if(error) {res.writeHead(404).end();return;}
      const mime={'.html':'text/html; charset=utf-8','.json':'application/json','.xml':'text/xml','.png':'image/png'};
      res.setHeader('Content-Type',mime[path.extname(file)]||'application/octet-stream');res.end(bytes);
    });
  });
  await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
  let browser;
  try {
    browser = await chromium.launch({executablePath:process.argv[2]||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
    const page = await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
    await page.goto(`http://127.0.0.1:${server.address().port}/Art/preview.html`);
    const params = await page.evaluate(()=>window.previewReady);
    const cdp = await page.context().newCDPSession(page);
    await cdp.send('DOM.enable'); await cdp.send('CSS.enable');
    const {root:doc} = await cdp.send('DOM.getDocument');
    const report = {size:[896,504],version:params.version, fonts:{},contrast:{},bounds:{}};
    const targets={'.strong':'inkPrimary','.suffix':'inkSecondary','.tag':'inkSecondary','.summary':'inkPrimary','.version':'badgeInk'};
    for(const selector of Object.keys(targets)) {
      const {nodeId} = await cdp.send('DOM.querySelector',{nodeId:doc.nodeId,selector});
      report.fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
      report.bounds[selector]=await page.locator(selector).boundingBox();
    }
    const final = await page.screenshot();
    await sharp(final).png({compressionLevel:9,effort:10}).toFile(path.join(root,'Mod/About/Preview.png'));
    await sharp(final).resize(268).png().toFile(path.join(qa,'Preview-268.png'));
    // Preserve layout while removing letters and their shadows; sample every pixel in each
    // text rectangle, a stricter check than the four corners requested by the guide.
    await page.addStyleTag({content:'.plate,.version { visibility:hidden; }'});
    const background = await page.screenshot({path:path.join(qa,'background.png')});
    const {data,info} = await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
    for(const [selector,key] of Object.entries(targets)) {
      const rect = report.bounds[selector]; let min=Infinity,at=null;
      if(selector==='.version') min=contrast(hexL(params.palette[key]),hexL(params.palette.accent));
      else for(let y=Math.floor(rect.y); y<Math.ceil(rect.y+rect.height); y++)
        for(let x=Math.floor(rect.x); x<Math.ceil(rect.x+rect.width); x++) {
          const i=(y*info.width+x)*info.channels;
          const ratio=contrast(hexL(params.palette[key]),luminance([...data.subarray(i,i+3)]));
          if(ratio<min) {min=ratio;at=[x,y];}
        }
      report.contrast[selector]={minimum:min,at};
      if(min<4.5) report.failed=true;
    }
    report.bytes=fs.statSync(path.join(root,'Mod/About/Preview.png')).size;
    if(report.bytes>=900000) report.failed=true;
    for(const fonts of Object.values(report.fonts)) if(!fonts.length || fonts.some(f=>!f.familyName.startsWith('Segoe UI'))) report.failed=true;
    fs.writeFileSync(path.join(qa,'report.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify(report,null,2));
    if(report.failed) throw Error('Preview QA failed');
  } finally {if(browser) await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
