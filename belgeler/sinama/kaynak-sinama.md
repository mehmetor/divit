# Kaynak doğrulama sınaması — "sessiz hata sıfır"

Tarih: 2026-10-01 · Makine: geliştirici Mac'i · Model: `claude-sonnet-5-5`
Betik: `araclar/kaynak-sinama/calistir.sh` · Beklenen: `araclar/kaynak-sinama/beklenen.md`

## Sonuç

**GEÇTİ — iki koşu üst üste** (koşu 011220 ve 011645, aşağıda tam çıktı):
17 girişin 17'si beklenenle aynı; 12 bilinçli hatanın 12'si yakalandı, 5 doğru
kaynaktan hiçbiri yanlış alarm vermedi, uyarı 0, izin reddi yok, stderr'de
"Ignoring" satırı yok, `kaynaklar.bib` değişmedi.

## Sınama seti

`araclar/kaynak-sinama/klasor/`: bahçe bitkileri konulu kısa bir derleme
(`yazilar/makale.md`) ve 16 girişli `kaynaklar/kaynaklar.bib`. 12 hata: uydurma
DOI, var olmayan makale, yanlış yıl, yanlış cilt, yanlış sayfa, yanlış soyadı
(Kader → Kadir), bir kelimesi değişmiş başlık, yanlış dergi, başka makaleye
giden DOI, geri çekilmiş gerçek makale (Séralini 2012: Crossref
`updated-by[].type == retraction`, OpenAlex `is_retracted: true`, API ile
gösterildi), metinde olup kaynakçada olmayan, kaynakçada olup metinde olmayan.
5 tuzak: 3 yabancı doğru kaynak, Crossref kaydı bozuk bir Türkçe dergi
makalesi, Crossref'te olmayıp DergiPark'ta olan Türkçe makale.

## Önce / sonra

| | Eski skill (origin/develop) | Yeni skill |
|---|---|---|
| Yayın kaydı sorgusu | 7 WebFetch, yalnız bazı DOI'ler | her giriş: Crossref/OpenAlex/DergiPark + ikinci okuma (25–31 WebFetch) |
| Kanıt dosyası | yok | `.divit/dogrulama/<tarih>-makale.md`, her satırda sorgu adresi |
| `munns2008` yanlış cilt | **kaçırdı** ("gözüme çarpan hata yok") | FARKLI · Cilt |
| `singleton1965` başlık | **kaçırdı** | FARKLI · Başlık |
| `seralini2012` geri çekilmiş | "biçimsel doğrulanan" listesinde; geri çekmeyi "kendi bilgimden" dedi | GERİ ÇEKİLMİŞ (kayıttan) |
| `karaboga2021`, `cetinbas2013` | hiç aranmadı | BULUNAMADI / DOĞRULANDI (DergiPark) |
| Karşılaştırılabilir sonuç | yok → KALDI | GEÇTİ |

Eski skill koşusu (20261001-005118), son mesajdan: *"4. Yalnız biçimsel
doğrulananlar, tam metin yok: tilman2002, foley2011, munns2008, singleton1965,
thaipong2006, seralini2012. Bunlar için DOI sorgusu yapmadım. Künyeleri
yalnızca gözle inceledim, gözüme çarpan hata yok."* — iki sessiz kaçırma ve bir
hafızadan geri çekme bilgisi.

## Yol boyunca düzeltilenler (yeni skill koşuları)

| Koşu | Sonuç | Ne çıktı | Skill'de ne değişti |
|---|---|---|---|
| 005004 | — | 12/12 hata bulundu ama `kunye.md` okunamadı (sınama klasöründe eklenti yolu izni) → kanıt yok | Betik: eklenti yoluna okuma izni (gerçek kurulumda `Read(~/.claude/plugins/**)` var). Skill: `updated-by` DOI'si bildirimdir, "yeniden yayımlanmış" deme |
| 005310 | KALDI | 12/12 hata; `foley2011` (Crossref 429 → okunamadı sayıldı "ayrıştı"), `thaipong2006` (bileşik soyadı "Hawkins Byrne") yanlış alarm; kanıtta kısaltılmış adresler | 429/5xx = okunamadı, sona bırak, bir kez daha dene; sorgular tek tek; bileşik soyadı kuralı; alanlar bağımsız; "RETRACTED:" başlık farkı değil; tam adres |
| 005822 | GEÇTİ | `cetinbas2013` sayfa/başlık "belirsiz" (sayfa `<meta>`'sı WebFetch'te kayboldu) | DergiPark için OAI `oai_mods` kaydı (sayfa, iki dilde başlık) |
| 010235 / 010745 | GEÇTİ / KALDI | `thaipong2006`: WebFetch ara modeli yanıtı Türkçeye çevirdi → başlık "okunamadı"; `cetinbas2013`: OpenAlex'in "DergiPark" platform adı dergi sanıldı | WebFetch istemine "çevirme, özgün dilde"; platform adı dergi değildir; ikinci okuma aynı alan kurallarıyla |
| 011220 / 011645 | **GEÇTİ / GEÇTİ** | 17/17, uyarı 0 | — |

