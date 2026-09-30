---
name: kaynak-dogrula
description: Bir metindeki atıfların gerçek olduğunu, künyelerin yayın kaydıyla birebir tuttuğunu, geri çekilmiş makale olmadığını ve iddiayı gerçekten desteklediğini doğrular. Hoca "atıfları kontrol et", "kaynakça doğru mu", "bu cümlenin kaynağı var mı", "kaynakçayı düzenle", "geri çekilmiş makale var mı" dediğinde veya atıf içeren bir metin üretilmeden önce kullan.
---

# Kaynak doğrulama

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

## Yasaklar

- **Künye üretme.** `kaynaklar.bib` içinde olmayan hiçbir künye yazılmaz;
  kaynak yoksa metne `[ATIF GEREKLİ]`. Adı, yılı, dergiyi tahmin etmek
  yasak — tahminin doğru çıkması bile kuralı değiştirmez.
- **Hafızadan doğrulama yok.** "Doğrulandı" yalnız bu oturumda WebFetch ile
  okunan bir yayın kaydına dayanır; sorgu adresi kanıt dosyasına yazılır.
- **Sessiz geçiş yok.** Emin olmadığın her giriş `ELLE BAK`'tır, `DOĞRULANDI` değil.
  Kaydı okuyamadıysan (ağ hatası, boş yanıt) "doğrulanamadı" de.
- `kaynaklar.bib`'i kendiliğinden düzeltme (aşağıda "Rapor").

Akademisyen için tek gerçek felaket uydurma ya da yanlış atıftır. Üç katman
denetlenir: **künye** (kaynak var mı, bilgileri doğru mu, geri çekilmiş mi),
**eşleştirme** (metindeki atıf ile kaynakça birbirini tutuyor mu), **pasaj**
(kaynak iddiayı gerçekten söylüyor mu). Asıl tehlike sonuncusudur.

## Kaynakça nereden gelir

**Zotero kullanıyorsa** — Better BibTeX ile `kaynaklar.bib`'e otomatik dışa
aktarım; tek doğruluk kaynağı Zotero'dur, `.bib` elle düzenlenmez.
**Zotero kullanmıyorsa** — PDF'ler `kaynaklar/`'a atılır; künye PDF'in ilk
sayfasından/DOI'sinden okunur, hatırlanmaz. Kaynakçayı Glob ile bul
(`**/*.bib`); birden çoksa hocaya hangisi olduğunu sor.

## Akış

Başlamadan `${CLAUDE_PLUGIN_ROOT}/skills/kaynak-dogrula/kunye.md` dosyasını
Read ile yükle: sorgu adresleri, alan kuralları, kanıt dosyası biçimi ve
ikinci okuma oradadır. Word metnini önce `kurallar`'daki gibi metne çevir.

### 1. Metin ↔ kaynakça eşleştirmesi (mekanik)

- Metindeki atıfları **Grep** ile çıkar (`output_mode: content`, satır
  numarasıyla): `\[@…\]` / `@anahtar` biçimi, "(Yılmaz, 2023)" / "Yılmaz vd.
  (2023)" biçimi, dipnot. Göz gezdirerek sayma.
- Kaynakçadaki girişleri Grep ile çıkar: `^@\w+\{` satırları (anahtar), yazar
  ve yıl satırları.
- Her atıfı ve her girişi **tek tek** listele: anahtar — metinde (satırlar) —
  kaynakçada evet/hayır. Yazar-yıl biçiminde soyadı + yıl birlikte eşleşmeli.
  Metinde olup kaynakçada olmayan → `KAYNAKÇADA YOK`; kaynakçada olup metinde
  olmayan → `METİNDE YOK` (künyesi yine denetlenir).

### 2. Künye denetimi — her giriş için, tek tek

`kunye.md`'deki sırayla: Crossref (DOI) → OpenAlex (DOI) → başlık araması →
DergiPark. Her giriş için yayın kaydını bul, geri çekme/düzeltme bilgisini
al, **alan alan** karşılaştır: yazar soyadları, yıl, cilt, sayfa, başlık,
dergi. Her alan `eşleşti` / `farklı` / `belirsiz` / `bulunamadı`. Sonucu
`kunye.md`'deki öncelik sırasıyla koy. Girişleri birbirine karıştırmamak için
her girişi bitirip kanıt dosyasına yazdıktan sonra sonrakine geç.

