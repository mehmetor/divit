# Entegrasyon (dalga 2) — sınama

Tarih: 2026-10-01 · Dal: `orc/yonetici-kitap-yazarlari-i/birlestirme-d2` (origin/develop üstüne)
Model: `claude-sonnet-5-5` · Claude Code 2.1.286

Uygulanan kaynaklar: `belgeler/sinama/dalga1-birlestirme-notlari.md` (her madde),
PR #21 (kaynak-sinama), #22 (baglanti), #23 (sunum-tablo), #24 (okul-rehberligi),
#25 (gecmis-telefon) ve `belgeler/sinama/*.md`.

## Sonuç

| Ölçüt | Sonuç |
|---|---|
| `claude plugin validate plugins/divit` | GEÇTİ (yalnız "version yok" uyarısı, bilinçli) |
| `claude plugin validate plugins/divit-akademik` | GEÇTİ (aynı uyarı) |
| Her SKILL.md < 150 satır | GEÇTİ (en uzun: `kitap-duzenle` 149, `kurulum` 149, `kurallar` 147) |
| `settings.json` geçerli JSON (`python3 -m json.tool`) | GEÇTİ |
| Deny eksilmedi | GEÇTİ: 8 → 44; eski satırların hiçbiri silinmedi |
| Allow | 33 → 66; eski satırların hiçbiri silinmedi |
| Yeni Bash ↔ PowerShell eşleşmesi | deny 14 ↔ 14, eşsiz yok. allow 10 ↔ 9: `zip *` ↔ `Compress-Archive *` (karşılık), `xcode-select -p` yalnız Mac (Windows'ta yok, bilinçli) |
| `diff hoca-paketi/Divit/KILAVUZ.html apps/web/kilavuz.html` | boş |
| Yazar sekmesi + "Herkes için" bölümü yasak kelime grep'i | 0 eşleşme |
| `apps/web/kilavuz-yazar.html` (yalnız yönlendirme sayfası) grep | 0 eşleşme |
| `bash araclar/sinama-kurulum.sh` | GEÇTİ — "SONUÇ: hepsi geçti", yeni `viii4` dahil |
| `claude -p` takvim / çeviri / Overleaf | üçü de doğru skill'e gitti, izin reddi yok |

Grep deseni (büyük/küçük harf duyarsız):
`hoca|öğrenci|tez|makale|dergi|hakem|jüri|akademik|sınav`; yazar `div`'inden
`<script>`'e kadar (yazar sekmesi ve ortak bölüm).

## Kurulum sınaması (`araclar/sinama-kurulum.sh`)

42 ölçüm GEÇTİ, KALDI 0, ATLANDI 0. Yeni ölçüm:

```
GEÇTİ viii4 settings.json dalga 2: zip, uploads, openalex, geçmiş ve bağlayıcı allow; gizli, git ve gönderme/silme deny
...
GEÇTİ G1    gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi
GEÇTİ G2    /opt/homebrew/bin/claude sürümü değişmedi (2.1.286 (Claude Code))
GEÇTİ G3    ~/Documents klasör kaydı (değişme zamanı, boyut) değişmedi
SONUÇ: hepsi geçti (ATLANDI satırları hariç).
```

## `claude -p` senaryoları

Düzenek (`/tmp/d2-kos.sh`): `hoca-paketi/Divit` kopyası `/tmp/d2-sin/<ad>`;
`CLAUDE.md` araç yolları dolduruldu; `.claude/settings.json` kaldırıldı, aynısı
(`extraKnownMarketplaces` çıkarılmış, `Read(/<worktree>/plugins/**)` eklenmiş)
`settings.local.json` olarak kondu. Profil `Kullanıcı türü: akademisyen`.
Mehmet'in bağlayıcıları kapalı: `ENABLE_CLAUDEAI_MCP_SERVERS=false`,
`--strict-mcp-config --mcp-config '{"mcpServers":{}}'`. Komut:

```
claude -p "<istem>" --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit --plugin-dir <worktree>/plugins/divit-akademik \
  --model claude-sonnet-5-5 --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
  --output-format stream-json --verbose < /dev/null
```

Üç koşuda da stderr'de "Ignoring" satırı 0.

### 1. Takvim — "bu hafta neler var"

```
ARAÇ Skill divit:kurallar
ARAÇ Skill divit:takvim
ARAÇ Read …/plugins/divit/skills/kurallar/akademisyen.md
ARAÇ Read ./.divit/profil/gorevler.md
ARAÇ Read ./.divit/profil/takvim.md
---SONUÇ---
**Bu hafta (1–7 Ekim)**

Bu hafta listenizde tarihli bir iş yok. İş listeniz henüz boş.

Dönem takviminiz ve haftalık ders programınız elinizde var mı? Bir kez verirseniz sınavdan önce soru hazırlığını, not girişinden önce değerlendirmeyi hatırlatırım.

Elinizde bir e-posta ya da duyuru varsa yapıştırın. İçindeki tarihleri bulup listenize eklemeyi sorarım.
permission_denials: []
```

### 2. Çeviri — "şunu Türkçeye çevir: Drip irrigation increases water use efficiency in tomato production."

```
ARAÇ Skill divit:kurallar
ARAÇ Skill divit:ceviri
ARAÇ Read …/plugins/divit/skills/kurallar/akademisyen.md
---SONUÇ---
**Damla sulama, domates üretiminde su kullanım verimliliğini artırır.**

Çeviriyi sohbete yazdım, dosya açmadım. Bir kaynakça ya da metne eklemek isterseniz eserin künyesini söyleyin, dosyaya kaydedeyim.
permission_denials: []
```

### 3. Overleaf — "yazilar/makale.md dosyasını Overleaf'e yükleyeceğim, hazırla"

Klasöre tek atıflı `yazilar/makale.md` ve `kaynaklar/kaynaklar.bib` kondu.

```
ARAÇ Skill divit:kurallar
ARAÇ Read …/plugins/divit/skills/kurallar/akademisyen.md
ARAÇ Skill divit:disa-aktar
ARAÇ Read …/plugins/divit/skills/disa-aktar/latex.md
ARAÇ Read ./yazilar/makale.md
ARAÇ Read …/plugins/divit/skills/kurallar/dosya-duzeni.md
ARAÇ Bash ls -R /private/tmp/d2-sin/overleaf --ignore=.git
ARAÇ Read ./kaynaklar/kaynaklar.bib
---SONUÇ---
Makaledeki tek atıf (`tilman2002`) kaynakçada var, ama doğrulama kaydı yok. Overleaf dosyasını hazırlamadan önce size bir şey soracağım.

Bu metindeki 1 atıf henüz doğrulanmadı. Overleaf'e göndermeden önce kontrol edeyim mi?

Bir de şunu öğrenmem gerekiyor: Derginin Overleaf şablonu var mı? […]
permission_denials: []
```

Gözlem: `disa-aktar` iki soruyu bir arada sordu ("tek soru" kuralına aykırı);
`disa-aktar` bu parçanın dosyası değil, not edildi.

## Yapılan değişiklikler (özet)

- `settings.json`: allow — `Edit(./sekiller/**)`, `Edit(./notlar/**)`,
  `Read(~/.claude/uploads/**)`, `zip`/`Compress-Archive`, gecmis-telefon'un
  git komutları (Bash + PowerShell), `WebFetch(domain:api.openalex.org)`,
  Gmail `search_threads/get_thread/create_draft/update_draft/list_drafts`,
  Takvim `list_events/search_events/list_calendars/suggest_time/create_event`.
  deny — `gizli/` dört satır, gecmis-telefon'un 13 git kalıbı (Bash + PowerShell),
  Gmail `send_message/reply/forward/trash_message/trash_thread`, Takvim `delete_event`.
- `kurallar`: yönlendirme (takvim, çeviri, şekil, malzeme, sunum, tablo,
  bağlantı, Overleaf, ayrıntılı geçmiş, veliye mektup/RAM/BEP); gizli kuralı;
  PowerPoint/Excel satırı; kabuk listesinde zip yalnız disa-aktar, git yalnız
  geri-al; saat uydurulmaz; kitap klasörü tam komutu `dosya-duzeni.md`'den
  SKILL.md'ye (Read ile yüklenen dosyada `${CLAUDE_PLUGIN_ROOT}` yerine
  konmuyor), `koy … [yeni-ad]`; satır için sorun notu şablonu `istek.md`'ye,
  rapor gösterme `dosya-duzeni.md`'ye taşındı. `akademisyen.md`: ders-takvimi,
  `takvim.md`. `yazar.md`: yardım özeti, tarihli ara dosya.
- `kitap-duzenle`: `raporlar/rapor-`, tarihli ara dosya, "Kaynak türü:" satırı.
  `kitap-derle`: aynı iki satır. `tez-kontrol` (+ klasördeki `CLAUDE.md`):
  `rapor/<bashar>/<bashar>-<tarih>.md`.
- `yardim`: yeni işler. `saglik`: 9. deneme "Bağlantılar".
- Kılavuz (iki sekme + ortak): iyi istek + Shift + Enter, yeni komutlar ve işler,
  kaynak kontrolü çıktısı, Overleaf, raporlar klasörü, "Gizli dosyalar" kutusu
  (yalnız akademisyen), ayrıntılı geçmiş, telefondan fotoğraf.
- SURUM `## Sıradaki · kurulum gerekir`: rol önekli satırlar.
- Yapılacaklar listesi (şimdi Plane DVT): biten satırlar silindi; `## Mehmet'e kalan` açıldı.
- `araclar/sinama-kurulum.sh`: `viii4`.
- `plugins/divit-akademik/SURUM.md` yok; akademik notlar çekirdek SURUM'da "Akademisyen:" önekiyle.
