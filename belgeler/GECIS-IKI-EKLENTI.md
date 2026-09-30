# Kurulu hocada iki eklentiye geçiş

Akademik işler (tez-kontrol, sinav, yayin-oncesi, kaynak-dogrula,
bolum-yaz) ayrı `divit-akademik` eklentisine taşındı. Bugün kurulu olan
hocanın makinesinde yalnız `divit` var. Bu belge yayından sonra o
makinede ne olacağını, Mehmet'in ne yapacağını ve sorun çıkarsa ne
yapılacağını yazar.

Buradaki her davranış `araclar/sinama-guncelleme.sh` ile yalıtılmış
ortamda, gerçek güncelleme yoluyla (aynı adresteki pazar yeri + zip)
sınandı; son çıktı: `belgeler/sinama/guncelleme-sinamasi.md`. Sınanmayan
tek şey Claude masaüstü uygulamasının kendisi ve Windows (aşağıda).

## Yayından sonra hocanın makinesinde ne olur

Claude Code pazar yerine yeni eklenen bir eklentiyi **hiçbir zaman
kendiliğinden kurmaz.** Bu yüzden iki yol var:

**1. Güncelleme kendiliğinden gelir** (pazar yerinde otomatik güncelleme
açıksa — kurulum betiği bunu açmaz; klasördeki ayar dosyası ister,
uygulama klasöre güvenildiğinde işler. Mehmet'in makinesinde açık):

- Claude açıkken güncelleme inerse açık sohbet eski Divit'le sürer.
  Yeni sürüm Claude kapatılıp açılınca gelir.
- Yeni açılışta çekirdek `divit` yeni sürümdedir, `divit-akademik`
  **yoktur.** `/` menüsünde `divit:tez-kontrol` ve diğer akademik
  komutlar kaybolur, `divit-akademik:` henüz gelmemiştir.
- "merhaba" → Divit her zamanki gibi açılır (tür satırı olmadığı için
  akademisyen kurallarını yükler; sınandı).
- Tez, sınav, atıf gibi bir iş istenirse Divit işe girişmez, dosyayı
  yorumlamaz; hocaya "Bu iş için Divit'in kurulumunu bir kez yenilemek
  gerekiyor… Yenileyeyim mi?" der. Hoca "evet" derse `guncelleme`
  skill'i kurulum komutunu çalıştırır (ekranda İngilizce izin sorusu
  çıkarsa **Allow once**), sonra "Claude'u kapatıp açın" der. Hiçbir
  dosya değişmez (sınandı).
- Hoca "güncelle" ya da "yenilikler neler" derse Divit yenilikleri
  anlatır (ilk madde: komut adları değişti, kurulumu bir kez yenilemek
  gerekir) ve onay ister; onaysız çalıştırmaz (sınandı).

**2. Güncelleme gelmez** (otomatik güncelleme kapalıysa): hoca eski
sürümde, eski komut adlarıyla, eksiksiz çalışmaya devam eder; bozulan
bir şey yoktur. Eski `guncelleme` skill'i haftada bir yayındaki sürüm
notuna bakar ve yeni sürüm görünce kurulumu önerir. Mehmet kurulumu
yenileyince hoca doğrudan son hâle geçer (kurulum betiği pazar yerini
yeniler, `divit`'i günceller, `divit-akademik`'i kurar).

Her iki yolda da boşluğu kısa tutmak için: **yayından sonra, aynı gün
kurulumu yenile.**

## Adımlar — Mac

1. Claude uygulamasını kapat.
2. Terminal'i aç, kurulum komutunu **değişkensiz** çalıştır (tür
   satırı yok → akademisyen; hocanın dosyalarına dokunulmaz):

   ```bash
   curl -fsSL https://divit.simetri.app/kur.sh | bash
   ```

3. Çıktıda `Kullanıcı türü: akademisyen` ve `Kurulu ve güncel (sürüm
   …)` görünmeli; "Üniversite işleri eklentisi şimdi kurulamadı" uyarısı
   **çıkmamalı.** Çıkarsa yayın adresleri henüz önbellekte eskidir
   (GitHub ~5 dakika tutar); birkaç dakika sonra komutu yeniden çalıştır.
   Hocanın klasöründe kanal dosyası yoksa kurulum `main` kanalını kullanır
   ve `.divit/kanal.txt`'ye `main` yazar; çıktıda "Deneme kanalı" satırı
   **olmamalı.**
   `DIVIT_TUR` **verme**: hocanın profili dolu ve tür satırı yok
   (akademisyen sayılır); `DIVIT_TUR=yazar` verilirse kurulum hiçbir şeye
   dokunmadan durur ("başka bir kullanım türüyle kurulmuş bir Divit var").
4. Claude uygulamasını aç → Code sekmesi → Divit klasörü.

Hoca kendisi "evet" dediyse `guncelleme` skill'i aynı komutu çalıştırmış
olur; Mehmet'in ayrıca bir şey yapması gerekmez, yalnız aşağıdaki
kontrol yapılır.

## Adımlar — Windows

