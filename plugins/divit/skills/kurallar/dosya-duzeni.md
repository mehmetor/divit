# Divit — dosya düzeni

`kurallar`'daki "Dosya düzeni" özetinin ayrıntısı. Amaç: aylar sonra da
klasör çöplüğe dönmesin, kullanıcı aradığını adından bulsun.

## Değişmez kural

**Kullanıcının kendi dosyaları asla yeniden adlandırılmaz ve taşınmaz**,
adı kurala uymasa da. Aşağıdaki her şey yalnız Divit'in **ürettiği**
dosyalar içindir.

## Adlandırma

- Divit'in ürettiği dosya: `<ad>-YYYY-AA-GG.<uzantı>`.
  `<ad>` kısa, küçük harf, Türkçe karaktersiz, tireli (`rapor`, `dilekce-izin`).
- Aynı gün aynı işin yeni hâli: `<ad>-YYYY-AA-GG-s2.<uzantı>`, sonra `-s3`.
  Yazmadan önce Glob ile bak; varsa bir sonraki sayıyı kullan, üstüne yazma.
- Kullanıcının dosyasından türeyen Word/PDF: ad kısmında `-divit` olur,
  karışmasın: `<kullanıcının dosya adı>-divit-YYYY-AA-GG.docx`.
- Raporun sayfa hâli aynı adı taşır: `rapor-2026-10-01.md` → `rapor-2026-10-01.html`.
- Güncellenerek yaşayan dosyalar tarih almaz: `plan.md`, `envanter.md`,
  `oneriler-<bolum-no>.md`, `kaynaklar/dogrulama.md`, `.divit/` altındaki
  profil, günlük ve not dosyaları. Bunlara önceki sürüm kuralı uygulanır.

## Klasörler — iş türü, sonra konu ya da kişi

| İş | Yer |
|---|---|
| Akademisyen: öğrenci metni raporu | `tez-kontrol/rapor/<baş harfler>/<baş harfler>-YYYY-AA-GG.md` |
| Yazar: kitap raporu | `kitaplar/<kitap-adi>/raporlar/rapor-YYYY-AA-GG.md` |
| Yazar: öneri, çalışma metni | `kitaplar/<kitap-adi>/duzenleme/`, `taslak/` |
| Yazışma | `yazilar/<tür>-<konu>-YYYY-AA-GG.md` |
| Word ve PDF çıktısı | `cikti/<ad>-YYYY-AA-GG.docx` |
| Ara dosya (metne çevrilmiş Word/PDF, deneme) | yalnız `.divit/gecici/<ad>-YYYY-AA-GG.<uzantı>` |

- Baş harf kullan, öğrencinin adını dosya ya da klasör adına yazma.
- Alt klasörü Write kendisi açar; ayrıca klasör açma komutu gerekmez.
- Ara dosya kullanıcının klasörlerine hiç yazılmaz. Adında tarih olsun ki
  `bakim` eskiyenleri bulabilsin.

Genel klasörler: akademisyen `tez-kontrol/` (`gelen/` **salt okunur**,
`rapor/` Divit'in); yazar `kitaplar/<ad>/` (`asil/`, `malzeme/` **salt okunur**;
`raporlar/`, `duzenleme/`, `taslak/`, `plan.md` Divit'in); `yazilar/`,
`kaynaklar/` (+ `.bib`, `dogrulama.md`), `cikti/`, `.divit/`. Yeni klasörü
öner, onayla aç, `gorevler.md`'ye yaz.

## Kitap klasörü betiği

`kitaplar/<ad>/asil` ve `malzeme`'yi yalnız bu betik açar ve doldurur (orada klasör
açma, kopyalama izinle kapalı). Ad küçük harf, Türkçe karaktersiz, tireli. Aynen
(Mac'te betik yolu tırnaksız; izin kuralı tırnaklı yolu tanımaz):
- Mac: `sh ${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.sh ac <ad>`
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/kitap-klasoru.ps1" ac <ad>`

Dosya koymak: `ac <ad>` yerine `koy <ad> asil "<dosya>"` (ya da `malzeme`). Cevap: `ACILDI`,
`KOPYALANDI` tamam; `VAR` → aynı adlı dosya orada, dokunulmadı, onu kullan; `HATA` → sade söyle.

## Klasör dışındaki dosya

Kullanıcı klasör dışındaki bir dosyayı sohbete sürükler ya da yolunu verirse:
söyle, onay al, `koy` ile yerleştir, oradan oku. `koy` HATA verirse Word'ü
pandoc'la doğrudan `.divit/gecici/`'ye çevirip oku; md, txt ya da PDF için
dosyayı sohbete sürüklemesini ya da `kaynaklar/`'a koymasını iste. Klasörü
açıp "buraya koyun" demek son çaredir. "Koydum" dendi ama dosya yoksa
uydurma: gördüğünü söyle, seçenek sun.
