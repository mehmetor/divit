# Skill izin ölçümü — 2026-09-30

Amaç: Mehmet'in Claude Desktop denemesinde görülen İngilizce izin
sorularının (değişkenli pandoc çağrısı, zincirli `cd … && sed … | wc`,
`mkdir -p kitaplar/<ad>/asil`) skill düzeltmesinden sonra kalmadığını
göstermek. Ortam: bu Mac, Claude Code 2.1.278 (`claude -p`), model
`claude-sonnet-5-5`, izin kipi `acceptEdits`, `--max-turns 40`.

## Yöntem

- Klasör: `hoca-paketi/Divit` kopyası `/tmp/divit-olcum/{yazar,hoca}`.
  `settings.json` şablondan; değişiklikler:
  - `env` DIVIT_* dolu (`~/.divit/araclar/…`); `extraKnownMarketplaces`
    çıkarıldı (eklenti `--plugin-dir` ile worktree'den yüklendi).
  - S3'ün iki allow kuralı: `Bash(sh */scripts/kitap-klasoru.sh *)`,
    `PowerShell(*kitap-klasoru.ps1*)`.
  - **Ek (sözleşmede yok, aşağıda "Bulgu 2"):** `Skill(divit:*)`,
    `Skill(divit-akademik:*)`.
  - **Yalnız ölçüm için:** `Read(//<worktree>/plugins/**)` — eklenti
    `--plugin-dir` ile worktree'den geldiği için; gerçek kurulumda eklenti
    `~/.claude/plugins/` altındadır ve şablondaki `Read(~/.claude/plugins/**)`
    bunu karşılar.
  - Aynı içerik `.claude/settings.local.json`'a da yazıldı.
- Çağrı: `claude -p "<istem>" --plugin-dir <worktree>/plugins/divit
  [--plugin-dir <worktree>/plugins/divit-akademik] --setting-sources local
  --permission-mode acceptEdits --output-format stream-json --verbose
  --model claude-sonnet-5-5 --max-turns 40`.
- **S8'den sapma:** `--setting-sources project,local` her çalıştırmada
  stderr'e `Ignoring 31 permissions.allow entries from .claude/settings.json`
  yazıyor (klasör güvenilir değil); satır settings.local.json varken de
  çıkıyor. `--setting-sources local` ile satır çıkmıyor ve local'deki allow
  kuralları uygulanıyor (Skill ve betik kuralıyla ayrıca sınandı). İçerik
  aynı olduğu için ölçümün anlamı değişmez. `~/.claude.json`'daki güven
  anahtarına dokunulmadı.
- Kayıtlar: `/tmp/divit-olcum/{yazar,hoca}.jsonl` ve `.err` (geçici).

## Sonuç

| Ölçüm | İstem | Tur | permission_denials | stderr "Ignoring" | Asıl dosya (shasum önce = sonra) | Rapor bildirimi (S5) |
|---|---|---|---|---|---|---|
| Yazar, `kitap-duzenle` | "Kitabım: sahada-yonetmek. Dosya: /tmp/divit-olcum/dis/kitap.docx. asil'e koy ve yeni baskı için düzenle; soru sormadan ilerle, onay veriyorum" | 20 | **boş** | yok | kaynak ve `asil/kitap.docx`: `e2a48e5b…` = `e2a48e5b…` | `.html` önce, `.md` sonra; mutlak yol, ters tırnak, kendi satırında; `[..](..)` yok; `open` yok |
| Akademisyen, `tez-kontrol` (iki eklenti) | "tez-kontrol/gelen/ak/ klasöründeki yüksek lisans tezini değerlendir ve rapor çıkar; soru sormadan ilerle, onay veriyorum" | 15 | **boş** | yok | `gelen/ak/tez.docx`: `816e5edb…` = `816e5edb…` | aynı biçim |

Akış hiçbir soruda durmadı; ikisi de raporu yazıp bitti.

### Çalışan kabuk komutları — yazar

1. `sh <eklenti>/scripts/kitap-klasoru.sh ac sahada-yonetmek` → `ACILDI`
2. `sh <eklenti>/scripts/kitap-klasoru.sh koy sahada-yonetmek asil "/tmp/divit-olcum/dis/kitap.docx"` → `KOPYALANDI`
3. `~/.divit/araclar/pandoc "kitaplar/sahada-yonetmek/asil/kitap.docx" -t gfm --wrap=none -o ".divit/gecici/sahada-yonetmek.md"`
4. `~/.divit/araclar/pandoc "kitaplar/sahada-yonetmek/duzenleme/rapor-2026-09-30.md" -s --metadata title="Editör raporu — Sahada Yönetmek" -o "kitaplar/sahada-yonetmek/duzenleme/rapor-2026-09-30.html"`

Geri kalan her şey Skill, Read ve Write (plan.md, rapor, üç öneri dosyası,
günlük). `cd`, zincir, `sed`/`wc`, değişkenli araç çağrısı yok.

### Çalışan kabuk komutları — akademisyen

1. `ls -la /private/tmp/divit-olcum/hoca/tez-kontrol/gelen/ak/` (sorusuz geçti; bkz. Bulgu 3)
2. `~/.divit/araclar/pandoc "tez-kontrol/gelen/ak/tez.docx" -t gfm -o ".divit/gecici/tez.md"`
3. `~/.divit/araclar/pandoc "tez-kontrol/rapor/ak-2026-09-30.md" -s --metadata title="Değerlendirme — A. K., 2026-09-30" -o "tez-kontrol/rapor/ak-2026-09-30.html"`

## Bulgular (ara ölçümlerden)

1. **Betik kuralı tırnaklı yolla eşleşmiyor.** `Bash(sh */scripts/kitap-klasoru.sh *)`
   kuralı `sh "/…/scripts/kitap-klasoru.sh" ac deneme` için onay istedi
   ("This command requires approval"); aynı kural tırnaksız
   `sh /…/scripts/kitap-klasoru.sh ac deneme` için sorusuz geçti.
   `Bash(sh *kitap-klasoru.sh*)` ikisini de geçirdi (`koy … "<dosya>"` dahil).
   Skill'lerde Mac çağrısı tırnaksız yazıldı (Mac kullanıcı adı boşluk
   içermez); kural metni değişmedi. Windows kuralı `PowerShell(*kitap-klasoru.ps1*)`
   iki yanı yıldızlı olduğu için tırnaktan etkilenmez (Windows ölçülemedi).
