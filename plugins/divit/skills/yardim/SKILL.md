---
name: yardim
description: Divit kılavuzunu açar ve kısa bir kullanım özeti verir. Kullanıcı "yardım", "kılavuz", "ne yapabilirsin", "nasıl kullanıyorum", "neler yapabilirim" dediğinde ya da ne isteyeceğini bilemediğinde kullan.
---

# Yardım

1. Kılavuzu tarayıcıda aç — her türde aynı dosya, adresine ek yazmadan:
   Mac: `open KILAVUZ.html`, Windows: `Invoke-Item KILAVUZ.html`. Doğru
   bölümü kılavuz kendisi seçer. Dosya yoksa bu adımı atla; bunu hocaya
   söyleme. Tür yazarsa (`kurallar`) özet
   `${CLAUDE_PLUGIN_ROOT}/skills/kurallar/yazar.md` → "Yardım özeti".

2. Pencerede şu kısa özeti ver — **bu biçimde, bu kadar kısa**:

   > Kılavuzu tarayıcınızda açtım. Kısaca, şunları yapabilirim:
   >
   > - Öğrenci tezini değerlendiririm: *"gelen klasöründeki tezi değerlendir"*
   > - Makalenizi göndermeden kontrol ederim: *"bu makaleyi göndermeden kontrol et"*
   > - Atıfları kontrol ederim: *"bu metindeki atıfları kontrol et"*
   > - Yazışma hazırlarım: *"dekanlığa dilekçe yazalım"*
   > - Kitabınıza editör gözüyle bakarım: *"kitabımı yeni baskı için düzenle"*
   > - Yazılarınızdan kitap planı çıkarırım: *"yazılarımdan kitap yapalım"*
   > - Word'e, sunuma, Excel'e çeviririm: *"bunu Word'e çevir"*, *"sunum hazırla"*
   > - Haftanızı özetlerim: *"bu hafta neler var"*
   > - Çeviri, grafik, fotoğraftan metin: *"şunu Türkçeye çevir"*, *"grafik çiz"*, *"el yazımı oku"*
   > - Gmail ve takviminiz bağlı mı bakarım, bağlamayı anlatırım: *"Gmail'imi bağla"*
   > - Bozulanı geri alırım, isterseniz ayrıntılı geçmiş tutarım: *"geri al"*, *"kaydet"*
   > - Sorunlarınızı Divit'i geliştirene iletirim: *"geri bildirim gönder"*
   >
   > Ne yapmak istersiniz?

3. Hocanın cevabını bekle. İlgili skill'e geç.

Hoca bir şeyin çalışmadığını söylüyorsa özet yerine `saglik` skill'ine geç.

## Yazım kuralı

Hocaya giden her cümle kılavuzdaki dille yazılır: kısa cümle, bir cümlede
bir eylem, "siz" hitabı, teknik terim yok ("terminal", "komut", "dosya
yolu" deme; "Divit penceresi", "klasör" de).
