# Güncelleme paketi sınaması — DVT-66, DVT-67, DVT-68, DVT-69

Tarih: 2026-10-08/09 · Bu Mac, Claude Code **2.1.295** (`claude -p`), model
klasör ayarından (`claude-opus-5-5`, effort low) · Dal
`orc/yonetici-plane-kullan-m-na/sina` (`uygula` dalının üstünde; uygula
develop'a alınmamıştı) · Ölçüm belgesi: `guncelleme-paketi-olcum.md`.

**Sonuç:** Paketin dört işi uçtan uca çalışıyor; bir KALDI çıktı ve
düzeltildi: geçiş notu (DVT-69) hiç sorulmuyordu, çünkü "ilk iş bitince
hatırlatma denetimi" tetiği hiç çalışmıyordu (`-p`'de 0/3, bu Mac'in
masaüstü oturumlarında 0/4). Tetik ilk günlük satırına bağlandı
(`3109f3f`), sonra 4/4. TEST-ORTAMI 7.3'teki iki yanlış beklenti de
düzeltildi.

## Düzen

- Geçici kök `/tmp/divit-sina14` (`$CLAUDE_JOB_DIR` bu oturumda
  tanımsızdı). Kayıtlar `kayit/*.jsonl` (her oturumun stream-json'u),
  `kayit/kur-cagrilari.log`, `kayit/curl.log`; bilerek silinmedi.
- **1.8.0:** `git archive origin/main` zip'i ve onun `kur.sh`'si,
  `HOME=<geçici ev>`, `DIVIT_TEST=1`, `DIVIT_KAYNAK_ZIP`, `DIVIT_DAL=deneme`.
  Akademisyen varsayılan yola (`ev/Documents/Divit`), yazar
  `DIVIT_HEDEF=ev/Documents/Divit-Yazar` ile. İkisi de `deneme 1.8.0`.
  Profiller dolduruldu (kurulum becerisi tetiklenmesin), kişi dosyaları
  kondu (`yazilar/…`, `gizli/ogrenci-notu.md`, `kitaplar/…/asil/…`),
  `hatirlatma.md` eski tarihli dört anahtarla.
- **Aday:** bu dalın `git archive HEAD`'i; `SURUM.md`'de `## Sıradaki`
  → `## 1.9.0 · 2026-10-08` (TEST-ORTAMI 7.1 gibi, yalnız geçici kopyada).
  Konuşmada eklenti bu kopyadan `--plugin-dir` ile (hocada kendiliğinden
  inmiş 1.9.0'ın yerine).
- **Konuşma:** `claude -p` gerçek girişle, `--setting-sources
  project,local`, `--plugin-dir`, `--output-format stream-json`; çok
  turlu akış `--resume`. Klasör CLAUDE.md'si yüklü.
- **Kurulum güvenliği:** `claude -p`, önde sahte `curl` olan bir `PATH`
  ile başladı. Sahte curl yalnız `…/kur.sh` isteğine (boru ya da `-o`)
  bir sarmalayıcı döndürür; sarmalayıcı `HOME`'u geçici eve çevirir,
  `DIVIT_TEST=1` ve aday zip'iyle **adayın `kur.sh`'sini** çalıştırır,
  `DIVIT_DAL`/`DIVIT_HEDEF`/`DIVIT_TUR`'u kaydeder. Claude'un yazdığı
  komut metni gerçeğiyle birebir aynı; çalışan kurulum geçici evde. Bash
  aracının saplamayı gördüğü önce doğrulandı (`command -v curl`).
- **Düzenek bedeli (iki tuzak):**
  1. `-p`'de klasör "güvenilmemiş" sayılıyor, `settings.json`'daki
     `permissions.allow` yok sayılıyor ("Ignoring 66 permissions.allow
     entries … not been trusted"). Gerçek klasörde hoca klasöre güvenir.
     Bu yüzden her oturumdan önce `settings.json` izinleri
     `settings.local.json`'a aynalandı (pazar yeri ve `enabledPlugins`
     çıkarılarak; eklenti dizini için `Read(//…)` eklenerek). Güncelleyici
     kuralı da böyle aynaya geçti; kuralın `settings.json`'daki metni
     ayrıca denetlendi.
  2. Aynanın `settings.json`'a dokunması, güncellemede "4 ayar dosyası
     saklandı" demesine yol açtı (temizde 3; aşağıda 20).

## Senaryo × sonuç

Kimlikler `kayit/<ad>.jsonl` dosyalarıdır.

| # | Senaryo | Sonuç | Kanıt |
|---|---|---|---|
| 1 | 1.8.0'ı iki klasöre kurmak (main `kur.sh` + zip) | GEÇTİ | `kur-a`, `kur-y`: çıkış 0, `Kullanıcı türü` doğru, `deneme 1.8.0` |
| 2 | (a) İlk mesaj "güncelle": kurallar önce yüklenir (`-p`) | GEÇTİ | 7/7 oturumda ilk araç `Skill(divit:kurallar)`, sonra `divit:guncelleme` (y1a, ab1a, ab2a, aaauto1, aaacc1, k1, a1a); "yenilikler neler" de (y4) |
| 3 | (a) Aynısı masaüstünde | ÖLÇÜLEMEDİ | Ölçüm belgesinde masaüstü 0/2; `-p` bunu yeniden üretemiyor. Mehmet'in denemesi (M1) |
| 4 | (b) Eski klasör: komutta `DIVIT_HEDEF` = sohbetin klasörü, tür verilmez | GEÇTİ | 4/4: `curl -fsSL …/deneme/kur.sh \| DIVIT_DAL=deneme DIVIT_HEDEF="<o klasör>" bash`; `kur-cagrilari.log`'da dört ayrı klasör, `DIVIT_TUR=<yok>` |
| 5 | Güncelleme öbür klasöre dokunmaz | GEÇTİ | Yazar güncellenirken akademisyen özeti `f768bdd…` önce = sonra; akademisyen güncellenirken yazar `bb79559…` = `bb79559…`; yazarın 2.–3. oturumunda akademisyen `4017b07…` = `4017b07…` |
| 6 | Tür klasörden: yazarda `divit-akademik@divit: false`, akademisyende `true`, `gizli/` ve dosyası yerinde | GEÇTİ | `settings.local.json`; `gizli/ogrenci-notu.md`, `yazilar/gec-azot/taslak.md` içerikleri aynı |
| 7 | (c) acceptEdits, eski klasör | GEÇTİ | y1b: tek araç çağrısı, tek onay iletisi ("…multiple operations… require approval"); `-p` soru gösteremediği için ret → Divit başka yol denemedi, Run metnini ve komutu kutuda verdi, `sorunlar.md`'ye "güncelleme" notu (Read+Edit). Masaüstündeki "Allow once" sorusu: M2 |
| 8 | (c) Auto, eski klasör | GEÇTİ | 3 deneme: 2 izin (ab1b, ab2b; sahte kurulum çalıştı), 1 ret **[Code from External]** (a1b). Retten sonra Divit Run yolunu verdi, `sorunlar.md`'ye yazdı, başka araç denemedi. Kararsızlık ölçüm belgesindeki gibi; yedek yol çalışıyor |
| 9 | (c) Güncelleyicili klasör, acceptEdits | GEÇTİ | aaacc2: `sh /tmp/…/ev/.divit/guncelle.sh deneme "<klasör>"` sorusuz çalıştı. Karşılaştırma: kural çıkarılınca (k2) aynı komut "This command requires approval" → kural gerçekten eşleşiyor |
| 10 | (c) Güncelleyicili klasör, Auto | GEÇTİ | aaauto2: aynı komut, ret yok, kurulum çalıştı (1/1). Sınıflandırıcının hiç çağrılmadığı dışarıdan görülmüyor; kuralın eşleştiği 9'dan biliniyor |
| 11 | Kurulumun klasöre yazdıkları | GEÇTİ | Güncellenen klasörde `kurulum-surumu.txt` 1.9.0, `hatirlatma.md`'de `son-gecis: 1.8.0` bir kez; `~/.divit/guncelle.sh` (geçici evde), CLAUDE.md'de `Güncelleyici: …`, settings.json'da `Bash(sh <ev>/.divit/guncelle.sh *)`; öbür klasör `1.8.0` kaldı |
| 12 | Run çıktısı okunur, kapanış ve günlük | GEÇTİ (kısmen ölçüldü) | y1c: çıktı mesajla verildi (masaüstünde Run düğmesi çıktıyı sohbete kendisi koyar; o yol ölçülemedi). "Güncelleme tamamlandı… eski hâli saklandı… Claude'u kapatıp açın"; `gunluk.md`'ye Read+Edit ile `· güncelleme · — · 1.9.0` |
| 13 | (d) Güncelleme akışında yasak kabuk komutu | GEÇTİ | Bütün "güncelle" oturumlarında Bash yalnız kurulum komutu; dosyalar Read/Edit ile. Ölçüm belgesindeki `head`, `cat`, `echo >>`, `printf >>` görülmedi |
| 14 | (e) `hatirlatma.md` anahtar tekrarı | GEÇTİ | 16 klasör kopyasının hiçbirinde tekrar eden anahtar yok; değişiklikler Edit ile |
| 15 | Yazar klasöründe akademik madde gelmez | GEÇTİ | y1a: dört madde, "Akademisyen: gizli…" maddesi yok; akademisyende (a1a) var |
| 16 | **Geçiş notu ilk işten sonra bir kez sorulur (aday, düzeltmesiz)** | **KALDI → düzeltildi** | a2a, ac1, ac3: iş bitti, günlük satırı yazıldı, `divit:bakim` hiç çağrılmadı (0/3); `son-gecis` 1.8.0'da kaldı. Bu Mac'in gerçek masaüstü oturumlarında da (4 oturum, ~170 kullanıcı satırı) `bakim` 0, `hatirlatma.md` hiç güncellenmemiş. Neden ve düzeltme aşağıda |
| 17 | Düzeltmeyle: geçiş sorusu ilk işten sonra | GEÇTİ | Günlük yazılan 4/4 iş oturumunda `bakim` yüklendi (fx2, fx5, fx6, y2a); akademisyende soru 3/3 (fx6'da `1.9.0.md`'deki metnin aynısı). Yalnız soru-cevap oturumlarında (fx1, fx3) günlük yok, tetik de yok (beklenen) |
| 18 | "Evet"ten sonra `son-gecis` ilerler | GEÇTİ | fx6b: `open .`, kapanış cümlesi; `son-gecis: 1.9.0`; günlükte `· geçiş · 1.9.0 · … evet dedi, Divit klasörü açıldı` |
| 19 | Üçüncü oturumda tekrar sorulmaz | GEÇTİ | fx6c (akademisyen) ve y3a (yazar): `bakim` yüklendi, soru yok, `hatirlatma.md` değişmedi |
| 20 | Yazarda geçiş sorusu yok, `son-gecis` sessizce ilerler | GEÇTİ | y2a: `1.9.0.md` okundu, "Kimin için: akademisyen" atlandı, `son-gecis: 1.9.0`, hocaya soru yok |
| 21 | Kurulumdan sonra "yenilikler neler" | GEÇTİ | y4: uzak SURUM WebFetch ile okundu, "Divit'iniz güncel", kurulum önerisi yok. TEST-ORTAMI'deki "1.9.0'ın notları" beklentisi yanlıştı (notlar güncelleme sohbetinde anlatılıp `son-gorulen-surum` yazılıyor); düzeltildi |
| 22 | Temiz güncellemede yedek satırı | GEÇTİ (belge düzeltildi) | Ayna olmadan 1.8.0 → aday: "Değiştirilen 3 ayar dosyasının önceki hâli saklandı" (CLAUDE.md, KILAVUZ.html, .claude/settings.json). TEST-ORTAMI 7.3 bu satırın çıkmamasını bekliyordu; 1.8.0'ın tasarımı gereği çıkar |
| 23 | `araclar/sinama-kurulum.sh` (i–xii) bu dalda | GEÇTİ | 62 GEÇTİ, KALDI yok, çıkış 0 |
| 24 | Windows | ÖLÇÜLEMEDİ | Aşağıda W1–W5 |

## KALDI: geçiş notu hiç sorulmuyordu (16) — düzeltildi

**Neden.** Geçiş notu `bakim` → "Hatırlatma denetimi"nin ilk adımı;
denetimi `kurallar`'ın en sonundaki tek satır istiyordu: "İlk iş bitince
(önce değil) `bakim` skill'inin 'Hatırlatma denetimi' bölümünü uygula."
Claude bu satırı uygulamıyor: işi bitirip günlüğü yazıyor, cevabı
kapatıyor. Bu yalnız geçişi değil, haftalık geri bildirim ve aylık bakım
önerilerini de baştan beri etkiliyordu (masaüstü kanıtı: 4/4 oturumda
`bakim` yok).

**Düzeltme** (`3109f3f`, tek dosya `plugins/divit/skills/kurallar/SKILL.md`,
149 satır): tetik, her oturumda güvenilir yazılan günlük satırına bağlandı.
"İş günlüğü" bölümüne: "Oturumun **ilk** günlük satırını yazınca, cevabı
bitirmeden `divit:bakim` skill'ini yükle ve 'Hatırlatma denetimi'ni uygula
(hatırlatılacak bir şey yoksa sessiz geç)." Eski satır kaldırıldı.
Sonuç: düzeltmesiz 0/3, düzeltmeyle 4/4 (16–20). Hocaya görünen etkisi
(öneriler artık gerçekten gelir) `SURUM.md` → `## Sıradaki`'ye yazıldı.

**Bedeli ve sınırı.** Her iş oturumunda `bakim` (148 satır) bir kez
yüklenir. Hoca yalnız soru sorup günlük satırı yazdırmayan oturumlarda
hatırlatma yine gelmez; geçiş bir sonraki iş oturumuna kalır.
Masaüstünde ölçülmedi (M3).

## Gözlemler (KALDI değil, bu paketin dışında)

- **İngilizce ara cümleler hocaya görünüyor:** "Log to sorunlar.md."
  (a1b), "Not for yazar; skip and record." (y2a), "Now the log entry."
  (fx2, y2a, fx6c). Araç çağrıları arasındaki metin sohbette görünür.
  Effort `low` ile ilgili olabilir. Plane'de ayrı iş önerilir.
- **Yasak kabuk başka akışlarda:** "kaynaklar klasöründe ne var?" → `ls -la`
  (ac2, fx3; kurallar Glob diyor); `bakim` geçiş dosyalarını bir kez
  `ls …/gecisler` ile listeledi (y2a; beceri Glob diyor). Güncelleme
  akışında görülmedi.
- **Uzak sürüm denetimi "güncelle"de atlanıyor:** `son-uzak-denetim` 7
  günden eskiyken "güncelle" oturumlarında WebFetch 0/7; "yenilikler
  neler"de 1/1. Bu sürümde etkisi yok (yüklü sürüm zaten yeniydi ve
  kurulum önerildi).
- **Geçiş günlük satırı** bir oturumda soru sorulurken "cevap bekleniyor"
  diye yazıldı (fx2), öbüründe cevaptan sonra (fx6b). Beceri cevaptan
  sonrasını kastediyor; zararsız.
- `DIVIT_HEDEF`'e `/private/tmp/…` (gerçek yol) yazıldı; Mac'te
  `~/Documents` için fark yok.

## Gerçek sistem

| Ne | Önce | Sonra |
|---|---|---|
| `~/.claude/settings.json` | `f313993e2fd6` | aynı |
| `~/.claude/plugins/known_marketplaces.json` (pazar yeri kaydı) | `adf2aea8e711` | aynı |
| `~/.claude/plugins/installed_plugins.json` | `eefdf6f86421` | **`0a2a591d8802`** — aşağıya bakın |
| `~/.divit` | yalnız `araclar/` (zaman 16:57) | aynı; `guncelle.sh` yok |
| `~/Documents/Divit`, `Divit-Yazar` | bu oturum okuyamıyor (macOS: "Operation not permitted") | dokunulamadı da; bütün kurulumlar `HOME=<geçici ev>` |
| `origin/deneme` | `0fe1fe1aa3a2` | aynı; yayın yapılmadı, push yok |

**`installed_plugins.json`'a bir kayıt eklendi (düzenek hatası).** Run
taklidinden sonra kur.sh yazar kopyasının `settings.local.json`'ına
`enabledPlugins`'i geri yazdı; aynayı yenilemeden açılan y1c oturumu
gerçek dosyaya şu kaydı ekledi: `divit@divit`, `scope: local`,
`projectPath: /private/tmp/divit-sina14/ev/Documents/Divit-Yazar`.
Yalnız o geçici yolda geçerli; Mehmet'in klasörlerini, kullanıcı
düzeyindeki kurulumu ve pazar yerini etkilemez. Kaydı geri almayı
denedim; oturumun güvenlik denetimi kendi ayarını değiştirme sayıp
reddetti, ben de bırakıp size bıraktım. Kaldırmak için (Mehmet):

```bash
cd /private/tmp/divit-sina14/ev/Documents/Divit-Yazar && claude plugin uninstall divit@divit --scope local
```

Ya da olduğu gibi bırakın: `/tmp` silinince sahipsiz kalır, zararı yok.

## Windows'ta Mehmet'in elle denemesi gerekenler

Windows'un hiçbir adımı bu Mac'te ölçülemedi.

- **W1** 1.8.0 klasöründe (deneme kanalı) "güncelle" → "evet", **Accept
  edits**: komut `powershell -NoProfile -ExecutionPolicy Bypass -Command
  "`$env:DIVIT_DAL='deneme'; `$env:DIVIT_HEDEF='C:\Users\<ad>\Documents\<klasör>'; irm …/deneme/kur.ps1 | iex"`
  mı (ters tırnaklar yerinde mi)? Kaç İngilizce soru, "Allow once"
  kurulumu bitiriyor mu, `DIVIT_HEDEF` o klasör mü?
- **W2** Aynısı **Auto**'da, 3 kez: ret gelirse Divit Run metnini ve
  komutu kutuda veriyor mu, `sorunlar.md`'ye yazıyor mu?
- **W3** Güncellemeden sonra: `%USERPROFILE%\.divit\guncelle.ps1` var mı;
  klasör CLAUDE.md'sinde `Güncelleyici:` satırı ve settings.json'da
  PowerShell kuralı var mı? `kurulum-surumu.txt`'yi elle `1.8.0` yapıp
  "güncelle" → komut `powershell -NoProfile -ExecutionPolicy Bypass -File
  "<güncelleyici>" deneme "<klasör>"` mı; Accept edits'te ve Auto'da soru
  ya da ret çıkmadan çalışıyor mu? **Boşluklu ve Türkçe harfli kullanıcı
  adında** (ör. `C:\Users\Ayşe Yılmaz`) aynı.
- **W4** İki klasörlü Windows'ta (Divit + Divit-Yazar): Divit-Yazar'da
  güncellerken `Documents\Divit` değişmiyor mu (`kurulum-surumu.txt`
  yalnız güncellenen klasörde yeni)?
- **W5** Geçiş: akademisyen klasöründe güncellemeden sonra yeni sohbet →
  bir dilekçe iste → sonunda "gizli" sorusu → "evet" → Gezgin açılıyor mu
  (`Invoke-Item .`), `son-gecis: 1.9.0` mı; ikinci iş sohbetinde soru
  yok mu?

## Mehmet'in Mac'te son el denemesi (TEST-ORTAMI 7.3)

Aday (bu dal, `3109f3f` dahil) 7.1 ile deneme dalına gönderildikten
sonra. Beklentiler bu sınamaya göre güncellendi.

- **M1** Divit-Yazar'da yeni sohbet, ilk mesaj `güncelle`. Dökümde ilk
  Skill çağrısı `divit:kurallar` mı? (Masaüstünde ölçüm belgesine göre
  daha önce 0/2; "Önce" satırı bunun için.) Sayım:
  `grep -o '"skill":"divit:[a-z-]*"' ~/.claude/projects/-Users-minihome-Documents-Divit-Yazar/<oturum>.jsonl | head -3`
- **M2** Yenilikler (en çok dört madde, akademik madde yok) → "evet".
  Komutta `DIVIT_HEDEF="/Users/minihome/Documents/Divit-Yazar"`.
  Accept edits'te tek İngilizce soru → **Allow once**; Auto'da ret gelirse
  Run. Çıktıda "Değiştirilen 3 ayar dosyasının önceki hâli saklandı"
  olağan. `Documents/Divit`'in `kurulum-surumu.txt`'si `1.8.0` kalmalı.
- **M3** Claude'u kapatıp aç. Divit (akademisyen) klasöründe de M1–M2.
  Sonra yeni sohbette bir **iş** iste (ör. bir dilekçe; yalnız soru
  sormak yetmez). Cevabın sonunda bir kez "gizli klasörü … açayım mı?"
  sorusu gelmeli → "evet" → Finder açılır; `hatirlatma.md`'de
  `son-gecis: 1.9.0`. Yeni sohbette ikinci bir iş → soru gelmemeli.
  Divit-Yazar'da bir iş → soru hiç gelmemeli, `son-gecis: 1.9.0`.
- **M4** Güncellenen bir klasörde `kurulum-surumu.txt`'yi `1.8.0` yapıp
  "güncelle" → komut `sh /Users/minihome/.divit/guncelle.sh deneme
  "<klasör>"`; Accept edits'te ve Auto'da soru ve ret yok.
- **M5** Bu turlarda araçlar arasında İngilizce cümle görünüyor mu
  (Gözlemler, ilk madde)? Görünüyorsa Plane'e yazın.

## Ölçülemeyenler

- Masaüstü ile `-p` farkı: kuralların beceriyle başlayan oturumda yüklenmesi
  (3), "Allow once" sorusunun görünüşü (7), Run düğmesinin çıktıyı sohbete
  getirmesi (12), hatırlatma tetiğinin masaüstünde çalışması (17).
- Auto'da güncelleyici kuralının sınıflandırıcıyı atladığı doğrudan
  (yalnız sonucu, 10).
- Windows'un tamamı (24).
