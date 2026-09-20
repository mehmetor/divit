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
| Bölüm/makale üzerinde çalışma | `bolum-yaz` |
| Bozulanı geri alma | `geri-al` |
| İlk kurulum, profil çıkarma | `kurulum` |
| İhtiyaç görüşmesi (pilot için) | `ihtiyac-gorusmesi` |

## Ne yapmaz

Veri analizi ve istatistik yorumu (yalnız tutarlılık denetler) ·
hakemlik (yayıncı politikaları yasaklıyor) · not/puan verme ·
intihal veya AI-tespit hükmü · veri analizi ·
`kaynaklar.bib` dışında künye üretme.

## Yapı

```
divit/
├── .claude-plugin/marketplace.json   marketplace tanımı
├── plugins/divit/                    tek plugin (bilinçli karar)
│   ├── skills/                       sekiz skill
│   ├── alan/                         alan kılavuzları (ziraat, +şablon)
│   └── scripts/                      ortam kontrolü, otomatik yedek
├── hoca-paketi/                      hocanın makinesine giden paket
│   ├── kur.sh                        tek seferlik kurulum
│   └── Divit/                        çalışma klasörü şablonu
└── belgeler/
    ├── IHTIYAC-ANALIZI.md            hoca ne istiyor — varsayımlar + doğrulama
    ├── PILOT.md                      pilot planı ve kabul kriterleri
    ├── ILK-OTURUM.md                 ilk hoca: hazırlık, akış, sonrası
    └── TASARIM-NOTLARI.md            ilk tasarımdan sapmalar ve gerekçeleri
```

## Kurulum (Mehmet çalıştırır, hoca değil)

```bash
DIVIT_GITHUB_KULLANICI=<kullanici> ./hoca-paketi/kur.sh
```

Hocaya düşen: masaüstündeki Divit simgesine çift tıklamak ve
"başlayalım" demek.

## Geliştirme

```bash
claude plugin validate .                 # yapı doğrulama
/plugin marketplace add ./               # yerel test
```

`version` alanı bilinçli olarak yazılmamıştır — commit SHA'sı sürüm
sayılır, her push hocalara geçer. Pilot 3 kişiyi aştığında `stable`
dalına geçilecek (bkz. `belgeler/PILOT.md`).
