# Kurulum sınaması

Soru: `kur.sh` Mehmet'in Claude masaüstü denemesinde görülen durumlarda
doğru davranıyor mu? (tür/profil çelişkisi, sessiz başarısızlık, sürüm
alt sınırı, klasör adı, tek kılavuz, kitap klasörü izinleri, kanal)

**Sonuç (2026-09-30):** 41 ölçüm GEÇTİ, KALDI yok. Tek ATLANDI (vii4):
kılavuz şablonunda `data-rol=""` henüz yok (kılavuz parçası bu dala
birleşmedi); betik bu durumda kopyanın şablonla birebir olduğunu denetler
(vii5 GEÇTİ). data-rol yolu elle ayrıca denendi: şablona
`<html lang="tr" data-rol="">` konmuş bir zip'le `DIVIT_TUR=yazar` →
`data-rol="yazar"`, `DIVIT_TUR=akademisyen` → `data-rol="akademisyen"`.
Birleşik dalda betik bunu vii4'te kendisi ölçer.

## Nasıl çalıştırılır

```bash
araclar/sinama-kurulum.sh            # --sakla: geçici klasör silinmez
```

- Çalışma ağacından zip yapar (`git stash create`: stash yığınına
  dokunmaz), kur.sh'yi `DIVIT_TEST=1`, `DIVIT_KAYNAK_ZIP`, geçici HOME,
  geçici `DIVIT_HEDEF` ve geçici `CLAUDE_CONFIG_DIR` ile çalıştırır.
- Eklenti adımı gerçek pazar yerinden iner (main ve deneme dalları):
  internet gerekir. origin'e push **yoktur**.
- Araçlar (pandoc, pdfcpu) bu makinedeki `~/.divit/araclar`'dan geçici
  eve kopyalanır; indirilmez.
