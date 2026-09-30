---
name: guncelleme
description: Divit'in yeniliklerini anlatır ve gerekirse kurulumu kullanıcının onayıyla yeniden çalıştırır. Kullanıcı "yenilikler neler", "Divit güncel mi", "güncelle", "yeni ne var" dediğinde ya da bakim skill'inin hatırlatma denetimi yeni bir sürüm bulduğunda kullan.
---

# Güncelleme ve yenilikler

Divit'in kendisi (skill'ler) kendiliğinden güncellenir. Klasör ayarları,
kılavuz ve araçlar ise ancak kurulum komutu yeniden çalışınca güncellenir.
Sürüm notları: `${CLAUDE_PLUGIN_ROOT}/SURUM.md`.

## Yasaklar

- Kurulumu **onaysız çalıştırma.** Önce neyin değişeceğini söyle.
- Sürüm notunda yazmayan bir yenilik anlatma.
- Hocaya teknik ayrıntı anlatma ("eklenti", "zip", "PATH" yok).

## Sürümleri bul

- **Kanal:** `.divit/kanal.txt`'nin ilk satırı (Read). Yalnız `main`, `yeni`,
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
  ilk başlığını oku, tarihi `son-uzak-denetim`'e yaz. Okunamazsa sessizce geç.

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

Tek komut, aynen (`<kanal>` yerine kanal adı; kanal `main` ise de aynı biçim):
- Windows: `` powershell -NoProfile -ExecutionPolicy Bypass -Command "`$env:DIVIT_DAL='<kanal>'; irm https://raw.githubusercontent.com/mehmetor/divit/<kanal>/kur.ps1 | iex" `` (`$env`'in önündeki ters tırnak kalsın: dıştaki PowerShell değişkeni açmasın)
- Mac: `curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/<kanal>/kur.sh | DIVIT_DAL=<kanal> bash`

Çıktının sonunu oku. "Kurulum bitti" görünüyorsa:

> "Güncelleme tamam. Yeniliklerin çalışması için Claude'u bir kez
> tamamen kapatıp yeniden açın. Sonra Divit sohbetine dönün."

Uyarı varsa uyarıyı tek cümleyle söyle ve `sorunlar.md`'ye "güncelleme"
türüyle yaz. Kurulum tarayıcıda kılavuzu açabilir; bunu hocaya söyle.
`gunluk.md`'ye tek satır: `… · güncelleme · — · <sürüm>`.
