---
name: malzeme
description: Fotoğrafı çekilmiş el yazısı notları ve kitap sayfalarını okuyup metne çevirir, her birinin nereden geldiğini (kendi yazım, başka kitaptan alıntı, esinlenme) not eder. Kullanıcı "fotoğraftaki yazıyı metne çevir", "el yazımı oku", "notlarımın fotoğrafını çektim", "şu sayfaların fotoğrafını koydum", "malzemeleri oku", "fotoğraflardaki metni çıkar" dediğinde kullan.
allowed-tools: Bash(sh */scripts/kitap-klasoru.sh *), PowerShell(*kitap-klasoru.ps1*)
---

# Malzeme — fotoğraftan metin

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Tür satırını `.divit/profil/kimlik.md`'den Read ile oku; hitap rol dosyasına göre.
Fotoğrafı Divit Read ile kendisi okur; ek program yoktur.

## Yasaklar

1. **`malzeme/` içine hiçbir şey yazma** — Write ile de, Edit ile de, klasör
   açarak da. Fotoğraflar orada kullanıcının asıl malzemesidir. Metin her
   zaman `notlar/malzeme-metin/` altına yazılır (aşağıda "Yer").
2. **Okunamayanı tahmin etme.** Seçemediğin her kelime `[okunamadı]`;
   birkaç kelime ise `[okunamadı: yaklaşık 3 kelime]`. Cümleyi anlamlı
   kılmak için kelime ekleme, yazım hatasını düzeltme, sırayı değiştirme.
3. **Künye uydurma.** Başka kitaptan gelen sayfanın yazarı, adı, yılı,
   sayfası yalnız kullanıcıdan ya da fotoğrafın kendisinden (sayfa başlığı,
   sayfa numarası) gelir; gerisi `[DOĞRULA]`.
4. **Başka kitaptan alınan metni kitaba kopyalama.** Bu skill yalnız metne
   çevirir; kitap metnine, taslağa ya da plana hiçbir şey eklemez.
5. Fotoğrafta başka birinin kişisel bilgisi (telefon, adres, kimlik numarası)
   varsa metne alma, `[kişisel bilgi çıkarıldı]` yaz.

## Yer

| | Fotoğraflar | Metin |
|---|---|---|
| Yazar | `kitaplar/<kitap-adi>/malzeme/` | `kitaplar/<kitap-adi>/notlar/malzeme-metin/` |
| Diğer | `malzeme/` | `notlar/malzeme-metin/` |

Dosya adı: `<ad>-metin-<YYYY-AA-GG>.md`; `<ad>` fotoğrafın adıdır (küçük harf,
Türkçe karaktersiz, tireli; `IMG_2041.jpg` → `img-2041`). Klasörü Write açar.
Aynı fotoğrafın metni zaten varsa (Glob ile `<ad>-metin-*.md`) atla ve söyle.

Yazarda kitap belli değilse `kitaplar/` altını Glob ile listele, sor. Kitap
klasörü yoksa `kurallar`'daki betikle `ac <kitap-adi>`. Kullanıcı fotoğrafı
sohbete sürüklediyse ya da yolunu verdiyse `koy <kitap-adi> malzeme "<dosya>"`
ile yerleştir, oradan oku. Diğer türde fotoğrafı bulunduğu yerden oku.

## Telefondan gelen fotoğraf

Kullanıcı "telefondan nasıl göndereceğim" derse aynen:
> "Telefonda Claude uygulamasında Code'a dokunup bu sohbeti açın, fotoğrafı ekleyin; ben malzemeye koyarım.
> Olmazsa fotoğrafı bilgisayara atın (iPhone'da AirDrop, Windows'ta OneDrive) ve buraya sürükleyin."

Mesajda fotoğraf varsa ve yolu yazmıyorsa: Glob ile `~/.claude/uploads/**/*`
altında en yeni dosyayı bul (adı `<kısa-kimlik>-image.jpg` gibi). Bulamazsan
uydurma, sürüklemesini iste. Bulunca anlamlı ad öner ("el-yazisi-01 diye
koyayım mı?"), onayla ve aynen (yeni ad uzantısız, küçük harf, Türkçe
karaktersiz, tireli; uzantıyı betik korur):
- Mac: `sh ${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.sh koy <kitap-adi> malzeme "<yol>" <yeni-ad>`
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.ps1" koy <kitap-adi> malzeme "<yol>" <yeni-ad>`

`VAR` derse bir sonraki sayıyı dene (`el-yazisi-02`). Diğer türde fotoğrafı oradan oku.

## Fotoğrafları bulma

