# Denetim — dosya düzeni (DVT-4)

Tarih: 2026-10-08 · Yöntem: metin denetimi (skill'ler okundu, ad ve yol
kalıpları karşılaştırıldı). Canlı sınama yapılmadı; aşağıda "Elle deneme".

DVT-4'ün dört maddesi:
1. Tarihli ve sürümlü ad: `<ad>-YYYY-AA-GG-s2.<uzantı>`.
2. İş türü → kişi/konu → dönem alt klasörleri.
3. Ara dosyalar yalnız `.divit/gecici/`.
4. `bakim` dağınıklığı bulur, hocaya önerir; onaysız taşıma yok, silme yok.

## Kuralın yeri

Kural tek yerde: `plugins/divit/skills/kurallar/SKILL.md` "Dosya düzeni"
özeti + ayrıntısı `kurallar/dosya-duzeni.md` (adlandırma, yerler tablosu,
taşıma komutu). Rol dosyaları (`akademisyen.md`, `yazar.md`) ve skill'ler
aynı kalıpları kullanır ya da kurallara atıf verir.

## Önceki durum (değişiklikten önce)

| Madde | Durum | Not |
|---|---|---|
| 1. Tarihli/sürümlü ad | **Kısmen** | Kural vardı (`-s2`). Uymayanlar: `disa-aktar` (`cikti/<ad>.docx`), `pdf` çizelgesi (`cikti/birlesik.pdf` …) ve PDF→Word (`cikti/<ad>.docx`), `kitap-duzenle/izleme.md` (`-2`, `-3`), `sekil` (`-2`), `eposta` (adsız "bir dosya"). |
| 2. Alt klasörler | **Kısmen** | `tez-kontrol/rapor/<baş harfler>/`, `kitaplar/<kitap>/raporlar/` vardı. Uymayanlar: `yayin-oncesi` kökte `rapor/` (izinde yok, izin sorusu çıkardı), `kitap-duzenle` izleme çıktısı `kitaplar/<kitap>/cikti/` (öteki Word çıktıları kökte `cikti/`). Tabloda olmayan yerler: çeviri, sınav, ses/fotoğraf metni, kaynak doğrulama raporu, makale klasörü. Dönem klasörü hiç yoktu. |
| 3. Ara dosya `.divit/gecici/` | **Yapılmış** | Kuralda ve tüm okuma/çevirme komutlarında (`tez-kontrol`, `yayin-oncesi`, `ceviri`, `kitap-*`, `pdf`, `sunum`, `tablo`, `saglik`, `gelistirici-paylas`) çıktı `.divit/gecici/`. Dışarı yazan skill bulunmadı. |
| 4. `bakim` dağınıklık önerisi | **Kısmen** | Eski ara dosyaları ve kural dışı adları **listeliyordu**; kökte/yanlış klasörde duran çıktı ve sürümsüz aynı adlar aranmıyordu; taşıma önerisi yoktu ("yeniden adlandırma önerme"). |

### Skill başına çıktı (değişiklikten sonra)

| Skill | Çıktı adı ve yeri | Ara dosya |
|---|---|---|
| tez-kontrol | `tez-kontrol/rapor/<bh>/<bh>-YYYY-AA-GG.md` + `.html`, `-s2` | `.divit/gecici/<bh>-…md` |
| yayin-oncesi | `yazilar/<makale-adi>/on-degerlendirme-YYYY-AA-GG.md` (önce kökte `rapor/`) | `.divit/gecici/` |
| kaynak-dogrula | `cikti/kaynak-dogrulama-YYYY-AA-GG.md`; iç kayıt `.divit/dogrulama/` | — |
| sinav | `yazilar/sinav/<ders>-<sınav>-YYYY-AA-GG[-cevap].md`, Word `cikti/` | — |
| bolum-yaz | `plan.md` (yaşayan), öneri ayrı sunulur | — |
| ders-takvimi | profil/görev dosyaları (yaşayan) | — |
| yazisma | `yazilar/<tür>-<konu>-YYYY-AA-GG.md`; `yazilar/<makale>/hakem-cevap-tablosu.md` (yaşayan) | — |
| eposta | uzun metin `yazilar/eposta-<konu>-YYYY-AA-GG.md` (önce adsız) | — |
| disa-aktar | `cikti/<ad>-divit-YYYY-AA-GG.docx`, `-s2` (önce tarihsiz) | — |
| pdf | `cikti/<ad>-<iş>-YYYY-AA-GG.pdf`, PDF→Word `cikti/<ad>-divit-…docx` | `.divit/gecici/form-…json` |
| sunum | `cikti/<ad>-sunum-YYYY-AA-GG.md/.pptx`, `-s2` | `.divit/gecici/` |
| tablo | `cikti/<ad>-YYYY-AA-GG.csv`, `-s2` | `.divit/gecici/` |
| sekil | `sekiller/<ad>.svg/.html/.md` (yaşayan), Word `cikti/<ad>-sekil-YYYY-AA-GG.docx` | — |
| ceviri | `yazilar/<ad>-ceviri-YYYY-AA-GG.md` ya da `kitaplar/<k>/ceviri/` | `.divit/gecici/` |
| ses | `notlar/ses-metin/<ad>-YYYY-AA-GG.md` (yazarda kitap altında), `-s2` | — |
| malzeme | `notlar/malzeme-metin/<ad>-metin-YYYY-AA-GG.md` | — |
| kitap-duzenle | `kitaplar/<k>/raporlar/rapor-YYYY-AA-GG.md`, `cikti/<k>-divit-…docx`, izleme `cikti/<k>-divit-oneriler-…docx` (önce `kitaplar/<k>/cikti/`, `-2`) | `.divit/gecici/` |
| kitap-derle | `kitaplar/<k>/taslak/`, `plan.md`, `cikti/<k>-divit-…docx` | `.divit/gecici/` |
| saglik | yalnız `.divit/gecici/saglik-…` | `.divit/gecici/` |
| gelistirici-* | `.divit/paylasim/…` | `.divit/gecici/` |

