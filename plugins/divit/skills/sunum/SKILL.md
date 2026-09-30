---
name: sunum
description: Bir metinden, bölümden ya da notlardan PowerPoint sunumu (.pptx) hazırlar; kurumun ya da kendi sunum şablonunu bir kez verince hep onu kullanır; gelen bir sunumu okuyup özetler. Kullanıcı "sunum hazırla", "slayt yap", "PowerPoint'e çevir", "bu bölümden sunum", "konuşmam için slayt", "şablonum bu", "bu sunumu oku" dediğinde kullan.
---

# Sunum — PowerPoint dosyası

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Tür satırını `.divit/profil/kimlik.md`'den Read ile oku; hitap ve kelimeler rol
dosyasına göre (yazara akademik kelime yok). Sunum pandoc ile yapılır; ek
program kurulmaz.

## Yasaklar

1. **Python, Node ya da başka program isteyen yerleşik PowerPoint becerisini
   kullanma**, bir şey kurma. Bu skill yeter.
2. **İçerik uydurma.** Slayttaki her madde, sayı ve alıntı kullanıcının metninden
   ya da söylediğinden gelir; kaynaktaki sayıyı aynen al. `[DOĞRULA]` yalnız kaynakta olmayan bilgi için; kaynaklar kurallardaki gibi.
3. **Tasarım vaadi verme.** "Sade bir sunum; renk ve yerleşimi kendi şablonunuz
   verir." Görsel, grafik, animasyon üretme. Hazır şekil varsa (ör. `sekil`
   skill'inin `.svg`'si) `![Başlık](yol)` ile konur; grafik isterse `sekil`.
4. Kullanıcının `.pptx` dosyasını yerinde değiştirme; her sonuç `cikti/` altında yeni dosya.
5. `gelen/`, `asil/`, `malzeme/` içine yazma. Başkasını değerlendirmek için gelen
   dosyayı (hakemlik, jüri) okuma.

## Adlar ve yer

- Sunum metni: `cikti/<ad>-sunum-YYYY-AA-GG.md`; PowerPoint: aynı adla `.pptx`.
  `<ad>` kısa, küçük harf, Türkçe karaktersiz, tireli. Önce Glob'la bak (boş sonuç "yok" demektir; başka komutla bakma, klasörü Write kendisi açar); aynı gün
  varsa `-s2`, `-s3`. Üstüne yazma.
- Şablon: `.divit/profil/sunum-sablonu.pptx` (tek dosya, tarihsiz).
- Ara dosya yalnız `.divit/gecici/`.

## Akış

1. **Kaynak.** Metin sohbette, bir dosyada ya da Word'de. Word/PDF'i kurallardaki
   çeviriyle oku. Konu belirsizse tek soru: "Hangi metinden, kaç dakikalık konuşma?"
2. **İskelet.** Önce ekranda liste olarak göster, dosya yazmadan:
   ```
   1. <Slayt başlığı> — <en çok 5 kısa madde>
   2. ...
   ```
   Kural: slayt başına en çok 5 madde, madde tek satır; 10 dakikaya ~6-8 slayt.
   "Böyle olsun mu, değiştirmek istediğiniz var mı?" Onay gelmeden yazma.
3. **Metin.** Onaydan sonra Write ile `cikti/<ad>-sunum-YYYY-AA-GG.md`:
   ```
   ---
   title: "<Sunum başlığı>"
   subtitle: "<alt başlık, varsa>"
   author: "<ad, profilden; yoksa boş bırak>"
   date: "<gün ay yıl>"
   lang: tr
   ---

   # <Slayt başlığı>

   - Madde
   - Madde

   ::: notes
   Konuşmacı notu (yalnız kullanıcı "notları da yaz" derse).
   :::
   ```
   Her `#` başlığı bir slayttır. Tablo markdown tablosu olarak girer (gerçek
   PowerPoint tablosu olur). İki sütun gerekirse:
   `:::::: columns` / `::: column` … `:::` / `::: column` … `:::` / `::::::`.
   Başlıktaki çift tırnağı `\"` yaz.
