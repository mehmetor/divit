# İzin kipi — Auto varsayılan yapılabilir mi? (DVT-3)

Tarih: 2026-10-08 · Bu Mac'te Claude Code **2.1.293** · Önceki sürümü
(2026-10-01, 2.1.286) bu belge yeniler; sonuç değişmedi, kanıt eklendi.

Bugünkü durum:

- `hoca-paketi/Divit/.claude/settings.json` → `"defaultMode": "acceptEdits"`.
  `kur.sh` / `kur.ps1` izin kipine dokunmuyor (klasör şablonu kopyalanıyor).
- Auto'yu hocaya öneren yerler: `kurulum` sonu (SKILL.md:132), `saglik`
  "İzin kipi" bölümü (SKILL.md:58-75), `KILAVUZ.html` (672-673).

## Bulgular

### 1. Klasör ayarıyla Auto varsayılan yapılamaz

Belge açık: `defaultMode` için "`auto` and `bypassPermissions` don't take
effect from project or local settings, so set them in `~/.claude/settings.json`
instead" (settings-reference, `permissions.defaultMode`). Klasörde `auto`
yazılırsa oturum yerleşik varsayılana döner ve **kullanıcı ayarındaki
`defaultMode` da atlanır** (permission-modes, "Which mode a session starts in").

Bu makinede ölçüldü (`claude -p`, `--setting-sources local`, oturum başı
`permissionMode` alanı):

| Ayar | Oturumun başladığı kip |
|---|---|
| klasör `settings.local.json`: `auto` | `default` (Manual) — yok sayıldı |
| klasör `settings.local.json`: `acceptEdits` | `acceptEdits` |
| `--settings` (kullanıcı/CLI düzeyi): `auto` | `auto` |

Klasör ayarı kullanıcı ayarından üstündür (settings precedence); yani
klasörde `acceptEdits` dururken kullanıcı ayarına `auto` yazmak da etkisizdir.

### 2. Kimde açık?

- **Plan:** "All plans." Team ve Enterprise'da varsayılan açık; yönetici
  `disableAutoMode: "disable"` ile kapatabilir (managed settings).
- **Model:** Anthropic hesabında Opus 4.6+, Sonnet 4.6+, Haiku 5.5 ya da
  Fable. Divit'in klasör modeli `claude-opus-5-5` → uygun.
- HIPAA yapılandırmalı kurumda Auto başlangıç kipi olmaz ama seçilebilir.
- Anthropic sunucu tarafında kapatabilir; o oturum sonuna kadar kapalı kalır.
- Auto seçilip kullanılamıyorsa oturum **sessizce Manual'de** başlar.
- **Maliyet:** Enterprise ve API hesaplarında denetleyici çağrıları jeton
  kullanımına sayılır; belge Pro/Max/Team için bir şey söylemiyor. Denetleyici
  varsayılan Sonnet 5; okumalar ve klasör içi düzenlemeler denetleyiciye
  gitmez, ek yük kabuk komutlarından gelir.

### 3. Masaüstü Code sekmesinde görünüş