## Yapılan değişiklik

- `kurallar/dosya-duzeni.md`: sürüm eki yalnız `-s2` (`-2`, `-yeni`, `(1)` yok);
  yaşayan dosyalara hakem cevap tablosu ve şekil dosyaları; yerler tablosuna
  makale, sınav, çeviri, ses/fotoğraf metni, kaynak doğrulama, PowerPoint/Excel;
  "kökte Divit dosyası durmaz"; dönem kararı; yeni bölüm "Divit dosyasını
  taşımak" (yalnız Divit'in ürettiği, onayla, `mv -n` / `Move-Item -LiteralPath`).
- `kurallar/SKILL.md`: kabuk listesine taşıma (yalnız `bakim` ve tür
  değişimi, onayla); "kökte Divit dosyası durmaz"; yönlendirmede "klasör karıştı".
  149 satır.
- `bakim/SKILL.md`: 5. adım dağınıklık denetimi (a yanlış yer, b dışarıda ara
  dosya, c sürümsüz aynı ad), onaylı taşıma, özet örneği. 135 satır.
- Uyum: `disa-aktar`, `pdf`, `eposta`, `sekil`, `geri-al` (`cikti/` altını da
  Divit'in sayar), `kitap-duzenle` + `izleme.md`, `divit-akademik/yayin-oncesi`.

## Açık karar — dönem klasörü

DVT-4 "iş türü → kişi/konu → dönem" diyor. Dönem için klasör **açılmadı**:
tarih adda, kişi/konu klasöründe ad sırası zaman sırasıdır; derin klasör hocanın
dosya bulmasını zorlaştırır ve bütün skill'lerin yolunu değiştirirdi. Pilotta
bir öğrencinin klasörü kalabalıklaşırsa (ör. 20+ rapor) `<bh>/<YYYY-YYYY>/`
eklenebilir; o zaman yalnız `dosya-duzeni.md` tablosu ve `tez-kontrol` değişir.

## İzin notu

`mv` / `Move-Item` klasör ayarında izinli değil; taşımada hocaya onay penceresi
çıkar. Bilerek böyle bırakıldı: geniş bir `mv` izni `gelen/` dosyalarını da
taşıyabilirdi (deny kuralları yalnız `Edit`'i tutar). Klasör ayarı değişmediği
için sürüm notunda "kurulum gerekir" yok.

## Elle deneme (Mehmet)

1. Akademisyen klasörü: kökte `rapor-2026-09-01.md` + `.html`, `yazilar/`'da
   `dilekce-izin.md` ile `dilekce-izin (1).md`, kökte `tez-metin.txt`; günlüğe
   bunları Divit'in yazdığını gösteren satırlar ekle. Ayrıca günlükte geçmeyen
   bir hoca dosyası (`notlarim.docx`). "bakım yap" de.
   Beklenen: en çok 5 madde; üç Divit dosyası önerilir, `notlarim.docx` önerilmez;
   "evet" sonrası `mv -n` / `Move-Item` ile taşınır, hiçbir şey silinmez,
   günlüğe tek satır.
2. Windows'ta aynı senaryo: `Move-Item` onay penceresi Türkçe hocaya anlaşılır mı,
   bir kez mi her dosyada mı soruyor?
3. `yayin-oncesi` ile kendi makaleni değerlendir: rapor
   `yazilar/<makale-adi>/` altına, izin sorusu çıkmadan yazılmalı.
4. `disa-aktar` iki kez aynı gün: `…-divit-<tarih>.docx`, sonra `-s2`.
