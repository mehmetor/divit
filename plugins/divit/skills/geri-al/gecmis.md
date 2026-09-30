# Ayrıntılı geçmiş (isteğe bağlı)

`geri-al`'ın eki. Önceki sürüm kuralının yerine geçmez, yanına eklenir: Divit
metin dosyasını değiştirmeden önce yine `.divit/onceki-surumler/`'e kopyalar.
Ayrıntılı geçmiş, kullanıcının "kaydet" dediği anların hepsini tutar; "dünkü
hâli", "geçen haftaki hâli" buradan gelir.

## Yasaklar

1. Kullanıcıya **git, depo, commit, sürüm denetimi** deme. Adı "ayrıntılı
   geçmiş", işlemi "kaydetmek", sonucu "kayıt" (tarih ve saatle).
2. Bilgisayarda araç yoksa (aşağıda "Var mı?") ayrıntılı geçmişi **hiç anma**,
   önerme, yerine yeni bir şey ("kaydet derseniz saklarım") vaat etme; bu
   dosyada kalan her şeyi atla. Kullanıcı kendisi sorduysa yalnız: "Bu
   bilgisayarda ayrıntılı geçmiş tutamıyorum. Değiştirdiğim her metin
   dosyasının önceki hâlini zaten saklıyorum."
3. Yalnız aşağıdaki komutlar, harfi harfine. `checkout`, `restore`, `reset`,
   `clean`, `push`, `remote`, `config`, `rm`, `add -A`, `add .`, `commit -a` yok.
   Kabuğa hiçbir zaman dosya yazdırma (`>` yok); eski hâli Write yazar.
4. `kitaplar/*/asil/`, `kitaplar/*/malzeme/`, `gelen/`, `gizli/`, `hakemlik/`
   altına hiçbir şey yazılmaz — eski hâl de. Oradaki dosyanın eski hâli
   `cikti/`ye ayrı dosya olarak çıkar (aşağıda "Word ve uzun dosya").
5. Kendiliğinden kaydetme. Kayıt yalnız kullanıcı istediğinde ("kaydet",
   "bu hâlini sakla") ve eski hâle dönmeden hemen önce yapılır.

Her komut tek başına, klasörün kökünde; `-C .` hep yazılır. Mac'te ve
Windows'ta komut aynıdır. Yollar `/` ile, köke göre.

## Var mı?

