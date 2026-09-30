# Son sınama — üç parçanın birleşimi · 2026-09-30

Dal `orc/yonetici-kitap-yazarlari-i/son` (taban `guncelleme-sinama`, PR #11).
Birleştirme sırası: `kurulum-duzelt` (#14) → `skill-duzelt` (#13) →
`kilavuz-web` (#12), üçü de `git merge --no-ff`, **çakışma çıkmadı.**
Ortam: bu Mac, `/opt/homebrew/bin/claude` 2.1.278; konuşma ölçümleri
`claude-sonnet-5-5`. Bütün kurulumlar `/tmp` altında, geçici `HOME` ve
geçici `CLAUDE_CONFIG_DIR` ile.

Sınanan son hâl: `9643c16`. Birleştirmeden sonra yapılan düzeltmeler
aşağıda "Birleştirmede düzeltilenler"de; her biri bu sınamadan önce
commit'lendi ve ölçümler son commit'te yinelendi.

## Özet

| # | Ölçüm | Beklenen | Sonuç |
|---|---|---|---|
| 1 | `claude plugin validate plugins/divit` | geçer | **GEÇTİ** (yalnız "version" uyarısı) |
| 2 | `claude plugin validate plugins/divit-akademik` | geçer | **GEÇTİ** (yalnız "version" uyarısı) |
| 3 | `bash -n kur.sh` | çıkış 0 | **GEÇTİ** |
| 4 | Her SKILL.md < 150 satır | en uzunu < 150 | **GEÇTİ** (kitap-duzenle 149, kurallar 148, kurulum 147) |
| 5 | `git grep -n -i 'kart\.html\|kart-yazar\|KILAVUZ-YAZAR\|kilavuz-yazar' -- ':!plugins/divit/SURUM.md'` | yalnız yönlendirme dosyaları | **GEÇTİ** — ürün dosyalarında yalnız `apps/web/_redirects` ve `apps/web/vercel.json`. Kalan eşleşmeler sınama betikleri (`araclar/sinama-*.sh`: eski kartın silinmediğini ve yazar kılavuzunun gelmediğini ölçer) ve eski sınama kayıtları (`belgeler/sinama/*`) |
| 6 | `git grep -n 'DIVIT_P' plugins/` | boş | **GEÇTİ** (çıkış 1) |
| 7 | S3: settings.json allow ↔ skill `allowed-tools` birebir | birebir | **GEÇTİ** — `Bash(sh */scripts/kitap-klasoru.sh *)`, `PowerShell(*kitap-klasoru.ps1*)`; kitap-duzenle ve kitap-derle'de birebir (kurallar ve kurulum'da artık yok, bkz. sapma 2) |
| 8 | `diff hoca-paketi/Divit/KILAVUZ.html apps/web/kilavuz.html`; kökte `data-rol=""` | diff boş, 1 eşleşme | **GEÇTİ** |
| 9 | `araclar/sinama-kurulum.sh` | KALDI ve ATLANDI yok | **GEÇTİ** — 41 GEÇTİ, vii4 (data-rol) dahil |
| 10 | `araclar/sinama-guncelleme.sh --dal deneme-gecis-202609301734 --karma` | KALDI ve ATLANDI yok | **GEÇTİ** — 25 GEÇTİ, 4 BİLGİ; konuşma ölçümleri (B2, B3, D, C9) koşuldu |
| 11 | Menü: yazar klasörü | `divit-akademik:` yok, `divit` var | **GEÇTİ** |
| 12 | Menü: akademisyen klasörü | beş `divit-akademik:` komutu | **GEÇTİ** |
| 13 | S8, yazar, kitap-duzenle (Word okuma, `kitap-klasoru.sh ac` ve `koy`) | ret yok, "Ignoring" yok, asıl dosya aynı, .md + .html, mutlak yol düz metin | **GEÇTİ** |
| 14 | S8, akademisyen, tez-kontrol | aynı ölçütler | **GEÇTİ** |
| 15 | Yasak kelime taraması (yazara dönük dosyalar) | eşleşme yok | **GEÇTİ** |
| 16 | Demo provası (`YAZAR-GORUSMESI.md` "Demo hazırlığı", /tmp yollarıyla) | 15 beklenen bulgu | **GEÇTİ** — 15/15, sıra ve uydurmama denetimi tuttu |
| 17 | `/opt/homebrew/bin/claude --version` önce/sonra | değişmez | **GEÇTİ** — 2.1.278 / 2.1.278 |
| 18 | Gerçek `~/.claude` | değişmez | **GEÇTİ** — settings.json, installed_plugins.json, known_marketplaces.json (G1, iki betikte); `settings.json` özeti iş başında ve sonunda `a12b5552…` |

## Birleştirmede düzeltilenler

1. **`Skill(divit:*)`, `Skill(divit-akademik:*)` settings.json'a eklendi**
   (skill-duzelt sapma 2). `allowed-tools` taşıyan skill açılırken izin
   ister; bu iki kural olmadan Desktop'ta her oturum başında İngilizce bir
   pencere çıkar.
2. **`allowed-tools` `kurallar` ve `kurulum`'dan kaldırıldı.** İlk güncelleme
   sınamasında B2, B3a, B3c KALDI: eski klasörün (main'deki) settings.json'ında
   `Skill(divit:*)` yok, bu yüzden yeni eklentiyle `divit:kurallar` ve
   `divit:kurulum` açılırken reddedildi (ölçüldü: permission_denials'ta
   `Skill divit:kurallar`), akademik güvenlik ağı (`akademisyen.md`)
   yüklenmedi ve tez isteğine "kurulumu yenileyin" yerine rapor yazıldı.
   Kaldırınca B2, B3, D, C9 geçti. Betik izni settings.json'da duruyor;
   kitap-duzenle ve kitap-derle (yalnız yeni yazar klasörlerinde) `allowed-tools`'u taşıyor.
3. **`kitap-klasoru.sh` / `.ps1` kökü kendisi bulur.** Serbest bir istekte
   model kuralları yüklemeden `cd kitaplar` yaptı; Bash aracının dizini
   orada kaldı ve betik `kitaplar/kitaplar/dinlemek-uzerine` açtı. Betik
   artık `.divit/` içeren ilk üst klasörü kök alır; bulamazsa `HATA` ile
   çıkar; göreli kaynak yolu çağrıldığı yere göre çözülür. `.ps1`
   `Set-Location` kullanmaz (aynı oturumda `&` ile çağrılınca çağıranın
   konumunu değiştiriyordu), tam yollarla çalışır. Sınama: Mac `sh` ve
   Docker'da PowerShell 7.4.6 — alt klasörden `ac`, `koy`, ikinci `koy`
   (`VAR`, 3), mutlak kaynak, bozuk ad (1), `.divit`'siz klasör (1).
4. **Windows güncelleme komutu** (skill-duzelt sapma 5): `guncelleme`'de
   `` `$env:DIVIT_DAL `` — dıştaki PowerShell değişkeni açmasın. Satır
   çift ters tırnaklı kod bloğuna alındı.
5. **Klasör CLAUDE.md çekirdek kuralları:** kabuk kuralı (zincir ve `cd`
   yok) ve "betiğin yolu `divit:kurallar`'da, yeni kitap için önce onu
   yükle". CLAUDE.md kurallar yüklenmeden de bağlamdadır.
6. **`sinama-guncelleme.sh` G1:** `known_marketplaces.json`'daki
   `lastUpdated` özete girmez. İlk turda G1 KALDI; tek fark
   `claude-plugins-official`'ın `lastUpdated` damgasıydı. Bunu Claude Code
   gerçek girişle açılan her oturumda (karma yol, bu makinedeki öteki
   oturumlar) kendisi yazar; iş başlamadan önce de değişmişti.
7. **Belgeler:** `YAZAR-GORUSMESI.md` demo hazırlığı tek kılavuza,
   .html rapora ve değişkensiz pandoc'a uyduruldu; `GECIS-IKI-EKLENTI.md`'de
   eski dosya adları kalktı.

## S8 ölçümleri — yöntem ve ayrıntı

Klasörler `kur.sh` ile kuruldu (`HOME=/tmp/divit-son/ev DIVIT_TEST=1
DIVIT_TUR=<tür> DIVIT_KAYNAK_ZIP=<HEAD zip'i> DIVIT_DAL=main`), sonra
kopyalandı. `.claude/settings.local.json` = klasörün settings.json'ı,
`extraKnownMarketplaces` çıkarılmış, `enabledPlugins` iki eklenti kapalı,
ek olarak yalnız ölçüm için `Read(/<worktree>/plugins/**)`. Çağrı:

```
claude -p "<istem>" --plugin-dir <worktree>/plugins/divit [--plugin-dir …/divit-akademik]
  --setting-sources local --permission-mode acceptEdits --no-session-persistence
  --output-format stream-json --verbose --model claude-sonnet-5-5 --max-turns 50
```

`--setting-sources local`: `project,local` güvenilmeyen klasörde her
zaman "Ignoring … permissions.allow" yazıyor (skill-duzelt ölçümü, sapma 4);
içerik aynı. stderr'de yalnız `unrecognized_model` bilgi satırı var,
"Ignoring" yok.

**Yazar, kitap-duzenle** — istem: "Kitabım: sahada-yonetmek. Dosya:
/tmp/divit-son/dis/kitap.docx. asil'e koy ve yeni baskı için düzenle. Soru
sormadan ilerle, onay veriyorum: her şeye bakılsın, yeni baskının amacı
güncellemek." 25 tur, permission_denials `[]`. Kabuk komutları:

1. `ls -la <klasör> <klasör>/kitaplar`
2. `sh <eklenti>/scripts/kitap-klasoru.sh ac sahada-yonetmek`
3. `sh <eklenti>/scripts/kitap-klasoru.sh koy sahada-yonetmek asil "/tmp/divit-son/dis/kitap.docx"`
4. `~/.divit/araclar/pandoc "kitaplar/sahada-yonetmek/asil/kitap.docx" -t gfm --wrap=none -o ".divit/gecici/sahada-yonetmek.md"`
5. `ls -R kitaplar/sahada-yonetmek .divit`
6. `mkdir kitaplar/sahada-yonetmek/duzenleme kitaplar/sahada-yonetmek/taslak`
7. `~/.divit/araclar/pandoc "…/duzenleme/rapor-2026-09-30.md" -s --metadata title="Editör raporu — Sahada Yönetmek" -o "…/duzenleme/rapor-2026-09-30.html"`

Asıl dosya: dışarıdaki kaynak ve `asil/kitap.docx` `609a6a31…` = `609a6a31…`.
Üretilen: `duzenleme/rapor-2026-09-30.md`, `.html`, `oneriler-4.md`,
`oneriler-5.md`, `plan.md`. Bildirim: iki mutlak yol, ters tırnak içinde,
kendi satırlarında; `[..](..)` ve `open` yok.

**Akademisyen, tez-kontrol** (iki eklenti) — istem: "tez-kontrol/gelen/ak/
klasöründeki yüksek lisans tezini değerlendir ve rapor çıkar; soru sormadan
ilerle, onay veriyorum". Tez kurgusal, pandoc'la üretilmiş kısa bir docx.
16 tur, permission_denials `[]`. Kabuk: `ls -la tez-kontrol/gelen/ak/
.divit/profil/`, pandoc ile Word → metin, `mkdir -p tez-kontrol/rapor`,
pandoc ile .md → .html. `gelen/ak/tez.docx` `688a51d7…` = `688a51d7…`.
Rapor `tez-kontrol/rapor/ak-2026-09-30.md` + `.html`, bildirim aynı biçimde.

## Yasak kelime taraması

`kurallar/yazar.md`'deki liste (hoca, öğrenci, tez, makale, hakem, jüri,
AVESİS, YÖK, akademik, sınav, APA, kaynakça stili ve ekleri), metin olarak
görünen kısım üzerinde:

- `hoca-paketi/Divit/KILAVUZ.html` yazar sekmesi + ortak bölümler: temiz
- `apps/web/index.html` yazar sekmesi + ortak SSS: temiz
- `plugins/divit/skills/kitap-duzenle/editorluk.md`, `kitap-derle/sablonlar.md`: temiz
- S8 ve demo koşularının yazara giden bütün dosyaları (rapor .md/.html,
  öneriler, plan) ve son mesajları: temiz

## Demo provası

`YAZAR-GORUSMESI.md` "Demo hazırlığı" /tmp yollarıyla: 2. adım `kur.sh`
(`DIVIT_TUR=yazar`), 3. adım örnek dosyalar (`asil/ornek-bolum.docx`,
`malzeme/*.md`), 4. adım profil, 5. adım klasör ayarı (settings.local.json,
yukarıdaki S8 yöntemiyle). Koşu `4379846`'da; sonrasında eklentide yalnız `kitap-klasoru.ps1` değişti. Etkileşimli oturum yerine `claude -p`; iki soru
istemin içinde cevaplandı ("5, hepsi", "1, güncellemek"). 19 tur,
permission_denials `[]`, `kitaplar/` altındaki 8 dosyanın özeti değişmedi.

`beklenen-bulgular.md` A bölümüyle karşılaştırma:

| # | Beklenen | Raporda |
|---|---|---|
| 1 | "erken gelmek" sözü tutulmuyor | Bulgu 1 (önem 3) |
| 2 | Fuar anekdotu ilkeye bağlanmıyor | Bulgu 5, `[BAĞLANTI]` |
| 3 | Çay anekdotu iki bölümde | Bulgu 2 (önem 3), öneri 5/1 gönderme |
| 4 | "Hayat gerçekten de bir okul" dolgu | Bulgu 3 |
| 5 | İngilizce iş jargonu | Bulgu 13, karşılıklar önerildi |
| 6 | 82 kelimelik tek cümle | Bulgu 12 ("yaklaşık yüz kelime"), öneri 4/3 böldü |
| 7 | 1987 / 1989 çelişkisi | Bulgu 7 (önem 3) |
| 8 | 1987 + 12 ≠ 1996 | Bulgu 8 (önem 3) |
| 9 | Kuzeyçam / Kuzey Çam | Bulgu 9 |
| 10 | formen / şef / ustabaşı | Bulgu 10 |
| 11 | Einstein sözü | Güncelleme 6, `[DOĞRULA]`, "doğrusu" yazılmadı |
| 12 | Eskimiş internet oranı | Güncelleme 1, `[GÜNCELLE]` `[DOĞRULA]` |
| 13 | "Geçen yıl emekli", 1.200 | Güncelleme 2 ve 3, `[GÜNCELLE]` |
| 14 | Akyamaç Metal ima | "Yayınevi ya da hukukçuyla konuşun", `[İZİN]`, hüküm yok |
| 15 | herkez, Bende, birşey, Yalnış, Herşey | Bulgu 14 ve 15; öneri 5/4–8 |

Sıra: yapı bulguları (1–6) son okumadan (15) önce. Uydurmama: 7, 8, 11,
12, 13 için yeni bilgi eklenmedi; 8'de yalnız aritmetik ("dokuz yıl").
Listede olmayan ek bulgular (uydurma sayılmaz, metinde karşılığı var):
Einstein paragrafının geçişi, 4. bölümün kapanışı, "sabah" / "vardiya
başı" görüşme farkı, "Kırk yıla yakın", "yüzde üç" farkının kaynağı,
kalite müdürü sahnesinin tanınabilirliği. Raporun kelime sayısı
(yaklaşık 1.950) README'deki 1.150'den yüksek.

## Ek gözlem — karar gerektiren (sınama ölçütü dışında)

Hiçbir skill'e düşmeyen serbest istek "Yeni bir kitaba başlıyorum, adı
'Dinlemek Üzerine'. Kitap klasörünü aç, başka bir şey yapma." yazar
klasöründe üç kez denendi:

- düzeltmelerden önce: `cd kitaplar` → betik `kitaplar/kitaplar/…` açtı
  (düzeltildi, madde 3);
- son hâlde 1. deneme: `divit:kurallar` → `kitap-klasoru.sh ac dinlemek-uzerine`,
  ret yok, doğru yer;
- son hâlde 2. deneme: hiçbir skill yüklenmedi, tek komut
  `mkdir -p "<klasör>/Dinlemek Üzerine" && ls` — kökte Türkçe adlı bir
  klasör açıldı, izin sorusu çıkmadı (`Bash(mkdir *)` allow'u S3 gereği
  duruyor; zincirin iki parçası da izinli).

Kitap düzenleme akışında (kitap-duzenle) betik her koşuda doğru kullanıldı.
Serbest istekte model bazen klasör CLAUDE.md'sindeki "önce kuralları yükle"
adımını atlıyor. Seçenekler: `Bash(mkdir *)`'i kaldırmak ya da daraltmak
(ör. yalnız `.divit/*`), ya da yeni kitaba başlamayı bir skill'in
tetikleyicisine eklemek.

## Kayıtlar

### araclar/sinama-kurulum.sh (son commit)

```
GEÇTİ i1    çıkış 0, 'Kurulum bitti'
GEÇTİ i2    tez-kontrol var, kitaplar yok
GEÇTİ i3    kimlik.md'ye (şablon) 'Kullanıcı türü: akademisyen' yazıldı
GEÇTİ i4    iki eklenti açık, divit kurulu ve güncel
GEÇTİ ii1   çıkış 0, 'Kurulum bitti'
GEÇTİ ii2   kitaplar var, tez-kontrol yok
GEÇTİ ii3   kimlik.md'ye 'Kullanıcı türü: yazar' yazıldı
GEÇTİ ii4   akademik eklenti klasörde kapalı
GEÇTİ iii1  çıkış ≠ 0, 'Kurulum bitti' yok
GEÇTİ iii2  açıklama ve yeni klasör komutu (Divit-Yazar)
GEÇTİ iii3  klasördeki hiçbir dosya değişmedi (shasum)
GEÇTİ iii4  tersi (dolu yazar profili + DIVIT_TUR=akademisyen) de durur, dosya değişmez
GEÇTİ iv1   çıkış 0, 'Kurulum bitti', tür akademisyen
GEÇTİ iv2   dolu kimlik.md değişmedi (tür satırı eklenmedi)
GEÇTİ iv3   elle eklenen izin duruyor, iki eklenti açık
GEÇTİ iv4   divit kurulu ve güncel (pazar yeri main)
GEÇTİ v1    çıkış ≠ 0, 'Kurulum bitti' yok
GEÇTİ v2    ne olduğu ve çözüm komutu yazıyor
GEÇTİ v3    çözüm komutundan sonra kurulum biter (çıkış 0, kurulu ve güncel)
GEÇTİ vi1   Belgeler altında: 'Belgeler → Divit-Yazar'
GEÇTİ vi2   Belgeler altında: 'Belgeler → Divit'
GEÇTİ vi3   Belgeler dışında: tam yol
GEÇTİ vii1  yeni klasörlerde yalnız KILAVUZ.html (kart ve yazar kılavuzu yok)
GEÇTİ vii2  eski klasördeki KART.html silinmedi
GEÇTİ vii3  klasör CLAUDE.md'si ve şablonlarda kart anılmıyor
GEÇTİ vii4  data-rol türe göre (akademisyen / yazar)
GEÇTİ viii1 settings.json: iki kitap-klasoru allow, asil/malzeme deny birebir; mkdir allow duruyor
GEÇTİ viii2 CLAUDE.md 'Araçlar' dolu (pandoc, pdfcpu tam yol; pdftotext 'yok'; yer tutucu yok)
GEÇTİ viii3 CLAUDE.md çekirdek kuralı: klasör açma ve kopyalama yalnız kitap-klasoru betiğiyle
GEÇTİ ix1   .divit/kanal.txt = DIVIT_DAL (deneme / main)
GEÇTİ ix2   DIVIT_DAL'sız yeniden kurulum deneme kanalında kaldı
GEÇTİ ix3   klasör ayarındaki pazar yeri adresi kanalın adresi
GEÇTİ ix4   main kanalında 'Deneme kanalı' satırı yok
GEÇTİ ix5   izinsiz dal adı → uyarı, main
GEÇTİ ix6   'yeni' izinli kanal
GEÇTİ x1    sahte claude çağrıldı ama 'update' yok
GEÇTİ x2    resmî kurulum (claude.ai/install) indirilmedi
GEÇTİ x3    bilgi satırı: güncelleme atlandı
GEÇTİ G1    gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi
GEÇTİ G2    /opt/homebrew/bin/claude sürümü değişmedi (2.1.278 (Claude Code))
GEÇTİ G3    ~/Documents klasör kaydı (değişme zamanı, boyut) değişmedi
```

### araclar/sinama-guncelleme.sh --dal deneme-gecis-202609301734 --karma (son commit)

```
GEÇTİ A1   yalnız divit@divit kurulu, sürüm main'deki özet (658769f6be47)
GEÇTİ A2   init'te divit:tez-kontrol var
BİLGİ A3   pazar yeri kaydında divit autoUpdate: yok (anahtar yazılmamış) (kur.sh CLI ile ekler; Desktop klasöre güvenince şablondaki autoUpdate:true işlenebilir)
GEÇTİ B0   raw marketplace.json deneme commit'iyle aynı (300 sn)
GEÇTİ B1a  divit yeni özette (c7b56e733a47), divit-akademik kurulu değil
GEÇTİ B1b  init: divit-akademik:* yok, divit:tez-kontrol yok, divit yeni yoldan
GEÇTİ B4a  eski CLAUDE.md divit:kurallar'ı yüklüyor (tür kurallar'da çözülür)
GEÇTİ B4b  eski settings.json eklenti dosyalarını okumaya izin veriyor (akademisyen.md)
BİLGİ B4c  eski tez-kontrol/CLAUDE.md eski skill adını anıyor; B3 güvenlik ağı bunu karşılamalı
BİLGİ B4d  eski settings.json'da kitaplar/ yasakları yok (akademisyende kitaplar/ yok; C'de gelir)
BİLGİ B5   açık oturum eski eklentiyle sürer; yeni sürüm Claude kapatılıp açılınca gelir
GEÇTİ B2   merhaba → kurallar akademisyen.md'yi Read ile okudu
GEÇTİ B3a  tez isteği → 'kurulumu bir kez yenilemek' yönlendirmesi
GEÇTİ B3b  sade Türkçe (eklenti/plugin/terminal/zip/JSON geçmiyor)
GEÇTİ B3c  rapor yazılmadı, hiçbir dosya değişmedi (.divit/ dışı)
GEÇTİ D1   güncelle → guncelleme skill'i yenilikleri anlatıp onay istiyor
GEÇTİ D2   kurulum onaysız çalıştırılmadı (kur.sh/kur.ps1 çağrısı yok)
GEÇTİ D3   akademik madde (komut adları, kurulumu yenileme) hocaya söylendi
GEÇTİ C1   iki eklenti kurulu: divit c7b56e733a47, divit-akademik fb29c366bf04
GEÇTİ C2   settings.local.json: iki eklenti açık, elle eklenen izinler duruyor
GEÇTİ C3   profil, tez-kontrol/gelen, yazilar değişmedi; kimlik.md'ye tür satırı eklenmedi
GEÇTİ C4   settings.json yeni: kitaplar yasakları var, pazar yeri deneme-gecis-202609301734
GEÇTİ C5   .claude/rules/taslak-yazim.md yeni
GEÇTİ C6   KILAVUZ.html yeni (/divit-akademik:, data-rol akademisyen), KILAVUZ-YAZAR.html ve kitaplar/ yok
GEÇTİ C10  .divit/kanal.txt = deneme-gecis-202609301734, CLAUDE.md 'Araçlar' dolu
GEÇTİ C7   .divit/kurulum-surumu.txt yazıldı (1.7)
GEÇTİ C8   init'te beş divit-akademik skill'i, eklentiler yeni yollardan
GEÇTİ C9   tez isteği → divit-akademik:tez-kontrol çalıştı, öğrenci dosyası değişmedi
GEÇTİ G1   gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi
```

### Menü (deneme-gecis-202609301734'ten kurulan klasörler, `claude -p` init)

```
yazar kur.sh çıkış 0
  Kurulu ve güncel (sürüm c7b56e733a47).
  eklentiler: ['divit']
  divit-akademik: []
  divit: ['divit:bakim', 'divit:disa-aktar', 'divit:eposta', 'divit:gelistirici-ihtiyac-gorusmesi', 'divit:gelistirici-paylas', 'divit:geri-al', 'divit:guncelleme', 'divit:kitap-derle', 'divit:kitap-duzenle', 'divit:kurulum', 'divit:pdf', 'divit:saglik', 'divit:yardim', 'divit:yazisma']
  MENÜ yazar: GEÇTİ
akademisyen kur.sh çıkış 0
  Kurulu ve güncel (sürüm c7b56e733a47).
  eklentiler: ['divit', 'divit-akademik']
  divit-akademik: ['divit-akademik:bolum-yaz', 'divit-akademik:kaynak-dogrula', 'divit-akademik:sinav', 'divit-akademik:tez-kontrol', 'divit-akademik:yayin-oncesi']
  divit: ['divit:bakim', 'divit:disa-aktar', 'divit:eposta', 'divit:gelistirici-ihtiyac-gorusmesi', 'divit:gelistirici-paylas', 'divit:geri-al', 'divit:guncelleme', 'divit:kitap-derle', 'divit:kitap-duzenle', 'divit:kurulum', 'divit:pdf', 'divit:saglik', 'divit:yardim', 'divit:yazisma']
  MENÜ akademisyen: GEÇTİ
```
