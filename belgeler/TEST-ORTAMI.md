# Test ortamı — Mehmet'in Mac'i deneme kanalında

Mehmet bu Mac'te Divit'i hocanın ve yazarın yaptığı **normal kurulumla**
kurar, iki kurgusal kişinin yerine geçip dener ve her yeni sürümü
**main'e yayından önce** "güncelle" diyerek alır. İş: DVT-59.

Bu belge iki şeyi anlatır: bir kerelik sıfırdan kurulum (0–6) ve her
yeni sürümde tekrarlanan döngü (7–8). Kanalın ayrıntısı
`belgeler/DENEME-KANALI.md`'de.

`[Mehmet elle]` işaretli adımlar ekran işidir ya da gerçek dosya siler;
ajan bunları çalıştırmaz. Geri kalan Terminal komutları yalıtılmış bir
ortamda (geçici `HOME`, `DIVIT_TEST=1`, `DIVIT_KAYNAK_ZIP`) denendi;
denenmeyenler yanında yazıyor.

## Neden kendi hesabın, neden deneme kanalı

- **Kendi hesabın.** Mehmet her gün açtığı Claude'da, kendi
  Belgeler'inde dener; ayrı oturum açmak gerekmez, güncelleme gerçek
  kullanımın içinde gelir. Bedeli: `divit` pazar yeri kullanıcı
  düzeyindedir, bir hesapta tek kanal olur. Bu hesaptaki **bütün**
  Divit klasörleri deneme kanalından güncellenir; main'deki hâli bu
  hesapta görmek için 9. adım gerekir.
- **Seçenek: ayrı macOS kullanıcısı** (`DENEME-KANALI.md` §1). Hocanın
  yeni bilgisayarı gibi tertemizdir, Mehmet'in kendi hesabına hiç
  dokunmaz. Her denemede oturum değiştirmek gerektiği için günlük test
  ortamı olarak bu belgedeki yol seçildi; tek seferlik "boş
  bilgisayarda kurulum" denemesi için o yol daha iyidir.
- **Deneme kanalı.** "Mehmet denemeden yayına alma" kuralı: yeni sürüm
  önce `deneme` dalına gider, Mehmet alır, onay verince main'e çıkar.
  main'e yayın yapılmadan güncelleme denenebilir.
- **Başlangıç 1.8.0.** Güncellemeyi gerçekten denemek için kurulum
  bugünkü yayındaki sürümle (main'deki 1.8.0) yapılır; 1.8.1 sonra
  üstüne gelir. Bu yüzden deneme dalı önce main'in aynısına getirilir
  (2. adım).

### Kural: `deneme` dalı bu Mac'indir

Bu düzenden sonra `deneme` dalına yapılan her yayın Mehmet'in günlük
Divit'ine iner. Ajanlar ve yan denemeler `deneme-<iş>` adını kullanır
(`./yayinla.sh --kanal deneme-<iş>`) ve yalıtılmış ortamda kurar;
`deneme` dalına yalnız Mehmet'e denetilecek aday sürüm gönderilir.

## 0. Önce yedek

1. `[Mehmet elle]` Claude uygulamasını tamamen kapatın (⌘Q). 1–4. adımlar
   bitene kadar açmayın: eski klasörlerden biri açılırsa klasör ayarı
   `divit` pazar yerini main'den yeniden ekleyebilir.
2. Terminal'de iki klasörü ve Claude'un bu klasörler için tuttuğu
   geçmişi (sohbetler ve hafıza notları) masaüstüne zipleyin:

   ```bash
   cd ~
   G=$(date +%Y-%m-%d)
   ditto -c -k --keepParent ~/Documents/Divit       ~/Desktop/yedek-$G-Divit.zip
   ditto -c -k --keepParent ~/Documents/Divit-Yazar ~/Desktop/yedek-$G-Divit-Yazar.zip
   ditto -c -k --keepParent ~/.claude/projects/-Users-minihome-Documents-Divit       ~/Desktop/yedek-$G-claude-Divit.zip
   ditto -c -k --keepParent ~/.claude/projects/-Users-minihome-Documents-Divit-Yazar ~/Desktop/yedek-$G-claude-Divit-Yazar.zip
   ls -lh ~/Desktop/yedek-$G-*.zip
   ```

   **Beklenen:** dört zip, hiçbiri 0 bayt değil. `Operation not
   permitted` derse: Sistem Ayarları → Gizlilik ve Güvenlik → Dosyalar
   ve Klasörler → Terminal → Belgeler'i açın, komutu yeniden çalıştırın.
   Bir zip'in içine bakmak için: `unzip -l ~/Desktop/yedek-$G-Divit.zip | tail -3`.

## 1. Pazar yeri kaydını kaldır

```bash
cd ~ && claude plugin marketplace remove divit
cd ~ && claude plugin marketplace list
```

**Beklenen:** `Successfully removed marketplace: divit`, ardından
`Also uninstalled 2 plugins … divit@divit, divit-akademik@divit`.
`marketplace list`'te `divit` yok; öteki pazar yerleri yerinde.

- **Kalkar:** `divit` pazar yeri kaydı (main adresi), iki Divit
  eklentisi ve onların saklanan verisi.
- **Kalır:** Belgeler'deki iki klasör, `~/.divit/araclar` (Word ve PDF
  araçları; yeniden indirilmez), masaüstündeki `Divit` kısayolu, öteki
  eklentiler.

