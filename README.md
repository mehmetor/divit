# Divit — akademik yazım tezgâhı

Makale, tez, kitap. Üniversite hocalarının yazım ve değerlendirme
işlerini kendi makinelerinde, kendi dosyalarıyla kolaylaştıran
Claude Code eklentisi.

**Divit**, kâtibin kuşağına taktığı taşınabilir kalem-hokka takımı.
Metnin kendisi değil, metni üretmek için yanında taşıdığın alet.
Ürünün konumlanması bu: hocanın işini yapmaz, hocanın işini yapmasını
sağlayan takımı kurar.

Web sitesi: **https://divit.simetri.app** ·
Kılavuz: [`KILAVUZ.html`](hoca-paketi/Divit/KILAVUZ.html) ·
Tek sayfalık kart: [`KART.html`](hoca-paketi/Divit/KART.html)

## Neden Divit

- **Sizi kendisi tanır.** Özgeçmişinizi okur, alanınızı çıkarır,
  makalelerinizden üslubunuzu öğrenir. Önceden hiçbir şey hazırlanmaz.
- **Uydurmaz.** Kaynaklarınızda olmayan künye yazmaz; her atıfı
  kaynaktaki birebir pasaja bağlar, Crossref'te denetler.
- **Dosyanızı bozmaz.** Word ve PDF'i yerinde değiştirmez; öğrenci
  dosyalarına yazamaz; her değişiklikten önce önceki sürümü saklar.
- **Sınırını bilir.** Not vermez, hakemlik yapmaz, intihal hükmü vermez.
- **Terminal yok.** Claude masaüstü uygulamasında sohbetle çalışır.
  Windows ve Mac'te aynı.
- **Kendiliğinden güncellenir.** Düzeltmeler hocanın makinesine kendisi gider;
  Divit yenilikleri kendisi söyler, kurulum gerekirse onayla yeniden çalıştırır.
- **Geri bildirim sizin elinizde.** Divit sorunları not eder; yalnız
  onayınızla, öğrenci bilgisi çıkarılmış hâlde gönderilir.

## Ne yapar

| Hoca şunu yazar | Divit |
|---|---|
| `bu tezi değerlendir` | Öğrenci dosyasına dokunmadan yapılandırılmış rapor ve öğrenciye e-posta taslağı (`tez-kontrol`) |
| `göndermeden kontrol et` | Gönderim öncesi okuma: çizelge-metin tutarlılığı, hedef derginin kurallarına uygunluk (`yayin-oncesi`) |
| `atıfları kontrol et` | Atıf ve kaynakça doğrulama (`kaynak-dogrula`) |
| `dekanlığa dilekçe yazalım` | Dilekçe, referans mektubu, hakem cevap tablosu ve mektubu (`yazisma`) |
| `bunu Word'e çevir` | Word/PDF çıktısı, dergi stili (`disa-aktar`) |
| `bölüm yazalım` | Yapı, itiraz, eksik tespiti (`bolum-yaz`) |
| `bu PDF'leri birleştir` | PDF birleştirme, sayfa çıkarma/silme/döndürme, kontrol listesi ve form işaretleme, PDF'ten Word'e, fotoğraftan PDF — bilgisayarda, siteye yüklemeden (`pdf`) |
| `geri al` | Önceki sürüme dönme (`geri-al`) |
| `geri bildirim gönder` | Notları onayla geliştiriciye iletme (`gelistirici-paylas`) |
| `yardım` | Kılavuzu açar (`yardim`) |
| `e-posta olarak hazırla` | Hocanın e-postasında taslak açar, izinle; göndermez (`eposta`) |
| `çalışıyor musun` | Word ve PDF okuma, PDF aracı, izin kipi, model ve profil denetimi (`saglik`) |
| `yenilikler neler` | Sürüm notlarını anlatır, gerekirse kurulumu onayla yeniden çalıştırır (`guncelleme`) |

Kendiliğinden çalışanlar: `kurulum` (ilk açılışta hocayı tanır),
`kurallar` (her oturumda), `bakim` (ayda bir, izinle profil ve hafıza
düzeni; haftalık geri bildirim hatırlatması), `guncelleme` (haftada bir
yeni sürüm denetimi). `gelistirici-ihtiyac-gorusmesi` pilot içindir.
Sürüm notları: [`plugins/divit/SURUM.md`](plugins/divit/SURUM.md).

Varsayılan model Opus 5.5, düşük çaba (klasör ayarı). Ağır işlerde Divit
`/effort high` önerir. Divit hocanın kullanım sınırını göremez. İzin
sorusu çok çıkarsa kip seçicisinde **Auto** önerir.

## Ne yapmaz

Hakemlik, jüri ve komisyon dosyası okuma · not/puan verme · intihal
veya "yapay zekâ yazmış" hükmü · veri analizi ve istatistik yorumu
(yalnız tutarlılık denetler) · kaynaklarda olmayan künye üretme.

## Kurulum

