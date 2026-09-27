// Mac: PDF'ten metin çıkarır (macOS'un kendi PDFKit'i; kurulum gerekmez).
// Kullanım: osascript -l JavaScript pdf-metin.js <girdi.pdf> <cikti.txt> [ilk-sayfa] [son-sayfa]
ObjC.import('PDFKit');
ObjC.import('Foundation');
function run(argv) {
  var doc = $.PDFDocument.alloc.initWithURL($.NSURL.fileURLWithPath(argv[0]));
  if (!doc || doc.isNil()) return 'HATA: PDF açılamadı';
  var n = doc.pageCount;
  var ilk = argv[2] ? parseInt(argv[2], 10) : 1;
  var son = argv[3] ? Math.min(parseInt(argv[3], 10), n) : n;
  var parca = [];
  for (var i = ilk; i <= son; i++) {
    var s = doc.pageAtIndex(i - 1).string;
    parca.push('\n=== Sayfa ' + i + ' ===\n' + (s && !s.isNil() ? s.js : ''));
  }
  $(parca.join('\n')).writeToFileAtomicallyEncodingError(argv[1], true, $.NSUTF8StringEncoding, null);
  return n + ' sayfa; ' + ilk + '-' + son + ' yazıldı';
}