4. **PowerPoint.** Şablon var mı, Glob ile `.divit/profil/sunum-sablonu.pptx`'e bak.
   - Mac, şablonlu: `~/.divit/araclar/pandoc "cikti/<ad>-sunum-<tarih>.md" --reference-doc ".divit/profil/sunum-sablonu.pptx" -o "cikti/<ad>-sunum-<tarih>.pptx"`
   - Windows, şablonlu: `& "<pandoc>" "cikti/<ad>-sunum-<tarih>.md" --reference-doc ".divit/profil/sunum-sablonu.pptx" -o "cikti/<ad>-sunum-<tarih>.pptx"`
   - Şablon yoksa `--reference-doc …` kısmını çıkar.
   Şekil varsa komuta `--resource-path "<şeklin klasörü>"` ekle.
5. **Aç:** Mac `open "cikti/<ad>-sunum-<tarih>.pptx"`, Windows `Invoke-Item "cikti/<ad>-sunum-<tarih>.pptx"`.

## Şablon — bir kez verilir

Kullanıcı "şablonum bu", "kurumun şablonu" deyip bir `.pptx` verirse (`.potx` ise "PowerPoint'te açıp .pptx olarak kaydeder misiniz?"),
ya da ilk sunumdan sonra "kendi şablonum var" derse:

1. Dosya klasör dışındaysa kurallardaki "Klasör dışındaki dosya" adımı; yolunu al.
2. Write ile `.divit/gecici/bos-sunum-YYYY-AA-GG.md` yaz, içi tek satır: `<!-- şablon kopyası -->`.
3. Şablonun kopyası (pandoc boş metinle şablonu aynen taşır):
   - Mac: `~/.divit/araclar/pandoc ".divit/gecici/bos-sunum-YYYY-AA-GG.md" --reference-doc "<şablon yolu>" -o ".divit/profil/sunum-sablonu.pptx"`
   - Windows: `& "<pandoc>" ".divit/gecici/bos-sunum-YYYY-AA-GG.md" --reference-doc "<şablon yolu>" -o ".divit/profil/sunum-sablonu.pptx"`
   Önceki şablon varsa önce Glob'la bak; üstüne yazmadan önce "Eski şablonun yerine
   bu geçsin mi?" diye sor.
4. "Şablonunuzu kaydettim; bundan sonraki sunumlar onunla çıkar." Hazır sunum
   varsa yeniden üretmeyi öner (yeni adla, `-s2`).

Şablonla sunum düz ya da tuhaf çıkarsa (başlıklar yerinde değil): şablonun
yerleşim adları farklı olabilir. Şablonsuz üret, kullanıcıya "Şablonunuzun
yerleşimini tanıyamadım; sade hâlini hazırladım, renkleri PowerPoint'te
Tasarım sekmesinden verebilirsiniz" de; `.divit/sorunlar.md`'ye not düş.

## Gelen sunumu okumak

Kullanıcı bir `.pptx` verip "oku", "özetle", "bundan metin çıkar" derse:
- Mac: `~/.divit/araclar/pandoc "<dosya>.pptx" -t gfm -o ".divit/gecici/<ad>-YYYY-AA-GG.md"`
- Windows: `& "<pandoc>" "<dosya>.pptx" -t gfm -o ".divit/gecici/<ad>-YYYY-AA-GG.md"`

Sonra Read ile oku. Resimlerdeki yazı gelmez; gerekirse söyle. Eski `.ppt`
okunmaz: "PowerPoint'te açıp Farklı Kaydet → .pptx yapar mısınız?"

## Değişiklik

"Şu slaytı çıkar", "maddeyi değiştir": sunum metnini kurallardaki önceki sürüm
kuralıyla Edit et, PowerPoint'i aynı gün için `-s2` adıyla yeniden üret. Kullanıcı
PowerPoint'te kendisi düzeltme yaptıysa onun dosyasının üstüne yazma.

## Kapanış

Kullanıcıya iki dosyanın tam yolu, her biri kendi satırında, ters tırnakta: önce
`.pptx`, sonra sunum metni `.md` ("değişiklik isterseniz buradan yeniden üretirim").
Tek cümle: "Divit PowerPoint dosyası yapar ama süslemez; renk ve düzen şablonunuzdan gelir."
Şablon yoksa bir kez: "Kurumunuzun ya da kendi şablonunuz varsa verin, sonrakiler onunla çıksın."

Günlüğe: `YYYY-AA-GG SS:DD · sunum · <dosya> · <kaç slayt, şablonlu/şablonsuz>`.