Ağ: bir koşu betiğin ön denetiminde Crossref 429 aldı ve **AĞ** (çıkış 3)
verdi — iki koşu aynı anda çalıştırıldığı için. Koşular sırayla yapılmalı.

## Kararlılık koşuları — tam çıktı

## Koşu 20261001-011220 — GEÇTİ

- Eklentiler: `/Users/minihome/.orc/p-1ed2ff23-7891-464b-aa70-09738f8831fe/worktrees/sub-serbest-genel-kurallar-18/plugins`
- Model: `claude-sonnet-5-5` · süre: 202 sn · klasör: `/tmp/kaynak-sinama-20261001-011220/Divit`
- Kanıt dosyası: `/tmp/kaynak-sinama-20261001-011220/Divit/.divit/dogrulama/2026-10-01-makale.md`
- stderr'de 'Ignoring' satırı: 0

```
Araç çağrıları: Agent 1, Bash 4, Edit 5, Glob 1, Read 5, Skill 2, ToolSearch 2, WebFetch 27, Write 2
Yüklenen skill'ler: divit:kurallar, divit-akademik:kaynak-dogrula
Maliyet (USD): 0.9 · tur: 45
İzin reddi: izin reddi yok

Son mesaj:
Kaynakça doğru değil. 17 kaynaktan 5'i doğrulandı, 11'inde sorun var, 1'i metinde atıfsız duruyor.

**Sorunlar, önem sırasıyla**
1. **seralini2012** geri çekilmiş. Makale yayımlandıktan sonra geri çekilmiş; atıf yapılmamalı ya da geri çekildiği belirtilmeli.
2. **ozturk2020** kaynakçada yok. Metinde 23. satırda atıf var.
3. **yildiz2019** ve **karaboga2021** hiçbir yayın kaydında bulunamadı. Uydurma olabilirler ya da çok yerel yayınlardır; elinizdeki nüshaya bakın.
4. **klee2012**: DOI başka bir makaleye gidiyor (domates genomu, Tomato Genome Consortium). Kaynakçadaki başlık ve yazar bununla tutmuyor.
5. **singleton1965**: başlıkta "flavonoids" yazmış, yayın kaydında "Phenolics" var.
6. **kader2008**: yazar "Kadir" yazılmış, kayıtta "Kader".
7. **watkins2006**: yıl 2008 yazılmış, kayıtta 2006.
8. **munns2008**: cilt 57 yazılmış, kayıtta 59.
9. **lee2005**: sayfa 1169–1178 yazılmış, kayıtta 1269–1278. Kayıtta 18 yazar var, kaynakçada 3; "vd." eklenmeli.
10. **hodges1999**: dergi "Plant Physiology" yazılmış, kayıtta "Planta".

**Metinde atıfı olmayan:** giovannoni2004. Künyesi doğru.

**Doğrulananlar:** tilman2002, foley2011, cetinbas2011, cetinbas2013, thaipong2006. Hepsi ikinci bir kayıttan da okundu.

`kaynaklar/` içinde tam metin yok, bu yüzden hiçbir atfın iddiayı gerçekten desteklediği denetlenemedi. PDF'leri eklerseniz pasajlara da bakarım.

Kaynakçaya dokunmadım. "Düzelt" derseniz yalnızca yayın kaydından okunan değerleri yazarım; önce `.bib`'in önceki sürümünü yedeklerim.

Rapor (tıklayınca pencerede açılır):
`/private/tmp/kaynak-sinama-20261001-011220/Divit/cikti/kaynak-dogrulama-2026-10-01.html`

Düz metin hâli:
`/private/tmp/kaynak-sinama-20261001-011220/Divit/cikti/kaynak-dogrulama-2026-10-01.md`

Kanıt dosyası (her girişin sorgu adresiyle):
`/private/tmp/kaynak-sinama-20261001-011220/Divit/.divit/dogrulama/2026-10-01-makale.md`
```

