# gizli/ klasörü — işletim sistemi kilidi mümkün mü? (DVT-2)

Tarih: 2026-10-08 · Bu Mac'te Claude Code 2.1.293, macOS 26 (Darwin 25.6).
Windows bu makinede sınanamadı; Windows satırları belgeye dayanır.

## Sorun

`gizli/` bugün izin kurallarıyla korunuyor (`hoca-paketi/Divit/.claude/settings.json`):
`Read(./gizli/**)`, `Edit(./gizli/**)`, `Bash(*gizli*)`, `PowerShell(*gizli*)`
ve klasör çapında arama kalıpları (`grep -r*`, `find *`, `rg *`,
`Get-ChildItem *`, `*-Recurse*` …). Son katman `kurallar`'daki yazılı yasak.

Claude Code belgesi bu katmanın sınırını açıkça yazıyor: Read/Edit deny
kuralları "don't apply to … arbitrary subprocesses that read or write files
indirectly, like a Python or Node script that opens files itself. For
OS-level enforcement that blocks all processes from accessing a path, enable
the sandbox." Bash kuralları için: "a deny or ask rule covers the invocation
Claude usually produces and isn't a security boundary around the program."
(permissions)

Bu makinede ölçüldü — klasörde yalnız `gizli/` deny kuralları, içinde
`OGRENCI-SIRRI-42` yazan `gizli/not.txt`; Claude'a tek bir betik
(`./kosu.sh`) çalıştırıldı:

| Betik içindeki komut | `acceptEdits` | `auto` |
|---|---|---|
| `cat gizli/not.txt` (doğrudan, Claude yazarsa) | reddedilir | reddedilir |
| `sh -c 'cat g*/n*.txt'` (betik içinde) | **okundu** | **okundu** |
| `d=giz; cat "${d}li/not.txt"` (betik içinde) | **okundu** | **okundu** |

Auto'da `./kosu.sh`'yi denetleyici geçirdi; aynı `sh -c` komutu doğrudan
yazılınca denetleyici durdurdu. Yani risk gerçek ama dar: Claude'un
**kendisinin** bir betik ya da dolaylı komut kurması gerekiyor. Olağan
akışta (2026-09-30 `okul-rehberligi.md` sınaması) sızıntı 0.

## Temel engel: Claude Code hocanın kullanıcısıyla çalışır

Masaüstü uygulaması ve onun başlattığı Claude Code, hocanın oturum
kullanıcısıyla çalışır. İşletim sisteminin dosya izinleri **kullanıcıya**
bakar, uygulamaya değil. Bu yüzden:

- Hocaya kapalı bir dosya Claude'a da kapalıdır, Claude'a açık olan hocaya
  da açıktır — Finder/Gezgin ile Claude ayrılamaz.
- Dosyanın sahibi hoca olduğu için kilidi **aynı kullanıcı geri açabilir**:
  Mac'te `chmod`/`chmod -a`/`chflags`, Windows'ta `icacls`. Claude da bu
  komutları çalıştırabilir (`acceptEdits`'te sorar, Auto'da denetleyici
  karar verir). Kilit, Claude'un kurduğu bir betiğe karşı engel değil,
  yalnız bir adım daha.

Bu Mac'te denendi (aynı kullanıcı, yönetici hakkı kullanılmadan):

| Komut | Okuma | Geri alma |
|---|---|---|
| `chmod +a "<kullanıcı> deny read,list,search" gizli` | `Permission denied` | `chmod -a …` ile hemen açıldı |
| `chmod 000 gizli` | `Permission denied` | `chmod 755` ile açıldı |
| `chflags uchg gizli/not.txt` | **okundu** (yalnız değişikliği engeller) | `chflags nouchg` |
| `hdiutil create … -encryption AES-256` | bağlı değilken dosyalar görünmez | — (sudo gerekmedi) |

## Yöntem tablosu

