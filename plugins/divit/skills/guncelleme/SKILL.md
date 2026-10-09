---
name: guncelleme
description: Divit'in yeniliklerini anlatır ve gerekirse kurulumu kullanıcının onayıyla yeniden çalıştırır. Kullanıcı "yenilikler neler", "Divit güncel mi", "güncelle", "yeni ne var" dediğinde ya da bakim skill'inin hatırlatma denetimi yeni bir sürüm bulduğunda kullan.
---

# Güncelleme ve yenilikler

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına uyar.

Divit'in kendisi (skill'ler) kendiliğinden güncellenir. Klasör ayarları,
kılavuz ve araçlar ise ancak kurulum komutu yeniden çalışınca güncellenir.
Sürüm notları: `${CLAUDE_PLUGIN_ROOT}/SURUM.md` (Read ile).

## Yasaklar

- Kurulumu **onaysız çalıştırma.** Önce neyin değişeceğini söyle.
- Sürüm notunda yazmayan bir yenilik anlatma.
- Hocaya teknik ayrıntı anlatma ("eklenti", "zip", "PATH" yok).
- Kabuk yalnız 3. adımdaki tek kurulum komutu için. Dosyaları Read ile oku,
  yayındaki notu WebFetch ile; kabukla okuma, listeleme, dosyaya ekleme yok.
- `.divit/gunluk.md` ve `.divit/sorunlar.md`: **Read sonra Edit** ile son
  satırın ardına ekle (Write ile baştan yazma).
- `.divit/hatirlatma.md`: anahtarın satırı varsa (ör. `son-uzak-denetim: …`)
  Edit ile **o satırı** değiştir; yoksa bir kez ekle. Aynı anahtar iki kez
  durmaz. Dosya yoksa Write ile aç.

## Sürümleri bul

- **Kanal:** `.divit/kanal.txt`'nin ilk satırı (Read). Yalnız `main`,
  `deneme` ya da `deneme-` ile başlayan bir ad geçerlidir; dosya yoksa ya
  da başka bir şey yazıyorsa `main`. Aşağıda `<kanal>` bu değerdir; hocaya
  anlatma.
- **Yüklü Divit:** `SURUM.md`'deki ilk `## <sürüm>` başlığı.
- **Hocanın gördüğü son sürüm:** `.divit/hatirlatma.md` → `son-gorulen-surum`
  (yoksa `.divit/kurulum-surumu.txt`; o da yoksa "0").
- **Klasörün kurulum sürümü:** `.divit/kurulum-surumu.txt` (yoksa "0").
- **Yayındaki en yeni sürüm** (haftada en çok bir kez, `son-uzak-denetim`
  7 günden eskiyse): WebFetch ile
  `https://raw.githubusercontent.com/mehmetor/divit/<kanal>/plugins/divit/SURUM.md`
  ilk başlığını oku, tarihi `son-uzak-denetim`'e yaz (Edit). Okunamazsa sessizce geç.

Sürümleri sayı olarak karşılaştır (1.10 > 1.9).

## 1. Yenilikleri anlat

Yüklü sürüm, `son-gorulen-surum`'dan yeniyse aradaki sürümlerin
maddelerini topla ve **en çok dört madde** söyle:

> "Divit güncellendi. Yenilikler:
> - PDF'leri artık birleştirebiliyorum.
> - …"

Tür yazarsa (`kurallar`) tez, öğrenci, makale, dergi, sınav, hakem,
kaynakça ya da akademik komutlarla ilgili maddeleri anlatma; madde
kalmazsa "Divit'te küçük iyileştirmeler yapıldı." de.

Sonra `son-gorulen-surum`'u yüklü sürüme yaz.

## 2. Kurulum gerekiyor mu

Şunlardan biri doğruysa kurulum öner:
- `kurulum-surumu`'ndan yeni ve başlığında `kurulum gerekir` yazan bir
  sürüm var;