| Anahtar | Tür | Beklenen | Bulunan | Şart | Durum |
|---|---|---|---|---|---|
| yildiz2019 | hata | BULUNAMADI, FARKLI | BULUNAMADI | — | GEÇTİ |
| karaboga2021 | hata | BULUNAMADI, FARKLI, ELLE BAK | BULUNAMADI | — | GEÇTİ |
| ozturk2020 | hata | KAYNAKÇADA YOK | KAYNAKÇADA YOK | Kaynakçada=hayır | GEÇTİ |
| giovannoni2004 | hata | METİNDE YOK, ELLE BAK | METINDE YOK | Metinde=hayır | GEÇTİ |
| watkins2006 | hata | FARKLI | FARKLI | Yıl=farklı | GEÇTİ |
| munns2008 | hata | FARKLI | FARKLI | Cilt=farklı | GEÇTİ |
| lee2005 | hata | FARKLI | FARKLI | Sayfa=farklı | GEÇTİ |
| kader2008 | hata | FARKLI | FARKLI | Yazar=farklı | GEÇTİ |
| singleton1965 | hata | FARKLI | FARKLI | Başlık=farklı | GEÇTİ |
| hodges1999 | hata | FARKLI | FARKLI | Dergi=farklı | GEÇTİ |
| klee2012 | hata | FARKLI | FARKLI | Başlık=farklı; Yazar=farklı | GEÇTİ |
| seralini2012 | hata | GERİ ÇEKİLMİŞ | GERI ÇEKILMIŞ | Geri çekme=geri çekilmiş | GEÇTİ |
| tilman2002 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| foley2011 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| thaipong2006 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| cetinbas2011 | tuzak | DOĞRULANDI, ELLE BAK | DOĞRULANDI | — | GEÇTİ |
| cetinbas2013 | tuzak | DOĞRULANDI, ELLE BAK | DOĞRULANDI | — | GEÇTİ |

Beklenen 17 satır · KALDI 0 · UYARI 0 · tabloda fazladan: yok · ağ hatası: 0

## Koşu 20261001-011645 — GEÇTİ

- Eklentiler: `/Users/minihome/.orc/p-1ed2ff23-7891-464b-aa70-09738f8831fe/worktrees/sub-serbest-genel-kurallar-18/plugins`
- Model: `claude-sonnet-5-5` · süre: 249 sn · klasör: `/tmp/kaynak-sinama-20261001-011645/Divit`
- Kanıt dosyası: `/tmp/kaynak-sinama-20261001-011645/Divit/.divit/dogrulama/2026-10-01-makale.md`
- stderr'de 'Ignoring' satırı: 0