Gereken tek şey: **Claude Pro** (ya da üstü) hesabı. Git, Python,
Homebrew ya da yönetici hakkı gerekmez. Kurulum Claude uygulamasını,
Claude Code'u, Word dönüştürücüsünü (pandoc), PDF aracını (pdfcpu; Windows'ta
ayrıca PDF okuyucu Poppler, Mac'te sistemin PDFKit'i) ve `Belgeler/Divit`
klasörünü hazırlar. Yeniden çalıştırmak güvenlidir; dosyalarınıza dokunmaz.

### Seçenek 1 — Tek komut

**Windows:** Başlat → "PowerShell" yazın → açın → yapıştırın → Enter.
```powershell
irm divit.simetri.app/kur.ps1 | iex
```

**Mac:** Spotlight → "Terminal" → yapıştırın → Enter.
```bash
curl -fsSL divit.simetri.app/kur.sh | bash
```

Kısa adres GitHub'daki asıl betiği çalıştırır. Site erişilemezse doğrudan:
`irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex` ·
`curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash`.

Windows'ta kurulumdan sonra Claude'u tamamen kapatıp yeniden açın.

### Seçenek 2 — Yapay zekâ sizin yerinize kursun

Claude uygulaması zaten kuruluysa: **Code** sekmesinde herhangi bir
klasörle yeni bir oturum açın ve aşağıdaki metni yapıştırın. Claude
betiği okur, ne yapacağını anlatır, onayınızı alır ve kurar.

```text
Divit'i bu bilgisayara kurmanı istiyorum. Divit, Claude için akademik yazım eklentisidir: https://github.com/mehmetor/divit

Ben teknik biri değilim. Lütfen şöyle ilerle:

1. Bilgisayarın Windows mu Mac mi olduğunu anla.
2. Kurulum betiğini indir ve oku (Windows: https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 — Mac: https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh). Ne yapacağını bana sade Türkçeyle, en çok beş maddede anlat. Onayımı bekle.
3. Onaylarsam betiği çalıştır:
   - Windows: powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex"
   - Mac: curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
   Kurulum birkaç dakika sürebilir; bitmesini bekle.
4. Sonucu denetle: "claude plugin list" çıktısında "divit@divit" görünmeli, Belgeler klasöründe "Divit" klasörü oluşmuş olmalı. Hata varsa çıktının son satırlarını oku ve düzeltmeyi dene. Çözemezsen bana ne olduğunu tek cümleyle söyle.
5. Bitince bana şunu söyle: Claude uygulamasında "Code" sekmesine geç, "Select folder" ile Belgeler → Divit klasörünü seç, "merhaba" yaz.

Bilgisayarımda başka hiçbir şeyi değiştirme, hiçbir dosyayı silme.
```

### Seçenek 3 — Claude Code'u zaten kullananlar için

```bash
claude plugin marketplace add https://raw.githubusercontent.com/mehmetor/divit/main/.claude-plugin/marketplace.json
claude plugin install divit@divit
```

Bu yol yalnız eklentiyi kurar; `Belgeler/Divit` klasörünü ve izinleri
hazırlamaz. Hocalar için Seçenek 1 ya da 2 önerilir.

### Kurulumdan sonra

Claude uygulaması → **Code** → **Local** → **Select folder** →
Belgeler → **Divit** → `merhaba`. Divit sizi kendisi tanır.
Klasördeki **KILAVUZ.html** ve **KART.html** kurulumla gelir.
Ayrıntı ve sorun giderme: [`belgeler/KURULUM-REHBERI.md`](belgeler/KURULUM-REHBERI.md).

## Yapı

```
divit/
├── kur.ps1, kur.sh                  tek komutluk kurulum (Windows, Mac)
├── yayinla.sh                       eklentiyi hocalara yayınlar
├── .claude-plugin/marketplace.json  pazar yeri (eklenti zip + sha256)
├── dagitim/                         yayınlanmış eklenti zip'leri
├── plugins/divit/                   eklentinin kaynağı
│   ├── skills/                      on yedi skill
│   ├── SURUM.md                     hocaya anlatılan sürüm notları
│   ├── alan/                        örnek alan kılavuzları (başlangıç noktası)
│   └── scripts/                     yardımcı betikler (Mac PDF okuma, harf denetimi)
├── hoca-paketi/Divit/               hocanın Belgeler/Divit klasörü şablonu
│   ├── CLAUDE.md                    Divit'in hocayla çalışma kuralları
│   ├── KILAVUZ.html                 hocanın kılavuzu
│   ├── KART.html                    tek sayfalık kart
│   └── .divit/profil/               Divit'in hocayı tanıdığı dosyalar
├── araclar/pano.py                  pilot panosu (geri bildirimleri toplar)
├── apps/web/                        divit.simetri.app tek sayfalık site (+ kısa kurulum adresi)
└── belgeler/                        ihtiyaç analizi, pilot planı, rehberler
```

## Geliştirme

```bash
claude plugin validate plugins/divit
./yayinla.sh            # zip + marketplace.json + commit
./yayinla.sh --gonder   # ayrıca GitHub'a gönder → hocalara ulaşır
```

Tasarım kararları ve gerekçeleri: [`CLAUDE.md`](CLAUDE.md).
