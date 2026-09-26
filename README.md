# Divit — akademik yazım tezgâhı

Makale, tez, kitap. Üniversite hocalarının yazım ve değerlendirme
işlerini kendi makinelerinde, kendi dosyalarıyla kolaylaştıran
Claude Code eklentisi.

**Divit**, kâtibin kuşağına taktığı taşınabilir kalem-hokka takımı.
Metnin kendisi değil, metni üretmek için yanında taşıdığın alet.
Ürünün konumlanması bu: hocanın işini yapmaz, hocanın işini yapmasını
sağlayan takımı kurar.

## Ne yapar

| İş | Skill |
|---|---|
| Öğrenci tezi/ödevi değerlendirme raporu | `tez-kontrol` |
| Atıf ve kaynakça doğrulama | `kaynak-dogrula` |
| Dilekçe, hakem cevabı, referans mektubu | `yazisma` |
| Word/PDF çıktısı, dergi stili | `disa-aktar` |
| Kendi makalesinin gönderim öncesi okuması | `yayin-oncesi` |
| Bölüm/makale üzerinde çalışma | `bolum-yaz` |
| Önceki sürüme dönme | `geri-al` |
| Kılavuzu açma | `yardim` |
| İlk kurulum, profil çıkarma | `kurulum` |
| İhtiyaç görüşmesi (pilot için) | `ihtiyac-gorusmesi` |

## Ne yapmaz

Veri analizi ve istatistik yorumu (yalnız tutarlılık denetler) ·
hakemlik (yayıncı politikaları yasaklıyor) · not/puan verme ·
intihal veya AI-tespit hükmü · veri analizi ·
`kaynaklar.bib` dışında künye üretme.

## Kurulum

Hocanın Claude Pro hesabı olmalı. Sonra tek komut:

**Windows** (PowerShell):
```powershell
irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex
```

**Mac** (Terminal):
```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
```

Sonra Claude uygulaması → **Code** → **Local** → **Select folder** →
Belgeler → Divit → `merhaba`. Divit hocayı kendisi tanır.
Ayrıntı: [`belgeler/KURULUM-REHBERI.md`](belgeler/KURULUM-REHBERI.md).

## Yapı

```
divit/
├── kur.ps1, kur.sh                  tek komutluk kurulum (Windows, Mac)
├── yayinla.sh                       eklentiyi hocalara yayınlar
├── .claude-plugin/marketplace.json  pazar yeri (eklenti zip + sha256)
├── dagitim/                         yayınlanmış eklenti zip'leri
├── plugins/divit/                   eklentinin kaynağı
│   ├── skills/                      on skill
│   ├── alan/                        örnek alan kılavuzları (başlangıç noktası)
│   └── scripts/                     yardımcı betik (isteğe bağlı)
├── hoca-paketi/Divit/               hocanın Belgeler/Divit klasörü şablonu
│   ├── CLAUDE.md                    Divit'in hocayla çalışma kuralları
│   ├── KILAVUZ.html                 hocanın kılavuzu
│   └── .divit/profil/               Divit'in hocayı tanıdığı dosyalar
└── belgeler/                        ihtiyaç analizi, pilot planı, rehberler
```

## Geliştirme

```bash
claude plugin validate plugins/divit
./yayinla.sh            # zip + marketplace.json + commit
./yayinla.sh --gonder   # ayrıca GitHub'a gönder → hocalara ulaşır
```

Tasarım kararları ve gerekçeleri: [`CLAUDE.md`](CLAUDE.md).
