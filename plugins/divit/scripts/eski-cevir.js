// Mac: eski PowerPoint (.ppt) ve Excel (.xls) dosyasının bir kopyasını Apple'ın
// Keynote / Numbers programıyla .pptx / .xlsx'e çevirir (.doc için textutil yeter).
// Asıl dosya değişmez; çıktı yalnız .divit/gecici/ altına yazılır; gizli/ ve
// hakemlik/ klasörlerindeki dosyalar açılmaz. Program önceden açık değilse iş
// bitince kapatılır; açıksa yalnız bu dosyanın penceresi kapanır.
// Kullanım: osascript -l JavaScript eski-cevir.js <girdi.ppt|xls> <.divit/gecici/ad.pptx|xlsx>
// Çıktı tek satır: TAMAM <çıktı> | HATA PROGRAM-YOK | HATA IZIN-YOK | HATA ZAMAN-ASIMI | HATA <neden>
// Windows eşi: eski-cevir.ps1 (aynı cevaplar).
ObjC.import('Foundation');

function run(argv) {
  if (argv.length < 2) return 'HATA Kullanım: eski-cevir.js <girdi.ppt|xls> <.divit/gecici/ad.pptx|xlsx>';
  var fm = $.NSFileManager.defaultManager;
  var cwd = fm.currentDirectoryPath.js;
  function tam(p) {
    return $(p.charAt(0) === '/' ? p : cwd + '/' + p).stringByStandardizingPath.js;
  }
  var girdi = tam(argv[0]);
  var cikti = tam(argv[1]);
  var turler = {
    ppt: { yeni: 'pptx', program: 'Keynote', bicim: 'Microsoft PowerPoint' },
    xls: { yeni: 'xlsx', program: 'Numbers', bicim: 'Microsoft Excel' }
  };
  var uzanti = girdi.split('.').pop().toLowerCase();
  var tur = turler[uzanti];

  if (!fm.fileExistsAtPath(girdi)) return 'HATA Dosya bulunamadı: ' + argv[0];
  if (!tur) return 'HATA Yalnız .xls ve .ppt çevrilir (.doc için textutil).';
  if (/\/(gizli|hakemlik)\//.test(girdi)) return 'HATA Bu klasördeki dosyalar okunmaz.';
  if (cikti.split('.').pop().toLowerCase() !== tur.yeni) return 'HATA Çıktı .' + tur.yeni + ' olmalı.';
  if (!/\/\.divit\/gecici\//.test(cikti)) return 'HATA Çıktı yalnız .divit/gecici/ altına yazılır.';
  fm.createDirectoryAtPathWithIntermediateDirectoriesAttributesError(
    $(cikti).stringByDeletingLastPathComponent, true, $(), null);

  var app;
  try {
    app = Application(tur.program);
    app.id();
  } catch (e) {
    return 'HATA PROGRAM-YOK';
  }
  var acikti = app.running();
  var belge = null;
  var sonuc;
  try {
    belge = app.open(Path(girdi));
    app.export(belge, { to: Path(cikti), as: tur.bicim });
    sonuc = fm.fileExistsAtPath(cikti) ? 'TAMAM ' + argv[1] : 'HATA Program dosyayı kaydetmedi.';
  } catch (e) {
    var no = e.errorNumber;
    if (no === -1743) sonuc = 'HATA IZIN-YOK';          // kullanıcı Otomasyon iznini vermedi
    else if (no === -1712) sonuc = 'HATA ZAMAN-ASIMI';  // program yanıt vermedi (şifre sorusu da olabilir)
    else sonuc = 'HATA ' + String(e.message || e).replace(/\s+/g, ' ');
  }
  try { if (belge) belge.close({ saving: 'no' }); } catch (e) { }
  try { if (!acikti) app.quit({ saving: 'no' }); } catch (e) { }
  return sonuc;
}
