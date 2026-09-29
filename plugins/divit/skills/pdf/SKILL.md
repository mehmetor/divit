---
name: pdf
description: PDF dosyalarıyla işler — birleştirme, sayfa çıkarma ya da silme, sayfa döndürme, PDF'i Word'e çevirme, kontrol listesi ya da form işaretleme, PDF'e not/yazı ekleme, fotoğrafları PDF yapma, PDF küçültme. Kullanıcı "PDF'leri birleştir", "şu sayfaları çıkar", "listeyi işaretle", "formu doldur", "PDF'e yaz", "fotoğrafları PDF yap", "PDF çok büyük" dediğinde kullan.
---

# PDF işleri

Hocalar bu işler için internetteki "ücretsiz PDF" sitelerine gidiyor:
dosyaları yabancı sunucuya yükleniyor, virüs riski var, sonunda üyelik
isteniyor. Divit bu işleri **hocanın bilgisayarında** yapar; dosya hiçbir
siteye yüklenmez.

## Yasaklar

- **Asıl PDF'i asla değiştirme.** Her sonuç `cikti/` altında yeni bir
  dosyadır: `<ad>-<iş>-<YYYY-AA-GG>.pdf` (ör. `kontrol-listesi-isaretli-2026-09-28.pdf`).
  Çıktı dosyasını her komutta **açıkça yaz**; yazmazsan araç asıl
  dosyanın üstüne yazar.
- `gelen/` ve `hakemlik/` kuralları burada da geçerli: öğrenci dosyası
  okunur ama değiştirilmez; hakemlik dosyasına hiç dokunulmaz.
- Şifreli PDF'in şifresini kırmaya çalışma. Hoca şifreyi biliyorsa ve
  isterse kaldırılmış kopyayı `cikti/`'ya yaz.
- İmza, kaşe ya da ıslak imza taklidi yapma.
- Bir komutu `;` ya da `&&` ile zincirleme; her komut ayrı.

## Araç

PDF aracının yeri `DIVIT_PDFCPU` ortam değişkenindedir.
- Mac: `"$DIVIT_PDFCPU" <komut> ...`
- Windows: `& $env:DIVIT_PDFCPU <komut> ...`

Aşağıda `P` yerine bunu yaz. Araç çalışmazsa `saglik` skill'ine geç.

| İş | Komut |
|---|---|
| Birleştir (sırayla) | `P merge "cikti/birlesik.pdf" "a.pdf" "b.pdf" "c.pdf"` |
| Sayfa çıkar (yalnız 3-7 ve 10) | `P trim -p 3-7,10 "girdi.pdf" "cikti/kesit.pdf"` |
| Sayfa sil | `P pages remove -p 2,5 "girdi.pdf" "cikti/sayfasiz.pdf"` |
| Sırayı değiştir | `P collect -p 3,1,2 "girdi.pdf" "cikti/sirali.pdf"` |
| Döndür (saat yönü) | `P rotate -p 1-2 "girdi.pdf" 90 "cikti/donuk.pdf"` |
| Her sayfayı ayrı dosya | `P split "girdi.pdf" "cikti/<ad>-sayfalar"` (klasörü önce aç) |
| Küçült | `P optimize "girdi.pdf" "cikti/kucuk.pdf"` |
| Fotoğraflardan PDF | `P import "cikti/taranan.pdf" "foto1.jpg" "foto2.jpg"` |
| Bilgi (sayfa sayısı, boyut) | `P info "girdi.pdf"` |
| Şifre kaldır (hoca biliyorsa) | `P decrypt --upw "<şifre>" "girdi.pdf" "cikti/sifresiz.pdf"` |

Sayfa numaralarını hocanın söylediği gibi kullan; emin değilsen önce
`info` ile sayfa sayısını öğren, "12 sayfa var, 3'ten 7'ye kadar mı?" diye sor.

## Kontrol listesi ya da form işaretleme

Önce formun doldurulabilir alanları var mı, bak: `P form list "girdi.pdf"`.

**a. Doldurulabilir form varsa** (kutular tıklanabiliyor):
1. `P form export "girdi.pdf" ".divit/gecici/form.json"`
2. JSON'u oku. Hocanın cevaplarına göre değerleri Edit ile değiştir
   (onay kutusu için `true`/`false`, metin alanı için metin).
3. `P form fill "girdi.pdf" ".divit/gecici/form.json" "cikti/<ad>-dolu.pdf"`

**b. Düz PDF ise** (kutular yalnız çizim):
1. PDF'i Read ile oku, maddeleri numarasıyla çıkar. Hocaya listeyi
   göster ve her maddenin cevabını al (hepsini tek tek sorma; "hepsi
   evet, yalnız 12 ve 31 hayır" gibi cevap kabul et).
2. İşaretleri sayfaya damga olarak koy. Tik için:
   `P stamp add -p <sayfa> -m text "4" "pos:tl, off:<x> <y>, scale:0.08 abs, rot:0, fontname:ZapfDingbats, fillc:#1f4e3d" "girdi.pdf" "cikti/<ad>-isaretli.pdf"`
   Türkçe not için `fontname:ArialMT` kullan. `off` değerleri sayfanın
   sol üst köşesinden punto cinsindendir (x sağa, y aşağı eksi). Sayfa
   boyutunu `info` ile öğren; maddenin yerini okuduğun sayfa görüntüsünden
   oranla hesapla.
   Birden çok işaret için her seferinde bir önceki çıktıyı girdi yap
   (`-isaretli-1.pdf`, `-isaretli-2.pdf` …); **aynı dosyaya yazma.**
3. **Sonucu Read ile aç ve bak.** İşaret kutunun dışındaysa konumu
   düzelt ve yeniden dene; en çok üç deneme. Olmazsa b3'e geç.
4. Yedek yol: maddeleri Word'de iki sütunlu bir çizelge olarak yaz
   (Madde · Durum ☒/☐ · Not), pandoc ile `cikti/`'ya docx üret. Hoca Word'de
   bakar, "Farklı Kaydet → PDF" ile gönderir.

Bitince dosyayı aç ve söyle: "İşaretli kopya hazır. Aslı olduğu gibi
duruyor. Göndermek isterseniz e-posta taslağı hazırlayabilirim."
Evet derse `eposta` skill'ine geç.

## PDF'i Word'e çevirme

- PDF'i `kurallar`'daki yolla metne çevir (Mac: pdf-metin.js, Windows:
  pdftotext), metni başlık,
  paragraf ve çizelgeleriyle md olarak `.divit/gecici/`'ye yaz, pandoc
  ile `cikti/<ad>.docx` üret. Hocaya söyle: "Metin ve çizelgeler geldi;
  sayfa düzeni ve resimler aynı olmayabilir."
- Taranmış (resim) PDF'te metni sayfa sayfa okuyarak çıkar; emin
  olmadığın sözcüğü `[?]` ile işaretle.

## Bitiş

Çıktıyı aç (Windows: `Invoke-Item`, Mac: `open`). `gunluk.md`'ye tek satır:
`… · pdf · <iş> · <sayfa sayısı / dosya sayısı>`.
