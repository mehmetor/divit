# İlk oturum — hazırlık ve akış

**Pilot hoca:** ziraat / tarım bilimleri. Branş henüz belirsiz;
CV ile netleşecek.

## A. Oturumdan önce (Mehmet)

### 1. CV'den çıkarılacaklar

CV'yi `kurulum` skill'i de okuyacak, ama sen önden bakarsan oturumu
doğru kurarsın. Şu altı şeyi ara:

| Aranan | Ne söyler |
|---|---|
| **Alt branş** (tarla bitkileri, bahçe bitkileri, toprak bilimi, bitki koruma, tarım ekonomisi, zootekni, tarım makineleri, gıda müh.) | Alan kılavuzunun hangi kısmı geçerli. `ziraat.md` tarla/bahçe ağırlıklı yazıldı; tarım ekonomisi veya zootekni çıkarsa kılavuz o oturumda düzeltilir. |
| **Yayın dili dağılımı** | Çoğu İngilizceyse Divit'in Türkçe tarafı daha az işe yarar; çoğu Türkçeyse tam hedefte. |
| **Tez danışmanlıkları** (sayı, devam eden) | `tez-kontrol` için elinde malzeme var mı. **Yoksa pilot zayıflar** — o zaman `yazisma` ile başla. |
| **Yürüttüğü projeler** (TÜBİTAK, TAGEM, BAP) | Rapor yükü var mı. `yazisma`nın en güçlü olduğu yer. |
| **İdari görev** (bölüm başkanı, dekan yrd., kurul üyeliği) | Varsa idari yazışma yükü ağırdır; ilk somut kazanç oradan gelir. |
| **Son 2-3 makalesi** | Üslup ve alan kılavuzu bunlardan çıkacak. PDF'lerini de iste. |

**CV ile birlikte iste:** son 2-3 makalesinin PDF'i, ve varsa
**şu an elinde okunmayı bekleyen bir öğrenci metni.** Üçüncüsü en
önemlisi — ilk oturumda gerçek iş yapılacak, demo yapılmayacak.

### 2. Alan kılavuzunu ayarla

`plugins/divit/alan/ziraat.md` hazır ama tarla/bahçe bitkileri
varsayımıyla yazıldı. Branş netleşince:
- **Tarla/bahçe bitkileri, bitki koruma, toprak** → olduğu gibi kullan
- **Tarım ekonomisi** → birim/Latince bölümleri çıkar; anket, ölçek,
  ekonometri tutarlılığı ekle
- **Zootekni** → birimler değişir (canlı ağırlık, yem dönüşüm oranı,
  günlük canlı ağırlık artışı); hayvan refahı etik kurul onayı
  yöntem bölümünde zorunlu madde olur
- **Gıda mühendisliği** → duyusal analiz, raf ömrü, mikrobiyolojik
  sayım birimleri (log kob/g)

### 3. Kurulum

```bash
irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex   # Windows
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash   # Mac
```

Windows'ta kurulum bitince Claude'u tamamen kapatıp yeniden aç
(yeni PDF araçları ancak böyle görünür). Sonra `çalışıyor musun`
yazdır; Divit Word, PDF, izin kipi ve modeli denetler.

Hocanın makinesinde, hocanın yanında yap. Kurulumu izlemesi
"bu benim bilgisayarımda çalışıyor" hissini veriyor — bu hissin
değeri küçümsenmemeli.

## B. Oturum akışı (yaklaşık 60 dakika)

| Süre | Ne |
|---|---|
| 0-10 | Kurulum. Hoca izler, sen yaparsın. |
| 10-25 | `kurulum` skill'i: tanışma, CV okuma, üslup, **alan kuralları doğrulaması** |
| 25-45 | **Gerçek iş:** elindeki öğrenci metniyle `tez-kontrol` |
| 45-55 | Raporu birlikte okuyun. **Hangi maddeyi sildiğini not al.** |
| 55-60 | `gelistirici-ihtiyac-gorusmesi` teklifi — kabul ederse ikinci oturuma |

### Oturumda senin işin

**Müdahale etme, not al.** Hoca takıldığında hemen yardım etme,
on saniye bekle. Nerede takıldığı, ne dediğinden daha değerli.

Şunları kaydet:
- Nerede durakladı, neyi anlamadı
- Hangi çıktıyı okumadan geçti (işe yaramadığının işareti)
- Raporun hangi maddelerini sildi/es geçti
- Hangi cümlede "bunu nasıl yaptın?" diye sordu (güven anı)
- Hangi cümlede yüzü asıldı (güven kaybı anı)

### Söylenmesi gerekenler (atlanmasın)

1. *"Kaynaklarınızda olmayan hiçbir atıfı size vermem. Emin
   olamadığım yere işaret koyarım."*
2. *"Öğrenci dosyalarınıza yazma iznim yok. Okurum, rapor yazarım,
   metne dokunmam."*
3. *"Bir dosyayı değiştirmeden önce önceki sürümünü saklarım. Bozulursa 'geri al' demeniz yeter."*
4. *"Deneme sonuçlarınızı yorumlamam, istatistik yapmam. Metnin
   kendi içinde tutarlı olup olmadığına bakarım."*

Dördüncüsü ziraat için kritik. Vaadi dar tutmak, sonra genişletmek;
geniş tutup geri çekilmekten iyidir.

## C. Oturumdan sonra

1. `ihtiyac-notu.md` varsa oku — "karşılayamadıkları" bölümü yol
   haritasıdır.
2. Alan kılavuzunda düzelttiklerini `plugins/divit/alan/ziraat.md`
   dosyasına geri işle. **Bir sonraki ziraatçı hoca bunu hazır bulur.**
   Ürünün ölçeklenme mekanizması bu.
3. İki hafta dokunma. İkinci haftanın sonunda Divit klasörünün kayıtlarına bak:

```bash
# Hocanın Belgeler/Divit/.divit/gunluk.md dosyasını (izniyle) birlikte açın
```

Kendiliğinden açmış mı? Kaç kez? En sert ölçüt bu — sorulmadan
cevaplanıyor.

## D. Başarısızlık işaretleri

Bunlardan biri olursa aşama 2'ye geçme, sebebini bul:

- Doğrulanamayan tek bir atıf bile çıkması
- Raporun yarısından fazlasının silinmesi
- İkinci haftada hiç açmamış olması
- "Word'de yapsam daha hızlı olurdu" demesi
