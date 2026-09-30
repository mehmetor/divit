---
name: disa-aktar
description: Metni Word ya da PDF olarak hazırlar — yayınevine teslim dosyası ya da dergi biçimi. Kaynakça stilini biçimlendirir, AI kullanım beyanı taslağı üretir. Kullanıcı "Word'e çevir", "PDF al", "dergiye göndereceğim", "APA'ya çevir", "çıktı al", "yayınevine göndereceğim", "Overleaf'e yükleyeceğim", "LaTeX dosyası lazım" dediğinde kullan.
---

# Dışa aktarma

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Pandoc + CSL. Dergi değişince değişen tek şey stil dosyasıdır,
metin değil. Kazanç burada: aynı makale üç dergiye üç biçimde,
elle düzeltme olmadan.

## Ön kontrol

pandoc kurulumda Divit'le birlikte gelir: Mac'te `~/.divit/araclar/pandoc`,
Windows'ta `& "<pandoc>"` (`kurallar`'daki "Araç yolları"). Çalışmazsa hocaya teknik ayrıntı anlatma: "Word çıktısı
için gereken araç bu bilgisayarda çalışmıyor; Divit'i kuran kişiye
haber verin" de ve metni md olarak `cikti/` altına bırak.

**PDF:** pandoc PDF için ayrıca LaTeX ister; Divit bunu kurmaz. PDF
istenirse Word çıktısı üret ve hocaya söyle: "Word'de Dosya → Farklı
Kaydet → PDF seçin." 

## Akış

1. **Önce `divit-akademik:kaynak-dogrula` çalıştır** (tür akademisyense). Doğrulanmamış atıf varken
   çıktı alma — çıktı alındıktan sonra hoca metni gönderir ve
   düzeltme şansı kalmaz. Sorunlu atıf varsa göster ve sor.
2. Hedefi sor: Word mü PDF mi, hangi dergi/stil?
   Tür yazarsa dergi/stil sorma; `${CLAUDE_PLUGIN_ROOT}/skills/kurallar/yazar.md`
   → "Yayınevine teslim" bölümüne göre çalış, 3–4. adımları atla.
3. CSL stilini belirle. `.claude/stiller/` altında yoksa Zotero Style
   Repository'den (`https://www.zotero.org/styles/<stil-adı>`) indir —
   Mac'te `curl -fsSL -o`, Windows'ta `Invoke-WebRequest -OutFile`.
4. Çalıştır (tek satır):
   - Mac: `~/.divit/araclar/pandoc taslak.md --citeproc --bibliography=kaynaklar.bib --csl=.claude/stiller/<stil>.csl -o "cikti/<ad>.docx"`
   - Windows: `& "<pandoc>" taslak.md --citeproc --bibliography=kaynaklar.bib --csl=.claude/stiller/<stil>.csl -o "cikti/<ad>.docx"`

5. Çıktıyı `cikti/` altına koy, kaynak markdown'a dokunma.

## LaTeX / Overleaf

Hoca "Overleaf", "LaTeX" ya da "dergi LaTeX istiyor" derse Word yerine bu
yol: `${CLAUDE_PLUGIN_ROOT}/skills/disa-aktar/latex.md` dosyasını Read ile
yükle ve ona göre çalış. Oradaki `<filtre>` şu tam yoldur:
`${CLAUDE_PLUGIN_ROOT}/skills/disa-aktar/overleaf.lua`. Tür akademisyen değilse
bu yolu kendiliğinden önerme.

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
Tür yazarsa beyan önerme; kullanıcı isterse "yayınevine not" olarak yaz.