| Yöntem | Sistem | Yönetici hakkı | Hoca Finder/Gezgin'de açabilir mi | Claude'u gerçekten engeller mi | Kurulum betiğine eklenir mi | Geri alınır mı |
|---|---|---|---|---|---|---|
| `chmod 000` / ACL deny (`chmod +a`) | Mac | Hayır | **Hayır** — hoca da açamaz | Hayır: aynı kullanıcı; Claude `chmod` ile açabilir | Evet ama hocayı kilitler | Evet |
| `chflags uchg` / `schg` | Mac | `uchg` hayır, `schg` evet | Evet (okur) | **Hayır** — okumayı engellemez | Anlamsız | `uchg` evet; `schg` tek kullanıcı kipinde |
| Ayrı macOS kullanıcısı (dosyalar başka hesapta) | Mac | **Evet** (hesap açmak) | Yalnız parolayla / hesap değiştirerek | Evet (başka kullanıcı) | Hayır (yönetici + hoca kararı) | Evet |
| Şifreli disk görüntüsü (`hdiutil`, sparsebundle) | Mac | Hayır | Çift tıkla + parola; bağlıyken açık | **Yalnız bağlı değilken.** Bağlıyken (hoca çalışırken) Claude da okur | Teknik olarak evet; ama ayrı bir alışkanlık | Evet |
| TCC "Dosyalar ve Klasörler" (Belgeler erişimi) | Mac | Hayır | Evet | Hayır — Divit klasörü zaten `~/Documents/Divit`; Claude'un Belgeler'e erişmesi gerekir, alt klasör ayrılamaz | Hayır (kullanıcı onayı, betikle verilemez) | Evet |
| **Claude Code sandbox** (`sandbox.enabled`) | **Yalnız Mac** (Linux/WSL2) | Hayır | Evet | **Evet, kabuk komutları ve alt süreçleri için** (aşağıda ölçüm) | Evet (klasör `settings.json`) | Evet |
| NTFS ACL deny (`icacls gizli /deny "%USERNAME%:(OI)(CI)R"`) | Windows | Hayır (sahip) | **Hayır** — hoca da açamaz | Hayır: aynı kullanıcı jetonu; sahip DACL'ı her zaman değiştirebilir (örtük WRITE_DAC) | Evet ama hocayı kilitler | Evet (`icacls /remove:d`) |
| OWNER RIGHTS deny (sahibin WRITE_DAC'ını almak) | Windows | Hayır (kurarken) | Hayır | Hayır (aynı kullanıcı) ve hoca kendisi de geri alamaz | Tehlikeli | **Yönetici gerekir** (`takeown`) |
| Bütünlük etiketi (MIC, "No-Read-Up") | Windows | Kendi düzeyinin (Medium) üstüne etiket koymak `SeRelabelPrivilege` ister | — | Hayır: Gezgin ve Claude ikisi de Medium | Hayır | — |
| EFS (dosya şifreleme) | Windows | Hayır | Evet (şeffaf) | **Hayır** — aynı kullanıcının bütün süreçlerine şeffaf | — | — |
| VHD/VHDX + BitLocker | Windows | **Evet** (VHD bağlama yönetici ister; BitLocker Home'da yok) | — | Bağlıyken hayır | Hayır | — |
| Claude Code sandbox | Windows (yerel) | — | — | **Yok**: "On native Windows, Claude Code runs commands unsandboxed." | — | — |
| Word belge parolası ("Parolayla Şifrele") | İkisi de | Hayır | Evet, parolayla | Evet — şifreli `.docx`'i pandoc/Read çözemez | Hayır (hocanın dosya başına işi) | Evet (parola unutulursa **kurtarılamaz**) |

Notlar:

- EFS Windows Home sürümlerinde yok; hocaların dizüstülerinin çoğu Home.
- Windows'un "Denetimli klasör erişimi" (Defender) yalnız **değişikliği**
  engeller, okumayı değil; açıp kapamak yönetici onayı ister.

## Claude Code sandbox — Mac'te ölçüm

Belge: sandbox Mac'te Seatbelt ile işletim sistemi düzeyinde çalışır, kabuk
komutlarına ve başlattıkları süreçlere uygulanır; **klasördeki `Read(...)`
deny kuralları sandbox'ın okuma yasağına eklenir** ("Paths and domains from
both sandbox settings and permission rules are merged"). Read/Edit
araçları sandbox dışındadır ama zaten deny kurallarına uyar.

Aynı betik, klasöre `"sandbox": {"enabled": true, "allowUnsandboxedCommands": false}`
eklenerek (`acceptEdits`):

| Betik adımı | Sandbox kapalı | Sandbox açık |
|---|---|---|
| `sh -c 'cat g*/n*.txt'` | okundu | **engellendi** (klasör listelenemedi) |
| `cat "${d}li/not.txt"` | okundu | **`Operation not permitted`** |
| `osascript -l JavaScript pdf-metin.js …` (Divit'in Mac PDF okuması) | çalıştı | "yazıldı" dedi ama **çıktı dosyası oluşmadı** (sessiz kırılma) |
| pandoc → `yazilar/a.docx` | çalıştı | çalıştı |
| `git -C . init` (`geri-al` yedek geçmişi) | çalıştı | **`Operation not permitted`** (`.git` sandbox'ın korumalı yolu) |
| `curl` → `api.crossref.org` | çalıştı | çalıştı (`WebFetch(domain:…)` allow'u izin listesine eklendi) |
| `~/.divit/` altına yazma (`guncelleme` → `kur.sh`) | çalıştı | **`Operation not permitted`** |

Yani sandbox Mac'te `gizli/`'yi gerçekten kapatıyor, ama:

1. **Windows'ta yok** — tasarım kararı 1 (Windows ve Mac eşit) ile çelişir;
   hocaların çoğu Windows'ta.
2. Divit'in üç akışını kırıyor: `geri-al` (git), `guncelleme` (kurulumu
   yeniden çalıştırma), Mac PDF okuma (osascript). Ayrıca belge: `open` ve
   `osascript` Apple Events gerektirince `-600` hatası; `allowAppleEvents`
   klasör ayarından açılamıyor. Her biri `excludedCommands` ile sandbox
   dışına alınabilir, ama dışarı alınan her komut korumayı deler.
3. Masaüstü Code sekmesinde sandbox'ın çalıştığı belgede **yazmıyor**;
   ölçüm `claude -p` ile.
4. Sandbox başlayamazsa (`failIfUnavailable` yoksa) komutlar sessizce
   sandbox'sız çalışır.

## Değerlendirme

- Hocanın kullanıcısıyla çalışan bir süreci **yalnız o klasörden** ayıran,
  yönetici hakkı istemeyen, hocanın kendi erişimini bozmayan ve iki
  sistemde eşit çalışan **bir işletim sistemi kilidi yok.** chmod/ACL/icacls
  hocayı da dışarıda bırakır ve aynı kullanıcı (dolayısıyla Claude) geri
  açabilir; EFS ve chflags okumayı engellemez; ayrı kullanıcı, VHD ve
  BitLocker yönetici ister.
- Tek gerçek OS katmanı Claude Code sandbox; o da yalnız Mac'te ve Divit'in
  üç akışını kırıyor.
- Şifreli kap (Mac disk görüntüsü, Word parolası) yalnız kapalıyken korur;
  hoca o dosyayla çalışırken açıktır. Yine de "dosya Divit'in hiç
  göremeyeceği yerde" sonucunu iki sistemde de veren tek yol, dosyayı
  Divit klasörüne koymamaktır.

## Öneri

**İşletim sistemi kilidi kurulmasın; `gizli/` izin katmanıyla kalsın ve
hocaya verilen söz ölçülen gerçeğe çekilsin.** Bugünkü metin ("Bu klasör
kilitlidir: Divit içindekileri açamaz") ölçümle uyuşmuyor; doğrusu "Divit
bu klasörü okumaz; ayarı da kapalı" ve buna tek bir ek önlem: **en hassas
dosyalar (vaka, görüşme, sağlık raporu) Divit klasörüne hiç konmasın**,
Belgeler'de ayrı bir klasörde dursun. Bu her iki sistemde eşit, yönetici
hakkı istemez, hocanın erişimini bozmaz. `gizli/` "Divit'in dokunmayacağı
yer" olarak kalır ama asıl gizli olanın yeri olmaktan çıkar.

Sandbox (yalnız Mac) bugün önerilmez; ileride masaüstünde ölçülür ve
Windows'ta karşılığı çıkarsa yeniden değerlendirilir (Plane'de ayrı iş).

Uygulanırsa değişecek dosyalar (izin ayarları değişmez):

- `hoca-paketi/Divit/gizli/BURAYA-BIRAKIN.txt` — "kilitlidir … açamaz"
  yerine "Divit bu klasörü okumaz"; en hassas dosyaları Divit klasörü dışında
  tutma cümlesi.
- `hoca-paketi/Divit/KILAVUZ.html` (327, 336) — aynı düzeltme.
- `plugins/divit/alan/okul-rehberligi.md` (17) — "bölme ayarla kilitlidir"
  yerine aynı ifade.
- `plugins/divit/skills/kurulum/yayinsiz.md` (59-65) — gizli klasör
  anlatımına "en hassas olanlar klasör dışında" cümlesi.
- `plugins/divit/skills/kurallar/SKILL.md` (36) — bir satır: `gizli/` için
  betik, değişken ya da `sh -c` ile dolaylı okuma da yasak (bugünkü
  "okunmaz, içinde arama yapılmaz" bunu açıkça kapsamıyor).
- `plugins/divit/SURUM.md` — `## Sıradaki` notu, `· kurulum gerekir`
  (kılavuz ve şablon değişti).
- Değişmeyecek: `kur.sh`, `kur.ps1`, `.claude/settings.json` şablonu.

**Mehmet'in kararı:** (1) `gizli/`'nin sözünü "kilitli"den "okumaz"a
indirmek; (2) hocaya "en hassası klasör dışında" demek — bu, okul rehberliği
gibi gizli dosyası çok olan kullanıcıda Divit'in o dosyalarla yardım
edemeyeceğini açıkça kabul etmek demek (bugün de yardım etmiyor).

## Kaynaklar

- İzin kurallarının sınırı (Read/Edit deny alt süreçlere uygulanmaz; Bash
  kuralı güvenlik sınırı değildir): https://code.claude.com/docs/en/permissions
- Sandbox — desteklenen sistemler (yerel Windows yok), izin kurallarıyla
  birleşme, korumalı yollar, Apple Events, `failIfUnavailable`, sınırlar:
  https://code.claude.com/docs/en/sandboxing
- Ayar başvurusu — `sandbox.enabled`, `permissions.blockReadsOutsideWorkingDirectories`:
  https://code.claude.com/docs/en/settings-reference
- Windows sahip hakları (örtük READ_CONTROL/WRITE_DAC, OWNER RIGHTS SID):
  https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc749445(v=ws.10)
- Mandatory Integrity Control: https://learn.microsoft.com/en-us/windows/win32/secauthz/mandatory-integrity-control
- VHD bağlamanın yönetici istemesi: https://learn.microsoft.com/en-us/powershell/module/storage/mount-diskimage
- EFS Home sürümünde yok: https://en.wikipedia.org/wiki/Encrypting_File_System
- Word belgesini parolayla şifreleme (Windows ve Mac; parola kurtarılamaz):
  https://support.microsoft.com/en-us/office/protect-a-document-with-a-password-05084cc3-300d-4c1a-8416-38d3e37d6826
- Önceki sınama: `belgeler/sinama/okul-rehberligi.md`.
- Bu belgedeki ölçümler: 2026-10-08, bu Mac, `claude -p --model
  claude-sonnet-5-5 --setting-sources local`, geçici `/tmp/gizli-deneme`
  (silindi).