- Gönder düğmesinin yanındaki kip seçicide: Manual, Accept edits, Plan,
  **Auto** (yalnız kullanılabilirse; "there is no separate Settings toggle"),
  Bypass (Pro/Max'te ayardan açılırsa).
- Seçicide seçilen kip **klasör başına hatırlanır ve `defaultMode`'un önüne
  geçer** (Plan hariç). Yani hoca bir kez Auto seçerse Divit klasöründe hep
  Auto'da başlar; klasördeki `acceptEdits` yalnız ilk açılışı belirler.
- Masaüstünün yerleşik başlangıç kipi belgede **yazmıyor** (terminal ve
  VS Code için 2.1.283'ten beri `auto`; `-p` için `default`). Klasörde
  `acceptEdits` yazılı olduğu için Divit'i bu boşluk etkilemez.

### 4. Auto'da deny kuralları bağlayıcı mı? — Evet, ama betik yolu açık

Belge: "Deny rules block in every mode, including `bypassPermissions`."
Denetleyici sırası: önce allow/ask/deny kuralları, sonra denetleyici.

Bu makinede Auto kipte ölçüldü (`--permission-mode auto`, klasörde
`Read(./gizli/**)`, `Edit(./gizli/**)`, `Bash(*gizli*)`):

| Komut | Sonuç |
|---|---|
| `cat gizli/not.txt` | **reddedildi** (deny kuralı) |
| `sh -c 'cat g*/n*.txt'` (adı geçmiyor) | **reddedildi** (denetleyici) |
| `./kosu.sh` (içinde `cat "${d}li/not.txt"`) | **çalıştı, içerik okundu** |

`gelen/`, `hakemlik/`, `asil/`, `malzeme/` korumaları Edit/Read deny
olduğu için Auto'da da aynen sürer. `gizli/`'nin betik yoluyla okunması
Auto'ya özgü değildir; `acceptEdits`'te de olur (bkz.
`gizli-klasor-kilidi.md`). Auto bu yolu kapatmaz, yalnız ara sıra yakalar.

### 5. İngilizce soru sayısı

| Durum | `acceptEdits` (bugün) | `auto` |
|---|---|---|
| Klasör içi yazma, `mkdir`/`mv`/`cp` | Sormaz | Sormaz |
| Allow listesindeki pandoc, pdfcpu, `open`, git yedek | Sormaz (2026-09-30 ölçümü: iki akış, **0 ret**) | Sormaz (kurallar önce gelir) |
| Listede olmayan komut (Claude'un beklenmedik bir şey denemesi) | **Sorar** | Denetleyici karar verir; sormaz |
| Korumalı yol (`.claude/`) yazımı | Sorar | Denetleyiciye gider |
| Klasör dışından ilk okuma (Read/Grep/Glob) | Sorar | **Bir kez dört seçenekli soru** ("No, and block…" seçilirse kullanıcı ayarına kalıcı yasak yazılır) |
| Denetleyici art arda 3 / toplam 20 engel | — | Auto duraklar, **sormaya döner** |
| Bash izin sorusunda | "Yes, and switch to auto mode" seçeneği çıkar (CLI'da belgeli) | — |

Özet: allow listesi Divit'in bilinen komutlarını zaten kapsadığı için
olağan akışta iki kip arasında fark küçük; fark, Claude listede olmayan bir
şey denediğinde çıkar. `saglik`'teki "başka kipte her komutta İngilizce izin
sorusu çıkar" cümlesi ölçümle uyuşmuyor (abartılı).

### 6. Riskler

- **Az soru eğilimi:** Belge: Auto "nudges Claude to keep working without
  stopping for clarifying questions, though Claude still asks when your
  prompt or a skill explicitly relies on it." `kurallar`'daki "Anladığım: …
  Doğru mu?" satırı (SKILL.md:42) açık ve zorunlu kalmalı.
- **Kalıcı yasak tuzağı:** klasör dışı ilk okumada hoca "No, and block…"
  seçerse bütün oturumlarda klasör dışı okuma kapanır; Masaüstündeki bir
  dosyayı vermek bozulur. Hoca bunun ne olduğunu anlamaz.
- **Sessiz engel:** denetleyici zararsız bir pandoc/PowerShell komutunu
  durdurabilir; hoca bunu hata sanar. 3 engelden sonra sorular geri gelir.
- **Kurum hesabı:** yönetici kapattıysa seçicide Auto görünmez; öneri cümlesi
  hocayı olmayan bir şeyi aramaya yollar.
- **Konuşmada verilen sınırlar kalıcı değil:** "gizliye bakma" gibi sözlü
  sınır sıkıştırmayla kaybolabilir; belge "hard guarantee" için deny ister.

## Seçenekler

| | Ne | Artı | Eksi |
|---|---|---|---|
| A | Klasörde `acceptEdits` kalır; Auto hocaya **önerilir**, seçim hocanın (bugünkü hâl) | Kurulum profile dokunmaz; Auto yoksa kayıp yok; seçim klasörde hatırlanır | Hocaya bir tık düşer |
| B | Klasörde `"defaultMode": "auto"` | — | **Çalışmaz**: yok sayılır, Manual'e düşer (ölçüldü) |
| C | `kur.sh`/`kur.ps1` kullanıcının `~/.claude/settings.json`'ına `auto` yazar ve klasörden `defaultMode` kalkar | Hoca hiçbir şey seçmeden Auto | Hocanın **bütün** Claude Code oturumlarını değiştirir (tasarım kararı 3: profile dokunma); kurum/plan Auto vermiyorsa Manual'e düşer — bugünkünden kötü |
| D | Klasörden `defaultMode` kaldırılır, yerleşik varsayılana bırakılır | Terminalde Auto | Masaüstünün yerleşik varsayılanı belgede yok; Auto yoksa Manual (en çok soru) |

## Önerilen karar

**A — klasörde `acceptEdits` kalsın, Auto hocaya bir kez önerilsin, kurulum
betikleri kullanıcı ayarına kip yazmasın.** Klasör ayarıyla Auto yapılamıyor;
yapılabilecek tek otomatik yol (C) hocanın profiline dokunuyor ve Auto
olmayan hesapta durumu kötüleştiriyor. Auto'nun gizlilik açısından ek
güvencesi de yok (deny zaten her kipte geçerli; betik yolu iki kipte de açık).

Uygulanırsa değişecek dosyalar (küçük düzeltmeler, ayar değişmez):

- `plugins/divit/skills/saglik/SKILL.md` — "Başka kipte her komutta İngilizce
  izin sorusu çıkar" → "Başka kipte Divit'in tanımadığı işlerde İngilizce izin
  sorusu çıkar." Seçicide Auto yoksa (kurum hesabı) öneriyi tekrarlamama satırı.
- `plugins/divit/skills/kurulum/SKILL.md` (132) — öneri cümlesine "seçicide
  Auto yoksa böyle kalabilir" eki.
- `hoca-paketi/Divit/KILAVUZ.html` (672-673) — Auto'da klasör dışı bir dosya
  için İngilizce soru çıkarsa **"Yes, and keep allowing…"** seçilmesi,
  "No, and block…" seçilmemesi; Auto görünmüyorsa sorun olmadığı.
- `plugins/divit/SURUM.md` — `## Sıradaki` altına not (kılavuz değiştiği için
  `· kurulum gerekir`).
- Değişmeyecek: `hoca-paketi/Divit/.claude/settings.json`, `kur.sh`, `kur.ps1`.

**Mehmet'in denemesi gereken (belgede yok):** masaüstü Code sekmesinde Divit
klasörü ilk açılışta `acceptEdits`'te mi başlıyor; Auto seçilince bir sonraki
oturumda hatırlanıyor mu; klasör dışı ilk okuma sorusu masaüstünde nasıl
görünüyor.

## Kaynaklar

- İzin kipleri — kullanılabilirlik, başlangıç kipi, klasörde `auto` yok
  sayılır, denetleyici sırası, geri düşme eşikleri, klasör dışı ilk okuma,
  maliyet, korumalı yollar: https://code.claude.com/docs/en/permission-modes
- Masaüstü — "Choose a permission mode", "Auto mode availability":
  https://code.claude.com/docs/en/desktop
- Ayar başvurusu — `permissions.defaultMode`, `disableAutoMode`:
  https://code.claude.com/docs/en/settings-reference
- İzin kuralları (deny her kipte): https://code.claude.com/docs/en/permissions
- `claude --help` (2.1.293): `--permission-mode` seçenekleri `acceptEdits,
  auto, bypassPermissions, manual, dontAsk, plan`.
- Önceki ölçüm: `belgeler/sinama/skill-izin-olcumu.md` (acceptEdits, 0 ret),
  `belgeler/sinama/okul-rehberligi.md` (gizli/ izin katmanı).
- Bu belgedeki ölçümler: 2026-10-08, bu Mac, `claude -p --model
  claude-sonnet-5-5 --setting-sources local`, geçici `/tmp` klasörleri
  (silindi).