- x) PATH'in başına sahte `claude` (sürüm 2.1.100 der, çağrıları yazar)
  ve sahte `curl` (claude.ai/install isteğini yazar ve reddeder, gerisini
  gerçek curl'e verir) konur.
- Sonda gerçek `~/.claude`'un üç dosyasının özeti, `/opt/homebrew/bin/claude`
  sürümü ve `~/Documents` klasör kaydı önce/sonra karşılaştırılır.

## Son çalıştırmanın çıktısı

```

== Hazırlık
claude: /opt/homebrew/bin/claude 2.1.278 (Claude Code)
Geçici dizin: /tmp/divit-kurulum.XXXXXX
Kaynak: 37558f0396d0

== i) Boş klasöre akademisyen
  kur.sh:   UYARI: Claude Code 2.1.278 eski (en az 2.1.280 gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir.
  kur.sh:   Kullanıcı türü: akademisyen
  kur.sh:   Kurulu ve güncel (sürüm 658769f6be47).
  kur.sh:   UYARI: Üniversite işleri eklentisi (divit-akademik) şimdi kurulamadı; kurulumu sonra yeniden çalıştırın.
GEÇTİ i1    çıkış 0, 'Kurulum bitti'
GEÇTİ i2    tez-kontrol var, kitaplar yok
GEÇTİ i3    kimlik.md'ye (şablon) 'Kullanıcı türü: akademisyen' yazıldı
GEÇTİ i4    iki eklenti açık, divit kurulu ve güncel

== ii) Boş klasöre yazar (deneme kanalıyla; ix'in ilk yarısı)
  kur.sh:   UYARI: Claude Code 2.1.278 eski (en az 2.1.280 gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir.
  kur.sh:   Kullanıcı türü: yazar
  kur.sh:   Kanal: deneme
  kur.sh:   Kurulu ve güncel (sürüm 635ffdbcfa8c).
GEÇTİ ii1   çıkış 0, 'Kurulum bitti'
GEÇTİ ii2   kitaplar var, tez-kontrol yok
GEÇTİ ii3   kimlik.md'ye 'Kullanıcı türü: yazar' yazıldı
GEÇTİ ii4   akademik eklenti klasörde kapalı

== iii) Dolu profil + çelişen DIVIT_TUR → durur
  kur.sh: Kurulum yapılmadı.
  kur.sh: Bu klasörde başka bir kullanım türüyle kurulmuş bir Divit var:
  kur.sh:   /tmp/divit-kurulum.XXXXXX/ev/Documents/Divit
  kur.sh: Klasöre ve içindeki bilgilere dokunulmadı.
  kur.sh: 
  kur.sh: Aynı bilgisayarda ikinci bir kullanım için yeni klasör:
  kur.sh:   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | DIVIT_TUR=yazar DIVIT_HEDEF="$HOME/Documents/Divit-Yazar" bash
  kur.sh: 
GEÇTİ iii1  çıkış ≠ 0, 'Kurulum bitti' yok
GEÇTİ iii2  açıklama ve yeni klasör komutu (Divit-Yazar)
GEÇTİ iii3  klasördeki hiçbir dosya değişmedi (shasum)
GEÇTİ iii4  tersi (dolu yazar profili + DIVIT_TUR=akademisyen) de durur, dosya değişmez

== iv) Değişkensiz yeniden kurulum (hocanın yolu)
  kur.sh:   UYARI: Claude Code 2.1.278 eski (en az 2.1.280 gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir.
  kur.sh:   Kullanıcı türü: akademisyen
  kur.sh:   Kurulu ve güncel (sürüm 658769f6be47).
  kur.sh:   UYARI: Üniversite işleri eklentisi (divit-akademik) şimdi kurulamadı; kurulumu sonra yeniden çalıştırın.
GEÇTİ iv1   çıkış 0, 'Kurulum bitti', tür akademisyen
GEÇTİ iv2   dolu kimlik.md değişmedi (tür satırı eklenmedi)
GEÇTİ iv3   elle eklenen izin duruyor, iki eklenti açık
GEÇTİ iv4   divit kurulu ve güncel (pazar yeri main)

== v) divit pazar yeri başka adreste kayıtlı
  kur.sh:   HATA: Divit bu bilgisayarda başka bir kaynaktan kurulu:
  kur.sh:     https://raw.githubusercontent.com/mehmetor/divit/deneme/.claude-plugin/marketplace.json
  kur.sh: 
  kur.sh: Kurulum tamamlanmadı.
  kur.sh: Bu bilgisayarda Divit başka bir kaynaktan kurulu; yeni sürüm gelemedi.
  kur.sh: Önce şunu çalıştırın:
  kur.sh: 
  kur.sh:   claude plugin marketplace remove divit
  kur.sh: 
  kur.sh: sonra bu kurulumu yeniden çalıştırın. Klasördeki dosyalarınız silinmez.
  kur.sh: 
GEÇTİ v1    çıkış ≠ 0, 'Kurulum bitti' yok
GEÇTİ v2    ne olduğu ve çözüm komutu yazıyor
GEÇTİ v3    çözüm komutundan sonra kurulum biter (çıkış 0, kurulu ve güncel)

== vi) Son mesajdaki klasör yeri
GEÇTİ vi1   Belgeler altında: 'Belgeler → Divit-Yazar'
GEÇTİ vi2   Belgeler altında: 'Belgeler → Divit'
GEÇTİ vi3   Belgeler dışında: tam yol

== vii) Tek kılavuz
GEÇTİ vii1  yeni klasörlerde yalnız KILAVUZ.html (kart ve yazar kılavuzu yok)
GEÇTİ vii2  eski klasördeki KART.html silinmedi
GEÇTİ vii3  klasör CLAUDE.md'si ve şablonlarda kart anılmıyor
ATLANDI vii4  şablonda data-rol="" yok (kılavuz parçası birleşmemiş); kopya şablonla aynı mı:
GEÇTİ vii5  şablonda data-rol yokken kopya şablonla birebir

== viii) İzinler ve araçlar
GEÇTİ viii1 settings.json: iki kitap-klasoru allow, asil/malzeme deny birebir; mkdir allow duruyor
GEÇTİ viii2 CLAUDE.md 'Araçlar' dolu (pandoc, pdfcpu tam yol; pdftotext 'yok'; yer tutucu yok)
GEÇTİ viii3 CLAUDE.md çekirdek kuralı: klasör açma ve kopyalama yalnız kitap-klasoru betiğiyle

== ix) Kanal
GEÇTİ ix1   .divit/kanal.txt = DIVIT_DAL (deneme / main)
  kur.sh:   UYARI: Claude Code 2.1.278 eski (en az 2.1.280 gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir.
  kur.sh:   Kullanıcı türü: yazar
  kur.sh:   Kanal: deneme
  kur.sh:   Kurulu ve güncel (sürüm 635ffdbcfa8c).
  kur.sh: Deneme kanalı: deneme
GEÇTİ ix2   DIVIT_DAL'sız yeniden kurulum deneme kanalında kaldı
GEÇTİ ix3   klasör ayarındaki pazar yeri adresi kanalın adresi
GEÇTİ ix4   main kanalında 'Deneme kanalı' satırı yok
GEÇTİ ix5   izinsiz dal adı → uyarı, main
GEÇTİ ix6   'yeni' izinli kanal

== x) DIVIT_TEST=1'de Claude Code güncellenmez
  çağrı: claude --version
GEÇTİ x1    sahte claude çağrıldı ama 'update' yok
GEÇTİ x2    resmî kurulum (claude.ai/install) indirilmedi
GEÇTİ x3    bilgi satırı: güncelleme atlandı

== Son
GEÇTİ G1    gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi
GEÇTİ G2    /opt/homebrew/bin/claude sürümü değişmedi (2.1.278 (Claude Code))
GEÇTİ G3    ~/Documents klasör kaydı (değişme zamanı, boyut) değişmedi

SONUÇ: hepsi geçti (ATLANDI satırları hariç).
```

Notlar:

- "Claude Code 2.1.278 eski (en az 2.1.280 gerekli)" uyarısı beklenir:
  bu Mac'teki `/opt/homebrew/bin/claude` 2.1.278; sınama onu güncellemez
  (x ve G2).
- main kanalında "Üniversite işleri eklentisi (divit-akademik) şimdi
  kurulamadı" uyarısı beklenir: main'in pazar yerinde akademik eklenti
  henüz yok (bilinen durum, uyarı olarak kalır; kurulum biter).
- v3: çözüm mesajındaki `claude plugin marketplace remove divit`
  çalıştırılınca aynı kurulum hatasız biter.

## Windows (kur.ps1, denenmedi)

Bu makinede PowerShell yok; kur.ps1 kur.sh ile aşağıdaki gibi
eşleştirildi.

Çapa: iki betikte aynı Türkçe yorum satırı ya da işlev adı.

| Konu | Çapa (kur.sh / kur.ps1) | Fark |
|---|---|---|
| Kanal önceliği, izinli adlar | `# Kanal: DIVIT_DAL > klasörün kanal.txt'si > main.` | ps1 büyük/küçük harf duyarlı karşılaştırır (`-ceq`, `-cmatch`) |
| Profil dolu mu, profildeki tür, DIVIT_TUR | `# Kullanıcı türü: DIVIT_TUR > kimlik.md satırı > akademisyen.` | ps1 "Kullanıcı türü:" ve "Henüz doldurulmadı"yı `[char]` ile kurar (betik ANSI okunsa da bozulmasın) |
| Tür çelişkisinde dur | `# Dolu profil başka türdense hiçbir şeye dokunmadan dur` | Mac `exit 2`; Windows `return` (betik `irm … \| iex` ile çalışır, `exit` pencereyi kapatır). Önerilen komut: Mac `DIVIT_HEDEF="$HOME/Documents/Divit-Yazar"`, Windows `$env:DIVIT_HEDEF=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Divit-Yazar'` |
| Alt sınır 2.1.280, DIVIT_TEST=1'de güncelleme yok | `EN_AZ=` / `$EnAzSurum =`, `# Sınama geliştiricinin kendi Claude Code'unu değiştirmez.` | ps1'de ayrıca `$ArsivEnAz` 2.1.224: CLI bunun da altındaysa eklenti adımı atlanır (bugünkü davranış). Mac bugünkü gibi eklenti adımını dener |
| Tür satırı yalnız şablon profile | `tur_satiri_yaz` / `TurSatiriYaz` | — |
| Tek kılavuz, data-rol | `kilavuz_yaz` / `KilavuzYaz` | sed / `.Replace` |
| CLAUDE.md "Araçlar" | `claude_md_yaz` / `ClaudeMdYaz` | Mac pdftotext `yok`; Windows Poppler'in pdftotext yolu (yoksa `yok`); Windows yolları ters bölüyle |
| Yeni klasöre kopyalama | `# … eski kart/kılavuzlar kopyalanmaz` | `*.html` ve `CLAUDE.md` döngüde atlanır, ardından işlevlerle yazılır |
| kanal.txt | `printf '%s\n' "$DAL" > "$KANAL_DOSYASI"` / `YazUtf8 $KanalDosyasi` | — |
| Klasör ayarındaki pazar yeri adresi = kanal | `# Pazar yeri adresi kanala göre` | sed / `-replace` |
| Eklenti komutları ev klasöründen | `# Ev klasöründen: bir klasörün kendi ayarı …` | `cd "$HOME"` / `Push-Location $Ev` … `Pop-Location` |
| Pazar yeri adresi denetimi | `# divit pazar yeri beklenen adreste mi?` | Mac awk ile JSON bloğunu ayırır (python varsayılmaz); ps1 `ConvertFrom-Json`. İkisi de `--json` yoksa yalnız eklenti listesine bakar; "source differs" kayıtta varsa da hata sayılır |
| Kurulum tamamlanmadı, çıkış ≠ 0 | `# Pazar yeri başka kaynaktaysa kurulum bitmiş sayılmaz.` | Mac `exit 1`; Windows `$global:LASTEXITCODE = 1` + `return` |
| Kılavuz parçasız açılır | `open "$HEDEF/KILAVUZ.html"` / `Invoke-Item (Join-Path $Hedef 'KILAVUZ.html')` | — |
| Klasör yeri | `# Klasör seçerken gösterilecek yer` | Windows "Belgeler > <ad>" (betik mesajları ASCII) |
| Deneme kanalı satırı | `Deneme kanalı: …` / `Deneme kanali: …` | — |
| `$BaskaKaynak` sıfırlama | — / `$BaskaKaynak = $null` | yalnız ps1: `iex` oturum değişkenlerini korur |
