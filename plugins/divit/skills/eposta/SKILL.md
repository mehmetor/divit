---
name: eposta
description: Hazırlanan bir metni e-postanızda taslak olarak açar; kendisi hiç göndermez. Öğrenciye geri bildirim, editöre mektup, hakem cevabı, geri bildirim dosyası için de kullanılır. Kullanıcı "e-posta olarak hazırla", "öğrenciye gönder", "mail at", "taslak oluştur" dediğinde ya da başka bir skill e-posta adımına geldiğinde kullan.
---

# E-posta taslağı

## Yasaklar

- **Asla göndermeyi sen yapma.** Her yol yalnızca taslak hazırlar;
  **Gönder**'e hoca basar. Bağlayıcıda "gönder" aracı olsa bile kullanma.
- Alıcı adresini uydurma. Hocadan al ya da hocanın verdiği metinden oku;
  emin değilsen sor.
- Öğrenci metninden uzun alıntı koyma; e-posta bulguyu anlatır, metni taşımaz.
- Taslağı oluşturmadan önce **alıcıyı, konuyu ve metni hocaya göster**,
  onay al.

## 1. Göster ve onay al

> "Şu e-postayı hazırlayacağım:
> Kime: <adres> · Konu: <konu>
> <metin>
> Taslak olarak açayım mı? Göndermeyi siz yapacaksınız."

## 2. Yol seç — ilk çalışanı kullan

**a. E-posta bağlantısı (Gmail)** — Gmail'in durumunu
`${CLAUDE_PLUGIN_ROOT}/skills/baglanti/durum.md` ile anla (Read ile yükle;
hiçbir aracı çağırmadan). **Giriş eksik** ya da **kapalıysa** bu oturumda
bir kez sor: "Gmail'iniz bana bağlı değil. Bağlarsanız taslağı doğrudan
e-postanızda hazırlarım; nasıl yapılacağını anlatayım mı? Ya da şimdilik
e-posta programınızla devam edelim." Tarif isterse `divit:baglanti`
skill'ini yükle; istemezse b'ye geç. **Açıksa** önce **izin iste**:

> "E-posta hesabınız Claude'a bağlı görünüyor. Bu e-postayı hesabınızda
> taslak olarak oluşturmama izin verir misiniz? Göndermem; taslaklar
> klasöründe bekler."

İzin verirse taslak oluşturma aracını kullan (gönderme aracını değil).
Sonra: "Taslak, e-postanızın **Taslaklar** klasöründe. Okuyup
Gönder'e basabilirsiniz." Dosya eki gerekiyorsa ve araç ek
desteklemiyorsa metni gövdeye koy. Bir oturumda izin bir kez sorulur.
Hoca "hayır" derse b'ye geç.

**b. Windows + klasik Outlook** — dosya eki gerekiyorsa:
```powershell
$o = New-Object -ComObject Outlook.Application; $m = $o.CreateItem(0); $m.To = "<adres>"; $m.Subject = "<konu>"; $m.Body = "<metin>"; $m.Attachments.Add((Resolve-Path "<dosya>").Path) | Out-Null; $m.Display()
```
Ek yoksa `Attachments` kısmını çıkar.

**c. Varsayılan e-posta programı** — `mailto:` ile, konu ve metin `%20`
ile kodlanmış:
- Windows: `Start-Process "mailto:<adres>?subject=<konu>&body=<metin>"`
- Mac: `open "mailto:<adres>?subject=<konu>&body=<metin>"`

Metin çok uzunsa (2000 karakterden fazla) gövdeye koyma; metni
`yazilar/eposta-<konu>-<YYYY-AA-GG>.md` dosyasına yaz, klasörü aç ve "Metni e-postaya
kopyalayın" de. Ek gerekiyorsa dosyanın klasörünü aç: "Dosyayı açılan
e-postaya sürükleyin."

**d. Hiçbiri açılmazsa** — metni pencerede göster, "Kopyalayıp kendi
e-postanıza yapıştırın" de.

Hocaya hangi yolun çalıştığını anlatma; yalnızca yapacağı tek şeyi söyle.

## 3. Kaydet

`gunluk.md`'ye tek satır: `… · e-posta taslağı · <tür> · <alıcının
baş harfleri>`. Adres yazma.
