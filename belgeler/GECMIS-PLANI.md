# Sessiz geçmiş — git ile belirleyici yedek (plan)

Durum: **planlandı, başlanmadı.** İş Plane'de açılır (DVT); bu belge
tasarım ve aşamaları taşır. Araştırma 2026-10-09'da yapıldı; aşağıdaki
"Doğrulanan gerçekler" o günün durumudur, işe başlarken yeniden denetle.

## Sorun

Hocanın en büyük korkusu çalışmasını kaybetmek (IHTIYAC-ANALIZI §3c).
Bugünkü koruma iki kurala dayanır: Word/PDF yerinde değişmez; metin
dosyası değişmeden önce `.divit/onceki-surumler/`'e kopyalanır. İkincisini
model Read + Write ile yapar; **unutursa yedek yoktur.** Hocanın Divit
dışında (Word'de) yaptığı değişikliklerin hiçbir geçmişi tutulmaz.
Claude Code'un kendi `/rewind`'i yalnız Claude'un Write/Edit'lerini tutar,
30 günde silinir; bu korkuyu karşılamaz.

## Doğrulanan gerçekler

- **MinGit** (Git for Windows'un kurulumsuz zip'i): 2.56.0.2, 64-bit zip
  ~40 MB, arm64 var. Pandoc gibi `~/.divit/araclar/git/` altına açılır,
  yönetici hakkı istemez. `bash.exe` içermez; bu iyidir, Claude Code onu
  Git Bash sanıp kabuğu değiştirmez, hook'lar PowerShell'de kalır.
  Kullanacağımız komutlar (add, commit, log, show, archive) kabuk istemez.
- **Claude Code hook'ları** `"shell": "powershell"` alanı taşıyor;
  `${CLAUDE_PROJECT_DIR}` yer tutucusunu PowerShell'de kendisi çeviriyor.
  Hook klasörün `.claude/settings.json`'ında durabilir. CLAUDE.md 5.
  kararın gerekçesi ("ortak betik yazılamaz") böylece kalkar: hook'u
  eklenti değil, **kurulum betiği platforma göre yazar** (güncelleyici
  kuralı zaten böyle yazılıyor, `kur.ps1` "guncelleKurali").
- Hook'lar yalnız klasör güven penceresinden sonra çalışır; hoca o
  pencereyi bugün de görüyor (KILAVUZ "Güvenlik"). **Yeni soru çıkmaz.**
  Stop ve PostToolUse hook çıktısı hocaya gösterilmez; `async: true`
  bekletmez. SessionEnd'in varsayılan süresi 1,5 sn; kullanılmaz.
- **Mac:** Apple git'i yalnız Xcode komut satırı araçlarıyla veriyor;
  taşınabilir ya da üçüncü taraf ikili yok (son dış kurulum 2021'de
  bırakılmış). `xcode-select --install` yönetici istemez ama Apple
  penceresi açar ve birkaç yüz MB indirir. Araçlar yokken `git` çağırmak
  o pencereyi açar; her çağrı önce `xcode-select -p` ile korunur.
- Masaüstü uygulaması klasör kökünde `.git` görürse dal adı ve "worktree"
  seçeneği gösterir: hocaya İngilizce git arayüzü. Kaçınılmalı.

## Tasarım

1. **Depo gizli, kökte `.git` yok.** Git `--git-dir=.divit/gecmis
   --work-tree=<klasör>` ile çalışır. Kökte `.git` olmayınca ne Claude
   Code ne masaüstü uygulaması depo sayar; dal adı, worktree, git status
   bağlamı çıkmaz. `.gitignore` klasöre girmez; dışlamalar
   `.divit/gecmis/info/exclude` içinde. Depo `.divit` altında olduğu için
   klasörle taşınır; OneDrive / Time Machine onu da yedekler.
   Alternatif `~/.divit/gecmis/<klasör-kimliği>` idi: klasör silinse
   geçmiş kalır ama klasör taşınınca kopar, kimlik eşlemesi gerekir.
   Karar: içeride.
2. **Tek sarmalayıcı betik, iki sürüm:** `~/.divit/gecmis.sh` ve
   `~/.divit/gecmis.ps1`. Alt komutlar: `kaydet <klasör> <ileti>`,
   `liste <klasör> [yol]`, `goster <klasör> <kimlik> <yol> <hedef>`.
   Git'in tam yolunu bilir, kimliği `-c user.name=Divit -c
   user.email=divit@yerel` ile verir, Mac'te önce `xcode-select -p`
   bakar, hata olursa sessizce `.divit/gecmis.log`'a yazar. Tehlikeli
   komut (checkout, reset, push, rm) betikte yoktur; settings.json'daki
   yirmi küsur `git -C *` allow/deny kuralı iki kurala iner: güncelleyici
   gibi mutlak yollu tek `Bash(sh …/gecmis.sh *)` ve tek
   `PowerShell(powershell -NoProfile -ExecutionPolicy Bypass -File "…\gecmis.ps1" *)`.
3. **Kayıt anları (hook, LLM'siz):**
   - `SessionStart` (startup, resume): hocanın oturumlar arasında Word'de
     yaptığı değişiklikleri yakalar. Betik hiçbir şey yazdırmaz
     (SessionStart stdout'u bağlama girer).
   - `Stop`, `async: true`: Divit'in her cevabından sonra. Değişiklik
     yoksa ucuzdur.
   - Kurulum sonunda ilk kayıt (`kur.sh` / `kur.ps1` içinden).
4. **Dışlamalar:** `gelen/`, `tez-kontrol/gelen/`, `gizli/`, `hakemlik/`,
   `kitaplar/*/asil/`, `.claude/`, `.divit/gecmis`, `.divit/gecici`,
   `.divit/onceki-surumler`, `.divit/paylasim`; pdf, zip, görüntü, video
   uzantıları. Word/Excel/PowerPoint **girer** (hocanın asıl işi;
   değişmedikçe yer kaplamaz). Profil ve günlük girer (bakım profili
   yeniden yazar, geçmişi değerli). Windows'ta `core.longpaths=true`;
   iki sistemde `core.quotepath=false`, `core.autocrlf=false`.
5. **Mac'te araç yoksa:** `kur.sh` tek cümle yazar ("Çalışmalarınızın
   geçmişini saklayabilmem için Apple'ın bir aracı gerekiyor; açılan
   pencerede Yükle'ye basın"), `xcode-select --install` çağırır, devam
   eder. Basılmazsa Divit bugünkü gibi çalışır; betik her çağrıda bakar,
   araç gelince kayıt kendiliğinden başlar.
6. **geri-al yeniden yazılır.** "Dünkü hâline dön" sarmalayıcıyla: metin
   dosyası için önce `kaydet`, sonra `goster` özgün yola; Word için
   `goster` ile `cikti/<ad>-onceki-<tarih>.docx`. gecmis.md'nin 20.000
   bayt sınırı ve "çıktı kesik mi" denetimi kalkar; dosyayı Claude değil
   betik yazar. Hook kaydı yedek olunca kurallar'daki "üstüne yazma"
   kuralı hocaya giden yeni çıktılarla sınırlanabilir (2026-10-09
   code-review bulgu 1).
7. **Görünürlük:** "haberi olmadan" değil "önüne çıkmadan". Kılavuza ve
   kurulum sohbetine tek cümle: "Çalışmalarınızın geçmişini bu
   bilgisayarda saklarım, hiçbir yere gönderilmez." (KVKK ve disk yeri.)
   `saglik` "son kayıt: <tarih saat>" göstersin; `bakim` depo boyutunu
   söylesin ki sessiz arıza aylarca gizli kalmasın.

## Aşamalar

1. **Sınama, kod yazmadan (Mehmet'in Windows'unda):**
   - MinGit zip iç yerleşimi (`cmd\git.exe` var mı, hangi klasörde).
   - Code sekmesinde Git Bash yokken `"shell": "powershell"` hook'u
     çalışıyor mu; `-ExecutionPolicy Bypass -File` biçimi gerekiyor mu.
   - Gizli depolu klasörde arayüzde git izi (dal adı, worktree) yok mu.
   - OneDrive altındaki `.divit/gecmis` ile `index.lock` çakışıyor mu.
2. **Kurulum:** MinGit indirme + `Unblock-File` (Windows), `xcode-select`
   akışı (Mac), iki sarmalayıcı, settings.json şablonuna hook'lar ve iki
   izin kuralı, ilk kayıt. SURUM.md'ye `· kurulum gerekir` notu; var olan
   hocalara `guncelleme` kurulumu yeniden çalıştırmayı önerir.
3. **Skill'ler:** `geri-al` ve `gecmis.md` yeniden yazımı; eski git
   kurallarının settings.json'dan çıkarılması; `saglik` ve `bakim` ekleri.
4. **Belgeler:** CLAUDE.md 1, 5, 6. kararların gerekçesi ("git
   varsayılmaz" doğru kalır: kurulum getirir, yoksa Divit eskisi gibi
   çalışır); TASARIM-NOTLARI'na üçüncü yeniden tasarım satırı.
5. **Sonraya:** geçmiş çalışan makinede `onceki-surumler` kopyalarını
   bırakmak (bir süre ikisi birlikte); hocanın Divit açmadan Word'de
   çalıştığı saatler için kullanıcı düzeyinde saatlik görev (launchd /
   Görev Zamanlayıcı, yönetici istemez); depo büyümesi için gc politikası.

## Riskler

- OneDrive "yalnız bulutta" tuttuğu dosyaları git okuyunca indirir; yavaş
  ama bozmaz.
- Antivirüs `git.exe`'yi kullanıcı profilinde görünce uyarabilir (pandoc'ta
  görülmedi).
- Çok Word dosyası olan klasörde ilk kayıt birkaç saniye sürer.
- Mac'te pencereye basılmazsa geçmiş yoktur; `saglik` bunu dürüstçe
  göstermeli.

## Kaynaklar

- MinGit: <https://github.com/git-for-windows/git/wiki/MinGit>,
  sürümler <https://github.com/git-for-windows/git/releases>
- Claude Code hooks: <https://code.claude.com/docs/en/hooks>
- Claude Code checkpointing: <https://code.claude.com/docs/en/checkpointing>
- Claude Code desktop (git ve worktree): <https://code.claude.com/docs/en/desktop>
- git-scm macOS: <https://git-scm.com/install/mac>