- Açık mı: `.git/HEAD` dosyasını Read ile oku. Varsa ayrıntılı geçmiş açıktır.
- Araç var mı (yalnız açık değilse ve kullanıcı istediyse ya da önereceksen):
  - Mac: önce `xcode-select -p`. Hata verirse araç yok; `git` komutunu hiç
    çalıştırma (Mac'te kurulum penceresi açar). Yol yazarsa `git --version`.
  - Windows: `git --version`. "tanınmıyor" türü hata → araç yok.

## Açma — kullanıcı açıkça isterse

Tek cümleyle anlat ve onay al: "Bu klasörde ayrıntılı geçmiş tutabilirim.
'Kaydet' dediğiniz her an saklanır; sonra 'dünkü hâline dön' diyebilirsiniz.
Yalnız bu bilgisayarda durur, hiçbir yere gönderilmez. Açayım mı?"

1. Kökte `.gitignore` yoksa Write ile aynen yaz (varsa dokunma):

   ```
   # Divit ayrıntılı geçmiş: bunlar geçmişe hiç girmez
   gizli/
   hakemlik/
   gelen/
   tez-kontrol/gelen/
   .divit/
   .claude/
   *.pdf
   *.zip
   *.jpg
   *.jpeg
   *.png
   *.heic
   *.webp
   *.mp4
   *.mov
   ```

   PDF ve fotoğraflar hiç yerinde değişmez ve büyüktür; geçmişe girmez.
2. `git -C . init`
3. İlk kaydı yap (aşağıda "Kaydetme"), iletiye `ilk kayıt`.
4. `.divit/gunluk.md`'ye: `… · geri-al · ayrıntılı geçmiş · açıldı`.
5. Kullanıcıya: "Ayrıntılı geçmiş açıldı. İstediğiniz an 'kaydet' deyin."

## Kaydetme

1. Kökteki çalışma klasörlerini Glob ile bul (`yazilar`, `kitaplar`,
   `tez-kontrol`, `kaynaklar`, `cikti`, `notlar`, `arsiv` ve kullanıcının
   açtığı diğerleri; `gizli`, `hakemlik`, `.divit`, `.claude` hariç). Kökteki
   `.md`, `.txt`, `.bib`, `.docx` dosyalarını da ekle.
2. Hepsini adıyla, tırnak içinde, `--` ardından:
   `git -C . add -- ".gitignore" "kitaplar" "yazilar" "notlar.md"`
3. `git -C . -c user.name=Divit -c user.email=divit@yerel commit -m "<ileti>"`
   İleti: kullanıcının sözü ya da "kaydet", kişi adı ve öğrenci adı olmadan.
   "nothing to commit" türü cevap → "Son kayıttan beri değişen bir şey yok."
4. "Kaydettim (1 Ekim, 14:30)." Günlüğe tek satır.

## Geçmişe bakma

Dosya belliyse:
`git -C . -c core.quotepath=false log -n 15 --date=iso --pretty=tformat:%h%x09%ad%x09%s -- "<yol>"`
Belli değilse aynı komut `--name-only` ile ve yol olmadan. Satırın başındaki
kısa kimliği kullanıcıya gösterme; "1 Ekim 14:30 — kaydet" gibi tarihle listele.

## Eski hâline dönme ("dünkü hâline dön")

1. Dosyayı ve anı netleştir. "Dünkü hâl" = bugünden önceki son kayıt:
   `git -C . -c core.quotepath=false log -n 1 --before=<bugün YYYY-AA-GG>T00:00 --date=iso --pretty=tformat:%h%x09%ad%x09%s -- "<yol>"`
   Kayıt yoksa dürüst ol: "O güne ait kaydım yok; ilk kayıt <tarih>."
2. Tarihi ve ne değişeceğini söyle, onay al.
3. Boyuta bak: `git -C . cat-file -s "<kimlik>:<yol>"` (bayt).
4. **Metin dosyası** (md, txt, bib), 20000 baytın altında, yasak klasörde değil:
   - Şimdiki hâli Read + Write ile `.divit/onceki-surumler/<YYYY-AA-GG_SSDD>/<aynı yol>`
     altına kopyala (önceki sürüm kuralı).
   - Eski hâli oku: `git -C . show "<kimlik>:<yol>"`
   - Çıktıyı Write ile özgün yola aynen yaz; metin tek bir satır sonuyla
     biter (kayıttaki gibi). Çıktı kısaltılmış görünüyorsa
     (kesik, "truncated", "saved to") yazma; 5. adıma geç.
   - Denetim: dosyayı Read ile oku, çıktıyla karşılaştır. `diff`, `status`
     gibi ek komut yok; satır sonu için ayrıca uyarı yazma.
5. **Word, uzun metin ya da yasak klasördeki dosya:** yerinde değiştirme.
   `git -C . archive --format=zip -o "cikti/<ad>-onceki-<kayıt tarihi YYYY-AA-GG>.zip" <kimlik> -- "<yol>"`
   Kullanıcıya: "Dosyanın <tarih> hâlini `<tam yol>` içine koydum; çift
   tıklayınca açılır. Şimdiki dosyanız olduğu gibi duruyor."
6. Tek cümleyle bitir, günlüğe yaz: `… · geri-al · <dosya> · <tarih> hâline döndü`.

## Kullanıcıya ne zaman önerilir

Yalnız araç varsa ve ayrıntılı geçmiş kapalıysa, tek kez:
- Kullanıcı "dünkü", "geçen haftaki hâli" istedi ama önceki sürümlerde yok.
- Kullanıcı "her şeyin geçmişini tut", "sürüm geçmişi", "kaydet" dedi.
Reddederse bu oturumda bir daha önerme.

Belgeler klasörü OneDrive ya da iCloud ile eşitleniyorsa açmadan önce bir kez
söyle: "Klasörünüz buluta eşitleniyor; ayrıntılı geçmiş de eşitlenir, biraz
yer kaplar." Onay yine kullanıcının.