Glob ile klasördeki `*.jpg`, `*.jpeg`, `*.png`, `*.heic`, `*.webp` (büyük
harfli uzantılar da: `*.JPG`, `*.HEIC`). Kaç fotoğraf olduğunu ve kaçının
metni zaten çıkmış olduğunu söyle. Ondan fazlaysa: "Hepsini mi okuyayım,
yoksa önce birkaçını mı?"

## Kaynak türü — her fotoğraf için, okumadan önce

Tek soru, numarayla:

> "<fotoğraf adı> ne? 1) Kendi el yazım 2) Başka bir kitaptan alıntı
> 3) Esinlendiğim bir sayfa"

Kullanıcı "hepsi aynı" derse bir kez sor. 2 ya da 3 ise ikinci soru:
"Hangi kitaptan? Yazarı, adı, yılı ve sayfası — bildiğiniz kadarı yeter."
Aynı kitabın ardışık sayfaları tek dosyada toplanabilir (kullanıcı isterse);
her sayfa `## <fotoğraf adı>` başlığıyla ayrılır.

## Okuma

Fotoğrafı Read ile aç ve aynen yaz:
- Satır ve paragraf düzenini koru; el yazısında satır sonu önemsizse
  paragrafı birleştir. Üstü çizili kelime `~~kelime~~`; kenara eklenen not
  `[kenar notu: …]`; ok, çizim, şema `[çizim: kısa tanım]`.
  Satırın içinde kelimenin yerinde duran karalama ya da çözülemeyen yazı
  çizim değildir: `[okunamadı]`.
- Basılı sayfada üst bilgi ve sayfa numarasını metne katma; sayfa numarasını
  başlık bilgisine yaz.
- Fotoğraf bulanık, eğik ya da yarımsa okuyabildiğin kadarını yaz ve kullanıcıya
  söyle: "Bu fotoğrafı daha yakından, gölgesiz çekebilir misiniz?"

**Fotoğraf açılmazsa** (çoğunlukla iPhone'un HEIC biçimi). Komut çalıştırma;
tarif et, tek seferde:
> "Bu fotoğrafı açamadım; telefonun özel bir biçiminde. İki yol var:
> Mac'te fotoğrafı Önizleme ile açıp Dosya › Dışa Aktar › Biçim: JPEG
> diyerek aynı klasöre kaydedin. Windows'ta Fotoğraflar uygulamasında açıp
> '…' › Farklı kaydet › JPG seçin. Bundan sonrası için iPhone'da Ayarlar ›
> Kamera › Biçimler › **En Uyumlu**'yu seçerseniz fotoğraflar doğrudan açılır."
Sonra `.divit/sorunlar.md`'ye kısa not.

## Dosya

```
# <ad> — fotoğraftan metin

Kaynak türü: <kendi el yazım | başka kitaptan alıntı | esinlenme>
Künye: <kullanıcının verdiği; kendi el yazısında "—"; eksik parça [DOĞRULA]>
Fotoğraf: <yol> · Sayfa: <varsa>
Okunma: <YYYY-AA-GG> · Okunamayan yer: <sayı>

> <UYARI satırı, türe göre aşağıdan aynen>

<metin>
```

UYARI satırları (Divit'in sonraki işleri, kitap düzenleme ve derleme dahil, buna uyar):
- Kendi el yazım: `Divit için: kullanıcının kendi metni. Kitapta kullanılabilir; kullanıcıya sormadan kitaba eklenmez.`
- Alıntı: `Divit için: BAŞKA BİR KİTAPTAN ALINTI. Kitap metnine kopyalanmaz. Yalnız kısa alıntı olarak, tırnak içinde ve künyesiyle; uzun alıntı [İZİN] ister.`
- Esinlenme: `Divit için: ESİN KAYNAĞI. Cümleleri kitaba aktarılmaz; fikir kullanıcının kendi cümleleriyle yazılır, istenirse kaynak anılır.`

## Kapanış

Her dosyanın yolunu tam yoluyla ver. Tek cümleyle `[okunamadı]` sayısını
söyle: "Okuyamadığım yerleri [okunamadı] diye işaretledim; isterseniz
fotoğrafa bakıp siz tamamlayın." Alıntı ya da esinlenme varsa bir kez:
"Başka kitaptan gelen metni kitaba doğrudan almayacağım; kullanırsak alıntı
olarak, kaynağıyla birlikte."

Kullanıcı `[okunamadı]` yerini söylerse Edit ile düzelt (`notlar/` altında
kullanıcının dosyası sayılır: önce önceki sürüm, `kurallar`'a göre).

Günlüğe: `YYYY-AA-GG SS:DD · malzeme · <kitap ya da klasör> · <kaç fotoğraf, türleri>`.
Günlüğe metnin içeriğini ve künyedeki kişi adını yazma.
