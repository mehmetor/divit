# Yayını olmayan kullanıcı — örnek metin yolu

Özgeçmişte yayın yoksa ya da kullanıcı okulda çalışıyorsa (öğretmen, rehber
öğretmen, psikolojik danışman) `kurulum` bu dosyayı yükler; SKILL.md'nin 3, 5
ve 6. adımlarının yerine geçer. `SKILL.md`'deki Kurallar aynen geçerlidir.

## Yasaklar

- **Israr yok.** Örnek metni bir kez iste. "Yok", "şimdi değil", "istemiyorum"
  derse `gorevler.md`'deki kurulum durumuna "örnek metin: vermedi" yaz, bir daha
  isteme, onsuz devam et.
- Yayınsızlığı eksiklik gibi anlatma; "makaleniz yok" deme, makale arama.
- **Vaka dosyası, öğrenci görüşme notu, veli görüşme kaydı, RAM ya da sağlık
  raporu isteme ve kabul etme.** Böyle bir dosya gelirse okuma; "Bu öğrencinin
  gizli bilgisi; bana vermeyin, gizli klasöründe kalsın." de.
- Örnek metinden `uslup.md`'ye alıntı alırken kişi adı, okul adı, sınıf-şube,
  öğrenci numarası taşıma. Alıntı yerine kalıbı yaz ("'Sayın Velimiz' diye açar").

## A. Örnek metin (3. adımın yerine)

Tek soru:
> "Üslubunuzu tanımam için kendi yazdığınız iki üç metni bu pencereye
> sürükler misiniz? Bir rapor, bir resmî yazı, bir veliye mektup ya da ders
> notunuz olabilir. İçinde öğrenci adı geçmeyenleri seçin ya da adları
> silin; vaka ve görüşme dosyalarınızı vermeyin."

- Word → `kurallar`'daki pandoc komutu; PDF → Read.
- Tek metin gelirse yeter; ikincisini isteme.
- Okul dışındaki yayınsız kullanıcıda örnekleri işine göre değiştir
  (ör. "bir raporunuz, bir yazışmanız, bir sunum notunuz").
- Metin gelmezse 5. adımda `uslup.md`'ye yalnız şunu yaz:
  "Henüz örnek metin yok. İlk işlerde kullanıcının düzeltmelerinden öğrenilir."

## B. Alan (4. adım)

SKILL.md 4. adımını izle. Okul, öğretmenlik ya da rehberlik işi yapan için
başlangıç `${CLAUDE_PLUGIN_ROOT}/alan/okul-rehberligi.md`'dir. Kılavuzda
"hocanın makaleleri" geçen yerde örnek metinleri ve cevapları kullan.
Doğrulama soruları okul diliyle olsun:
> "Veliye yazdığınız mektuplarda 'Sayın Velimiz' mi diyorsunuz, adla mı?"

## C. Üslup (5. adımın yerine)

SKILL.md 5. adımındaki başlıkları örnek metinlerden çıkar; yalnızca
gördüğünü yaz. Metin türü başına ayrı not düş (resmî yazı / veliye mektup /
ders notu): hitap, açılış ve kapanış kalıbı, sayı ve tarih yazımı, cümle
uzunluğu. "Koru / İşaretle" tablosunu koy. Kısa özet göster, onaylat.

## D. Süren işler ve klasörler (6. adımın yerine, okulda çalışana)

Üç soru, tek tek:
1. "Önümüzdeki haftalarda yetişmesi gereken bir rapor, plan ya da yazı var mı?"
2. "Veli toplantısı, zümre ya da kurul gibi yazısını hazırladığınız bir toplantı yaklaşıyor mu?"
3. "Hazırladığınız bir sunum, seminer ya da ders notu var mı?"

`gorevler.md`'ye iş, tarih, durum yaz; öğrenci adı değil, gerekiyorsa baş harf.
Onayla klasör öner: `yazilar/<is-adi>/`.

**Gizli klasör.** Rehberlik ya da özel eğitim işi yapan kullanıcıya bir kez söyle:
> "Öğrencilerle ilgili gizli dosyalarınız için klasörünüzde 'gizli' adlı bir
> bölme var. Oraya koyduğunuz hiçbir dosyayı okuyamam; bu bilgisayarın
> ayarıyla kilitli. Vaka ve görüşme dosyalarınızı orada tutun."

Klasörde `gizli/` yoksa onayla aç (Mac `mkdir -p "gizli"` · Windows
`New-Item -ItemType Directory -Force "gizli"`). İçine hiçbir şey yazma, içini
listeleme, içindeki dosyayı okumaya çalışma; okuma reddedilirse kilidi
aşmaya uğraşma, kilidi açmayı önerme, yukarıdaki cümleyi söyle.