Neden şart: kayıt main'e bağlıyken deneme kurulumu `HATA: Divit bu
bilgisayarda başka bir kaynaktan kurulu` deyip 1 koduyla biter ("Kurulum
tamamlanmadı"). Yalıtılmış ortamda denendi.

## 2. Deneme dalını 1.8.0'a getir

Yönetici ya da ajan yapar (Mehmet de çalıştırabilir). Geliştirme
klasöründe, main'in tam hâlinden geçici bir çalışma kopyası açılır,
yayın oradan yapılır; develop'a ve main'e hiçbir şey yazılmaz.

```bash
cd ~/Simetri/Develop/divit
git fetch origin
git worktree add --detach /tmp/divit-1.8.0 origin/main
(cd /tmp/divit-1.8.0 && ./yayinla.sh --kanal deneme)
git worktree remove --force /tmp/divit-1.8.0
```

**Beklenen:** `Gönderildi: deneme → <commit> (kaynak edea956… (HEAD))`,
`divit sürümü 70921676b383`, `divit-akademik sürümü 8767801395af` —
main'deki 1.8.0'ın sürümleriyle aynı (zip belirleyici; main'de
`./yayinla.sh` denemesiyle doğrulandı, ikisi de "değişiklik yok").

~5 dakika sonra (GitHub önbelleği):

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/.claude-plugin/marketplace.json | grep '"url"'
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/plugins/divit/SURUM.md | grep -m1 '^## '
```

**Beklenen:** `…/deneme/dagitim/divit-70921676b383.zip` ve
`…/deneme/dagitim/divit-akademik-8767801395af.zip`; başlık
`## 1.8.0 · 2026-10-08 · kurulum gerekir`. Başka bir sürüm görünürse
biri araya deneme yayını yapmıştır: bu adımı yineleyin.

## 3. Eski klasörleri sil

`[Mehmet elle]` — 0. adımdaki zip'leri gördükten sonra:

```bash
rm -rf ~/Documents/Divit ~/Documents/Divit-Yazar
rm -rf ~/.claude/projects/-Users-minihome-Documents-Divit ~/.claude/projects/-Users-minihome-Documents-Divit-Yazar
ls ~/Documents | grep -i divit
```

**Beklenen:** son komut hiçbir şey yazmaz. İkinci satır şart: Claude
hafıza notlarını klasörün yoluna göre tutar; silinmezse yeni klasör
eski Divit'in notlarını "hatırlar" ve kurulum sıfırdan olmaz.
`~/.divit` ve masaüstündeki `Divit` kısayolu kalır (kısayol 4. adımdan
sonra yine doğru klasörü gösterir).

## 4. İki kurulum

