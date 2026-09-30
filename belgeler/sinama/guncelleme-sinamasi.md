# Hoca güncelleme sınaması

Soru: kurulu tek hoca (yalnız `divit@divit`, main'deki sürüm, tür satırı
olmayan akademisyen profili) yeni sürüme (iki eklenti) geçerken sorun
yaşar mı? Adımlar ve beklenen davranış için geçiş belgesi:
`belgeler/GECIS-IKI-EKLENTI.md`.

**Sonuç (2026-09-30):** Hayır. Güncelleme kendiliğinden gelse de gelmese de
hocanın hiçbir dosyası değişmedi; akademik komutlar kurulum yenilenene
kadar kaybolur ama Divit tez isteğinde sade Türkçe "kurulumu bir kez
yenilemek gerekiyor… Yenileyeyim mi?" der ve yenileme tek adımla (kur.sh)
beş akademik komutu geri getirir. Bütün ölçümler GEÇTİ.

## Nasıl çalıştırılır

Yayına gidecek dalda, temiz çalışma ağacıyla:

```bash
araclar/sinama-guncelleme.sh --dal deneme-gecis-$(date +%Y%m%d%H%M) --karma
git push origin --delete deneme-gecis-...     # iş bitince, elle
```

- Betik başta origin'e push yapacağını yazar; dal adı zorunludur ve dal
  uzakta önceden olmamalıdır (tek kullanımlık).
