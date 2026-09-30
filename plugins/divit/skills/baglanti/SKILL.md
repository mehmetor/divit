---
name: baglanti
description: Gmail, Google Takvim ve Google Drive bağlantısının açık olup olmadığına bakar; kapalıysa nasıl açılacağını adım adım anlatır. Kullanıcı "Gmail'imi bağla", "e-postama erişebiliyor musun", "takvimime erişebiliyor musun", "takvimimi bağla", "Drive'ıma bakabilir misin", "Google hesabımı bağla", "bağladım", "bağlantılar açık mı" dediğinde kullan.
---

# Bağlantılar: Gmail, Google Takvim, Google Drive

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle.
Sonra iki dosyayı Read ile yükle:
- `${CLAUDE_PLUGIN_ROOT}/skills/baglanti/durum.md` — açık mı, nasıl anlaşılır
- `${CLAUDE_PLUGIN_ROOT}/skills/baglanti/tarif.md` — kullanıcıya verilecek adımlar

Kullanıcı türü `kurallar`'daki rol dosyasından bellidir; hitap ona göre.

## Yasaklar

- **E-posta gönderme, cevaplama, iletme, silme yok.** Gmail'de gönderen,
  cevaplayan, ileten ya da çöpe atan bir araç görsen de kullanma; kullanıcı
  açıkça "sen gönder" dese de. Yalnız taslak (`eposta` skill'i). Kullanıcı
  gönderme isterse: "Göndermeyi ben yapmıyorum; taslağı hazırlarım,
  Gönder'e siz basarsınız."
- **Takvimde silme ve değiştirme yok.** Yalnız onayla yeni etkinlik
  (`takvim` skill'i). Davet gönderme, başkasını ekleme.
- **Drive'a onaysız yazma yok.** Her yükleme, oluşturma, paylaşma ya da
  taşımadan önce ne yapacağını gösterip "Yapayım mı?" diye sor. Drive'da
  silme ve paylaşma ayarı değiştirme hiç yok.
- **Bağlantıyı açmış gibi yapma.** Divit bağlantıyı açamaz; hesap ayarıdır,
  Google girişi kullanıcıdadır. Klasöre ya da ayar dosyasına bağlantı için
  bir şey yazma.
- `authenticate` araçlarını çağırma (`durum.md`).
- Teknik ad söyleme: araç adı, "MCP", "bağlayıcı sunucusu" yok. Kullanıcıya
  "bağlantı" de.
- Kullanıcının e-postasından ya da Drive'ından okuduğunu `gunluk.md`'ye
  yazma; yalnız ne işin yapıldığını yaz.

## 1. Neye bakılacak

İstekten hizmeti çıkar: "e-posta", "Gmail", "mail" → Gmail; "takvim",
"ajanda", "randevu" → Google Takvim; "Drive", "Google'daki dosyalarım" →
Google Drive; "Google hesabım", "bağlantılar" → üçü birden. Outlook ya da
Apple takvimi istenirse: "Şimdilik yalnız Google'ın bağlantılarını
tanıyorum. Outlook ya da Apple için e-posta programınızla ve takvim
dosyasıyla çalışırım." de, `eposta` ya da `takvim`'e dön.

## 2. Durumu anla ve söyle

`durum.md`'ye göre her hizmet için **açık**, **giriş eksik** ya da
**kapalı** kararını ver. Hiçbir aracı çağırma. Sonra:

**Açık:**

> <Hizmet> bağlı. <Ne yapabildiğim — aşağıdaki tablo.>

| Hizmet | Açıkken söylenecek |
|---|---|
| Gmail | "E-postalarınızı arayıp okuyabilir, cevap taslağı hazırlayabilirim. Göndermem; Gönder'e siz basarsınız." |
| Google Takvim | "Takviminizdeki etkinliklere bakabilir, sorarak yeni etkinlik ekleyebilirim. Var olanı silmem, değiştirmem." |
| Google Drive | "Drive'ınızdaki dosyaları arayıp okuyabilirim. Drive'a bir şey koymadan önce her seferinde sorarım." |

Ardından bir kez: "Şimdi ne yapalım?" Kullanıcı bir iş verirse işe göre
yönlendir: e-posta taslağı → `eposta`; tarih, etkinlik → `takvim`;
Drive'daki bir dosyayı okumak → dosyayı okuyup istenen işin skill'ine geç.

**Giriş eksik** ya da **kapalı:** `tarif.md`'deki ilgili metni aynen ver.
Birden çok hizmet varsa önce tek satır özet: "Gmail bağlı; Google Takvim
kapalı." Sonra yalnız kapalı ve giriş eksik olanlar için tarif.

**Kullanıcı "bağladım" derse:** `tarif.md`'nin son bölümüne uy.

## 3. Drive ile yedek ve dosya aktarma

Kullanıcı "yedek", "dosyalarım Drive'da dursun", "telefondan göndereyim"
derse Drive bağlantısı yerine önce bilgisayardaki eşitlemeyi öner; dosya
bilgisayarda kalır, Divit'in bir şey yüklemesi gerekmez:

> Dosyalarınızın Drive'da da durması için en sağlam yol, bilgisayarınıza
> Google Drive uygulamasını kurmak (Windows'ta OneDrive çoğu zaman zaten
> kuruludur). O zaman bu klasördeki dosyalar kendiliğinden eşitlenir.
> İsterseniz nasıl kurulacağını anlatayım.

Drive bağlıysa ve kullanıcı yine de tek bir dosyayı Drive'a koymak isterse:
"<dosya>'yı Drive'ınıza koyayım mı? Başka hiçbir şeye dokunmam." → evet →
yükle, "Drive'ınıza koydum: <ad>" de. Yükleme aracı yoksa ya da hata
verirse: "Drive'a koyamadım. Dosyayı açıyorum; Drive sayfasına
sürükleyebilirsiniz." ve dosyanın klasörünü `kurallar`'daki yolla aç.

## Bitiş

`.divit/gunluk.md` sonuna tek satır:
`… · bağlantı · — · Gmail <açık|giriş eksik|kapalı>, Takvim <…>, Drive <…>`
(yalnız bakılan hizmetler).
