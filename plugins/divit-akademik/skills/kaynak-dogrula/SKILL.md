---
name: kaynak-dogrula
description: Bir metindeki atıfların gerçek olduğunu ve iddiayı gerçekten desteklediğini yerel kaynaklardan doğrular. Hoca "atıfları kontrol et", "kaynakça doğru mu", "bu cümlenin kaynağı var mı", "kaynakçayı düzenle" dediğinde veya atıf içeren bir metin üretilmeden önce kullan.
---

# Kaynak doğrulama

Akademisyen için tek gerçek felaket uydurma atıftır. İki katmanı var
ve ikisi de burada kontrol edilir:

1. **Künye uydurma** — var olmayan bir kaynak. Kolay yakalanır.
2. **Yanlış atfetme** — kaynak gerçek, künye doğru, ama yazar o şeyi
   söylememiş. *Asıl tehlike budur.* Biçimsel her kontrolden geçer,
   ancak hakem elinde patlar.

Bu yüzden ölçüt "kaynak listede var mı" değil, **"iddiayı destekleyen
birebir pasajı gösterebiliyor muyum"**dur.

## Değişmez kural

`kaynaklar.bib` içinde olmayan hiçbir künye üretilmez. Kaynak yoksa
metne `[ATIF GEREKLİ]` yazılır ve orada durulur. Kaynağın adını,
yılını, dergisini tahmin etmek yasaktır — tahminin doğru çıkması bile
kuralı değiştirmez.

## Kaynakça nereden gelir

İki yol desteklenir, hocaya hangisini kullandığını sor:

**Zotero kullanıyorsa** — Better BibTeX eklentisiyle `kaynaklar.bib`
dosyasına otomatik dışa aktarım kurulur (bir kez kurulur, sonra
kendiliğinden güncellenir). Tek doğruluk kaynağı Zotero'dur; `.bib`
elle düzenlenmez.

**Zotero kullanmıyorsa** — hoca PDF'leri `kaynaklar/` klasörüne atar.
Her PDF'ten künye çıkarılır ve `kaynaklar.bib` buradan üretilir.
Künye PDF'in kendi ilk sayfasından/DOI'sinden okunur, hatırlanmaz.

Her iki yolda da **tam metin yerelde olmalı**: atıf kurmak için
kaynağın PDF'i veya metni `kaynaklar/` altında bulunmalı.

## Doğrulama akışı

1. Metindeki tüm atıfları çıkar (`[@anahtar]`, "(Yılmaz, 2023)",
   dipnot — hangisi kullanılmışsa).
2. Her atıf için sırayla:
   - **a. Künye var mı?** `.bib` içinde anahtar bulunuyor mu?
   - **b. Tam metin var mı?** `kaynaklar/` altında PDF/metin var mı?
   - **c. Pasaj var mı?** Atfın dayandığı iddiayı destekleyen
     **birebir cümleyi** kaynaktan bul. PDF'i Read aracıyla aç, Grep ile ara.
     Hafızadan cevap verme — dosyayı gerçekten aç.
3. Sonucu tabloya yaz.

| Durum | Anlamı | Ne yapılır |
|---|---|---|
| ✅ Doğrulandı | Künye + tam metin + destekleyen pasaj | — |
| ⚠️ Pasaj bulunamadı | Kaynak var, iddiayı destekleyen yer yok | Hocaya sor: iddia mı yanlış, sayfa mı yanlış |
| ⚠️ Tam metin yok | Künye var, PDF yok | Doğrulanamaz; hoca PDF'i eklemeli |
| ❌ Künye yok | `.bib`'de yok | `[ATIF GEREKLİ]` — atıf kurulamaz |

## Yayıncı kaydıyla doğrulama (DOI)

Künyenin kendisi de yanlış olabilir: yazar adı bozulmuş, yıl kaymış,
başlık değişmiş. DOI'si olan her giriş için yayıncı kaydını çek ve
karşılaştır (soyadı, yıl, dergi, cilt, sayfa, başlık):

WebFetch aracıyla `https://api.crossref.org/works/<DOI>` adresini oku;
başlığı, yazar soyadlarını, yılı, cildi ve sayfayı iste. (Komut satırı
kullanma — WebFetch Windows'ta da Mac'te de aynı çalışır.)

DOI'si olmayan giriş için `works?query.bibliographic=<başlık+yazar>`
ile ara; **başlık benzerliği yüksek değilse eşleşme sayma.** Bulamadığını
"doğrulanamadı" diye bırak, tahminle tamamlama.

Özellikle ara: bir kelimenin toplu değiştirilmesiyle bozulmuş adlar
(metinde "bell → capia" yapılınca "La Bella" → "La Capiaa" olur).

## Doğrulanmış atıf kaydı

Doğrulanan her atıf için `kaynaklar/dogrulama.md` dosyasına satır ekle:

```markdown
- `[@yilmaz2023]` — s. 44 — "birebir alıntılanan cümle"
  → dayandığı iddia: <taslaktaki cümle> — ✅ 2026-09-20
```

Bu dosya hocanın kanıt defteridir. Hakem sorduğunda açar, gösterir.

## Rapor

İşin sonunda hocaya **yalnızca sorunlu olanları** göster. 40 atıfın
38'i temizse "38 atıf doğrulandı, 2'sinde sorun var" de ve ikisini
aç. Temiz olanları tek tek sayma.
