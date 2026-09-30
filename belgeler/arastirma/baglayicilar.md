# Bağlayıcılar (Gmail, Google Takvim, Google Drive) — araştırma

Tarih: 2026-10-01 · Bu Mac'te Claude Code 2.1.286.

## Kısa cevap

- **Evet, Code sekmesinde kullanılabiliyor.** Masaüstü uygulaması, hesaba
  bağlı claude.ai bağlayıcılarını yerel Code oturumlarına kendisi verir.
  Klasör ayarı ya da MCP ayarı gerekmez, Divit açamaz da: hesap ayarıdır,
  Google girişi kullanıcıdadır.
- Bağlayıcı, Code sekmesinde mesaj kutusunun yanındaki **+** düğmesi →
  **Connectors** menüsünden eklenir; yönetimi **Ayarlar → Connectors**
  (ya da + → Connectors → Manage connectors).
- Oturum bağlayıcının açık olup olmadığını **araç listesinden** anlar.

## Bir oturum nasıl anlar? (ölçüldü)

Bu oturumda (claude.ai hesabıyla giriş yapılmış Claude Code) araç listesinde
şunlar göründü:

| Durum | Görünen araçlar |
|---|---|
| Gmail bağlı ve yetkili | `mcp__claude_ai_Gmail__search_threads`, `get_thread`, `create_draft`, `update_draft`, `list_drafts`, … ve **`send_message`, `reply`, `forward`, `trash_*`** |
| Google Takvim bağlı ve yetkili | `mcp__claude_ai_Google_Calendar__list_events`, `search_events`, `create_event`, `update_event`, `delete_event`, `suggest_time`, `list_calendars` |
| Google Drive eklenmiş ama Google girişi yapılmamış | Yalnız `mcp__claude_ai_Google_Drive__authenticate` ve `…__complete_authentication` |
| Hiç eklenmemiş | Hiçbir `mcp__claude_ai_<Ad>__*` aracı yok |

Kural (öneri): önek `mcp__claude_ai_` + hizmet adı (`Gmail`,
`Google_Calendar`, `Google_Drive`).

**Dikkat:** İzin belgesi bu biçimi "Claude Code'un kendisi getirdiği"
bağlayıcılar (terminal, VS Code) için yazıyor. Masaüstü Code sekmesi
bağlayıcıları başka yoldan (süreç içinde) veriyor; oradaki adlar ölçülmedi.
Bu yüzden skill'deki denetim öneki değil **hizmet adını** arasın: araç
adında `Gmail`, `Calendar`, `Drive` geçen `mcp__…` araçları. Pilot makinede
Code sekmesinde "hangi bağlayıcıların açık?" diye sorup adlar bir kez
kaydedilmeli.

- Asıl işi yapan araçlar varsa → **açık**.
- Yalnız `authenticate` varsa → **eklenmiş ama Google girişi eksik**;
  kullanıcıya "Ayarlar → Connectors'ta Google Drive'ın yanındaki Bağlan'a
  basın" denir. `authenticate` aracını Divit çağırmaz (tarayıcıda giriş
  ister, hoca şaşırır).
- Hiç yoksa → **kapalı**; tarif verilir.

Araçlar çoğu zaman ertelenmiş (deferred) gelir: adı listede görünür, şeması
ToolSearch ile yüklenir. Açık/kapalı kararı için adın görünmesi yeter.

Not: bağlayıcılar yalnız claude.ai hesabıyla girişte gelir; API anahtarıyla
ya da Bedrock gibi sağlayıcılarla gelmez.

## Yetkiler

