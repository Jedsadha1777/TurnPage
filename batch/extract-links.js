import fs from 'fs';
import { getDocument } from 'pdfjs-dist/legacy/build/pdf.mjs';

const inputPath = process.argv[2];
const outputPath = process.argv[3];

if (!inputPath || !outputPath) {
  console.error('❌ Usage: node extract-links.js input.pdf output.json');
  process.exit(1);
}

async function extractLinks(pdfPath, jsonPath) {
  try {
    const data = new Uint8Array(fs.readFileSync(pdfPath));
    const pdf = await getDocument({ data }).promise;

    const allLinks = [];
    const pageSizes = [];

    console.log(`Extracting links from ${pdf.numPages} pages...`);

    for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
      const page = await pdf.getPage(pageNum);
      const viewport = page.getViewport({ scale: 1.0 });
      const annotations = await page.getAnnotations();

      pageSizes.push({
        width: viewport.width,
        height: viewport.height
      });

      const pageLinks = annotations
        .filter(ann => ann.subtype === 'Link')
        .map(ann => {
          const transform = viewport.transform;

          const applyTransform = (x, y, m) => [
            m[0] * x + m[2] * y + m[4],
            m[1] * x + m[3] * y + m[5]
          ];

          const [x1, y1, x2, y2] = ann.rect;
          const [tx1, ty1] = applyTransform(x1, y1, transform);
          const [tx2, ty2] = applyTransform(x2, y2, transform);

          return {
            transformedRect: [
              Math.min(tx1, tx2),
              Math.min(ty1, ty2),
              Math.max(tx1, tx2),
              Math.max(ty1, ty2)
            ],
            url: ann.url || null,
            dest: ann.dest || null,
            destPage: null
          };
        });

      // index = pageNum - 1
      allLinks.push(pageLinks);

      for (const link of pageLinks) {
        if (link.dest && Array.isArray(link.dest)) {
          try {
            const destRef = link.dest[0];
            const pageIndex = await pdf.getPageIndex(destRef);
            link.destPage = pageIndex;
          } catch (err) {
          }
        }
      }

    }

    // read JSON 
    let jsonData = {};
    if (fs.existsSync(jsonPath)) {
      const existingContent = fs.readFileSync(jsonPath, 'utf8');
      jsonData = JSON.parse(existingContent);
    }

    // add links 
    jsonData.links = allLinks;
    jsonData.pageSizes = pageSizes;

    // save
    fs.writeFileSync(jsonPath, JSON.stringify(jsonData, null, 2));


    const totalLinks = allLinks.reduce((sum, pageLinks) => sum + pageLinks.length, 0);
    console.log(`Found ${totalLinks} links in total`);

  } catch (error) {
    console.error('❌ Error extracting links:', error.message);
    process.exit(1);
  }
}


extractLinks(inputPath, outputPath)
  .then(() => process.exit(0))
  .catch(err => {
    console.error('❌ Failed:', err);
    process.exit(1);
  });