Özellikle ara: toplu değiştirmeyle bozulmuş adlar ("bell → capia" yapılınca
"La Bella" → "La Capiaa"), tek harf kaymış soyadları, bir kelimesi değişmiş
başlıklar, başka makaleye giden DOI.

### 3. İkinci bağımsız okuma

`DOĞRULANDI` ve `METİNDE YOK` çıkan her giriş, **rapor yazılmadan önce**,
`kunye.md`'deki "İkinci bağımsız okuma" bölümüyle öteki kaynaktan yeniden
okunur. Uyuşmazlık → `ELLE BAK`. İkinci okuma yapılmadıysa o giriş
`DOĞRULANDI` olamaz.

### 4. Kanıt dosyası

`.divit/dogrulama/<YYYY-AA-GG>-<metin adı>.md` — `kunye.md`'deki biçimle:
eşleştirme listesi, özet tablo, her giriş için sorgu adresi, dönen alanlar,
karşılaştırma ve ikinci okuma. Hakem ya da hoca sorduğunda gösterilecek
belge budur; özet tablodaki her satırın arkasında bir sorgu adresi olmalı.

### 5. Pasaj doğrulaması (tam metin varsa)

Künyesi `DOĞRULANDI` olan her atıf için:
- **Tam metin var mı?** `kaynaklar/` altında PDF/metin var mı (Glob)?
- **Pasaj var mı?** Atfın dayandığı iddiayı destekleyen **birebir cümleyi**
  kaynaktan bul: PDF'i `kurallar`'daki yolla metne çevir, Grep ile ara,
  Read ile oku. Hafızadan cevap verme.

| Durum | Ne yapılır |
|---|---|
| ✅ Pasaj bulundu | `kaynaklar/dogrulama.md`'ye satır ekle (aşağıda) |
| ⚠️ Pasaj bulunamadı | Hocaya sor: iddia mı yanlış, sayfa mı yanlış |
| ⚠️ Tam metin yok | Künye doğru ama iddia denetlenemedi; hoca PDF'i eklemeli |

```markdown
- `[@yilmaz2023]` — s. 44 — "birebir alıntılanan cümle"
  → dayandığı iddia: <taslaktaki cümle> — ✅ 2026-09-20
```

## Rapor

Rapor `cikti/kaynak-dogrulama-<YYYY-AA-GG>.md`; `kurallar`'daki "Rapor
gösterme" kuralıyla sayfa hâli de yapılır ve ikisi tam yoluyla verilir.
Sade Türkçe, teknik kelime yok ("API", "JSON", "DOI kaydı" yerine "yayın
kaydı", "yayıncının kaydı").

- İlk satır sayım: "17 kaynaktan 5'i doğrulandı, 11'inde sorun var, 1'ine
  elle bakmanız gerekiyor." Temiz olanları tek tek sayma.
- Sonra sorunlular, önem sırasıyla: geri çekilmiş → kaynakçada yok →
  bulunamadı → bilgisi farklı → elle bakın → metinde atfı olmayan.
- Her sorunda: kaynakçada ne yazıyor, yayın kaydında ne yazıyor (yalnız
  farklı alan), kaydın adresi. Geri çekilmişte: "Bu makale yayımlandıktan
  sonra geri çekilmiş; atıf yapılmamalı ya da geri çekildiği belirtilmeli."
- Bulunamadı: "Hiçbir yayın kaydında bulamadım. Uydurma olabilir ya da çok
  yerel bir yayındır; elinizdeki nüshaya bakın." Tahmini künye önerme.
- Pasaj durumu tek satır: kaç atıfın pasajı gösterildi, kaçının tam metni yok.
- Son satır: kanıt dosyasının yolu.

**Düzeltme.** Hoca "düzelt" derse ve Zotero kullanıyorsa düzeltmeyi
Zotero'da yapmasını söyle. Kullanmıyorsa, `kurallar`'daki önceki sürüm
kuralıyla `.bib`'in kopyasını al; yalnız **yayın kaydından birebir okunan**
değeri yaz, başka alana dokunma. Geri çekilmiş ve bulunamayan girişi silme.

Bitince `.divit/gunluk.md`'ye tek satır: `kaynak-dogrula · <metin> · N kaynak,
M sorun`.