2. **`allowed-tools` taşıyan skill açılırken izin istiyor.** Frontmatter'da
   `allowed-tools` olan skill (`divit:kurallar`, `divit:kitap-duzenle`)
   `Execute skill: divit:kurallar` izni istedi ve `-p`'de reddedildi;
   `allowed-tools`suz `divit:yardim` sorusuz yüklendi. `Skill(divit:*)`
   allow kuralı eklenince sorun kalktı. Desktop'ta bu, her oturumun başında
   İngilizce bir izin penceresi demektir. Çözüm ya settings.json'a
   `Skill(divit:*)` ve `Skill(divit-akademik:*)` eklemek ya da skill'lerden
   `allowed-tools`'u kaldırmak (settings.json'daki betik kuralı tek başına
   yetiyor).
3. **Grep ve Glob araçları bu sürümde yok.** `claude -p` başlangıç kaydındaki
   araç listesinde Grep ve Glob yok; model Grep'i çağırınca "No such tool
   available: Grep … search file contents with grep via the Bash tool
   instead" döndü. Skill'ler artık "Read, Write, Edit (Grep, Glob varsa
   onlar da)" diyor. Klasör içeriğine bakmak için model tek başına `ls`
   kullandı ve çalışma klasörü içinde sorusuz geçti; klasör dışı `ls`
   engellendi.
4. **Skill kuralları yüklemeden komut çalıştırıyordu.** İlk turda model
   `tez-kontrol`/`kitap-duzenle`'yi `divit:kurallar`'dan önce açtı ve
   `cat …; mkdir -p … && pandoc … && wc -w …` gibi zincirler, çıplak
   `pandoc` yazdı (4 ret). Kabuk çalıştıran on skill'in başına "Önce:
   `divit:kurallar` bu oturumda yüklenmediyse şimdi yükle" satırı eklendi;
   son ölçümde iki akış da önce kuralları yükledi.

## Ölçülmeyenler

- Windows (PowerShell 5.1): `kitap-klasoru.ps1` yalnız Linux'ta
  PowerShell 7.4 ile sınandı (ac, koy yeni, koy var → 3 ve dosya
  değişmedi, geçersiz ad, olmayan kaynak, yanlış yer, eksik bağımsız
  değişken). İzin kuralları Windows'ta ölçülmedi.
- Claude Desktop'ta rapor yoluna tıklayınca `.html`'in pencerede açılması:
  belgeye dayanıyor, burada kanıt yok. **Mehmet elle doğrulayacak.**
