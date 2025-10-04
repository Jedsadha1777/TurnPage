# Turnpage 

TurnPage is a simple flipbook viewer built with HTML Canvas.
It supports both direct PDF loading and pre-processed JSON with images, with smooth page-flip animation and mobile support.

You can view a live demo here: 
https://jedsadha1777.github.io/turnpage/


## Features
- PDF direct loading or pre-processed images (low/high-res)
- Page flip animation
- Zoom & pan
- Hyperlink support (internal/external)
- Auto portrait/landscape mode
- Touch support (iOS/Android)
- Thumbnail navigation


## How to Usage 

### PDF 

```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
</head>
<body>
  <canvas id="turnpage"></canvas>  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <script src="turnpage.js"></script>
  <script>
    const flipbook = new TurnPage('turnpage', {
      pdfUrl: 'document.pdf',              // Direct PDF
      autoLoad: true
    });
  </script>
</body>
</html>
```

### JSON (Recommnad) 

*To generate the JSON and image files, check out the ./batch folder. There’s a script in there that converts PDFs to JSON and creates images (thumbnail, low-res, and high-res) for this project.

```html
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
</head>
<body>
  <canvas id="turnpage"></canvas>  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <script src="turnpage.js"></script>
  <script>
    const flipbook = new TurnPage('turnpage', {
      jsonUrl: 'batch/mydoc/index.json',   // Pre-processed images + links
      autoLoad: true
    });
  </script>
</body>
</html>
```

## Options

```javascript
new TurnPage('canvasId', {
  pdfUrl: 'file.pdf',           // PDF source
  jsonUrl: 'data/index.json',   // Pre-processed source
  autoLoad: true,               // Auto-load on init
  singlePageMode: false,        // true = single, false = double page
  autoDetectMode: true          // Auto-detect portrait/landscape
});
```

## Dependencies

**Browser (CDN):**
- PDF.js 3.11.174 - https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js



## Browser Support

- Chrome/Edge/Firefox: Full support
- Safari/iOS: Full support (requires `touch-action: none` CSS)

## License

This project is open-sourced under the [MIT license](https://opensource.org/licenses/MIT). 
It also uses PDF.js https://github.com/mozilla/pdf.js, which is licensed under the Apache License 2.0.