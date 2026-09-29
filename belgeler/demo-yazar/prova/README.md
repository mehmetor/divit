*KURGUSAL ÖRNEK — bu klasördeki çıktılar kurgusal demo malzemesinden
üretildi. Kişiler, şirketler ve olaylar uydurmadır.*

# Demo provası — 2026-09-29

Canlı demo aksarsa bunlar gösterilir. İki iş, birleşik dalda
(`orc/yonetici-kitap-yazarlari-i/entegrasyon`), yazar kurulumunun
ürettiği bir klasörde çalıştırıldı.

## Nasıl çalıştırıldı

Klasör: `DIVIT_TUR=yazar` ile sınama kurulumu; `asil/*` →
`kitaplar/ornek/asil/`, `malzeme/*` → `kitaplar/ornek2/malzeme/`;
`kimlik.md`'de `Kullanıcı türü: yazar` ve kurgusal bir yazar tanımı;
`.claude/settings.local.json`'da yayındaki iki eklenti kapalı.

```bash
claude -p --setting-sources project,local --plugin-dir <repo>/plugins/divit \
  --add-dir <repo>/plugins/divit --permission-mode acceptEdits "<istek>"
```

Etkileşimli sorular olmasın diye seçimler isteğe yazıldı:

1. "kitaplar/ornek kitabımı yeni baskı için düzenle, yapı ve tutarlılık.
   Seçimlerim: bakılacak yer yapı ve tutarlılık, yeni baskının amacı
   güncelleme; soru sormadan raporu yaz."
2. "kitaplar/ornek2 içindeki yazılarımdan kitap yapalım, envanter ve
   içindekiler önerisi. Soru sormadan envanteri ve içindekiler
   seçeneklerini yaz; iskeleti sonra konuşuruz."

## Dosyalar

| Klasör | Dosya | Divit'teki yeri |
|---|---|---|
| `kitap-duzenle/` | `rapor-2026-09-29.md` | `kitaplar/ornek/duzenleme/` |
| | `oneriler-4.md`, `oneriler-5.md` | `kitaplar/ornek/duzenleme/` |
| | `plan.md` | `kitaplar/ornek/` |
| | `pencere-ozeti.md` | Divit penceresindeki son cevap |
| `kitap-derle/` | `envanter.md`, `plan.md` | `kitaplar/ornek2/` |
| | `pencere-ozeti.md` | Divit penceresindeki son cevap |

## Sonuç

- **kitap-duzenle:** `beklenen-bulgular.md` A listesindeki 15 bulgunun
  12'si ana bulgularda (1-4, 7-14), kalan 3'ü (5 jargon, 6 uzun
  paragraf, 15 yazım) seçilmeyen aşamalar için "sonraki aşamalar" notunda.
  Uydurma yok: yıllar, oran ve söz yalnız işaretlendi. Yapı bulguları
  yazımdan önce geliyor.
- **kitap-derle:** B listesindeki 10 bulgunun 10'u; dört `[İZİN]` (iki
  gazete yazısı, konuşma kaydı, röportaj), tekrar eden çay anekdotu,
  `[GÜNCELLE]`, tarihsiz not, konuşma dili, iki parçada 2001 krizi. Üç
  içindekiler kurgusu ve "bu bölüm için sizin anlatmanız gerekir"
  boşlukları.
- `asil/` ve `malzeme/` değişmedi (`shasum` önce/sonra aynı).
- Pencere özetleri ve dosyalar yazar dili denetiminden geçti (akademik
  kelime yok).

## Görülen küçük sapmalar

- Hukuki ima için `[İZİN]` kullanıldı; S8'de `[İZİN]` yayın hakkı içindir,
  bu bulgu raporun "Yayınevi ya da hukukçuyla konuşun" bölümünde duruyor.
- Günlük satırlarındaki saat tahmin (sınama kipinde saat komutu
  çalışmadı).
- `kitap-derle` kimlik dosyasındaki "fabrika müdürlüğü" ile yazıdaki
  "genel müdür"ü çelişki saydı: prova profili bilerek kısa tutulmuştu,
  demo profili tek genel satırdır.
