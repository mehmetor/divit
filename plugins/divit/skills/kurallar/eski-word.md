# Eski Word dosyası (.doc)

pandoc yalnız `.docx` okur; eski Word biçimini (`.doc`, büyük harfle `.DOC`
de) okuyamaz. Önce bir **kopyası** `.docx` olarak `.divit/gecici/`'ye çevrilir,
sonra o kopya `kurallar`'daki "Word → metin" satırıyla okunur. Asıl dosya
değişmez, taşınmaz. Komutlar `kurallar` → "Dosyalarla çalışma" tablosundaki
"Eski Word" satırıdır; ad kuralı: `.divit/gecici/<ad>-<YYYY-AA-GG>.docx`,
ardından gelen `.md` ile aynı kök (öğrenci dosyasında baş harfler, ad değil).

Hocaya "dönüştürme", "biçim", "doc/docx" gibi kelime kullanma; "eski Word
dosyası" de. Word'ü bu betik dışında hiçbir yolla açtırma.

## Mac

Sormadan çevir: `textutil` macOS'un kendi aracıdır, program açmaz.
Çıkan dosya yoksa ya da pandoc onu okuyamazsa aşağıdaki "Farklı Kaydet"
cümlesini söyle.

## Windows — onay

Betik hocanın Word programını görünmeden, birkaç saniye açar. Bu yüzden
onaysız çalışmaz.

1. `.divit/profil/onaylar.md`'yi Read ile oku. İçinde `- eski-word: her zaman`
   satırı varsa sormadan çalıştır.
2. Yoksa çalıştırmadan önce aynen sor (bir sohbette bir kez; o sohbetteki
   bütün eski Word dosyaları için geçerlidir):
   > "Bu dosya Word'ün eski biçiminde kaydedilmiş, ben doğrudan okuyamıyorum.
   > Bilgisayarınızdaki Word'ü arka planda birkaç saniye açıp dosyanın bir
   > kopyasını yeni biçime çevirebilirim. Asıl dosyanıza ve açık Word
   > belgelerinize dokunmam.
   > 1) Evet, çevir
   > 2) Evet, bundan sonra hiç sormadan çevir
   > 3) Hayır"
3. **1** → çalıştır. **2** → önce satırı kaydet, sonra çalıştır:
   `onaylar.md` yoksa Write ile oluştur:
   ```
   # Onaylar

   Divit'e verdiğiniz kalıcı izinler. Bir satırı silerseniz Divit o işi yine sorar.

   - eski-word: her zaman (YYYY-AA-GG)
   ```
   Varsa Read sonra Edit ile sona ekle. Hocaya tek cümle: "Tamam, bundan sonra
   eski Word dosyalarını sormadan çeviririm; 'artık sormadan çevirme' derseniz
   yine sorarım." **3** → "Farklı Kaydet" cümlesini söyle.
4. Hoca "artık sormadan çevirme", "Word'ümü açma" derse satırı Edit ile
   kaldır, tek cümleyle söyle.

## Betiğin cevabı (tek satır)

| Cevap | Ne yap |
|---|---|
| `TAMAM <yol>` | O `.docx`'i pandoc ile oku, işe devam et. Hocaya çeviriyi ayrıca anlatma. |
| `HATA WORD-YOK` | "Bilgisayarınızda Word bulamadım, bu eski dosyayı açamıyorum. Dosyayı size gönderen kişiden yeni Word ya da PDF hâlini isteyebilir misiniz?" |
| `HATA SIFRELI` | "Dosya şifreli. Word'de şifresiyle açıp **Dosya → Farklı Kaydet → Word Belgesi (.docx)** seçerek aynı klasöre kaydeder misiniz?" |
| `HATA ZAMAN-ASIMI` | "Word arka planda yanıt vermedi, kapattım. Word'ü bir kez kendiniz açıp ilk açılıştaki soruları kapatır mısınız? Sonra yeniden denerim." |
| Başka `HATA …` | "Farklı Kaydet" cümlesi. |

Her `HATA`'yı `.divit/sorunlar.md`'ye **sessizce** yaz (`kurallar/istek.md` →
"Sorun notu biçimi"; betiğin satırını aynen ekle).

**"Farklı Kaydet" cümlesi:** "Bu dosya Word'ün eski biçiminde. Word'de açıp
**Dosya → Farklı Kaydet → Word Belgesi (.docx)** seçerek aynı klasöre kaydeder
misiniz? Sonra hemen okurum."

Aynı istekte birden çok eski Word dosyası varsa her biri için betiği ayrı
çalıştır; ilk `HATA WORD-YOK`'ta ötekileri deneme.
