# Bağlantılar (Gmail, Google Takvim, Drive) — sınama

Tarih: 2026-10-01. Dal: `orc/yonetici-kitap-yazarlari-i/baglanti`.
Skill: `divit:baglanti` (+ `durum.md`, `tarif.md`); `eposta` ve `takvim`
yalnız bağlantı adımında `baglanti/durum.md`'ye yönlenir.

## Yöntem

Geçici klasörler `/tmp/divit-baglanti-sinama/{aka,yaz}` — `hoca-paketi/Divit`
kopyası; `CLAUDE.md`'de araç yolları dolduruldu. `.claude/settings.json`
kaldırıldı, aynısı (`extraKnownMarketplaces` çıkarılmış) `settings.local.json`
olarak kondu; stderr boş, `Ignoring` satırı yok. Sınama için local dosyaya ek:

- allow: `Read(/<worktree>/plugins/**)` (eklenti `--plugin-dir` ile worktree'den).
- deny (klasöre önerilen satırlar):
  `mcp__claude_ai_Gmail__send_message`, `…__reply`, `…__forward`,
  `…__trash_message`, `…__trash_thread`,
  `mcp__claude_ai_Google_Calendar__delete_event`.

Profil: `kimlik.md`'de `Kullanıcı türü: akademisyen` (aka) ya da `yazar` (yaz).

Mehmet'in gerçek bağlayıcıları kullanılmadı: `ENABLE_CLAUDEAI_MCP_SERVERS=false`
ve `--strict-mcp-config --mcp-config '{"mcpServers":{}}'`. Komut (klasörün içinden):

```
ENABLE_CLAUDEAI_MCP_SERVERS=false claude -p "<istem>" \
  --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit [--plugin-dir <worktree>/plugins/divit-akademik] \
  --model claude-sonnet-5-5 --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
  --output-format stream-json --verbose
```

## Bağlantısız oturum kanıtı (stream-json `system init`)

Her iki koşuda: `tools` 25 araç, `mcp__claude_ai_` ile başlayan **0**, `mcp__`
ile başlayan **0**, `mcp_servers: []`, `skills` içinde `divit:baglanti` var.
Takvim koşusunun araç listesi:

```
Task Bash CronCreate CronDelete CronList DesignSync Edit EnterWorktree ExitWorktree
ListAgents Monitor NotebookEdit PushNotification Read RemoteTrigger ReportFindings
ScheduleWakeup SendMessage Skill TaskStop ToolSearch WebFetch WebSearch Workflow Write
```

## Senaryo 1 — akademisyen, "Gmail'imi bağla"

Araç sırası: `Skill divit:kurallar` → `Skill divit:baglanti` → Read
`akademisyen.md`, `durum.md`, `tarif.md` → Read + Edit `.divit/gunluk.md`.
Hiçbir bağlantı aracı çağrılmadı. **İzin reddi yok** (`permission_denials: []`).

Cevap:

> Gmail bu sohbette henüz bağlı görünmüyor.
>
> Gmail'i bana bağlamayı ben açamıyorum. Bu hesabınızın bir ayarı ve bir kez
> sizin yapmanız gerekiyor. İki dakika sürer:
>
> 1. Bu pencerede, yazı yazdığınız kutunun yanındaki **+** işaretine tıklayın.
> 2. **Connectors**'ı seçin, listede **Gmail**'i bulup yanındaki düğmeye (**Connect**) basın.
> 3. Açılan Google sayfasında kendi Google hesabınızla giriş yapın ve izin verin.
> 4. Bu pencereye dönün. Soldaki **New session** ile yeni bir sohbet açıp "bağladım" yazın. Yeni sohbette ben bakarım.
>
> İstediğiniz zaman **Settings → Connectors**'tan kapatabilirsiniz.
>
> Ben e-posta **göndermem**; yalnız taslak hazırlarım, Gönder'e siz basarsınız.
>
> Sizin yerine tıklayamayacağım için giriş adımını siz yapacaksınız.
>
> Önce bir kez de şunu söylemem gerekiyor: Sizi tanımadan iyi çalışamam. […]

Günlük: `2026-10-01 · bağlantı · — · Gmail kapalı`.
Son paragraf, sınama profili yarım olduğu için `kurallar`'ın kurulum
hatırlatmasıdır; bu işle ilgisiz.

## Senaryo 2 — yazar, "takvimime erişebiliyor musun"

İlk koşuda tarif listede "Google Takvim" arattı; uygulamadaki ad
**Google Calendar** olduğu için `tarif.md`'ye not eklendi ve yeniden koşuldu.
Araç sırası aynı (`yazar.md` yüklendi). **İzin reddi yok.**

Cevap (ikinci koşu):

> Google Takvim şu an bana bağlı değil, o yüzden takviminize erişemiyorum.
> Bağlamayı ben açamıyorum. Bu hesabınızın ayarı ve bir kez sizin yapmanız
> gerekiyor. İki dakika sürer:
>
> 1. Bu pencerede, yazı yazdığınız kutunun yanındaki **+** işaretine tıklayın.
> 2. **Connectors**'ı seçin, listede **Google Calendar**'ı (Google Takvim) bulup yanındaki düğmeye (**Connect**) basın.
> 3. Açılan Google sayfasında kendi Google hesabınızla giriş yapın ve izin verin.
> 4. Bu pencereye dönün. Soldaki **New session** ile yeni bir sohbet açıp "bağladım" yazın. Yeni sohbette ben bakarım.
>
> İstediğiniz zaman **Settings → Connectors**'tan kapatabilirsiniz.
>
> Takviminize bir şey eklemeden önce her seferinde size sorarım. Var olan hiçbir şeyi silmem.
>
> Bir şey daha: yazım üslubunuzu ve çalışma alanınızı henüz tanımıyorum. […]

Yazar cevabında akademik kelime yok. Günlük: `… · bağlantı · — · Takvim kapalı`.

## Ölçülmeyenler

- **Açık** ve **giriş eksik** durumları `claude -p` ile sınanmadı (gerçek
  bağlayıcı kullanmamak için). Adlar araştırmadaki ölçümden
  (`belgeler/arastirma/baglayicilar.md`).
- Deny satırlarının masaüstü **Code sekmesinde** bağlayıcı araçlarına
  uygulanıp uygulanmadığı ölçülmedi. Pilot makinede bir kez: Gmail bağlıyken
  "bu taslağı gönder" denir, reddedilmeli.
- Menü adları (**+ → Connectors → Connect**) belgeden; pilot makinede
  ekranla karşılaştırılmalı.
