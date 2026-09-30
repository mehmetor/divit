# Bağlama tarifi — kullanıcıya gösterilecek metinler

Metinleri **aynen** ver; `<Hizmet>` yerine Gmail, Google Takvim ya da
Google Drive yaz. Aynı anda birden çok hizmet istendiyse adımları bir kez
ver, 2. adımda hepsini say. Menü adları (**Connectors**, **Connect**,
**Settings**) uygulamada İngilizce göründüğü için İngilizce kalır. Listede
aranacak ad da İngilizcedir: takvim için 2. adımda **Google Calendar** yaz
("listede **Google Calendar**'ı (Google Takvim) bulup…"); Gmail ve Google
Drive aynı kalır.
Akademisyen de yazar da aynı metni görür.

## Kapalıysa

> <Hizmet>'i bana bağlamayı ben açamıyorum; hesabınızın ayarı, bir kez
> sizin yapmanız gerekiyor. İki dakika sürer:
>
> 1. Bu pencerede, yazı yazdığınız kutunun yanındaki **+** işaretine tıklayın.
> 2. **Connectors**'ı seçin, listede **<Hizmet>**'i bulup yanındaki
>    düğmeye (**Connect**) basın.
> 3. Açılan Google sayfasında kendi Google hesabınızla giriş yapın ve
>    izin verin.
> 4. Bu pencereye dönün; soldaki **New session** ile yeni bir sohbet açıp
>    "bağladım" yazın. Yeni sohbette ben bakarım.
>
> İstediğiniz zaman **Settings → Connectors**'tan kapatabilirsiniz.

Hizmete göre sona **tek** satır ekle:
- Gmail: "Ben e-posta **göndermem**; yalnız taslak hazırlarım, Gönder'e siz
  basarsınız."
- Google Takvim: "Takviminize bir şey eklemeden önce her seferinde size
  sorarım; var olan hiçbir şeyi silmem."
- Google Drive: "Drive'ınızdaki dosyaları okuyabilirim; Drive'a bir şey
  koymadan önce her seferinde size sorarım."

## Giriş eksikse

> <Hizmet> bana eklenmiş ama Google girişi yapılmamış görünüyor.
>
> 1. Yazı kutusunun yanındaki **+** işaretine tıklayın, **Connectors**'ı seçin.
> 2. **<Hizmet>**'in yanındaki **Connect** düğmesine basın.
> 3. Açılan Google sayfasında hesabınızla giriş yapıp izin verin.
> 4. Soldaki **New session** ile yeni bir sohbet açıp "bağladım" yazın.

## Listede yoksa ya da Google izin vermiyorsa

Kullanıcı "listede yok", "izin vermedi", "yöneticiniz onaylamadı" gibi bir
şey derse:

> Kurum hesaplarında (çalıştığınız yerin verdiği e-posta) bu bağlantıyı
> kurumun bilgi işlem birimi kapatmış olabilir; bunu siz ya da ben
> açamayız. Bu arada işimize e-posta programınızla ya da takvim dosyasıyla
> devam ederiz, hiçbir şey kaybolmaz. İsterseniz bilgi işlem birimine
> "Claude uygulamasının Google hesabıma bağlanmasına izin verilmesini
> istiyorum" diye yazabilirsiniz.

## "Bağladım" dendiğinde

`durum.md`'ye göre yeniden bak.
- Açıksa: "<Hizmet> bağlı, teşekkürler." ve bekleyen işe dön.
- Hâlâ görünmüyorsa: "Bu sohbette henüz göremiyorum. Soldaki **New
  session** ile yeni bir sohbet açıp aynı isteği yazar mısınız? Yeni
  sohbet bağlantıyı görür." Bir kez söyle; ikinci kez de görünmezse
  `.divit/sorunlar.md`'ye "bağlayıcı görünmedi" diye yaz ve e-posta
  programı ya da takvim dosyası yoluna geç.
