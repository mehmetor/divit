# PowerPoint ve Excel — Python'suz yol araştırması

Tarih: 2026-10-01 · Bu Mac: pandoc 3.10.2 (`/opt/homebrew/bin/pandoc`),
Excel/PowerPoint kurulu değil (yalnız Keynote, Numbers), bölge `en_TR`.

## Kısa cevap

- **PowerPoint: pandoc yeter.** `pandoc x.md -o x.pptx` çalışıyor; başlık
  slaytı, maddeler, tablo, konuşmacı notu, iki sütun, Türkçe harfler sorunsuz.
  Kurumun şablonu `--reference-doc` ile verilir.
- **Excel: `.csv` (noktalı virgül + UTF-8 BOM).** pandoc `.xlsx` **yazamaz**
  (yalnız okur). Divit'in Write aracı BOM'u koruyor (ölçüldü). Türkçe
  Excel'de çift tıkla doğru açılması Windows'ta **ölçülmedi**, pilotta
  bakılmalı.
- **Claude'un kendi `xlsx`/`pptx` becerileri Code sekmesine geliyor ama
  Python, Node ve LibreOffice istiyor** — hocanın makinesinde varsayılamaz.
  İlk pilot hocanın "kendi başına başardığı" iş büyük ihtimalle ya Chat
  sekmesindeydi (bulutta kod çalıştırma) ya da Claude bir şey kurdu;
  günlüğe bakılmalı.
- **Okuma bedava:** pandoc `.pptx` ve `.xlsx` dosyalarını markdown'a
  çeviriyor; Divit gelen sunum ve tabloları okuyabilir.

## Ölçümler

### 1. md → pptx

Deneme dosyası: YAML başlığı (başlık, alt başlık, yazar, tarih, `lang: tr`),
üç `#` bölümü, madde listesi, 3 sütunlu tablo, `::: notes` konuşmacı notu,
`:::::: columns` iki sütun.

```
$ pandoc x.md -o x.pptx
cikis=0                      # 33.3K
$ unzip -l x.pptx | grep -E "slides/slide|notesSlide"
ppt/slides/slide1.xml … slide4.xml        # başlık + 3 slayt
ppt/notesSlides/notesSlide1.xml           # konuşmacı notu gitti
$ unzip -p x.pptx ppt/slides/slide2.xml | grep -o "Çiğdem[^<]*"
Çiğdem, Şule, Ilgın, Öykü, İğdır — Türkçe harf sınaması
$ unzip -p x.pptx ppt/slides/slide3.xml | grep -o "<a:tbl>"
<a:tbl>                                    # gerçek PowerPoint tablosu
```

LibreOffice ile PDF'e çevirip bakıldı (yalnız ölçüm için; hocada
varsayılmaz): tablo slaytı düzgün, görünüm sade ve beyaz zemin.

### 2. Şablon (`--reference-doc`)

```
$ pandoc -o sablon.pptx --print-default-data-file reference.pptx
sablon=0
$ pandoc x.md --reference-doc=sablon.pptx -o x2.pptx
ref=0
```

Kurumun `.pptx` şablonu da verilebilir; pandoc şu düzen adlarını arar:
Title Slide, Title and Content, Section Header, Two Content, Comparison,
Content with Caption, Blank. Kurum şablonunda bu adlar yoksa varsayılan
düzen kullanılır — Türkçe PowerPoint'te düzen adları Türkçe olabilir,
**pilotta bir kurum şablonuyla denenmeli**.

### 3. Excel için CSV

Write aracıyla `U+FEFF` ile başlayan, `;` ayırıcılı dosya yazıldı:

```
$ head -c 8 tablo.csv | xxd
00000000: efbb bf59 c3b6 6e74      # EF BB BF = UTF-8 BOM, sonra "Yönt"
```

İçerik: başlık satırı, `Çiğdem, Şule` (virgül içeren hücre), `8100,5`
(ondalık virgül), `"İğdır; ölçüm"` (tırnak içinde noktalı virgül).
LibreOffice'e `;` ayırıcıyla alındığında sütunlar ve Türkçe harfler doğru
geldi. (Bu Mac'te Excel yok; Windows Excel'de çift tık ölçülmedi.)

Belgelerden bilinen:

- Excel CSV'yi çift tıkla açarken **sistemin liste ayırıcısını** kullanır.
  Ondalık ayırıcısı virgül olan bölgelerde (Türkiye dahil) liste ayırıcı
  `;`'dür. Yani Türkçe Windows'ta `;` doğru; İngilizce bölge ayarlı
  makinede her şey tek sütuna düşer.
- Excel, BOM yoksa dosyayı UTF-8 saymaz, eski kod sayfasıyla açar →
  `ş`, `ğ`, `İ` bozulur. **BOM şart.**
- İlk satıra `sep=;` yazmak ayırıcı sorununu çözer ama **BOM'u etkisiz
  bırakır** (Türkçe harfler bozulur). Kullanılmamalı.
- Yedek yol: Excel'de **Veri → Metinden/CSV'den**, köken "65001: Unicode
  (UTF-8)", ayırıcı "Noktalı virgül".

### 4. pandoc okuma

```
$ pandoc --list-output-formats | grep -c xlsx   → 0   (yazamaz)
$ pandoc --list-input-formats  → … csv … pptx … tsv … xlsx …
$ pandoc tablo.xlsx -t gfm
## tablo
| Yöntem | Su (m³/da) | Verim (kg/da) | Not          |
| Karık  | 650.0      | 7200.0        | Çiğdem, Şule |
| Damla  | 450.0      | 8100,5        | İğdır; ölçüm |
$ pandoc x.pptx -t gfm       → slayt başlıkları, maddeler, tablo geliyor
```

