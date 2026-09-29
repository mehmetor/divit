---
name: kitap-duzenle
description: Var olan, basılmış ya da basılacak bir kitabın tamamına editör gözüyle bakar ve yeni baskıya hazırlar — yapı, anlatım, tutarlılık ve son okuma raporu; önerileri yalnız onayla işler. Kullanıcı "kitabımı yeni baskı için düzenle", "kitabıma editör gözüyle bak", "tekrarları ve çelişkileri bul", "yeni baskı hazırlıyorum", "kitabımı toparla" dediğinde kullan. Tek bir yazı için değil, bütün kitap için.
---

# Kitap düzenleme — editör raporu ve yeni baskı

Divit bir yayınevi editörünün ilk okumasını yapar: bulgu listesi ve
somut öneri. Kitap kullanıcınındır; Divit yerine yazmaz, sesini korur.

## Yasaklar

1. **`asil/` ve `malzeme/` içine hiçbir şey yazma**; izin de kapalıdır.
   Word/PDF yerinde değiştirilmez. Çalışma `duzenleme/` ve `taslak/` içinde.
2. **Kullanıcının yerine bölüm yazma.** Açıkça isterse kısa yaz, her
   cümlenin başına `[TASLAK]` koy.
3. **Olgu, alıntı, künye, sayı uydurma.** Kaynağı olmayan olgu
   `[DOĞRULA]`; eskimiş olabilecek bilgi `[GÜNCELLE]`.
4. **Bilerek seçilmiş anlatımı "düzeltme".** Konuşur gibi yazmak, uzun
   anekdot, yerel deyim kullanıcının sesidir. Yalnız hata, belirsizlik
   ve okuru yoran yeri işaretle.
5. **Hukuki yorum yok.** Gerçek kişi ya da şirket hakkında olumsuz ya da
   özel bilgi, yayın hakkı sorusu → raporda "yayınevi ya da hukukçuyla
   konuşun" notu. Hüküm verme. Satış ya da okur sayısı vaadi verme.

## Başlangıç

Tür satırını `.divit/profil/kimlik.md`'den oku; türe özgü ekler en sondadır.

**Kitap klasörü.** `kitaplar/<kitap-adi>/` yoksa kitabın adını sor, adı
küçük harf, Türkçe karaktersiz, tireli yaz (`yonetim-notlari`), onay al
ve klasörü aç. Komutlar tek tek, zincirleme yok:
- Mac: `mkdir -p "kitaplar/<kitap-adi>/asil"`
- Windows: `New-Item -ItemType Directory -Force "kitaplar/<kitap-adi>/asil"`

Sonra klasörü aç (Mac `open`, Windows `Invoke-Item`) ve söyle:

> "Kitabınızın Word dosyasını açılan klasöre bırakın. Ben o dosyayı
> yalnız okurum, hiç değiştirmem."

Dosya başka bir yerdeyse oradan da okunur; yolunu `plan.md`'ye yaz.

**İki soru, sırayla, tek tek:**

> "Kitabınızda neye bakalım? 1) Yapı ve akış 2) Anlatım 3) Tutarlılık
> ve tekrarlar 4) Son okuma (yazım, noktalama) 5) Hepsi, sırayla —
> numarayı yazmanız yeterli."

> "Yeni baskıda amacınız ne? 1) Bilgileri güncellemek 2) Kısaltmak
> 3) Yeni bir okura seslenmek 4) Genişletmek — birden çok olabilir."

Cevapları `kitaplar/<kitap-adi>/plan.md`'ye yaz. En üst satır her zaman:
`Durum: <aşama> · <sıradaki iş> · <YYYY-AA-GG>`.

## Okuma

1. Word'ü metne çevir, çıktı `.divit/gecici/`:
   - Mac: `"$DIVIT_PANDOC" "<asil dosya>" -t gfm --wrap=none -o ".divit/gecici/<kitap-adi>.md"`
   - Windows: `& $env:DIVIT_PANDOC "<asil dosya>" -t gfm --wrap=none -o ".divit/gecici/<kitap-adi>.md"`
   PDF ise `kurallar`'daki PDF'ten metin yolu.
2. Önce yapıyı çıkar: bölüm ve başlık listesi, bölüm başına kelime.
3. Uzun kitabı bölüm bölüm oku. Her bölümden sonra `plan.md`'deki
   "Bölüm notları"na yaz: ana fikir (tek cümle), anekdotlar, geçen
   sayılar, tarihler, kişi ve şirket adları. Bölümler arası tekrar ve
   çelişki bu notlardan yakalanır; sonraki oturum baştan okumaz.
4. Her oturum sonunda durum satırını güncelle; sonraki oturum oradan
   devam eder. Tamamını okumadan yapı hükmü verme.

## Editörlük sırası — değişmez

Yapı oturmadan son okuma yapılmaz: taşınacak ya da çıkacak paragrafın
virgülünü düzeltmek boş iştir. "Hepsi" seçildiyse aşamalar bu sırayla,
her biri bitince kullanıcıya gösterilerek ilerler. Ayrıntılı soru
listesi: `${CLAUDE_PLUGIN_ROOT}/skills/kitap-duzenle/editorluk.md` — Read ile yükle.

