---
name: disa-aktar
description: Metni Word (.docx) veya PDF'e çevirir, dergi stiline göre kaynakça biçimlendirir, AI kullanım beyanı taslağı üretir. Hoca "Word'e çevir", "PDF al", "dergiye göndereceğim", "APA'ya çevir", "çıktı al" dediğinde kullan.
---

# Dışa aktarma

Pandoc + CSL. Dergi değişince değişen tek şey stil dosyasıdır,
metin değil. Kazanç burada: aynı makale üç dergiye üç biçimde,
elle düzeltme olmadan.

## Ön kontrol

pandoc kurulumda Divit'le birlikte gelir; yeri `DIVIT_PANDOC` ortam
değişkenindedir. Çalışmazsa hocaya teknik ayrıntı anlatma: "Word çıktısı
için gereken araç bu bilgisayarda çalışmıyor; Divit'i kuran kişiye
haber verin" de ve metni md olarak `cikti/` altına bırak.

**PDF:** pandoc PDF için ayrıca LaTeX ister; Divit bunu kurmaz. PDF
istenirse Word çıktısı üret ve hocaya söyle: "Word'de Dosya → Farklı
Kaydet → PDF seçin." 

## Akış

1. **Önce `kaynak-dogrula` çalıştır.** Doğrulanmamış atıf varken
   çıktı alma — çıktı alındıktan sonra hoca metni gönderir ve
   düzeltme şansı kalmaz. Sorunlu atıf varsa göster ve sor.
2. Hedefi sor: Word mü PDF mi, hangi dergi/stil?
3. CSL stilini belirle. `.claude/stiller/` altında yoksa Zotero Style
   Repository'den (`https://www.zotero.org/styles/<stil-adı>`) indir —
   Mac'te `curl -fsSL -o`, Windows'ta `Invoke-WebRequest -OutFile`.
4. Çalıştır (tek satır):
   - Mac: `"$DIVIT_PANDOC" taslak.md --citeproc --bibliography=kaynaklar.bib --csl=.claude/stiller/<stil>.csl -o "cikti/<ad>.docx"`
   - Windows: `& $env:DIVIT_PANDOC taslak.md --citeproc --bibliography=kaynaklar.bib --csl=.claude/stiller/<stil>.csl -o "cikti/<ad>.docx"`

5. Çıktıyı `cikti/` altına koy, kaynak markdown'a dokunma.

## Bilinen sınır — söylemekten kaçınma

Word'e aktarılan metin ortak yazarlardan **değişiklik izleriyle**
(tracked changes) geri geldiğinde markdown'a temiz dönmez. Hoca çok
yazarlı bir makale üzerinde çalışıyorsa bunu baştan söyle:

> Divit ilk taslak için güçlü. Ortak yazarla gidip gelmeye
> başladığınızda Word'de kalmanız daha az sorun çıkarır; bittiğinde
> geri getirebiliriz.

Bunu gizlemek, hocayı üçüncü haftada hayal kırıklığına uğratmaktan
iyidir.

## AI kullanım beyanı

Dergiye gidecek bir metin dışa aktarılıyorsa beyan taslağı üret ve
hocaya sun — derginin politikasına göre düzenlemesi gerektiğini söyle:

> Bu çalışmanın hazırlanmasında <araç> dil düzenlemesi ve kaynak
> doğrulaması amacıyla kullanılmıştır. Metnin bilimsel içeriği,
> yorumu ve sonuçları yazar(lar)a aittir.

Beyanı kendiliğinden metne gömme; ayrı sun, kararı hoca versin.
