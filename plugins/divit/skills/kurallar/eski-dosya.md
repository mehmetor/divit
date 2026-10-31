# Eski Word, Excel ve PowerPoint dosyası (.doc, .xls, .ppt)

pandoc yalnız yeni biçimleri (`.docx`, `.xlsx`, `.pptx`) okur; eski biçimleri
(büyük harfle `.DOC` vb. de) okuyamaz. Önce bir **kopyası** yeni biçimde
`.divit/gecici/`'ye çevrilir, sonra o kopya her zamanki yolla okunur (Word:
`kurallar` → "Word → metin"; Excel: `tablo` → "Gelen Excel"; PowerPoint:
`sunum` → "Gelen sunumu okumak"). Asıl dosya değişmez, taşınmaz. Komutlar
`kurallar` → "Dosyalarla çalışma" tablosundaki "Eski Word, Excel, PowerPoint"
satırıdır. Ad: `.divit/gecici/<ad>-<YYYY-AA-GG>.docx|xlsx|pptx`, ardından gelen
`.md` ile aynı kök (öğrenci dosyasında baş harfler, ad değil).

Hocaya "dönüştürme", "biçim", "doc/xls/ppt" gibi kelime kullanma; "eski Word
(Excel, PowerPoint) dosyası" de. Programları bu betikler dışında açtırma.

## Hangi program açılır

| Dosya | Windows (`eski-cevir.ps1`) | Mac |
|---|---|---|
| `.doc` | Word | hiçbiri: `textutil` (macOS'un kendi aracı) — **sormadan çevir** |
| `.xls` | Excel | Numbers (`eski-cevir.js`) |
| `.ppt` | PowerPoint | Keynote (`eski-cevir.js`) |

## Onay (program açılan her durumda)

1. `.divit/profil/onaylar.md`'yi Read ile oku. İçinde `- eski-dosya: her zaman`
   satırı varsa sormadan çalıştır.
2. Yoksa çalıştırmadan önce aynen sor; `<program>` yukarıdaki tablodan
   (bir sohbette bir kez; o sohbetteki bütün eski dosyalar için geçerlidir):
   > "Bu dosya <Word / Excel / PowerPoint>'in eski biçiminde kaydedilmiş, ben
   > doğrudan okuyamıyorum. Bilgisayarınızdaki <program> programını arka planda
   > kısa bir süre açıp dosyanın bir kopyasını yeni biçime çevirebilirim. Asıl
   > dosyanıza ve açık belgelerinize dokunmam.
   > 1) Evet, çevir
   > 2) Evet, bundan sonra eski dosyaları hiç sormadan çevir
   > 3) Hayır"
   Mac'te ilk seferde ekledir: "Mac bir kez 'Claude, <program>'ı denetlemek
   istiyor' diye sorabilir; **İzin Ver**'e basın."
3. **1** → çalıştır. **2** → önce satırı kaydet, sonra çalıştır:
   `onaylar.md` yoksa Write ile oluştur:
   ```
   # Onaylar

   Divit'e verdiğiniz kalıcı izinler. Bir satırı silerseniz Divit o işi yine sorar.

   - eski-dosya: her zaman (YYYY-AA-GG)
   ```
   Varsa Read sonra Edit ile sona ekle. Hocaya tek cümle: "Tamam, bundan sonra
   eski dosyaları sormadan çeviririm; 'artık sormadan çevirme' derseniz yine
   sorarım." **3** → "Farklı Kaydet" cümlesini söyle.
4. Hoca "artık sormadan çevirme", "programlarımı açma" derse satırı Edit ile
   kaldır, tek cümleyle söyle.

## Betiğin cevabı (tek satır)

| Cevap | Ne yap |
|---|---|
| `TAMAM <yol>` | O kopyayı oku, işe devam et. Hocaya çeviriyi ayrıca anlatma. |
| `HATA PROGRAM-YOK` | "Bilgisayarınızda <program> bulamadım, bu eski dosyayı açamıyorum. Dosyayı size gönderen kişiden yeni hâlini ya da PDF'ini isteyebilir misiniz?" |
| `HATA SIFRELI` | "Dosya şifreli. <Word / Excel / PowerPoint>'te şifresiyle açıp "Farklı Kaydet" ile yeni biçimde aynı klasöre kaydeder misiniz?" |
| `HATA IZIN-YOK` (Mac) | "Mac, <program>'ı açmama izin vermedi. **Sistem Ayarları → Gizlilik ve Güvenlik → Otomasyon**'da Claude'un altındaki <program> düğmesini açarsanız yeniden denerim." |
| `HATA ZAMAN-ASIMI` | "<program> arka planda yanıt vermedi, kapattım. <program>'ı bir kez kendiniz açıp ilk açılıştaki soruları kapatır mısınız? Sonra yeniden denerim." Mac'te dosya şifreli de olabilir: bunu da ekle. |
| `TAMAM` ama okuma boş, `textutil` hatası, başka `HATA …` | "Farklı Kaydet" cümlesi. |

Her `HATA`'yı `.divit/sorunlar.md`'ye **sessizce** yaz (`kurallar/istek.md` →
"Sorun notu biçimi"; betiğin satırını aynen ekle).

**"Farklı Kaydet" cümlesi:** "Bu dosya <Word / Excel / PowerPoint>'in eski
biçiminde. Açıp **Dosya → Farklı Kaydet** ile yeni biçimde (Word Belgesi
.docx / Excel Çalışma Kitabı .xlsx / PowerPoint Sunusu .pptx) aynı klasöre
kaydeder misiniz? Sonra hemen okurum."

Aynı istekte birden çok eski dosya varsa her biri için betiği ayrı çalıştır;
bir programın `HATA PROGRAM-YOK`'unda o türün ötekilerini deneme.
