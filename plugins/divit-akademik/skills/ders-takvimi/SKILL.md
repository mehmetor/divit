---
name: ders-takvimi
description: Dönemin akademik takvimini (sınav haftaları, not giriş son günleri, tatiller) ve haftalık ders programını bir kez alıp kaydeder; Divit hatırlatmaları buna göre yapar. Hoca "akademik takvimi ekle", "dönem takvimim", "ders programım bu", "sınav haftaları ne zaman", "yeni dönem başladı" dediğinde ya da takvim PDF'ini, fotoğrafını verdiğinde kullan.
---

# Dönem takvimi ve ders programı

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle;
her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Bir kez alınır, `.divit/profil/takvim.md`'ye yazılır. `divit:takvim` skill'i
bu dosyayı okuyup sınavdan önce soru hazırlığını, not girişinden önce
değerlendirmeyi hatırlatır.

## Yasaklar

- **Tarih uydurma.** Belgede okunmayan ya da bulanık tarihi yazma; o satıra
  `[DOĞRULA]` koy ve hocaya sor. Geçen yılın takviminden bu yılı tahmin etme.
- Belge birden çok fakülte ya da program için farklı tarih veriyorsa
  hangisinin hocanınki olduğunu sor; hepsini yazma.
- Kaydetmeden önce tabloyu hocaya göster, onay al.
- Israr etme: hoca "sonra" derse `Durum: istenmedi` satırını yaz (aşağıda), bir daha sorma.

## 1. İste — tek soru

> "Üniversitenizin bu dönemki akademik takvimi ve haftalık ders programınız
> elinizde var mı? PDF'ini, Word dosyasını ya da ekran fotoğrafını bu
> pencereye sürükleyebilirsiniz. Yoksa tarihleri siz söyleyin, ben yazayım."

Okuma:
- PDF, Word: `kurallar`'daki "Dosyalarla çalışma" ve "dışarıdaki dosya" yolu.
- Fotoğraf ya da ekran görüntüsü: Read ile doğrudan bak.
- Excel: "Excel dosyasını okuyamıyorum; PDF olarak kaydedip verir misiniz,
  ya da ekranın fotoğrafını?" de.
- Hoca "sitede var" derse: WebSearch ile üniversitenin akademik takvim
  sayfasını bul, bağlantıyı göster; "İndirip buraya sürükler misiniz?" de.

Takvim ve ders programı ayrı belgelerse ikisini **tek tek** iste. Ders
programı yoksa sadece dönem takvimiyle devam et.

## 2. Çıkar

Dönem takviminden (hocanın dönemi; güz mü bahar mı sor gerekiyorsa):
- Derslerin başlaması ve bitişi
- Ara sınav haftası (vize), final haftası, bütünleme haftası
- Her biri için **not giriş son günü**
- Resmî tatiller, ders yapılmayan günler

Ders programından: gün, saat, ders adı (kodu varsa kodu), yer.

## 3. Göster, onayla

> Şunları buldum, doğru mu?
>
> | Olay | Başlangıç | Bitiş |
> |---|---|---|
> | Ara sınav haftası | 9 Kasım 2026 Pazartesi | 15 Kasım 2026 Pazar |
> | Ara sınav not girişi son günü | 27 Kasım 2026 Cuma | |
>
> | Gün | Saat | Ders | Yer |
> |---|---|---|---|
> | Pazartesi | 10.00–12.00 | <ders> | <derslik> |

Hoca düzeltirse düzelt, tekrar göster.

## 4. Kaydet

`.divit/profil/takvim.md`'ye Write ile (dosya varsa ve `Durum: istenmedi`
dışında bir şey yazıyorsa önce hocaya "Eski dönemin yerine yazayım mı?"
diye sor). Tarihler `YYYY-AA-GG`:

```
# Dönem takvimi

Dönem: 2026-2027 Güz · Kaynak: <belge adı ya da "hoca söyledi"> · Kaydedildi: YYYY-AA-GG

| Olay | Başlangıç | Bitiş |
|---|---|---|
| Derslerin başlaması | 2026-09-21 | |
| Ara sınav haftası | 2026-11-09 | 2026-11-15 |
| Ara sınav not girişi son günü | 2026-11-27 | |
| Final haftası | 2027-01-04 | 2027-01-15 |
| Final not girişi son günü | 2027-01-20 | |
| Bütünleme haftası | 2027-01-25 | 2027-01-29 |
| Tatil: <ad> | 2026-10-29 | |

# Haftalık ders programı

| Gün | Saat | Ders | Yer |
|---|---|---|---|
| Pazartesi | 10.00-12.00 | <ders> | <derslik> |
```

`[DOĞRULA]` işaretli satırları olduğu gibi bırak.

## 5. Bitiş

Tek paragraf:

> "Takviminizi kaydettim. Sınav haftasından iki hafta önce soru hazırlığını,
> not girişinden bir hafta önce değerlendirmeyi hatırlatırım. İsterseniz bu
> tarihleri takviminize de eklerim."

"Evet" derse `divit:takvim` skill'inin 3. bölümüne geç (sınav haftaları ve
not giriş son günleri tüm gün etkinlik). Ders programını takvime eklemeyi
önerme; hoca isterse haftalık tekrar yerine yalnız o haftanın derslerini ekle.

Dersin adı `.divit/profil/dersler.md`'de yoksa oraya da ekle (yalnız ad ve
kod; `sinav` skill'i gerisini kendisi sorar).

`.divit/gunluk.md` sonuna tek satır: `… · ders-takvimi · .divit/profil/takvim.md · <dönem> kaydedildi`.
