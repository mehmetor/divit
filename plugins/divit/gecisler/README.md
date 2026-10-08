# Geçiş notları

Sürüme özel, **bir kez** yapılacak işler: kurulumun kendisi yapamayan,
hocanın kararını isteyen adımlar (ör. eski bir anlatıma güvenip bir yere
konmuş dosyalar). Klasör ayarı, kılavuz ya da araç değiştiyse bu geçiş
değildir; `SURUM.md` başlığına `· kurulum gerekir` yazılır.

Geçiş gerekmiyorsa dosya yazılmaz; boş geçiş dosyası bırakma.

## Divit nasıl uygular

`bakim` → "Hatırlatma denetimi"nin ilk adımı (hocanın oturumdaki ilk işi
bittikten sonra; oturumda en çok bir hatırlatma, geçiş önce gelir):

1. Başlangıç: `.divit/hatirlatma.md` → `son-gecis`; yoksa
   `.divit/kurulum-surumu.txt`; o da yoksa 0. Kurulum betikleri var olan
   bir klasörü yeni sürüme geçirirken eski kurulum sürümünü `son-gecis`
   olarak bir kez yazar; böylece kurulum geçişten önce çalışsa da geçiş
   kaybolmaz. Yeni klasörde geçiş yoktur.
2. Bu klasördeki `<sürüm>.md` dosyalarından başlangıçtan büyük, yüklü
   sürümden (`SURUM.md` ilk başlığı) büyük olmayanlar sayı sırasıyla okunur
   (1.10 > 1.9).
3. Türe uymayan madde atlanır. Kalan her maddenin sorusu aynen, tek tek
   sorulur; adımlar yalnız "evet"te uygulanır.
4. Her dosyadan sonra `son-gecis` o sürüme ilerletilir (Edit), soru
   sorulduysa `gunluk.md`'ye `… · geçiş · <sürüm> · …` satırı yazılır.
   Cevap "hayır" da olsa bir daha sorulmaz.

## Dosya adı

`<sürüm>.md`, yalnız sayı: `1.9.0.md`. Geliştirirken sıradaki sürümün
numarası yazılır (release-please'in açık "divit X yayını" PR'ı). Yayından
önce numarayı o PR'la karşılaştır; değiştiyse dosyanın adını da değiştir.

## Biçim

```
# <sürüm> geçişi

## <madde adı>
Kimin için: herkes | akademisyen | yazar
Neden: <geliştirici için tek cümle; hocaya okunmaz>
Soru:
> "<hocaya aynen sorulacak cümle>"
Evet:
1. <adım; komut varsa Mac ve Windows yan yana>
2. <hocaya söylenecek kapanış cümlesi>
Hayır: <hocaya söylenecek tek cümle; başka iş yok>
```

## Kurallar

- Her maddede tek soru; **onaysız iş yok.** Hiçbir şey silinmez.
- Soru ve cümleler sade Türkçe, teknik terim yok (bkz. `CLAUDE.md`).
- Adımlar `kurallar` skill'ine uyar: dosya işi Read, Write, Edit; kabuk
  yalnız orada izinli işler için, her komut tek başına.
- Adım `.claude/` altına yazmaz; klasör ayarı kurulumun işidir.
- `gizli/`, `gelen/`, `hakemlik/` ve `kitaplar/*/asil|malzeme` okunmaz,
  değiştirilmez; hocanın dosyasını Divit taşımaz, klasörü açar.
- Ölçülebilir olsun: ne yapıldığı günlük satırından okunabilmeli.