Akademisyen (ziraat profesörü), varsayılan klasör:

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.sh | DIVIT_DAL=deneme DIVIT_TUR=akademisyen bash
```

**Beklenen:** 6 adım; `Kullanıcı türü: akademisyen`, `Kanal: deneme`,
`Oluşturuldu: /Users/minihome/Documents/Divit`, `Kurulu ve güncel
(sürüm 70921676b383)`, "Kurulum bitti.", 3. maddede `Belgeler → Divit`,
en sonda `Güncellemeler şu dağıtımdan gelir: deneme`. "Üniversite işleri
eklentisi şimdi kurulamadı" **çıkmamalı**. Kılavuz tarayıcıda açılır.

Yazar (kalite yazarı), ayrı klasör:

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.sh | DIVIT_DAL=deneme DIVIT_TUR=yazar DIVIT_HEDEF="$HOME/Documents/Divit-Yazar" bash
```

**Beklenen:** `Kullanıcı türü: yazar`, `Kanal: deneme`, `Oluşturuldu:
/Users/minihome/Documents/Divit-Yazar`, `Kurulu ve güncel (sürüm
70921676b383)`, `Belgeler → Divit-Yazar`. Kılavuz yazar sekmesinde açılır.

Denetim:

```bash
cd ~ && claude plugin marketplace list | grep -A1 '❯ divit'
cd ~ && claude plugin list | grep -A2 '@divit'
for K in Divit Divit-Yazar; do echo "$K: $(cat ~/Documents/$K/.divit/kanal.txt) $(cat ~/Documents/$K/.divit/kurulum-surumu.txt)"; done
```

**Beklenen:** pazar yeri `…/mehmetor/divit/deneme/.claude-plugin/marketplace.json`;
`divit@divit` `Version: 70921676b383`, `divit-akademik@divit`
`Version: 8767801395af`; `Divit: deneme 1.8.0`, `Divit-Yazar: deneme 1.8.0`.

