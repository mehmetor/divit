---
name: sinav
description: Ders notundan, kitap bölümünden ya da sunumdan sınav sorusu ve cevap anahtarı hazırlar — çoktan seçmeli, klasik, doğru-yanlış, boşluk doldurma; Word çıktısı. Hoca "sınav sorusu hazırla", "vize/final soruları", "quiz", "soru bankası", "cevap anahtarı" dediğinde kullan.
---

# Sınav sorusu hazırlama

Soruyu Divit önerir, sınavı hoca yapar. Hoca her soruyu görür, değiştirir
ya da siler.

## Yasaklar

- **Soru yalnızca hocanın verdiği kaynaktan çıkar.** Ders notu, kitap
  bölümü, sunum, hocanın anlattığı konu listesi. Kaynakta olmayan bilgiyi
  soru ya da doğru cevap yapma. Genel bilgiyle soru eklemek istersen
  hocaya sor ve soruyu `[KAYNAK DIŞI]` diye işaretle.
- **Her sorunun kaynaktaki yeri yazılır** (sayfa, slayt ya da başlık).
  Gösteremiyorsan soruyu çıkar.
- Sayı, birim, Latince ad, formül kaynaktakiyle **harfi harfine** aynı olur.
- Tek doğru cevap. Çoktan seçmelide ikinci bir şıkkın da savunulabilir
  olduğunu görürsen düzelt ya da hocaya söyle.
- Öğrenci cevabına not verme; bu skill yalnızca soru hazırlar.
- Önceki yılların sınavını hoca verirse onu yalnızca biçim ve düzey
  için kullan; aynı soruyu tekrar önerme, hoca istemedikçe.

## Önce sor — tek tek, en fazla dört soru

Cevabı `.divit/profil/dersler.md`'de varsa sorma, oradan al.

1. Hangi ders, hangi sınav (vize, final, bütünleme, quiz)? Hangi konular?
2. Kaynak ne? ("Ders notunu ya da sunumu buraya bırakın.")
3. Soru türü ve sayısı. Öneri: "20 çoktan seçmeli, 5 şık" ya da
   "5 klasik". Hoca "sen öner" derse dersin düzeyine göre öner.
4. Cevap anahtarı ve puan dağılımı istiyor mu? Varsayılan: evet.

Dersin adını, düzeyini (lisans / yüksek lisans), öğrenci sayısını ve
tercih edilen soru türünü `.divit/profil/dersler.md`'ye yaz; bir sonraki
sınavda tekrar sorma. Dosya yoksa oluştur:

```
## <Ders adı> (<kod varsa>)
- Düzey: lisans 3. sınıf · Öğrenci: ~60
- Tercih: 20 çoktan seçmeli (5 şık) + 2 klasik
- Kaynak: yazilar/dersler/<ders>/ders-notu.pdf
```

## Akış

1. Kaynağı oku (PDF ve Word: `kurallar` skill'indeki yol). Konu listesini
   ve her konunun kaynaktaki yerini çıkar.
2. Konulara soru dağıt: her konudan en az bir soru, ağırlık kaynaktaki
   yer kaplamasına göre. Dağılımı hocaya **tablo olarak** göster, onay al:

   | Konu | Kaynakta yeri | Soru sayısı | Düzey (hatırlama / anlama / uygulama) |
   |---|---|---|---|

3. Soruları yaz. Düzeyleri karıştır: yarıdan fazlası hatırlama olmasın.
4. Kendi kendini denetle, sonra hocaya sun:
   - Doğru şık her soruda kaynakta gösterilebiliyor mu?
   - Doğru şıklar A–E arasında dengeli dağılmış mı? Hep aynı harf olmasın.
   - "Hepsi" / "hiçbiri" şıkkı ve olumsuz kök ("hangisi değildir") az
     olsun; olumsuz kökte **değildir** kalın yazılsın.
   - Bir sorunun metni başka bir sorunun cevabını veriyor mu?
   - Şıklar aynı uzunlukta ve aynı dil yapısında mı? En uzun şık hep
     doğru olmasın.
   - Klasik soruda "ne bekleniyor" belli mi? Cevap anahtarında her
     klasik soru için beklenen ana noktalar ve puanı yazılır.
5. Hoca değişiklik isterse yalnızca o soruları yeniden yaz.

## Çıktı

İki ayrı dosya — biri öğrenciye, biri hocaya:

- `yazilar/sinav/<ders>-<sınav>-<YYYY-AA-GG>.md` — sınav kâğıdı: üst
  bilgi (ders, tarih, süre, ad-soyad-numara satırı), yönerge, sorular.
  Kaynaktaki yer **bu dosyada yazmaz.**
- `yazilar/sinav/<ders>-<sınav>-<YYYY-AA-GG>-cevap.md` — cevap anahtarı:
  her soru için doğru cevap, kaynaktaki yeri, düzeyi, puanı; klasik
  sorular için beklenen ana noktalar.

Hoca onaylayınca ikisini de pandoc ile Word'e çevir → `cikti/`
(`kurallar` skill'indeki komut). Klasör yoksa oluşturmayı öner.
İki sınav grubu (A/B) isterse aynı soruları şık ve soru sırası değişmiş
olarak ikinci kâğıda yaz; cevap anahtarında iki grubu yan yana göster.

Günlüğe yaz: `sınav sorusu · <ders> · <soru sayısı> soru, <tür>`.

## Hocaya kapanışta söyle

"Sorular ders notunuzdan çıktı; her birinin kaynaktaki yeri cevap
anahtarında yazıyor. Lütfen her soruyu okuyun, özellikle doğru
şıkları. Değiştirmek istediğiniz soruyu numarasıyla söyleyin."
