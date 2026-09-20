---
name: kurulum
description: Divit'in ilk kurulumu. Hocanın CV'si ve birkaç yazısından kimlik ve üslup profilini çıkarır, çalışma klasörünü hazırlar. Hoca ilk kez açtığında, "kurulum", "başlayalım", "beni tanı" dediğinde veya .claude/profil/kimlik.md boşsa kullan.
---

# İlk kurulum

Hedef: hoca on beş dakika içinde ilk gerçek işini yapmış olsun.
Kurulum ekranı değil, **ilk iş** kurulumdur.

## Ton

Hoca teknik değil. Terminal, git, dosya yolu, JSON gibi kelimeleri
kullanma. "Klasör", "dosya", "yedek" yeterli. Aynı anda tek soru sor.
Sorularını numaralandırıp liste hâlinde yığma.

## Adım 1 — Tanışma (3 soru, tek tek)

1. "Nasıl hitap edeyim? Unvanınız ve bölümünüz?"
2. "Alanınız ne? Hangi konularda yazıyorsunuz?"
3. "Elinizde özgeçmiş var mı? Varsa bu klasöre bırakın, ben okurum."

CV varsa oku ve **çıkardıklarını onaylat**: "Şunları anladım: ...
Doğru mu, eksik var mı?" Onaysız kaydetme.

`.claude/profil/kimlik.md` dosyasını yaz: unvan, bölüm, üniversite,
alan, çalışma konuları, yazdığı diller, ders verdiği düzeyler.

## Adım 2 — Üslup

"Kendi yazdığınız 2-3 makale veya bölüm verir misiniz? Nasıl
yazdığınızı öğreneyim ki size yabancı gelen metinler üretmeyeyim."

Metinleri oku, `.claude/profil/uslup.md` yaz: cümle uzunluğu eğilimi,
birinci çoğul mu tekil mi ("çalışmamızda" / "bu yazıda"), dipnot
alışkanlığı, terim tercihleri (hangi Türkçe karşılığı seçiyor),
kaçındığı kalıplar, paragraf uzunluğu.

**Önemli:** Üslup profili metni *cilalamak* için kullanılır, taslağı
hocanın sesiyle üretmek için değil. Taslaklar kasıtlı olarak nötr ve
işaretli çıkar; hoca içeriği onayladıktan sonra üslup uygulanır.
Sebebi: kendi sesiyle gelen metni insan daha az denetler.

## Adım 3 — Kaynakça yolu

"Kaynaklarınızı nasıl tutuyorsunuz? Zotero, Mendeley, EndNote ya da
klasörde PDF?"

- **Zotero** → Better BibTeX eklentisini kur, `kaynaklar.bib` dosyasına
  otomatik dışa aktarımı ayarla. Adımları tek tek, ekran ekran anlat.
- **Diğer / yok** → `kaynaklar/` klasörüne PDF atmasını söyle.
  `kaynak-dogrula` bu yolla da çalışır.

Her iki durumda da şunu söyle: *"Kaynaklarınızda olmayan hiçbir atıfı
size vermem. Emin olamadığım yere işaret koyarım."* Bu cümle ürünün
tek satırlık vaadidir, kurulumda mutlaka geçsin.

## Adım 4 — İlk iş

"Şimdi gerçek bir iş yapalım. Hangisi elinizde var?"
- Okumanız gereken bir öğrenci metni → `tez-kontrol`
- Yazmanız gereken bir yazı/dilekçe → `yazisma`
- Elinizdeki bir taslağın atıf kontrolü → `kaynak-dogrula`

Birini bitirmeden kurulumu bitmiş sayma.

## Adım 5 — Güvence

Kapanışta tek paragraf, sadeleştirilmiş:

> Her oturumda çalışmanızın yedeğini alıyorum. Bir şey bozulursa
> "geri al" demeniz yeterli. Öğrenci dosyalarınıza yazma iznim yok,
> sadece okuyabiliyorum. Kaynaklarınızda olmayan bir künyeyi asla
> üretmem.

## Adım 6 — İhtiyaç notu

`ihtiyac-gorusmesi` skill'ini çalıştırmayı teklif et: "On dakikanızı
alırsam, bu aracı size göre ayarlayabilirim." Kabul ederse oraya geç.
