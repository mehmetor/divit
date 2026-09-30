# Bağlayıcı durumu — nasıl anlaşılır

Bu dosyayı `baglanti`, `eposta` ve `takvim` aynı biçimde kullanır.
Hiçbir aracı çağırmadan, yalnız **araç listene bakarak** karar ver. Adın
listede görünmesi yeter; araç ertelenmiş (şeması sonradan yüklenen) olabilir.

## Hangi adlara bakılır

Adı `mcp__` ile başlayan ve içinde hizmet adı geçen araçlar:

| Hizmet | Adında geçen | Asıl iş araçlarına örnek |
|---|---|---|
| Gmail | `Gmail` | `search_threads`, `get_thread`, `create_draft`, `list_drafts` |
| Google Takvim | `Calendar` | `list_events`, `search_events`, `create_event`, `list_calendars` |
| Google Drive | `Drive` | arama, dosya okuma, dosya oluşturma |

Terminalde ve bu Mac'te görülen biçim `mcp__claude_ai_Gmail__create_draft`
gibidir; masaüstü uygulamasında önek farklı olabilir, o yüzden öneke değil
**hizmet adına** bak.

## Üç durum

- **Açık** — o hizmetin `authenticate` ve `complete_authentication` dışında
  en az bir aracı var.
- **Giriş eksik** — o hizmetin yalnız `authenticate` /
  `complete_authentication` araçları var. Bağlayıcı eklenmiş ama Google
  girişi yapılmamış.
- **Kapalı** — adında o hizmet geçen hiçbir araç yok.

## Değişmez kurallar

- `authenticate` ya da `complete_authentication` araçlarını **hiç çağırma**:
  tarayıcıda beklenmedik bir giriş sayfası açar, kullanıcı şaşırır.
  Girişi kullanıcı kendisi yapar (tarif: `tarif.md`).
- Durumu anlamak için deneme amaçlı araç çağırma. Açık bir aracı yalnız
  kullanıcının istediği iş için ve bu işin skill'indeki onaydan sonra kullan.
- Bir araç çağrıldığında hata verirse (izin, giriş süresi dolmuş) durumu
  **giriş eksik** say ve `tarif.md`'deki giriş tarifini ver.
