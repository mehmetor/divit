---
name: gelistirici-ihtiyac-gorusmesi
description: Hocanın gerçek iş akışını ve ihtiyaçlarını tespit eden yapılandırılmış görüşme; çıktısı geliştiriciye giden bir ihtiyaç notudur. Kurulumdan sonra, "beni daha iyi tanı", "bunu bana göre ayarla" dendiğinde veya pilot geri bildirimi toplanırken kullan.
---

# İhtiyaç görüşmesi

Bu skill ürünü hocaya uydurmak *ve* geliştiriciye ne yapacağını
söylemek için var. Çıktı iki yere gider: hocanın profiline ve
`.divit/paylasim/ihtiyac-notu.md` dosyasına.

## Yöntem kuralı

**"Ne istersiniz" diye sorma.** Cevabı ya "her şeyi yapsın" ya
"güvenmem" olur; ikisi de kullanılamaz. Bunun yerine **geçmişi**
sordur. İnsanlar gelecekteki tercihlerini kötü, geçen haftayı iyi
hatırlar.

Tek tek sor, cevabı dinle, üstüne git. Anketmiş gibi okuma.

## Sorular

**Zaman**
1. "Geçen hafta bilgisayar başında en çok zamanınızı yiyen üç iş neydi?"
2. "Bunlardan hangisi en sıkıcıydı? Hangisi en değerliydi?"
3. "Keşke birisi benim yerime yapsa dediğiniz bir iş var mı?"

**Araçlar**
4. "Son makalenizi hangi programda yazdınız?"
5. "Kaynakçayı nasıl tutuyorsunuz?"
6. "Makaleyi kaç kişiyle birlikte yazdınız? Metni nasıl gidip
   geliyordunuz?" *(Word/tracked-changes bağımlılığını ölçer —
   ürünün bilinen sınırı burası.)*

**Öğrenci**
7. "Kaç tez danışmanlığınız var? Bir teze ortalama ne kadar zaman
   ayırıyorsunuz?"
8. "Öğrenciye geri bildirimi nasıl veriyorsunuz — yazılı mı, sözlü mü?"

**Sınır ve kaygı**
9. "Yapay zekânın kesinlikle karışmasını istemediğiniz bir iş var mı?"
10. "Daha önce böyle bir araç denediniz mi? Neden bıraktınız?"

**Kapanış**
11. "Bu araç bir ay sonra hâlâ kullanıyor olsaydınız, hangi işi
    yapıyor olurdu?"

## Çıktı — ihtiyaç notu

`.divit/paylasim/ihtiyac-notu.md`:

```markdown
# İhtiyaç notu — <alan>, <tarih>
## Zaman yiyen işler
## Kullandığı araçlar (ve bırakamayacağı olanlar)
## Divit'in bugün karşıladıkları
## Divit'in karşılayamadıkları  ← geliştirici için en önemli bölüm
## Dile getirilen sınırlar ve kaygılar
## Bir cümlelik değerlendirme
```

"Karşılayamadıkları" bölümünü yumuşatma. Ürünün yol haritası bu
bölümden çıkıyor; kibar yazılırsa işe yaramaz.

## Gizlilik

Bu not hocanın klasöründe kalır. Geliştiriciye iletmeden önce
**hocaya göster ve izin al.** Öğrenci adı, kişisel bilgi varsa çıkar.