- yayındaki sürüm yüklü sürümden yeni (Divit'in kendisi henüz inmemiş).

`son-oneri-guncelleme` 7 günden eskiyse sor. Hoca kendisi istediyse
("güncelle" dedi ya da bir iş için kurulumu yenilemeye "evet" dedi) bu
bekleme yok: bu sohbette henüz sormadıysan şimdi sor; "evet" dediyse
doğrudan 3. adım.

> "Bu yeniliklerin tamamı için kısa bir güncelleme gerekiyor. Birkaç
> dakika sürer; dosyalarınıza ve ayarlarınıza dokunmaz. Şimdi
> yapayım mı? Ekranda İngilizce bir izin sorusu çıkarsa **Allow once**
> seçin."

- "evet" → 3. adım.
- başka cevap → `son-oneri-guncelleme`'yi bugüne yaz; bir hafta sonra
  yeniden sor.

## 3. Güncelle

`<klasör>`: bu sohbetin çalıştığı Divit klasörünün tam yolu, sonunda `/` ya
da `\` olmadan (ör. `/Users/ayse/Documents/Divit-Yazar`, `C:\Users\Ayşe
Yılmaz\Documents\Divit`). Başka klasör yazma; tür verme (kurulum onu
`kimlik.md`'den okur). `<kanal>` kanal adı; `main` ise de aynı biçim.

**a) Güncelleyici varsa** — klasördeki `CLAUDE.md` → "Araçlar" →
"Güncelleyici:" satırında bir yol (`<güncelleyici>`) var. Tek komut, aynen:
- Mac (yol tırnaksız; izin kuralı tırnaklı yolu tanımaz): `sh <güncelleyici> <kanal> "<klasör>"`
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File "<güncelleyici>" <kanal> "<klasör>"`

**b) Yoksa** (eski klasör; güncelleyici bu kurulumla gelir), tek komut, aynen:
- Windows: `` powershell -NoProfile -ExecutionPolicy Bypass -Command "`$env:DIVIT_DAL='<kanal>'; `$env:DIVIT_HEDEF='<klasör>'; irm https://raw.githubusercontent.com/mehmetor/divit/<kanal>/kur.ps1 | iex" `` (`$env`'lerin önündeki ters tırnaklar kalsın: dıştaki PowerShell değişkeni açmasın; klasör adında `'` varsa `''` yaz)
- Mac: `curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/<kanal>/kur.sh | DIVIT_DAL=<kanal> DIVIT_HEDEF="<klasör>" bash`

**Komut engellenirse** (ret iletisi geldi, ör. "denied by … auto mode
classifier"): başka araçla, başka komutla ya da parça parça deneme. Söyle:

> "Bilgisayarınızın güvenlik ayarı güncellemeyi benim başlatmama izin
> vermedi; bu bir hata değil. Aşağıdaki satırı siz başlatabilirsiniz:
> kutunun yanındaki **Run** düğmesine basın. Birkaç dakika sürer;
> dosyalarınıza dokunmaz."

Sonra denediğin komutun aynısını tek başına bir kod kutusunda ver. Hoca izin
sorusuna kendisi "No" dediyse ısrar etme: "Tamam, güncellemeyi yapmadım;
isterseniz sonra 'güncelle' deyin." İkisinde de `sorunlar.md`'ye "güncelleme"
türüyle not yaz (Ne oldu: komutun hangi yolu, ret iletisi, izin kipi).
Hoca **Run**'a basınca çıktı bu sohbete gelir; aşağıdaki gibi oku.

Çıktının tamamını oku ("Kurulum bitti" uyarı varken de yazılır):

- "önceki hâli saklandı" (Windows: "onceki hali saklandi") satırı varsa
  tek cümle: "Kurulumun değiştirdiği birkaç ayar dosyasının önceki hâli
  saklandı; elle yaptığınız bir değişiklik kaybolmadı, gerekirse 'geri
  al' deyin."
- "Üniversite işleri eklentisi … şimdi kurulamadı" (Windows: "simdi
  kurulamadi") varsa yayın adresi henüz yenilenmemiştir: "Bir parça şimdi
  inmedi; birkaç dakika sonra yeniden deneyelim. Hazır olunca 'tamam'
  yazın." de. "tamam" gelince aynı komutu **bir kez daha** çalıştır (yeni
  onay istemeden; hoca zaten istedi). Yine çıkarsa uyarıyı tek cümleyle
  söyle ve bir sonraki sohbette "güncelle" demesini iste.
- Başka uyarı varsa tek cümleyle söyle.

Uyarı olmadan ya da ikinci denemede bitince:

> "Güncelleme tamam. Yeniliklerin çalışması için Claude'u bir kez
> tamamen kapatıp yeniden açın. Sonra Divit sohbetine dönün."

Her uyarıyı `sorunlar.md`'ye "güncelleme" türüyle yaz. Kurulum tarayıcıda
kılavuzu açabilir; bunu hocaya söyle.
`gunluk.md`'ye tek satır (Read sonra Edit, sona): `… · güncelleme · — · <sürüm>`.
Bu sohbette hatırlatma denetimi yapma ve geçiş notu sorma: Claude yeniden
açılınca ilk işte sorulur; yoksa soru kapanan sohbette kalır.
