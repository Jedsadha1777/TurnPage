# PDF Batch Processor

## Requirements

```bash
# Ubuntu/Debian
sudo apt-get install poppler-utils nodejs npm

# macOS
brew install poppler node

# Windows
choco install poppler nodejs

npm install
```

## Usage

```bash
chmod +x batch-process.sh
./batch-process.sh
```

Processes all PDFs in current directory to:
```
batch/[PDF_NAME]/
├── index.json (metadata + links)
├── thumbnails/ (200px)
├── low/ (800px)
└── high/ (1600px)
```

## Manual Link Extraction

```bash
node extract-links.js input.pdf output.json
```

## Dependencies

**package.json**
```json
{
  "type": "module",
  "dependencies": {
    "pdfjs-dist": "^3.11.174"
  }
}
```

**System tools:**
- `pdftoppm` (from poppler-utils) - PDF to image conversion
- `node` - Run extract-links.js

**Script files:**
- `extract-links.js` - Extract hyperlinks from PDF
- `batch-process.sh` - Batch convert all PDFs