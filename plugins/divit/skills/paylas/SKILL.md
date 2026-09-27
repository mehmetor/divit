---
name: paylas
description: Divit'in çalışırken tuttuğu notları (iş günlüğü, karşılaşılan sorunlar, ihtiyaç notu) Divit'i geliştiren kişiye geri bildirim olarak gönderir. Önce ne gönderileceğini açıklar, dosyayı gösterir ve açık onay ister. Hoca "geri bildirim gönder", "sorunları ilet", "paylaş", "Mehmet Bey'e gönder", "Divit'i geliştirene yaz" dediğinde kullan.
---

# Geri bildirim paylaşma

Divit'i geliştiren kişi hocanın makinesini göremez. Hocanın geri bildirimi
ürünün nasıl gelişeceğini belirler. Ama **hiçbir şey hocanın açık onayı
olmadan gönderilmez.**

Alıcı: **Mehmet Akif Orakçı · mehmetakiforakci@gmail.com**

## Kurallar

- Oturum dökümlerini ve Claude'un kendi kayıtlarını **kullanma.** Yalnızca
  Divit'in `.divit/` altında kendi tuttuğu notlar gönderilir.
- **Gönderilmeyenler:** hocanın metinleri, öğrenci dosyaları, özgeçmiş,
  profil dosyaları (`kimlik.md`, `uslup.md`), kaynak PDF'leri.
- Öğrenci adı, öğrenci numarası ve herhangi bir metinden alıntı dosyada
  **bulunamaz.** Varsa çıkar; yerine baş harf ya da iş türü yaz.
- Hoca "evet" demeden gönderme adımına geçme. "Olabilir", "bakarız" onay
  değildir; tekrar sor.
- Hiçbir şeyi silme. Gönderilen notlar yerinde kalır.

## 1. Açıkla

Kısa ve sade:

> "Çalışırken iki şey not tutuyorum: yaptığım işlerin kısa bir günlüğü ve
> karşılaştığınız sorunlar. Bunları Divit'i geliştiren Mehmet Akif
> Orakçı'ya gönderebilirim; Divit'i sizin işinize göre iyileştirmesine
> yardımcı olur. Metinleriniz, öğrencilerinizin dosyaları ve
> özgeçmişiniz gönderilmez. Önce size göstereceğim; onaylamazsanız hiçbir
> şey gitmez."

## 2. Topla

`.divit/paylasim/son-paylasim.txt` varsa oradaki tarihten sonraki
kayıtları al; yoksa hepsini.

- `.divit/gunluk.md` → iş türüne göre sayılar + satırlar
- `.divit/sorunlar.md` → sorun kayıtları
- `.divit/paylasim/ihtiyac-notu.md` → varsa ve daha önce gönderilmediyse
- `.divit/paylasim/alan-*.md` → varsa (hoca daha önce izin vermişti)

Sonra hocaya sor: "Eklemek istediğiniz bir şey var mı? İyi giden ya da
hiç işe yaramayan bir şey?" Cevabını olduğu gibi ekle.

## 3. Dosyayı yaz

`.divit/paylasim/geri-bildirim-<YYYY-AA-GG>.md`:

```markdown
# Divit geri bildirimi — <YYYY-AA-GG>
Alan: <alan.md'deki alan adı> · Sistem: <Windows / Mac> · Dönem: <ilk–son tarih>

## Hocanın notu
<hocanın kendi sözleri; yoksa "—">

## Özet
- <N> iş: <tez-kontrol 3, yazışma 2, …>
- <M> sorun kaydı

## Sorunlar
<sorunlar.md kayıtları, anonimleştirilmiş>

## İş günlüğü
<günlük satırları, anonimleştirilmiş>

## İhtiyaç notu / alan kılavuzu
<varsa>
```

Yazdıktan sonra dosyayı bir kez daha oku ve öğrenci adı, numarası ya da
alıntı kalmadığını denetle.

## 4. Göster ve onay iste

Dosyayı hocaya aç (Windows: `Invoke-Item "<yol>"`, Mac: `open "<yol>"`) ve
özetle: "3 sorun ve 12 iş kaydı var. Dosya ekranda açık."

> "Bunu Mehmet Akif Orakçı'ya göndermemi onaylıyor musunuz? Çıkarmamı
> istediğiniz bir şey varsa söyleyin."

Hoca çıkarma isterse dosyayı düzelt, yeniden göster, yeniden sor.
Hoca "hayır" derse: "Tamam, hiçbir şey gönderilmedi. Dosya
`.divit/paylasim` klasöründe duruyor; isterseniz sonra gönderebiliriz."

## 5. Gönder (yalnızca açık onaydan sonra)

Konu: `Divit geri bildirim — <alan> — <YYYY-AA-GG>`

Önce `eposta` skill'inin **a** yolunu dene: hocanın e-posta bağlayıcısı
varsa izin iste, dosyanın içeriğini gövdeye koyarak taslak oluştur.
Bağlayıcı yoksa ya da hoca izin vermezse aşağıdaki yollara geç.

İlk çalışan yolu kullan, sırayla dene. **Bir yol başarısız olursa bir
sonrakine geç; b'yi atlama.** Windows 11'deki yeni Outlook a'yı
desteklemez ama b'de açılır.

**a. Windows + Outlook** — e-posta dosya ekli hazırlanır, hoca yalnızca
**Gönder**'e basar:
```powershell
$o = New-Object -ComObject Outlook.Application; $m = $o.CreateItem(0); $m.To = "mehmetakiforakci@gmail.com"; $m.Subject = "<konu>"; $m.Body = "Merhaba, Divit geri bildirimim ekte."; $m.Attachments.Add((Resolve-Path "<dosya>").Path) | Out-Null; $m.Display()
```

**b. Varsayılan e-posta programı** — alıcı ve konu dolu açılır; dosyayı
hoca ekler:
- Windows: `Start-Process "mailto:mehmetakiforakci@gmail.com?subject=<konu, %20 ile>"`
- Mac: `open "mailto:mehmetakiforakci@gmail.com?subject=<konu, %20 ile>"`

Sonra dosyanın klasörünü aç (Windows: `Invoke-Item ".divit/paylasim"`,
Mac: `open ".divit/paylasim"`) ve söyle: "Açılan e-postaya
`geri-bildirim-<tarih>.md` dosyasını sürükleyip gönderin."

**c. Hiçbiri açılmazsa** (tarayıcıdan e-posta kullanan hocalar): adresi ve
dosyanın yerini yaz, dosyanın klasörünü aç; hocanın kendi e-postasından ek
olarak göndermesini iste.

Hocaya hangi yolun çalıştığını söyleme; yalnızca yapacağı tek şeyi söyle
("Açılan e-postada Gönder'e basın" ya da "dosyayı e-postaya sürükleyin").

## 6. Kaydet

Hoca gönderdiğini söyleyince `.divit/paylasim/son-paylasim.txt` dosyasına
bugünün tarihini yaz. Teşekkür et, tek cümle.