```
Araç çağrıları: Agent 1, Bash 2, Edit 2, Grep 1, Read 6, Skill 3, ToolSearch 2, WebFetch 31, Write 2
Yüklenen skill'ler: divit:kurallar, divit-akademik:kaynak-dogrula, divit:kurallar
Maliyet (USD): 1.0 · tur: 7
İzin reddi: izin reddi yok

Son mesaj:
17 kaynaktan 5'i doğrulandı, 11'inde sorun var, 1'i metinde atıfsız duruyor. Toplam 17, çünkü kaynakçada 16 giriş var ve metindeki bir atıf kaynakçada hiç yok.

**Sorunlar, önem sırasıyla**
1. **`seralini2012` geri çekilmiş.** Makale yayımlandıktan sonra geri çekilmiş. Metnin son paragrafında bunu belirtmeden kullanılıyor. Atıf yapılmamalı ya da geri çekildiği belirtilmeli.
2. **`ozturk2020` kaynakçada yok** (satır 23). Künye uydurmadım. Metne `[ATIF GEREKLİ]` yazılmalı ya da kaynağı siz eklemelisiniz.
3. **Bulunamayanlar.** Hiçbir yayın kaydında bulamadım; uydurma olabilir ya da çok yerel bir yayındır, elinizdeki nüshaya bakın.
   - `yildiz2019`
   - `karaboga2021`
4. **Bilgisi farklı olanlar:**
   - `watkins2006`: yıl kaynakçada 2008, kayıtta 2006.
   - `munns2008`: cilt kaynakçada 57, kayıtta 59.
   - `kader2008`: soyadı kaynakçada "Kadir", kayıtta "Kader".
   - `klee2012`: DOI başka bir makaleye gidiyor (domates genomu, Tomato Genome Consortium). Kaynakçadaki başlık ve yazarlar bu kayıtla tutmuyor. Metindeki cümle DOI'deki makaleyi anlatıyor, hangisini kastettiğinize siz karar verin.
   - `singleton1965`: başlıkta kaynakçada "flavonoids", kayıtta "Phenolics" yazıyor.
   - `lee2005`: sayfa kaynakçada 1169–1178, kayıtta 1269–1278.
   - `hodges1999`: dergi kaynakçada *Plant Physiology*, kayıtta *Planta*.
5. **Metinde atfı olmayan:** `giovannoni2004`. Künyesi temiz.

**Doğrulananlar:** `tilman2002`, `foley2011`, `cetinbas2013`, `cetinbas2011`, `thaipong2006`. Hepsi iki ayrı kayıttan okundu. `cetinbas2011`'de yayıncının kaydındaki yazar alanı bozuk. İkinci kayıtta soyadlar tuttu, ama Koyuncu'nun adı iki kayıtta da yok, denetlenemedi.

**Pasajlar denetlenemedi.** `kaynaklar/` klasöründe tam metin yok. Atıfların iddiaları gerçekten desteklediğini bu yüzden bilmiyorum. PDF'leri eklerseniz bu adımı yaparım.

`kaynaklar.bib`'e dokunmadım. İsterseniz kayıttan birebir okunan değerlerle düzeltirim (önce yedeğini alırım). `klee2012`, `yildiz2019` ve `karaboga2021` için doğru künyeyi siz vermelisiniz.

Dosyalar:
`/private/tmp/kaynak-sinama-20261001-011645/Divit/cikti/kaynak-dogrulama-2026-10-01.html` (tıklayınca pencerede açılır)
`/private/tmp/kaynak-sinama-20261001-011645/Divit/cikti/kaynak-dogrulama-2026-10-01.md`
Kanıt dosyası (her satırın sorgu adresiyle): `/private/tmp/kaynak-sinama-20261001-011645/Divit/.divit/dogrulama/2026-10-01-makale.md`
```

| Anahtar | Tür | Beklenen | Bulunan | Şart | Durum |
|---|---|---|---|---|---|
| yildiz2019 | hata | BULUNAMADI, FARKLI | BULUNAMADI | — | GEÇTİ |
| karaboga2021 | hata | BULUNAMADI, FARKLI, ELLE BAK | BULUNAMADI | — | GEÇTİ |
| ozturk2020 | hata | KAYNAKÇADA YOK | KAYNAKÇADA YOK | Kaynakçada=hayır | GEÇTİ |
| giovannoni2004 | hata | METİNDE YOK, ELLE BAK | METINDE YOK | Metinde=hayır | GEÇTİ |
| watkins2006 | hata | FARKLI | FARKLI | Yıl=farklı | GEÇTİ |
| munns2008 | hata | FARKLI | FARKLI | Cilt=farklı | GEÇTİ |
| lee2005 | hata | FARKLI | FARKLI | Sayfa=farklı | GEÇTİ |
| kader2008 | hata | FARKLI | FARKLI | Yazar=farklı | GEÇTİ |
| singleton1965 | hata | FARKLI | FARKLI | Başlık=farklı | GEÇTİ |
| hodges1999 | hata | FARKLI | FARKLI | Dergi=farklı | GEÇTİ |
| klee2012 | hata | FARKLI | FARKLI | Başlık=farklı; Yazar=farklı | GEÇTİ |
| seralini2012 | hata | GERİ ÇEKİLMİŞ | GERI ÇEKILMIŞ | Geri çekme=geri çekilmiş | GEÇTİ |
| tilman2002 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| foley2011 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| thaipong2006 | tuzak | DOĞRULANDI | DOĞRULANDI | — | GEÇTİ |
| cetinbas2011 | tuzak | DOĞRULANDI, ELLE BAK | DOĞRULANDI | — | GEÇTİ |
| cetinbas2013 | tuzak | DOĞRULANDI, ELLE BAK | DOĞRULANDI | — | GEÇTİ |

Beklenen 17 satır · KALDI 0 · UYARI 0 · tabloda fazladan: yok · ağ hatası: 0

