---
name: yayin-oncesi
description: Hocanın kendi makale taslağını dergiye göndermeden önce hakem gözüyle okur ve öncelikli düzeltme raporu çıkarır — tutarsızlık, eksik yöntem, kaynakça, çeviri hataları. Hoca "bu makaleyi göndermeden bir bakar mısın", "yayına hazırlıyoruz", "hakeme gitmeden kontrol et", "çeviriyi kontrol et" dediğinde kullan. Öğrenci metni için değil (o `tez-kontrol`), başkasının makalesi için hiç değil (hakemlik yasak).
---

# Yayın öncesi ön okuma

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Amaç: hakemin soracağı soruları hakemden önce sormak. Rapor bir bulgu
listesidir; metni yeniden yazmaz.

## Değişmez kurallar

1. **Orijinale dokunma.** Dosyayı salt okunur yap, SHA256 kaydını al.
   Tüm çalışma kopyada ya da ayrı rapor dosyasında yapılır.
2. **Makalenin sahibi hoca olmalı.** Yazarlar arasında değilse dur:
   bu hakemlik olabilir. Sor.
3. **Yorum ile denetimi ayır.** Sayıyla doğrulanan bulgu "hata", değeri
   alışılmışın dışında olan ama doğrulanamayan "kontrol edilmeli".
   Emin olmadığını hata diye yazma.
4. Kaynakça düzeltmesini **yayıncı kaydından** yap (Crossref/DOI).
   Hafızandan künye tamamlama; doğrulayamadığını "eksik" diye bırak.
5. Üslup hocanındır (`uslup.md`). Dil bölümünde yalnızca anlam bozan
   hata ve hakemin itiraz edeceği aşırı iddia yazılır.

## Akış

1. Metni düz metne çevir (`divit:kurallar`'daki pandoc komutu, `-t plain
   --wrap=none`, çıktı `.divit/gecici/`). Tamamını oku.
2. Harf–LSD denetimi: Mac'te Python varsa betiği çalıştır:
   `python3 "${CLAUDE_PLUGIN_ROOT}/scripts/harf-lsd-denetimi.py" <dosya>`.
   Python yoksa (Windows'ta genellikle yoktur) kuralı kendin uygula:
   her çizelge satırında her ikili için `fark = |a − b|`; fark > LSD ise
   ortak harf olamaz, fark < LSD ise en az bir ortak harf olmalı. Her
   çifti tek tek yaz ve hesapla; göz kararı geçme. Harf dizisinde atlama
   (a, b, f) da yazım hatasıdır.
3. Aşağıdaki kontrol listesini uygula.
   **Dergi uygunluğu:** hedef dergiyi sor (`alan.md`'de sık dergiler
   varsa öner). Hoca derginin yazım kuralları sayfasının adresini ya da
   PDF'ini verirse oku ve metni ölç: kelime sınırı (özet ve tam metin,
   **say**, tahmin etme), özet yapısı, anahtar kelime sayısı, bölüm
   düzeni, kaynak ve atıf biçimi, çizelge/şekil sınırı, zorunlu beyanlar.
   Raporda ayrı bir "Dergi kuralları" çizelgesi: kural · metindeki durum ·
   uyuyor mu. Kurallar verilmezse bu bölümü atla; kuralları hafızadan
   yazma.
4. `rapor/on-degerlendirme-<tarih>.md` yaz; `divit:kurallar`'daki "Rapor
   gösterme" kuralıyla `.html` hâlini üret, iki tam yolu ver. Hoca Word'de
   okumak isterse aynı pandoc komutuyla .docx da üret (tablo sütun
   oranlarını içeriğe göre ayarla).
5. Hocaya üç cümlelik özet ver; en ağır dört bulguyu say.

## Kontrol listesi — öncelik sırasıyla

**1. Gönderimi engelleyenler (önem 3)**
- Taslakta kalan çalışma izleri: yazar notları ("SEVİN?"), alternatif
  paragraflar, "202x" gibi yer tutucular, "[Makale başlığı]" künyeler,
  başka dilde kalan çizelge başlıkları.
- **Yapay zekâ ile üretilmiş görsel** (dosya adında Gemini, DALL·E,
  Midjourney, "Generated"): yayıncıların çoğu yasaklar ya da beyan ister.
- Özetteki ana iddia bulgularla aynı mı? Uygulama kısaltmaları özette
  doğru tanımlanmış mı (C⁻ = gübresiz gibi)?
- Ana sonuç istatistikle destekleniyor mu? Yüzde değişim var da mutlak
  değer ve harflendirme yok mu?
- Özgünlük iddiası ("no studies…") metnin **kendi kaynakçasıyla**
  çelişiyor mu? Kaynakçadaki başlıkları tara.
- Sonuç bölümü, bulguların desteklemediği bir element/özellik sayıyor mu?
- Materyalin kaynağı gösterilen referansla uyuşuyor mu?
- Başka makaleden kalma cümle: "each variety", "both cultivars" ama tek çeşit.

**2. Çizelge–metin tutarlılığı (mekanik)**
- Metinde anılan her en yüksek/en düşük değer çizelgede aynı uygulamada mı?
- Aralıklar ("81,33–57,00") çizelgenin gerçek min/max değeri mi?
- Doğru çizelgeye mi atıf yapılıyor?
- Harf–LSD tutarlılığı (betik). Harf dizisinde atlama (a, b, f).
- Ondalık ayırıcı tek biçim mi (İngilizce dergide nokta)?
- Her şekil/element için ayrı LSD var mı?

**3. Yöntem — tekrarlanabilirlik**
Alan kılavuzundaki (`alan.md`) zorunlu maddeler + her ölçülen özelliğin
yöntemi var mı? Doz tanımı tek ve birimli mi? Yıl, sezon, lokasyon,
parsel, hasat sayısı?

**4. Kaynakça**
- Metin ↔ kaynakça iki yönlü: eksik, fazla, yıl/soyadı uyuşmazlığı.
- Mükerrer girişler.
- **Toplu değiştirme izi:** yazar adlarında ya da özgün makale
  başlıklarında metindeki bir kelimenin bulunması (ör. "bell → capia"
  sonrası "La Capiaa"). Şüpheli girişleri DOI ile doğrula.
- Stil birliği; ResearchGate yerine DOI.

**5. Dil ve çeviri**
Anlam bozan çeviri (alan kılavuzundaki "çeviri tuzakları"), dil bilgisi,
yazım; "our country" gibi yerel bakış; aşırı iddia (demonstrate, prove,
strong effect — tek sezon, tek lokasyonla).

**6. Kontrol edilmeli**
Birimi ya da büyüklüğü alışılmışın dışında görünen değerler; atıf yapılan
yöntemle uyuşmayan protokol tarifi. Neden şüphelendiğini yaz, hüküm verme.

**7. Güçlü yanlar**
Her zaman yaz. Makalenin en güçlü sorusunu bul ve sonucu onun etrafında
kurmayı öner — rapor yalnızca eksik listesi olmasın.

## Rapor sonu

> *Bu rapor yapay zekâ destekli bir ön okumadan geçmiştir. Sayısal
> tutarlılık denetimleri hesaplanarak, kaynakça düzeltmeleri yayıncı
> kayıtlarıyla doğrulanarak yapılmıştır. Bilimsel değerlendirme ve son
> karar yazarlara aittir.*
