# `yeni` kanalı — kurulum linkleri

Yeni sürüm main'e dokunmadan GitHub'daki `yeni` dalından dağıtılır.
Kurulu hoca bunu almaz; bu linkle kuran kullanıcı güncellemede `yeni`de
kalır. Yalıtılmış kurulum sınaması: `belgeler/sinama/yeni-kanal.md`.

## Kurulum komutları

Mac (Terminal):

```bash
# yazar
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/yeni/kur.sh | DIVIT_DAL=yeni DIVIT_TUR=yazar bash
# akademisyen
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/yeni/kur.sh | DIVIT_DAL=yeni bash
```

Windows (PowerShell) — **Windows'ta denenmedi**; `kur.ps1` `DIVIT_DAL`'ı
Mac'teki gibi okur (`if ($env:DIVIT_DAL) { $Dal = $env:DIVIT_DAL }`):

```powershell
# yazar
$env:DIVIT_DAL='yeni'; $env:DIVIT_TUR='yazar'; irm https://raw.githubusercontent.com/mehmetor/divit/yeni/kur.ps1 | iex
# akademisyen
$env:DIVIT_DAL='yeni'; irm https://raw.githubusercontent.com/mehmetor/divit/yeni/kur.ps1 | iex
```

**Bu bilgisayarda Divit başka kaynaktan kuruluysa** (ör. main'den ya da
`deneme`den) kurulum `HATA: Divit bu bilgisayarda başka bir kaynaktan
kurulu` der. Önce:

```bash
claude plugin marketplace remove divit
```

Bu komut o bilgisayar hesabındaki Divit'i `yeni`ye taşır; başka kanaldan
kurulu klasörler de artık `yeni`den güncellenir.

**Mac'te Claude Code eskiyse** (2.1.280 altı) kurulum önce günceller,
olmazsa resmî kurulumu yapar. Resmî kurulum npm ile genel kurulmuş
`claude`'u kaldırır (`npm uninstall --global @anthropic-ai/claude-code`);
geliştirme makinesinde `/opt/homebrew/bin/claude` bu yüzden gidebilir.

## Kurulu hoca neden almaz

Hoca main'deki pazar yerinden (`…/divit/main/.claude-plugin/marketplace.json`)
kendiliğinden güncellenir. `./yayinla.sh --kanal yeni` yalnız `yeni` dalına
yazar; main'deki `marketplace.json` ve `dagitim/` değişmez, hocanın
gördüğü sürüm aynı kalır.

## Hocayı geçirmek istediğinde

1. **main'e yayın:** develop → release-please PR'ı → birleşince yayın.
   Hoca kendiliğinden alır; iki eklentiye geçişte ne olacağı ve ne
   yapılacağı: [GECIS-IKI-EKLENTI.md](GECIS-IKI-EKLENTI.md).
2. **Yeni linkle yeniden kurulum:** hocanın makinesinde önce
   `claude plugin marketplace remove divit`, sonra yukarıdaki akademisyen
   komutu. Hoca bundan sonra `yeni`den güncellenir; main'e dönmesi için
   aşağıdaki adım gerekir.

## Kanal yapışkandır

Kurulum kanalı klasörde `.divit/kanal.txt`'ye yazar. `DIVIT_DAL`'sız
yeniden kurulum ve "güncelle" aynı kanalda kalır. `yeni` kullanıcısını
ileride main'e geçirmek için komutta açıkça `DIVIT_DAL=main` verilir:

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | DIVIT_DAL=main bash
```

## `yeni`'yi tazelemek

Güncel entegrasyon dalında, temiz çalışma ağacıyla:

```bash
./yayinla.sh --kanal yeni
```

Yalnız `yeni` dalına hızlı ileri bir commit ekler (zip'ler, iki adres).
GitHub ham adresleri ~5 dakika önbellekte kalır. `yeni` kullanıcısı yeni
sürümü "güncelle" ile ya da uygulamanın otomatik güncellemesiyle alır.

## Bilinen sınırlar

- Site (divit.simetri.app) ve `divit.simetri.app/kur.sh` yönlendirmesi
  main'den yayımlanır; main'e yayına kadar **eski** sürümü gösterir.
  `yeni` kullanıcısı yalnız yukarıdaki raw.githubusercontent.com adreslerini
  kullanır.
- Kurulumun son satırı `Deneme kanalı: yeni` der; kanal doğru, yalnız
  etiket "deneme" diyor.