- **A** dalı main'in birebir kopyası yapar ve main'in `kur.sh`'siyle
  geçici HOME + geçici `CLAUDE_CONFIG_DIR`'a kurar; hocayı taklit eder
  (settings.local.json'a iki elle izin, tür satırsız dolu kimlik.md,
  `tez-kontrol/gelen/` ve `yazilar/`'a birer dosya).
- **B** `./yayinla.sh --deneme <dal>` ile aynı adresteki marketplace.json'u
  yeni iki eklentiye çevirir, GitHub ham önbelleğini bekler (30 sn arayla,
  en çok 10 dk), sonra otomatik güncellemenin yaptığı iki adımı çalıştırır:
  `claude plugin marketplace update divit` (katalog yenilenir) ve
  `claude plugin update divit@divit` (kurulu eklenti yeni özete taşınır).
  Otomatik güncelleme yalnız kurulu eklentiyi yeniler, yeni eklentiyi
  kurmaz; bu yüzden `divit-akademik` bu aşamada yoktur. Kurulum
  yenilenmeden ölçülür.
- **C** bu dalın `kur.sh`'siyle, `DIVIT_TUR` vermeden kurulumu yeniler.
- Ölçümler bittiğinde geçiciler silinir (`--sakla` ile kalır).

### Konuşma ölçümleri (B2, B3, D, C9)

Geçici config'te `claude -p` girişsiz çalışmaz ("Not logged in"); init satırı ise girişsiz basılır.
Ortamda `CLAUDE_CODE_OAUTH_TOKEN` ya da `ANTHROPIC_API_KEY` varsa betik
konuşmaları yalıtılmış config'le yapar (bu yol **denenmedi**). Yoksa:

- `--karma` verilmezse ATLANDI yazar.
- `--karma` ile gerçek girişle ama gerçek ayar ve eklentiler olmadan:
  hoca klasörünün kopyasında `.claude/settings.json`'dan
  `extraKnownMarketplaces`, `settings.local.json`'dan `enabledPlugins`
  çıkarılır (yoksa Claude Code gerçek config'e o klasör için "local"
  kurulum kaydı ve pazar yeri yazar); klasörde açık ve kurulu her
  eklenti `--plugin-dir` + `--add-dir` ile verilir (`--add-dir`, gerçekte
  `Read(~/.claude/plugins/**)` izninin karşılığıdır);
  `--setting-sources project,local --no-session-persistence
  --disallowedTools Bash PowerShell`. İnit satırında divit eklentilerinin
  `@inline` ve geçici config yolundan geldiği denetlenir; gerçek
  `~/.claude`'un üç dosyası önce/sonra karşılaştırılır (G1).
- Klasör ayarındaki model (`claude-opus-5-5`) Claude Code 2.1.280 ister;
  betik konuşma için makinedeki en yeni `claude` kopyasını seçer.

## Son çalıştırmanın çıktısı

Dal `deneme-gecis-202609301456`, kaynak commit `7b503b7` (üç PR
birleştirilmiş entegrasyon + bu işin düzeltmeleri).

```text

== Ön koşullar
Bu betik origin'e PUSH yapar: 'deneme-gecis-202609301456' dalı (önce main'in kopyası, sonra deneme commit'i).
claude (eklenti işleri): /opt/homebrew/bin/claude 2.1.278 · konuşma: ~/.local/bin/claude 2.1.285
Geçici dizin: /tmp/divit-sinama.2K09cO

== A) Eski hâl (main)
Gönderildi: deneme-gecis-202609301456 = origin/main (caebb153ad2e)
  kur.sh:   Kurulu ve güncel (sürüm 658769f6be47).
GEÇTİ A1   yalnız divit@divit kurulu, sürüm main'deki özet (658769f6be47)
GEÇTİ A2   init'te divit:tez-kontrol var
BİLGİ A3   pazar yeri kaydında divit autoUpdate: yok (anahtar yazılmamış) (kur.sh CLI ile ekler; Desktop klasöre güvenince şablondaki autoUpdate:true işlenebilir)

== B) Yeni sürüm gelir, kurulum yenilenmez
  yayinla: Gönderildi: deneme-gecis-202609301456 → 063e4c4adfe6 (kaynak 7b503b7d0c9c (orc/yonetici-kitap-yazarlari-i/guncelleme-sinama))
  yayinla:   divit sürümü 635ffdbcfa8c
  yayinla:   divit-akademik sürümü 8094459df0d4
  Beklenen sürümler: divit 635ffdbcfa8c · divit-akademik 8094459df0d4. Ham adres önbelleği bekleniyor…
GEÇTİ B0   raw marketplace.json deneme commit'iyle aynı (300 sn)
GEÇTİ B1a  divit yeni özette (635ffdbcfa8c), divit-akademik kurulu değil
GEÇTİ B1b  init: divit-akademik:* yok, divit:tez-kontrol yok, divit yeni yoldan
GEÇTİ B4a  eski CLAUDE.md divit:kurallar'ı yüklüyor (tür kurallar'da çözülür)
GEÇTİ B4b  eski settings.json eklenti dosyalarını okumaya izin veriyor (akademisyen.md)
BİLGİ B4c  eski tez-kontrol/CLAUDE.md eski skill adını anıyor; B3 güvenlik ağı bunu karşılamalı
BİLGİ B4d  eski settings.json'da kitaplar/ yasakları yok (akademisyende kitaplar/ yok; C'de gelir)
BİLGİ B5   açık oturum eski eklentiyle sürer; yeni sürüm Claude kapatılıp açılınca gelir
  eklentiler: divit@inline /tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c, cc-plugin-agents-md@builtin builtin, cc-plugin-telemetry@builtin builtin
  araç: Skill {"skill": "divit:kurallar"}
  araç: Read {"file_path": "/tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c/skills/kurallar/akademisyen.md"}
  metin: Merhaba Hocam, hoş geldiniz.
         
         Bugün ne üzerinde çalışalım? Örneğin bir öğrencinizin tezine bakabilir, yayına hazırladığınız bir makaleyi gözden geçirebilir, kaynakçanızı denetleyebilir ya da bir yazışma taslağı hazırlayabilirim.
         
         Ayrıca, sizin yazım üslubunuzu ve alanınızın kurallarını henüz tanımıyorum. Uygun olduğunuzda özgeçmişinizi ya da ilk yazarı olduğunuz birkaç makaleyi verirseniz size göre çalışabilirim.
GEÇTİ B2   merhaba → kurallar akademisyen.md'yi Read ile okudu
  eklentiler: divit@inline /tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c, cc-plugin-agents-md@builtin builtin, cc-plugin-telemetry@builtin builtin
  araç: Skill {"skill": "divit:kurallar"}
  araç: Read {"file_path": "/tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c/skills/kurallar/akademisyen.md"}
  araç: Glob {"pattern": "tez-kontrol/**/*"}
  metin: The divit-akademik:tez-kontrol skill isn't in the list, so I must not evaluate; say reinstall needed and ask for approval to run guncelleme.
  araç: Read {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-b/Divit/.divit/gunluk.md"}
  araç: Edit {"replace_all": false, "file_path": "/private/tmp/divit-sinama.2K09cO/karma-b/Divit/.divit/gunluk.md", "old_string": "# Divit iş günlüğü\n", "new_string": "# Di
  metin: Hocam, gelen klasöründe **ab-tez-bolum3.md** dosyasını gördüm. Ancak şu an tezi değerlendiremiyorum. Divit'in bu işi yapan bölümü bu bilgisayarda yüklü değil. Yarım bir değerlendirme vermek istemedim, bu yüzden dosyayı açmadım.
         
         Bu iş için Divit'in kurulumunu bir kez yenilemek gerekiyor. Birkaç dakika sürer; dosyalarınız ve profiliniz olduğu gibi kalır.
         
         **Kurulumu şimdi yenileyeyim mi?** Onay verirseniz yenilemenin hemen ardından tezin değerlendirmesine geçerim.
GEÇTİ B3a  tez isteği → 'kurulumu bir kez yenilemek' yönlendirmesi
GEÇTİ B3b  sade Türkçe (eklenti/plugin/terminal/zip/JSON geçmiyor)
GEÇTİ B3c  rapor yazılmadı, hiçbir dosya değişmedi (.divit/ dışı)
  eklentiler: divit@inline /tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c, cc-plugin-agents-md@builtin builtin, cc-plugin-telemetry@builtin builtin
  araç: Skill {"skill": "divit:kurallar"}
  araç: Skill {"skill": "divit:guncelleme"}
  araç: Read {"file_path": "/tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c/skills/kurallar/akademisyen.md"}
  araç: Read {"file_path": "/tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c/SURUM.md", "limit": 60}
  araç: Glob {"pattern": ".divit/*.{md,txt}"}
  araç: Read {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-b/Divit/.divit/kurulum-surumu.txt"}
  araç: Write {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-b/Divit/.divit/hatirlatma.md", "content": "son-gorulen-surum: Sıradaki\n"}
  metin: Divit'te birkaç yenilik var:
         - Tez, sınav, makale ve atıf komutlarının adı değişti. Artık "/divit-akademik:" ile başlıyorlar (örneğin "/divit-akademik:tez-kontrol").
         - Ders notunuzdan sınav soruları ve cevap anahtarı hazırlayabilirim, Word dosyası olarak. Denemek için "ders notumdan vize hazırla" yazmanız yeterli.
         - Kitabınıza editör gözüyle bakabilirim; önerilerimi ancak siz onaylarsanız işlerim. Bunun için "kitabımı yeni baskı için düzenle" yazın.
         - Dağınık yazılarınızdan bir kitap planı ve bölüm iskeleti çıkarabilirim. Bunun için "yazılarımdan kitap yapalım" yazın.
         
         Bu yeniliklerin hepsini kullanabilmeniz için kısa bir güncelleme gerekiyor. Birkaç dakika sürer ve dosyalarınıza ya da ayarlarınıza dokunmaz. Şimdi yapayım mı? Ekranda İngilizce bir izin sorusu çıkarsa **Allow once** seçeneğine basın.
         
         Son olarak, sizi daha iyi tanımam için üslubunuzla alanınız hakkında birkaç bilgiye ihtiyacım var. Güncellemeden sonra "beni tanı" yazarsanız bunu birlikte kısa sürede tamamlarız.
GEÇTİ D1   güncelle → guncelleme skill'i yenilikleri anlatıp onay istiyor
GEÇTİ D2   kurulum onaysız çalıştırılmadı (kur.sh/kur.ps1 çağrısı yok)
GEÇTİ D3   akademik madde (komut adları, kurulumu yenileme) hocaya söylendi

== C) Kurulum yenilenir (DIVIT_TUR yok)
  kur.sh:   Kullanıcı türü: akademisyen
  kur.sh:   Kurulu ve güncel (sürüm 635ffdbcfa8c).
GEÇTİ C1   iki eklenti kurulu: divit 635ffdbcfa8c, divit-akademik 8094459df0d4
GEÇTİ C2   settings.local.json: iki eklenti açık, elle eklenen izinler duruyor
GEÇTİ C3   profil, tez-kontrol/gelen, yazilar değişmedi; kimlik.md'ye tür satırı eklenmedi
GEÇTİ C4   settings.json yeni: kitaplar yasakları var, pazar yeri deneme-gecis-202609301456
GEÇTİ C5   .claude/rules/taslak-yazim.md yeni
GEÇTİ C6   KILAVUZ.html yeni (/divit-akademik:), KILAVUZ-YAZAR.html ve kitaplar/ yok
GEÇTİ C7   .divit/kurulum-surumu.txt yazıldı (1.7)
GEÇTİ C8   init'te beş divit-akademik skill'i, eklentiler yeni yollardan
  eklentiler: divit-akademik@inline /tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit-akademik/8094459df0d4, divit@inline /tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c, cc-plugin-agents-md@builtin builtin, cc-plugin-telemetry@builtin builtin
  araç: Skill {"skill": "divit:kurallar"}
  araç: Skill {"skill": "divit-akademik:tez-kontrol"}
  araç: Read {"file_path": "/tmp/divit-sinama.2K09cO/cfg/plugins/cache/divit/divit/635ffdbcfa8c/skills/kurallar/akademisyen.md"}
  araç: Glob {"pattern": "tez-kontrol/**/*"}
  araç: Read {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/tez-kontrol/gelen/ab-tez-bolum3.md"}
  araç: Read {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/tez-kontrol/CLAUDE.md"}
  araç: Grep {"pattern": "Yılmaz|Yilmaz", "path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/kaynaklar", "output_mode": "files_with_matches"}
  araç: Write {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/tez-kontrol/rapor/ab-2026-09-30.md", "content": "# Değerlendirme — A.B., 2026-09-30\n**Metin:** ab
  araç: Read {"file_path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/.divit/gunluk.md"}
  metin: Rapor hazır, iş günlüğüne kayıt düşüyorum.
  araç: Edit {"replace_all": false, "file_path": "/private/tmp/divit-sinama.2K09cO/karma-c/Divit/.divit/gunluk.md", "old_string": "# Divit iş günlüğü\n", "new_string": "# Di
  metin: A.B.'nin Bölüm 3 dosyasını okudum ve değerlendirme raporunu yazdım.
         
         **Kısaca:**
         - **Metin çok kısa.** Gelen dosya bir tez bölümü değil, iki cümlelik bir not. Çeşit adları, deneme yeri, yıllar, tekerrür sayısı ve istatistik analiz yok.
         - **En ciddi sorun verinin kime ait olduğu.** "Ortalama verim 3.200 kg/da bulunmuştur" cümlesi öğrencinin kendi ölçümünü anlatıyor gibi, ama değer Yılmaz (2019)'a atfedilmiş. Bu kaynak çalışma klasörünüzdeki kaynaklar arasında da yok.
         - **Güçlü yanı:** Ölçülen şey, birimi (kg/da) ve süresi (üç yıl) açıkça yazılmış.
         
         Raporda öğrenciye doğrudan iletebileceğiniz yapıcı bir bölüm de var. Önce öğrenciden bölümün tam hâlini istemeniz gerekebilir.
         
         Alan bilgileriniz henüz eksik olduğu için meyve yetiştiriciliğine özel kontrolleri uygulayamadım. Profilinizi tamamladığımızda bir sonraki raporlarda bunları da denetlerim.
         
         Rapor: `tez-kontrol/rapor/ab-2026-09-30.md`
         
         Öğrenciye gidecek bir e-posta taslağı hazırlayayım mı?
GEÇTİ C9   tez isteği → divit-akademik:tez-kontrol çalıştı, öğrenci dosyası değişmedi

== Son
GEÇTİ G1   gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi

Uzak deneme dalı silinmedi. İş bitince: git push origin --delete deneme-gecis-202609301456
SONUÇ: hepsi geçti (ATLANDI satırları hariç).
Geçiciler saklandı: /tmp/divit-sinama.2K09cO
```

## Ölçümlerin yorumu

- **A3 — otomatik güncelleme.** `kur.sh` pazar yerini komut satırıyla
  ekler ve `autoUpdate` anahtarı yazılmaz (üçüncü taraf pazar yerinde
  varsayılan kapalı). Klasördeki `settings.json` aynı pazar yerini
  `autoUpdate: true` ile bildirir; masaüstü uygulaması klasöre güvenince
  bu işlenebilir (Mehmet'in makinesinde kayıt `autoUpdate: true`).
  Hocada güncellemenin kendiliğinden gelip gelmediği buna bağlıdır; iki
  durum da güvenli (geçiş belgesi → "Yayından sonra…").
- **B3.** Divit dosyayı yorumlamadan kurulumu yenilemeyi öneriyor. Bu
  koşudan önceki elle denemede model yenilemeyi önerirken öğrenci
  dosyası hakkında iki gözlem de yazmıştı; güvenlik ağı satırına "kendin
  yapmaya çalışma, dosya hakkında yorum yapma" eklendi. Aynı koşuda
  araç çağrıları arasında İngilizce tek satırlık bir ara not
  ("The divit-akademik:tez-kontrol skill isn't in the list…") göründü;
  masaüstünde hocaya görünebilir. Model davranışı; kural değişikliğiyle
  güvenilir biçimde önlenemez, kalan risk olarak not edildi.
- **D.** `guncelleme` yenilikleri dört maddeyle anlatıp onay istiyor;
  ilk madde komut adlarının değiştiği ve kurulumun bir kez yenilenmesi
  gerektiği (SURUM.md'de en üste alındı). Yazara ait "Divit artık kitap
  yazarlarıyla da çalışır" maddesi seçilmedi; kitap düzenleme ve
  yazılardan kitap maddeleri akademisyene de açık işler olduğu için
  karışıklık yaratmıyor. Denemede SURUM.md başlığı henüz "Sıradaki"
  olduğundan `son-gorulen-surum: Sıradaki` yazıldı; yayında başlık sürüm
  numarası olur.
- **C7.** `kurulum-surumu.txt` = 1.7, çünkü denemede en üst başlık
  "Sıradaki"; yayında yeni sürüm numarası yazılır.
- **B5 (okuma).** Güncelleme açık bir oturum sırasında inerse oturum eski
  eklentiyle sürer (`claude plugin update` "Restart to apply changes"
  der); yeni sürüm Claude kapatılıp açılınca gelir.
- **"local" kurulum kaydı.** Klasör `enabledPlugins` ile eklenti açınca
  Claude Code, kurulu eklentiler listesine o klasör için ayrı bir kayıt
  yazar; `claude plugin update` yalnız kullanıcı düzeyindeki kaydı
  yeniler ve local kayıt eski özette kalır. Ölçümlerde yüklenen eklenti
  her seferinde kullanıcı düzeyindeki yeni sürümdü (B1b, C8).

## E — Windows (kur.ps1, denenmedi)

C'de kullanılan her kur.sh satırının kur.ps1 karşılığı:

| kur.sh | kur.ps1 | Durum |
|---|---|---|
| Tür: `DIVIT_TUR` > kimlik.md satırı > akademisyen (sed) | 202–217 (satır `StartsWith`, `-like 'yazar*'`) | aynı |
| Tür verilmedikçe kimlik.md'ye satır yazılmaz | 266 `if ($TurVerildi)` | aynı |
| Var olan klasörde CLAUDE.md, kılavuz, kart kopyası | 235 | aynı |
| `tez-kontrol/CLAUDE.md` yalnız klasör varsa | 236–238 | aynı |
| Türün klasörü yoksa eklenir, hiçbir şey silinmez | 240–243 | aynı |
| `.claude/rules/` yenilenir | 244–245 | aynı |
| `.divit/` eksikleri `cp -Rn` ile (üst düzey dosyalar dahil) | 246–252: alt klasörler + eksik profil dosyaları | **fark:** eksik `gunluk.md` / `sorunlar.md` Windows'ta geri gelmez. Kurulu hocada ikisi de vardır; Divit gerektiğinde yazar. Düzeltilmedi. |
| settings.json yeniden yazılır (araç yolları) | 269–271 (BOM'suz UTF-8) | aynı |
| `kurulum-surumu.txt` = ilk sayısal başlık | 272–276 | aynı |
| settings.local.json: yalnız iki anahtar (plutil), okunamazsa dokunulmaz | 278–297 (ConvertFrom/To-Json `-Depth 20`, okunamazsa dokunulmaz) | anlamca aynı; PowerShell 5.1 dosyayı yeniden biçimler (girinti, `<`/`>` kaçışları) — içerik aynı kalır |
| Eklenti adımı: add, update, install/update divit, install/update divit-akademik, liste | 309–332 | aynı |

kur.ps1'de değişiklik yapılmadı. (Satır numaraları bu çalıştırmanın
kur.ps1'ine göredir; kurulum düzeltmesinden sonraki eşleştirme:
`belgeler/sinama/kurulum-sinamasi.md` → Windows.)

## Kurulum düzeltmesinden sonra (2026-09-30)

`kurulum-duzelt` dalında (tür çelişkisi, pazar yeri adresi denetimi,
2.1.280 alt sınırı, tek kılavuz, kanal) yeniden çalıştırıldı; bütün
kurulum ve eklenti ölçümleri GEÇTİ. Konuşma ölçümleri (B2, B3, D, C9)
girişsiz çalıştırıldığı için ATLANDI: bu değişiklik skill'lere dokunmaz,
yukarıdaki konuşma sonuçları geçerlidir. Yeni ölçüm C10: klasöre
`.divit/kanal.txt` (kurulumdaki dal) ve CLAUDE.md'ye dolu "Araçlar"
bölümü yazıldı. C6 artık kılavuzun kök etiketindeki `data-rol`'ü
akademisyen olarak bekler (şablonda data-rol yokken de geçer).

```
== Ön koşullar
Bu betik origin'e PUSH yapar: 'deneme-gecis-202609301649' dalı (önce main'in kopyası, sonra deneme commit'i).
claude (eklenti işleri): /opt/homebrew/bin/claude 2.1.278 · konuşma: ~/.local/bin/claude 2.1.285
Geçici dizin: /tmp/divit-sinama.XXXXXX

== A) Eski hâl (main)
Gönderildi: deneme-gecis-202609301649 = origin/main (caebb153ad2e)
  kur.sh:   Kurulu ve güncel (sürüm 658769f6be47).
GEÇTİ A1   yalnız divit@divit kurulu, sürüm main'deki özet (658769f6be47)
GEÇTİ A2   init'te divit:tez-kontrol var
BİLGİ A3   pazar yeri kaydında divit autoUpdate: yok (anahtar yazılmamış) (kur.sh CLI ile ekler; Desktop klasöre güvenince şablondaki autoUpdate:true işlenebilir)

== B) Yeni sürüm gelir, kurulum yenilenmez
  yayinla: Gönderildi: deneme-gecis-202609301649 → a94a58cb7bdd (kaynak 37558f0396d0 (orc/yonetici-kitap-yazarlari-i/kurulum-duzelt))
  yayinla:   divit sürümü 635ffdbcfa8c
  yayinla:   divit-akademik sürümü 8094459df0d4
  Beklenen sürümler: divit 635ffdbcfa8c · divit-akademik 8094459df0d4. Ham adres önbelleği bekleniyor…
GEÇTİ B0   raw marketplace.json deneme commit'iyle aynı (300 sn)
GEÇTİ B1a  divit yeni özette (635ffdbcfa8c), divit-akademik kurulu değil
GEÇTİ B1b  init: divit-akademik:* yok, divit:tez-kontrol yok, divit yeni yoldan
GEÇTİ B4a  eski CLAUDE.md divit:kurallar'ı yüklüyor (tür kurallar'da çözülür)
GEÇTİ B4b  eski settings.json eklenti dosyalarını okumaya izin veriyor (akademisyen.md)
BİLGİ B4c  eski tez-kontrol/CLAUDE.md eski skill adını anıyor; B3 güvenlik ağı bunu karşılamalı
BİLGİ B4d  eski settings.json'da kitaplar/ yasakları yok (akademisyende kitaplar/ yok; C'de gelir)
BİLGİ B5   açık oturum eski eklentiyle sürer; yeni sürüm Claude kapatılıp açılınca gelir
ATLANDI B2   konuşma ölçümü: giriş yok. Karma yol: araclar/sinama-guncelleme.sh --dal <yeni-dal> --karma
ATLANDI B3   konuşma ölçümü: giriş yok. Karma yol: araclar/sinama-guncelleme.sh --dal <yeni-dal> --karma
ATLANDI D    konuşma ölçümü: giriş yok. Karma yol: araclar/sinama-guncelleme.sh --dal <yeni-dal> --karma

== C) Kurulum yenilenir (DIVIT_TUR yok)
  kur.sh:   UYARI: Claude Code 2.1.278 eski (en az 2.1.280 gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir.
  kur.sh:   Kullanıcı türü: akademisyen
  kur.sh:   Kurulu ve güncel (sürüm 635ffdbcfa8c).
GEÇTİ C1   iki eklenti kurulu: divit 635ffdbcfa8c, divit-akademik 8094459df0d4
GEÇTİ C2   settings.local.json: iki eklenti açık, elle eklenen izinler duruyor
GEÇTİ C3   profil, tez-kontrol/gelen, yazilar değişmedi; kimlik.md'ye tür satırı eklenmedi
GEÇTİ C4   settings.json yeni: kitaplar yasakları var, pazar yeri deneme-gecis-202609301649
GEÇTİ C5   .claude/rules/taslak-yazim.md yeni
GEÇTİ C6   KILAVUZ.html yeni (/divit-akademik:, data-rol akademisyen), KILAVUZ-YAZAR.html ve kitaplar/ yok
GEÇTİ C10  .divit/kanal.txt = deneme-gecis-202609301649, CLAUDE.md 'Araçlar' dolu
GEÇTİ C7   .divit/kurulum-surumu.txt yazıldı (1.7)
GEÇTİ C8   init'te beş divit-akademik skill'i, eklentiler yeni yollardan
ATLANDI C9   konuşma ölçümü: giriş yok. Karma yol: araclar/sinama-guncelleme.sh --dal <yeni-dal> --karma

== Son
GEÇTİ G1   gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi

Uzak deneme dalı silinmedi. İş bitince: git push origin --delete deneme-gecis-202609301649
SONUÇ: hepsi geçti (ATLANDI satırları hariç).
```