Not: sayılar `650.0` biçiminde geliyor; rapora aktarırken düzeltilmeli.

### 5. Claude'un yerleşik becerileri

claude.ai hesabıyla giriş yapılan oturumlara `anthropic-skills:xlsx`,
`…:pptx`, `…:docx`, `…:pdf` her zaman eşitlenir (`~/.claude/skills/synced/`).
Bu Mac'teki kopyalarında (salt okundu):

- `xlsx`: oluşturma/düzenleme **`openpyxl` (Python)**, formül hesabı
  `python scripts/recalc.py` + **LibreOffice**.
- `pptx`: oluşturma **`pptxgenjs` (Node)**, okuma `markitdown` (Python),
  doğrulama `python scripts/office/validate.py`.
- Beceri metni "önceden kurulu" diyor — bu bulut ortamı için doğru, hocanın
  Windows'u için değil. Eksikse Claude `pip install` / `npm install`
  deneyebilir; Python/Node yoksa iş yarıda kalır ya da izin ister.

Ayrıca: `anthropic-skills:pdf` ile Divit'in `pdf` skill'i adları çakışıyor;
'/' menüsünde ikisi de görünür. Divit'in skill'leri `divit:` önekiyle
ayrışıyor ama "PDF birleştir" isteği yanlış skill'e gidebilir — pilotta
bakılmalı.

## Öneri

### `sunum` skill'i (çekirdek eklenti, iki rol)

- Kullanıcı: "sunum hazırla", "slayt yap", "PowerPoint'e çevir", "bu
  bölümden sunum".
- Akış: içerikten slayt iskeleti (başlık + en çok 5 madde/slayt) →
  kullanıcıya liste olarak göster, onay → `cikti/<ad>-sunum-<tarih>.md`
  yaz → `pandoc … -o cikti/<ad>-sunum-<tarih>.pptx` (klasörde varsa
  `.divit/profil/sunum-sablonu.pptx` ile `--reference-doc`) → dosyayı aç.
- Konuşmacı notları `::: notes` ile; kullanıcı "notları da yaz" derse.
- Tasarım vaat edilmez: "sade bir sunum; renk ve yerleşimi kendi
  şablonunuzla verirsiniz" denir. Şablonu kullanıcı bir kez verir, Divit
  profile kopyalar (`koy` benzeri bir adım; `.claude/` altına değil).
- Görsel/grafik yok (veri analizi yapılmaz kuralı; şekil `malzeme`'den
  hazır gelirse `![](yol)` ile konur).
- İzin: `Bash(*pandoc*)`/`PowerShell(*pandoc*)` zaten var; yeni izin gerekmez.

### `tablo` skill'i (çekirdek eklenti, iki rol)

- Kullanıcı: "Excel'e aktar", "tablo yap", "bunu Excel'de açılır yap".
- Akış: tabloyu önce ekranda göster, onay → Write ile
  `cikti/<ad>-<tarih>.csv`: **ilk karakter U+FEFF**, ayırıcı `;`, ondalık
  virgül, `;`/`"`/satır sonu içeren hücre çift tırnakta, tırnak ikilenir →
  dosyayı aç.
- Açılınca tek sütunsa kullanıcıya tek cümlelik yedek yol: "Excel'de Veri →
  Metinden/CSV'den, ayırıcı Noktalı virgül."
- Formül, biçim, birden çok sayfa **yok** — bunlar gerekirse "Excel'de
  kendiniz ekleyin" denir ya da Google Sheets bağlayıcısı (bkz.
  `baglayicilar.md`) önerilir.
- Okuma yönü: gelen `.xlsx`/`.pptx` → `pandoc <dosya> -t gfm` ile metne;
  `pdf`'teki gibi `.divit/gecici/`ye.
- Kılavuzda Word'deki gibi: "Divit Excel ve PowerPoint dosyası yapar ama
  süslemez."

Her iki skill de `anthropic-skills:xlsx/pptx`'e **yönlendirmez**; kurallarda
"Python/Node isteyen yerleşik beceriyi kullanma" satırı olmalı.

## Kalan riskler

- Türkçe Windows Excel'de BOM + `;` CSV çift tıkla açılışı ölçülmedi.
- Kurum PowerPoint şablonunda düzen adları Türkçe ise pandoc düzeni
  bulamayabilir.
- Yerleşik `anthropic-skills` becerilerinin kendiliğinden tetiklenmesi
  (Divit'in skill'i yerine).

## Kaynaklar

- Pandoc kılavuzu — slayt gösterileri, pptx düzenleri, `--reference-doc`:
  https://pandoc.org/MANUAL.html#slide-shows ve
  https://pandoc.org/MANUAL.html#option--reference-doc
- Excel ve bölge ayarı / liste ayırıcı:
  https://help.itglue.kaseya.com/help/Content/1-admin/import-and-export/changing-regional-setting-csv-imports.html
- UTF-8 BOM ve Excel: https://cococonvert.com/blog/excel-csv-special-characters
- `sep=` satırının BOM'u bozması:
  https://dev.library.kiwix.org/content/stackoverflow_en_nopic_2021-08/questions/20395699/sep-statement-breaks-utf8-bom-in-csv-file-which-is-generated-by-xsl
- Eşitlenen claude.ai becerileri (`anthropic-skills`, `pdf` ve `xlsx` her
  zaman eşitlenir): https://code.claude.com/docs/en/skills
- Masaüstü — yerel oturumlar hesap becerilerini yükler:
  https://code.claude.com/docs/en/desktop