1. Claude uygulamasını kapat.
2. PowerShell'i aç (yönetici gerekmez), kurulum komutunu **değişkensiz**
   çalıştır:

   ```powershell
   irm https://divit.simetri.app/kur.ps1 | iex
   ```

3. Çıktıda Mac'teki 3. adımdaki satırlar görünmeli.
4. Claude uygulamasını aç → Code sekmesi → Divit klasörü.

## Kontrol — ne görülmeli (iki sistemde aynı)

- Kutuya `/` yaz, `divit-akademik` yaz: `tez-kontrol`, `sinav`,
  `yayin-oncesi`, `kaynak-dogrula`, `bolum-yaz` görünmeli. Komut adları
  artık `/divit-akademik:<ad>`; kılavuz (`KILAVUZ.html`) bu adlarla
  yenilendi. Kılavuz artık tek dosya; klasördeki eski `KART.html`
  silinmez ama güncellenmez de (eski komut adlarını taşır).
- `/divit:` altında `kitap-duzenle` ve `kitap-derle` de görünür; hoca
  kitap yazıyorsa kullanabilir, türü değişmez.
- Klasörde yeni dosya ya da klasör belirmemeli: `kitaplar/` ve
  `KILAVUZ-YAZAR.html` **yok**, `.divit/profil/kimlik.md`'ye tür satırı
  eklenmemiş.
- `.claude/settings.local.json`'da iki eklenti de `true`; hocanın daha
  önce "bir daha sorma" dediği izinler yerinde.
- "tez-kontrol/gelen'deki dosyayı değerlendir" → `divit-akademik:tez-kontrol`
  çalışır, rapor `tez-kontrol/rapor/` altına yazılır.

## Sorun çıkarsa

| Görülen | Yapılacak |
|---|---|
| Akademik komutlar yok, Divit "kurulumu yenilemek gerekiyor" diyor | Yukarıdaki kurulum adımı. Hoca "evet" diyerek de yapabilir. |
| Kurulum "Kurulum tamamlanmadı … başka bir kaynaktan kurulu" deyip bitti | `divit` pazar yeri o hesapta başka adresle kayıtlı. `claude plugin marketplace remove divit`, sonra kurulumu yeniden çalıştır. Klasöre dokunulmaz. |
| Kurulum "Kurulum yapılmadı … başka bir kullanım türüyle" deyip bitti | Komuta `DIVIT_TUR` yazılmış ve klasörün türüyle çelişiyor. Hocada `DIVIT_TUR`'suz çalıştır; ikinci kullanım için çıktıdaki `DIVIT_HEDEF` komutu. |
| Kurulum çıktısında "Üniversite işleri eklentisi şimdi kurulamadı" | 5 dakika bekleyip komutu yeniden çalıştır. Sürerse `claude plugin marketplace update divit` sonra komutu yeniden çalıştır. |
| Kurulumdan sonra da akademik komutlar yok | Claude'u **tamamen** kapatıp aç (açık sohbet eski eklentiyle sürer). Yine yoksa klasörde `.claude/settings.local.json`'da `"divit-akademik@divit": true` var mı bak. |
| "Klasör ayar dosyası okunamadı; dokunulmadı" uyarısı | Hocanın `settings.local.json`'u bozuk; betik ona dokunmadı. Dosyayı aç, `enabledPlugins` altına iki anahtarı elle yaz. |
| Divit "Bu model desteklenmiyor" gibi İngilizce bir hata veriyor | Claude uygulaması eski; uygulamayı güncelle (klasör ayarındaki model Claude Code 2.1.280 ve sonrasını ister; kurulum betiği komut satırını buna göre günceller, olmazsa uyarı basar). Geçişle ilgili değildir. |
| Bir dosya bozuldu | Kurulum hocanın dosyalarına dokunmaz (sınandı). Divit içinde "geri al" ya da `.divit/onceki-surumler/`. |

## Bilinen ayrıntılar

- Klasör `enabledPlugins` ile eklenti açtığı için Claude Code kurulu
  eklentiler listesine o klasör için ayrı bir kayıt (kapsam: local)
  yazar ve bu kayıt eski sürümde kalabilir. Sınamada yüklenen eklenti
  her zaman kullanıcı düzeyindeki yeni sürümdü; kayıt zararsız.
- Kurulum yenilenmeden önce klasördeki eski `CLAUDE.md`, eski
  `.claude/rules/taslak-yazim.md` ve eski `settings.json` yeni
  eklentiyle çelişmez: eski CLAUDE.md de `divit:kurallar`'ı yükler,
  eski ayarlar eklenti dosyalarını okumaya izin verir. Eski
  `tez-kontrol/CLAUDE.md` eski skill adını anar; güvenlik ağı bunu
  karşılar. Eski ayarlarda `kitaplar/` yasakları yoktur; akademisyende
  `kitaplar/` olmadığı için etkisizdir, kurulum yenilenince gelir.

Windows'ta `kur.ps1` bu işte sınanmadı; kur.sh ile satır satır
eşleştirildi (`belgeler/sinama/guncelleme-sinamasi.md` → E). Geçişi o
makinede ilk kez yaparken çıktıyı dikkatle oku.