| Bağlayıcı | Okur | Yazar |
|---|---|---|
| Gmail | Arama, yazışma okuma, ek **adları** (ek içeriği değil) | Taslak oluşturur/günceller; **gönderir, cevaplar, iletir, çöpe atar** (claude.ai'de varsayılan olarak her birinde onay sorar) |
| Google Takvim | Etkinlikler, takvimler, boş zaman | Etkinlik oluşturur, günceller, siler |
| Google Drive | Arama; Docs, Sheets, Slides, PDF, görsel, Office dosyalarını okur | Destek sayfasına göre yeni Docs/Sheets/Slides oluşturur, **her türden dosya yükler**, paylaşır, taşır, çöpe atar (bir kısmı "beta") |

YAPILACAKLAR'daki "Drive büyük ihtimalle yalnız okur" varsayımı **yanlış
çıktı**: destek belgesine göre Drive yazabiliyor. Ancak Code sekmesinde
hangi Drive araçlarının geldiği bu Mac'te görülemedi (Drive girişi yok);
yedek için yine de **masaüstü eşitlemesi** (Google Drive/OneDrive/iCloud
uygulaması) daha sağlam: dosya bilgisayarda kalır, Divit'in kabuk izni
gerekmez.

## Güvenlik — öneri

Gmail aracında `send_message`, `reply`, `forward` var. `eposta` skill'i
bugün "gönder aracı olsa bile kullanma" diyor; bu **yazıyla koruma**, tasarım
kararı 9 "koruma yazıyla değil izinle" der. Kod önerisi (bu parçada
yapılmadı): klasör `settings.json` deny'a

```json
"mcp__claude_ai_Gmail__send_message",
"mcp__claude_ai_Gmail__reply",
"mcp__claude_ai_Gmail__forward",
"mcp__claude_ai_Gmail__trash_message",
"mcp__claude_ai_Gmail__trash_thread",
"mcp__claude_ai_Google_Calendar__delete_event"
```

Deny kuralında `mcp__<sunucu>__<araç>` ya da `mcp__<sunucu>__*` biçimi
geçerli; parantezli (`mcp__x__y(...)`) kural ayar dosyasında yok sayılır.

**Doğrulanmalı:** masaüstü uygulaması bağlayıcıları "süreç içinde" verdiği
için MCP ayarları ona ulaşmıyor (belge böyle diyor); izin kuralı (deny) ise
ayrı bir katman — Code sekmesinde uygulanıp uygulanmadığı pilot makinede
bir kez denenmeli (Divit'ten taslak yerine göndermesi istenir, reddedilmeli).
Kurum yöneticisi (Team/Enterprise) araç başına "engelli" de verebilir.

## Kullanıcıya tarif — sade Türkçe taslak

Akademisyen de yazar da aynı metni görür (akademik kelime yok).

> Gmail'inizi (ya da Google Takviminizi) bana bağlamak için:
>
> 1. Bu pencerede, yazı kutusunun yanındaki **+** işaretine tıklayın.
> 2. **Connectors**'ı seçin, listeden **Gmail**'i bulun.
> 3. Açılan Google sayfasında kendi hesabınızla giriş yapıp izin verin.
> 4. Buraya dönüp "bağladım" yazın; ben bakarım.
>
> Bunu bir kez yaparsınız. İstediğiniz zaman **Ayarlar → Connectors**'tan
> kapatabilirsiniz. Ben e-posta **göndermem**; yalnız taslak hazırlarım,
> Gönder'e siz basarsınız.

Takvim için 4. maddeden sonra: "Takviminize bir şey eklemeden önce her
seferinde size soracağım."

Kurumsal hesapta (Team/Enterprise) ek satır: "Listede Gmail yoksa
kurumunuzun yöneticisi açmamış olabilir; bu durumda e-posta programınızla
devam ederiz."

## Hangi skill'e girmeli — öneri

| Yer | Ne girer |
|---|---|
| `kurallar` (bir satır) | "Bağlayıcı gereken işte önce araç listesinde `mcp__claude_ai_<Ad>__` ara; yoksa `saglik`'taki tarifi ver." Tek doğruluk kaynağı. |
| `saglik` | Denetimlere "Bağlayıcılar: Gmail / Takvim / Drive açık mı" satırı; kapalıysa tarifi gösterir (dosya: `saglik/baglayicilar.md`, SKILL.md 150 satır sınırı için ayrı). |
| `eposta` | Bugünkü (a) yolunun "kuruluysa" koşulunu yukarıdaki açık/eksik/kapalı ayrımıyla değiştir; kapalıysa önce tarifi öner, istemezse (b)/(c) e-posta programı yolu. |
| Takvim/iş takibi skill'i (paralel parçada yazılıyor) | Etkinlik yalnız onayla: "Şunu takviminize ekleyeyim mi: …" → evet → `create_event`. Silme yok. |
| Drive | Ayrı skill yok. Yedek ve telefondan aktarma için masaüstü eşitleme tarifi (`telefondan-yukleme.md`). |

## Kalan riskler

- Deny kuralının masaüstü bağlayıcılarında işleyip işlemediği ölçülmedi.
- Google Workspace (kurum) hesaplarında Google yöneticisinin Claude'u
  onaylaması gerekebilir; hoca bunu kendisi çözemez.
- Drive yazma araçlarının Code sekmesindeki adları görülemedi.

## Kaynaklar

- Desktop — "Connect external tools", + → Connectors, Ayarlar → Connectors:
  https://code.claude.com/docs/en/desktop
- MCP — "How connectors reach Claude Code", claude.ai bağlayıcı kimlik
  koşulları, kurum araç denetimleri: https://code.claude.com/docs/en/mcp
- Google Workspace bağlayıcıları (planlar, Drive/Gmail/Takvim yetkileri):
  https://support.claude.com/en/articles/10166901-use-google-workspace-connectors
- İzin kuralları (MCP araç adlarıyla deny): https://code.claude.com/docs/en/permissions