Kanal yalnız burada verilir. Bundan sonra bu klasörlerde çalışan her
kurulum (Divit'in "güncelle"si dahil) `.divit/kanal.txt`'den `deneme`yi
okur.

Yalıtılmış sınamada (1.8.0'ın `kur.sh`'i, `DIVIT_TEST=1`) iki klasör de
böyle çıktı: akademisyende `tez-kontrol/` ve `gizli/`, yazarda
`kitaplar/`; `settings.local.json`'da `divit-akademik@divit` sırasıyla
`true` / `false`; klasör ayarındaki pazar yeri adresi `/deneme/`.
Eklenti adımı da ayrı bir `CLAUDE_CONFIG_DIR` ile denendi ("Kurulu ve
güncel"); sürüm o an deneme dalında ne varsa odur.

## 5. Kişilerin dosyaları

Malzeme geliştirme klasöründe:
`belgeler/personalar/ziraat-profesoru/` ve `belgeler/personalar/kalite-yazari/`.
Her paketin `README.md`'si "Klasöre yerleşim" tablosunu verir; burada
yalnız komutları var. Önce develop'u güncelleyin, paketler orada olmalı:

```bash
cd ~/Simetri/Develop/divit && git switch develop && git pull
P=~/Simetri/Develop/divit/belgeler/personalar
ls $P
```

**Beklenen:** `kalite-yazari  ziraat-profesoru`. Yoksa paketler henüz
develop'a alınmamıştır (dalları: `orc/yonetici-plane-kullan-m-na/persona-ziraat`,
`…/persona-yazar`).

`.md` kaynakları, `README.md`, `senaryolar.md` ve `beklenen-bulgular.md`
hiçbir klasöre **kopyalanmaz**: Divit cevabı önceden görmemeli.

**Kurulum sohbetinden önce** — kişinin "masaüstü". Buradakiler sohbet
penceresine sürüklenir, Divit klasörüne kopyalanmaz:

```bash
P=~/Simetri/Develop/divit/belgeler/personalar
mkdir -p ~/Desktop/Bozdoganli ~/Desktop/kamil-bey/malzeme
cp $P/ziraat-profesoru/ozgecmis.docx $P/ziraat-profesoru/yazilar/*.docx \
   $P/ziraat-profesoru/ders/akademik-takvim-2026-2027-guz.pdf \
   $P/ziraat-profesoru/diger/hakemlik/YTD-2026-0412-hakem-dosyasi.docx ~/Desktop/Bozdoganli/
cp $P/kalite-yazari/ozgecmis.docx $P/kalite-yazari/basilmis-kitap/catlak-parca-bolum-3-4.docx ~/Desktop/kamil-bey/
cp $P/kalite-yazari/malzeme/*.docx ~/Desktop/kamil-bey/malzeme/
ls ~/Desktop/Bozdoganli ~/Desktop/kamil-bey ~/Desktop/kamil-bey/malzeme
```

**Beklenen:** `Bozdoganli/` içinde 5 dosya (özgeçmiş, iki makale,
takvim PDF'i, hakem dosyası); `kamil-bey/` içinde özgeçmiş, kitap
Word'ü ve `malzeme/` altında 7 `.docx`.

**Ziraat profesörü, kurulum sohbetinden sonra** (6. adım bitince; hoca
bunları e-postadan alıp klasöre koymuş gibi). Yazarda bu adım **yok**:
kitap ve malzeme sohbete sürüklenir, `kitaplar/` altına Divit kendisi
koyar (`kalite-yazari/README.md` → "Klasöre yerleşim").

```bash
P=~/Simetri/Develop/divit/belgeler/personalar/ziraat-profesoru
D=~/Documents/Divit
mkdir -p $D/yazilar/gec-azot $D/tez-kontrol/gelen/MG $D/yazilar/dersler/TBB302
cp $P/yazilar/Bozdoganli-Kusdemir-2026-gec-azot-TASLAK.docx $D/yazilar/gec-azot/
cp $P/tez-kontrol/gelen/MG/Gokdere_tez_bolum3-4_v2.docx $D/tez-kontrol/gelen/MG/
cp $P/kaynaklar/*.pdf $P/kaynaklar/kaynaklar.bib $D/kaynaklar/
cp $P/ders/TBB302-hafta5-bugdayda-gubreleme.docx $D/yazilar/dersler/TBB302/
cp $P/diger/gizli/ogrenci-gorusme-notu-OY.md $D/gizli/
```

**Beklenen:** hata yok. Divit kurulum sohbetinde başka klasör adları
önerdiyse (ör. `tez-kontrol/gelen/MG/` yerine başka bir şey) onun
adını kullanın. Hakem dosyası senaryo 19'da, o adımda elle konur:
`mkdir -p $D/hakemlik && cp ~/Desktop/Bozdoganli/YTD-2026-0412-hakem-dosyasi.docx $D/hakemlik/`
(`hakemlik/` şablonda yoktur, izin kuralı vardır).

Yollar yalıtılmış ortamda iki paketin gerçek dosyalarıyla denendi.

## 6. Claude'da kurulum sohbeti

1. `[Mehmet elle]` Claude uygulamasını açın → **Code** → **Local** →
   **Select folder** → Belgeler → Divit. Klasöre güvenin.
   **Beklenen:** izin sorusu yok. `/` yazıp `divit` diye süzünce
   `divit-akademik:tez-kontrol`, `…:sinav`, `…:yayin-oncesi`,
   `…:kaynak-dogrula`, `…:bolum-yaz` ve `divit:` komutları.
2. `[Mehmet elle]` Hikmet Bey olarak yazın ve
   `ziraat-profesoru/senaryolar.md` 1–6'yı izleyin (ilk mesaj: "Merhaba.
   Mehmet Bey bu programı kurdu…"; özgeçmiş ve iki makale
   `Masaüstü/Bozdoganli/`'dan sürüklenir).
   **Beklenen:** `kurulum` akademisyen olarak başlar, özgeçmiş ister;
   jüri/komisyon uyarısı gelir; makaleler internette bulunamaz ve
   uydurulmaz. Ayrıntı senaryolarda.
3. `[Mehmet elle]` Yeni pencere (ya da sohbeti kapatıp) → Belgeler →
   Divit-Yazar. `/` → `divit` diye süzün.
   **Beklenen:** `divit:kitap-duzenle`, `divit:kitap-derle` …;
   `divit-akademik:` ile başlayan **hiçbir şey yok**.
4. `[Mehmet elle]` Kâmil Bey olarak `kalite-yazari/senaryolar.md` 1.3–1.9
   (ilk mesaj: "Başlayalım."; özgeçmiş ve kitap Word'ü
   `Masaüstü/kamil-bey/`'den sürüklenir).
   **Beklenen:** yazar yolu; "hoca, makale, akademik" geçmez; kitap
   Word'ü `kitaplar/<kitap>/asil/` altına Divit'in kendisi koyar.
5. Ziraat klasörü için 5. adımın "kurulum sohbetinden sonra" kısmını
   şimdi çalıştırın.

İki kurulum sohbeti bitmeden 7. adıma geçmeyin: güncelleme dolu bir
profilin üstüne gelmeli, hocadaki gibi.

## 7. Yeni sürümü yayından önce al (her sürümde)

İlk kez: 1.8.0 → 1.8.1. Sonraki her develop işinde aynı döngü, yalnız
sürüm numarası değişir.

**7.1 Aday sürümü deneme dalına gönder** (yönetici ya da ajan). Sürüm
numarası release-please'in açık PR'ının başlığındaki numaradır
("divit 1.8.1 yayını"). develop'taki `SURUM.md`'nin en üstünde
`## Sıradaki` yazar; Divit'in "güncelle"si sürümleri **sayı** olarak
karşılaştırır, "Sıradaki"yi okuyamaz. Bu yüzden geçici kopyada başlık,
yayında CI'nin yapacağı gibi numarayla değiştirilir; bu commit yalnız
deneme dalına gider, develop'a girmez:

```bash
cd ~/Simetri/Develop/divit
git fetch origin
S=1.8.1
git worktree add --detach /tmp/divit-aday origin/develop
cd /tmp/divit-aday
python3 - "$S" "$(TZ=Europe/Istanbul date +%Y-%m-%d)" <<'PY'
import re, sys
surum, tarih = sys.argv[1:]
p = "plugins/divit/SURUM.md"
s = open(p, encoding="utf-8").read()
s, n = re.subn(r"^## Sıradaki", f"## {surum} · {tarih}", s, count=1, flags=re.M)
if n != 1: sys.exit("HATA: '## Sıradaki' yok")
open(p, "w", encoding="utf-8").write(s)
PY
git commit -qam "chore: deneme için $S başlığı (develop'a girmez)"
./yayinla.sh --kanal deneme
cd ~/Simetri/Develop/divit && git worktree remove --force /tmp/divit-aday
```

**Beklenen:** `Gönderildi: deneme → …`, iki yeni sürüm (bugünkü
develop'la denendi: `divit 5519f81a712d`, `divit-akademik
75b696d003a9`; develop değiştiyse başka olur, numaraları not edin).
Başlık `kurulum gerekir` taşımıyorsa Divit kurulum önermez; taşıyorsa
CI'deki gibi başlıkta kalır. Aynı gün yayınlanırsa main'deki zip de
aynı özeti alır.

**7.2 Önbelleği bekle** (~5 dakika):

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/plugins/divit/SURUM.md | grep -m1 '^## '
```

**Beklenen:** `## 1.8.1 · <tarih>`.

**7.3 `[Mehmet elle]` Kişinin klasöründe güncelle.** Claude'u tamamen
kapatıp açın, Divit klasörünü açın. Ya kısaca `güncelle` yazın ya da
hocaya gönderilecek istemi (`GECIS-IKI-EKLENTI.md` → "Hoca kendisi
yaparsa", "Yapıştırılacak metin" kısmı) yapıştırın; istemdeki
`1.8.0`'ı denenen sürümle (`1.8.1`) değiştirin, yoksa önbellek eskiyse
1.8.0'ı yeniden kurar. İki yol olabilir; ikisi de doğru:

- **Divit kendiliğinden inmediyse:** Divit yayındaki sürümü 1.8.1 bulur,
  "kısa bir güncelleme gerekiyor… Şimdi yapayım mı?" der. "evet" →
  İngilizce izin sorusunda **Allow once** → kurulum `DIVIT_DAL=deneme`
  ile çalışır → "Güncelleme tamam… Claude'u kapatıp açın".
  **Beklenen:** komutta `/deneme/kur.sh` ve `DIVIT_DAL=deneme` (main
  değil); "önceki hâli saklandı" ve "şimdi kurulamadı" satırları yok.
- **Divit kendiliğinden indiyse** (klasör ayarında otomatik güncelleme
  açık; uygulama açılışında gelir): Divit kurulum **önermez** (1.8.1
  başlığında "kurulum gerekir" yok), yenilikleri anlatır.

Claude'u kapatıp açtıktan sonra `yenilikler neler`.
**Beklenen:** 1.8.1'in notları (en çok dört madde; yazar klasöründe
akademik madde yok), kurulum önerisi yok. Terminal'de:

```bash
cd ~ && claude plugin list | grep -A2 '@divit'
for K in Divit Divit-Yazar; do echo "$K: $(cat ~/Documents/$K/.divit/kanal.txt) $(cat ~/Documents/$K/.divit/kurulum-surumu.txt)"; done
```

**Beklenen:** `Version` 7.1'deki yeni numaralar; kanal iki klasörde de
`deneme`; kurulum sürümü güncellemeyi Divit'in kurduğu klasörde
`1.8.1`, kurulumsuz gelen klasörde `1.8.0` (doğru: kurulum gerekmedi).
Kişinin dosyaları değişmemiş olmalı.

Yalıtılmış sınamada 1.8.1 adayının `kur.sh`'i iki dolu klasörün
üstünde `DIVIT_DAL`'sız çalıştırıldı: kanal `deneme` kaldı, "Klasör
zaten var. Kişisel dosyalara dokunmadan…", `kurulum-surumu` `1.8.1`.
Claude uygulamasının içindeki güncelleme denenmedi; asıl denenecek o.

**7.4 Onay.** Mehmet sürümü beğenirse release-please PR'ı birleştirilir,
CI main'e yayınlar. Mehmet'in Mac'i zaten bu sürümdedir; bir sonraki
aday yine 7.1'den gelir. Beğenmezse düzeltme develop'a gider, 7.1
yinelenir; main'e bir şey gitmez.

## 8. Senaryolar ve bulgular

- Ziraat profesörü: `belgeler/personalar/ziraat-profesoru/senaryolar.md`
  (7. senaryodan sonrası; beklenenler `beklenen-bulgular.md`).
- Kalite yazarı: `belgeler/personalar/kalite-yazari/senaryolar.md`
  (2. bölümden sonrası; `beklenen-bulgular.md`).

Uymayan her şey Plane'de **DVT** projesine yeni iş olarak yazılır,
`mehmet` etiketiyle. Başlıkta sürüm, kişi ve senaryo:
`1.8.1 · ziraat · 7: çizelge farkını bulmadı`. Gövdede ne yazıldı, ne
bekleniyordu, ne oldu; varsa ekran görüntüsü. Divit'in klasördeki
`.divit/sorunlar.md`'sine yazmayın (Divit okur, sonucu bozar).
Hassas not (gerçek hoca adı, ücret, strateji) Plane'e yazılabilir,
repoya yazılmaz.

## 9. main'e geri dönmek

Bu hesapta yayındaki hâli görmek gerekirse (ör. bir hocanın sorununu
birebir yaşamak):

```bash
cd ~ && claude plugin marketplace remove divit
curl -fsSL https://divit.simetri.app/kur.sh | DIVIT_DAL=main DIVIT_TUR=akademisyen bash
curl -fsSL https://divit.simetri.app/kur.sh | DIVIT_DAL=main DIVIT_TUR=yazar DIVIT_HEDEF="$HOME/Documents/Divit-Yazar" bash
```

**Beklenen:** çıktıda `Kanal:` satırı ve "Güncellemeler şu dağıtımdan
gelir" satırı **yok**; `Kurulu ve güncel (sürüm <main'deki sürüm>)`;
`kanal.txt` iki klasörde `main`. Klasördeki dosyalara dokunulmaz.
`DIVIT_DAL=main` açıkça yazılır: yazılmazsa klasörün `kanal.txt`'si
`deneme`de tutar. Önce `marketplace remove` şart (1. adımın tersi).
Deneme kanalına dönmek için 1. ve 4. adımdaki komutlar, klasör
silinmeden (`DIVIT_DAL=deneme` ile).
