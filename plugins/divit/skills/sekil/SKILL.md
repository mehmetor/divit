---
name: sekil
description: Rakamlardan grafik (sütun, çizgi, pasta), akış şeması ya da zaman çizelgesi çizer; Word'e konabilecek şekilde hazırlar. Kullanıcı "grafik çiz", "şu rakamlardan grafik yap", "sütun grafiği", "pasta grafiği", "akış şeması çiz", "zaman çizelgesi yap", "kitaba bir şekil lazım", "bu tabloyu grafiğe çevir" dediğinde kullan.
allowed-tools: Bash(sh */scripts/kitap-klasoru.sh *), PowerShell(*kitap-klasoru.ps1*)
---

# Şekil — grafik, akış şeması, zaman çizelgesi

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Tür satırını `.divit/profil/kimlik.md`'den Read ile oku; hitap rol dosyasına göre.
Divit şekli kendisi çizer (SVG çizim dosyası, Write ile). Ek program kurulmaz.

## Yasaklar

1. **Sayı uydurma.** Her değer kullanıcıdan ya da onun dosyasından gelir.
   Eksik değer boş bırakılmaz, tahmin edilmez: sor. Yuvarlama, toplama,
   yüzdeye çevirme yalnız kullanıcı isterse; yaptıysan şeklin altında söyle.
2. **Kaynak satırı zorunlu.** Verinin nereden geldiği şeklin altında yazar.
   Bilinmiyorsa sor; cevap yoksa `Kaynak: [DOĞRULA]`. Kaynak uydurma.
3. **Veriyi yorumlama.** "Satışlar patladı", "anlamlı fark" gibi hüküm yok;
   istatistik hesabı yok. Şekil yalnız verilen sayıyı gösterir.
4. `asil/`, `malzeme/`, `gelen/` içine yazma. Kullanıcının Word'üne dokunma.
5. Başkasının yayınından alınan şekli "aynısını çiz" isteğinde bir kez söyle:
   "Başka bir yayından alınan şekil için kaynak gösterilmeli, gerekirse izin
   alınmalı." Kaynak satırına "… verisinden uyarlanmıştır" yaz.

## Başlangıç — en fazla üç soru, tek tek

1. **Veri.** Yapıştırılmış tablo, Word/Excel'den kopyalanan satırlar ya da
   dosya. Dosyayı Read ile oku (Word için `kurallar`'daki çeviri). Excel
   dosyası okunamazsa: "Excel'deki ilgili satırları seçip buraya yapıştırır mısınız?"
2. **Şekil türü** belli değilse öner, onay al:
   zaman içinde değişim → çizgi; kalemleri karşılaştırma → sütun;
   bir bütünün payları (toplam %100) → pasta (6 dilimden fazlaysa sütun öner);
   adımlar ve kararlar → akış şeması; tarihli olaylar → zaman çizelgesi.
3. **Başlık ve kaynak.** "Şeklin başlığı ne olsun, rakamlar nereden?"

Ad: kısa, küçük harf, Türkçe karaktersiz, tireli (`satis-2020-2024`).

## Yer

- Yazar: `kitaplar/<kitap-adi>/sekiller/`; kitap belli değilse sor. Kitap
  klasörü yoksa önce `kurallar`'daki betikle `ac <kitap-adi>`.
- Diğer: `sekiller/`.
Aynı adlı dosya varsa sonuna `-2` ekle; üstüne yazma. Klasörü Write kendisi açar.

## Çizim

`${CLAUDE_PLUGIN_ROOT}/skills/sekil/kaliplar.md` dosyasını Read ile yükle;
şekil türünün kalıbını ve hesap kurallarını oradan al. Sonra üç dosya:

1. `<ad>.svg` — şeklin kendisi (Write).
2. `<ad>.html` — kullanıcının bakması için sayfa: kalıptaki HTML iskeleti,
   içine aynı SVG, altında kaynak satırı ve veri tablosu (Write).
3. `<ad>.md` — Word için:
   ```
   ![Şekil <no>. <Başlık>](<ad>.svg)

   Kaynak: <kaynak>
   ```
   Şekil numarası bilinmiyorsa `Şekil <no>.` yerine yalnız başlık.

**Denetim (atlama):** SVG'yi Read ile tekrar oku. Veri tablosundaki her
değerin şekilde bir kez, doğru etiketle yazılı olduğunu ve sütun
yükseklikleri ya da dilim payları ile değerlerin aynı sırada olduğunu tek
tek karşılaştır. Uymayan varsa düzelt, sonra devam et.

## Word'e koymak

Tek şekillik Word dosyası (kullanıcı şekli oradan kopyalayıp kendi
dosyasına yapıştırır):
- Mac: `~/.divit/araclar/pandoc "<yer>/<ad>.md" --quiet --resource-path "<yer>" -o "cikti/<ad>-sekil-<YYYY-AA-GG>.docx"`
- Windows: `& "<pandoc>" "<yer>/<ad>.md" --quiet --resource-path "<yer>" -o "cikti/<ad>-sekil-<YYYY-AA-GG>.docx"`

Şekil Word'e çizim olarak girer, büyütünce bozulmaz. Word 2016 ve sonrası
gerekir (içerde not; kullanıcıya söyleme). Kullanıcı "Word'de şekil boş
görünüyor" derse: Word sürümünü sor; eskiyse `.html` dosyasını tarayıcıda
açıp şeklin ekran görüntüsünü almasını tarif et (Windows: Win+Shift+S;
Mac: Cmd+Shift+4), sonra `.divit/sorunlar.md`'ye not düş.

Kitap metni `taslak/` içinde markdown ise şekli oraya da aynı satırla
bağlayabilirsin; `disa-aktar` Word'e çevirirken şekli gömer.

## Kapanış

Kullanıcıya:
- `.html` dosyasının tam yolu ("tıklayınca şekli görürsünüz"),
- Word dosyasının tam yolu,
- "Renk, sıra ya da yazı değişsin isterseniz söyleyin."

Kullanıcı değişiklik isterse SVG'nin önceki sürümünü `kurallar`'a göre al,
üç dosyayı birlikte güncelle, Word dosyasını yeni tarihle yeniden üret.

Günlüğe: `YYYY-AA-GG SS:DD · şekil · <ad> · <tür, kaç değer>`.