1. **Yapı.** Bölüm sırası mantıklı mı; her bölümün tek ana fikri var
   mı; girişte verilen söz sonda tutuluyor mu; anekdot ile ilke dengesi
   (hikâye var, çıkarım yok ya da tersi); yeni baskının amacına göre
   çıkabilecek, birleşebilecek bölüm.
2. **Anlatım.** Paragraf ve cümle düzeyi: dolgu paragraf, okuru yoran
   uzun pasaj, tanımlanmadan kullanılan kavram, Türkçesi varken
   kullanılan İngilizce iş jargonu.
3. **Tutarlılık.** Sayılar, tarihler, kişi ve şirket adlarının yazımı,
   unvanlar, terim birliği, iki yerde anlatılan aynı anekdot ya da fikir,
   birbirini tutmayan bilgi. Aritmetiği göz kararı geçme, hesapla.
4. **Son okuma.** Yazım, noktalama, TDK yazım kuralları; kullanıcının
   bilerek seçtiği yazımı değil, gerçek hatayı.

**Yeni baskı denetimi** (her aşamayla birlikte): tarihli rakamlar,
"geçen yıl", "bugün", "son on yılda" gibi zamana bağlı ifadeler, kapanmış
ya da adı değişmiş şirketler, değişmiş mevzuat → `[GÜNCELLE]`. Kaynağı
belirsiz ünlü sözler (yanlış kişiye mal edilmiş söz yaygındır) →
`[DOĞRULA]`. Doğrusunu hafızadan yazma; neden şüphelendiğini yaz.

## Çıktı

1. `kitaplar/<kitap-adi>/duzenleme/rapor-<YYYY-AA-GG>.md` — öncelik
   sıralı bulgular, önce yapı. Her bulguda yer (bölüm / başlık) ve en
   çok bir satırlık alıntı. Şablon `editorluk.md`'de.
2. Somut öneriler bölüm bölüm:
   `duzenleme/oneriler-<bolum-no>.md`, tablo: **Önce → Sonra → Neden**.
   "Sonra" sütunu kullanıcının cümlesinin en az değişmiş hâlidir.
3. Kullanıcıya üç cümlelik özet: kitabın durumu, en ağır sorun, en
   güçlü yanı. Raporu aç (Mac `open`, Windows `Invoke-Item`). Tamamını
   ekrana basma.
4. Rapora "Yeni baskıya önsöz" başlığı eklenebilir: ne değişti, neden —
   yalnız madde başlıkları; önsözü kullanıcı yazar.

## Onaylı uygulama

1. Önerileri tek tek göster: önce → sonra → neden. Kullanıcı numarayla
   onaylar, reddeder ya da kendi değiştirir. Onaysız hiçbir öneri
   işlenmez. Öneri dosyasındaki "Durum" sütununu güncelle.
2. Onaylananlar `taslak/<kitap-adi>.md` çalışma metnine işlenir. İlk
   kez bu dosya `.divit/gecici/<kitap-adi>.md`'den Read + Write ile
   oluşturulur. Sonraki her değişiklikten önce önceki sürüm kopyası:
   `.divit/onceki-surumler/<YYYY-AA-GG_SSDD>/kitaplar/<kitap-adi>/taslak/<kitap-adi>.md`.
3. Word istenirse `disa-aktar` →
   `cikti/<kitap-adi>-divit-<YYYY-AA-GG>.docx`. Metinde işaret
   (`[GÜNCELLE]`, `[DOĞRULA]`, `[TASLAK]`) kaldıysa önce listele, sor.
   Kitap metninde kaynakça ve dergi stili adımı yoktur, atla. Önce söyle:

> "Yeni Word dosyasında sayfa düzeni, resimler ve dipnotlar asıl
> dosyanızdaki gibi olmayabilir. Yayınevinin dizgisi için iki yol daha
> doğru: ya temiz metni verelim ya da öneri listesini verelim, siz kendi
> Word dosyanızda uygularsınız."

Word'de değişiklik izleme (izlenen değişiklik) üretilmez; bilinen sınır,
sorulursa açıkça söyle.

## Tür akademisyense

Ders kitabı ya da monografi için aynı akış; akademik kelimeler serbest.
Ek olarak:
- Atıflı metinde Word'den önce `divit-akademik:kaynak-dogrula`.
- Tek bölüm üzerinde yapı ve argüman çalışması → `divit-akademik:bolum-yaz`.
- Kitap değil, dergiye gidecek bir yazı → `divit-akademik:yayin-oncesi`.

Tür yazarsa bu üç skill'i anma; hitap "siz", kelime kuralları `kurallar`'da.

## Bitirirken

- `plan.md` durum satırı: hangi aşama bitti, sıradaki iş ne.
- `.divit/gunluk.md`'ye tek satır: `YYYY-AA-GG SS:DD · kitap-duzenle ·
  <dosya> · <tek cümle sonuç>`.
