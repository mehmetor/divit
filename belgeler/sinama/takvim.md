# Takvim ve dönem takvimi — sınama

Tarih: 2026-10-01. Dal: `orc/yonetici-kitap-yazarlari-i/takvim`.
Skill'ler: `divit:takvim` (+ `ics.md`), `divit-akademik:ders-takvimi`.

## Yöntem

Geçici klasörler `/tmp/divit-takvim-sinama/{aka,aka2,yaz}` —
`hoca-paketi/Divit` kopyası; `CLAUDE.md`'de `__PANDOC__` →
`/opt/homebrew/bin/pandoc`. `.claude/settings.json` kaldırıldı, aynısı
`settings.local.json` olarak kondu (stderr'de `Ignoring` satırı yok). Sınama
için local dosyaya iki ek:

- `Read(//<worktree>/plugins/**)` — eklenti `--plugin-dir` ile worktree'den
  yüklendiği için; gerçek kurulumda eklenti `~/.claude/plugins/` altındadır,
  oradaki izin zaten var.
- 2.–5. koşularda `Bash(open *)` allow'dan çıkarılıp deny'a kondu:
  sınama bu Mac'te takvim programını açmasın diye. Denial beklenendir.

Komut (klasörün içinden):

```
ENABLE_CLAUDEAI_MCP_SERVERS=false claude -p "<istem>" \
  --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit [--plugin-dir <worktree>/plugins/divit-akademik] \
  --model claude-sonnet-5-5 --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
  --output-format stream-json --verbose
```

Örnek `gorevler.md` (akademisyen), kurulumdaki "iş, kişi, tarih, durum" sırası:

```
- Tez ara raporu okuma · E.K. · 2026-10-03 · bekliyor
- BAP proje ara raporu · — · 2026-10-06 · sürüyor
- Makale düzeltmesi (hakem dönüşü) · — · 2026-10-20 · bekliyor
- Yüksek lisans seminer değerlendirmesi · M.T. · 2026-09-28 · bekliyor
- Bölüm kurulu yazısı · — · 2026-09-25 · bitti
- Ders notlarını güncelleme · — · — · sürüyor
```

## Sonuç

| # | Senaryo | Sonuç |
|---|---|---|
| 1 | Akademisyen, "bu hafta neler var", `takvim.md` yok | **GEÇTİ** |
| 2 | Akademisyen, e-postadan iki tarih → `gorevler.md` + `.ics` | **GEÇTİ** |
| 3 | Yazar, "bu hafta neler var" | **GEÇTİ** |
| 4 | Akademisyen, dönem takvimi ve ders programı yazılı veriliyor | **GEÇTİ** |
| 5 | Akademisyen, `takvim.md` var, sınav haftası 11 gün sonra | **GEÇTİ** |

## 1. "bu hafta neler var" (akademisyen)

Araçlar: `Skill divit:kurallar` → `Skill divit:takvim` → Read akademisyen.md,
takvim.md (yok), gunluk.md → Edit gunluk.md. Cevap:

```
**Bu hafta (1–7 Ekim)**
- **Cumartesi 3 Ekim:** Tez ara raporu okuma (E.K.)
- **Salı 6 Ekim:** BAP proje ara raporu

**Tarihi geçmiş, bitti mi?** Yüksek lisans seminer değerlendirmesi (M.T.), 28 Eylül. …
**Sonraki hafta:** … 20 Ekim Salı günlü makale düzeltmesi (hakem dönüşü).
Tarihi olmayan 1 iş var: Ders notlarını güncelleme.
İsterseniz bu tarihleri takviminize de eklerim.
Dönem takviminiz ve haftalık ders programınız elinizde var mı? Bir kez verirseniz …
```

Gün adları doğru (3 Ekim 2026 Cumartesi, 6 Ekim Salı, 20 Ekim Salı). Bitmiş iş
gösterilmedi. İzin reddi: ilk koşuda eklenti yolu okuma reddi (yukarıdaki
sınama düzeni; düzeltildi). Son koşuda **izin reddi yok**. Bu koşu ilk
sürümle yapıldı; "Bugün … iş yok" satırı sonra kuralla kaldırıldı.

## 2. E-postadan tarih yakalama + `.ics`

İstem: bölüm başkanlığı e-postası (izlence teslimi 14 Ekim 2026; kurul
21 Ekim 2026 14.00, B-201) + "göreve ekle, takvime de ekle; onay veriyorum".

Araçlar: kurallar → takvim → Read ics.md → Edit gorevler.md → Write
`cikti/takvim/2026-10-14-izlence-ve-kurul.ics` → Bash `open …` (reddedildi,
beklenen) → Edit gunluk.md. `gorevler.md`'ye eklenen iki satır aynı biçimde,
`bekliyor`. Kullanıcıya dosyanın tam yolu ve Google için içe aktarma yolu verildi.

Dosya (tamamı):

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Divit//Takvim//TR
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
UID:20261014-izlence-teslimi-1@divit
DTSTAMP:20261001T090000Z
DTSTART;VALUE=DATE:20261014
DTEND;VALUE=DATE:20261015
SUMMARY:Ders izlencelerinin teslimi (mesai bitimi)
DESCRIPTION:Kaynak: bölüm başkanlığı e-postası.
BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:Ders izlencelerinin teslimi
TRIGGER:-P1D
END:VALARM
END:VEVENT
BEGIN:VEVENT
UID:20261021-akademik-kurul-2@divit
DTSTAMP:20261001T090000Z
DTSTART:20261021T140000
DTEND:20261021T150000
SUMMARY:Bölüm Akademik Kurulu (B-201)
LOCATION:B-201
DESCRIPTION:Kaynak: bölüm başkanlığı e-postası.
BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:Bölüm Akademik Kurulu
TRIGGER:-PT1H
END:VALARM
END:VEVENT
END:VCALENDAR
```

Zorunlu alan grep'i (`grep -c "^<alan>"`): BEGIN:VCALENDAR 1, VERSION:2.0 1,
PRODID 1, BEGIN:VEVENT 2, UID 2, DTSTAMP 2, DTSTART 2, SUMMARY 2, END:VEVENT 2,
END:VCALENDAR 1, `DTEND;VALUE=DATE:20261015` 1 (tüm gün → ertesi gün). 75 baytı
aşan satır: yok (`LC_ALL=C awk 'length>75'`). `file`: "vCalendar calendar file",
UTF-8. **CRLF sınanmadı:** Write düz satır sonu yazıyor (`\r` sayısı 0);
Outlook/Google/Apple'da içe aktarma elle denenmedi.

İzin reddi: `Bash open "cikti/takvim/…ics"` — sınamada bilerek kapatıldı.

**Bağlayıcı yolu (ilk koşu):** Bağlantılar kapatılmadan yapılan ilk koşuda
oturum bu hesabın gerçek Google Takvim bağlantısını gördü, izin sorusu yerine
(istemde onay verilmişti) iki `create_event` denedi; `-p` kipinde **reddedildi**,
hiçbir etkinlik oluşmadı; skill `.ics` yoluna geçti. Aynı koşuda `open` izinliydi,
takvim programı dosyayı açtı (bu Mac'te içe aktarma penceresi; onaylanmadıysa
takvime bir şey eklenmedi). Bu koşuda `TZID=Europe/Istanbul` yazılmıştı;
`VTIMEZONE` bloğu olmadan geçersiz sayılabileceği için kural yerel saate çevrildi.

## 3. Yazar, "bu hafta neler var"

Yalnız `divit` eklentisi. Araçlar: kurallar → takvim → yazar.md, gorevler.md,
gunluk.md.

```
**Bu hafta (1–7 Ekim)**
- **Pazartesi 5 Ekim**: Yeni baskı düzeltmeleri (yonetim-notlari), sürüyor.
**Sonraki hafta:** 12 Ekim Pazartesi günü dizgi provası okuma var (yonetim-notlari), bekliyor.
Hatırlatma: Yeni baskı düzeltmeleri için son tarih 5 Ekim Pazartesi.
İsterseniz bu tarihleri takviminize de eklerim.
```

Akademik kelime yok, dönem takvimi sorulmadı. Çifte "Hatırlatma" satırı
sonra kuralla kaldırıldı. **İzin reddi yok.**

## 4. Dönem takvimi ve ders programı

İstem: güz dönemi tarihleri + iki ders, "tablo doğruysa kaydet, onay veriyorum".
Araçlar: kurallar → `divit-akademik:ders-takvimi` → Read takvim.md, dersler.md →
Write `.divit/profil/takvim.md`, `dersler.md` → Edit gunluk.md. Tablo gün
adlarıyla gösterildi; bütünleme ve tatil verilmediği için yazılmadı ve
söylendi. **İzin reddi yok.** Oluşan dosya:

```
# Dönem takvimi

Dönem: 2026-2027 Güz · Kaynak: hoca söyledi · Kaydedildi: 2026-10-01

| Olay | Başlangıç | Bitiş |
|---|---|---|
| Derslerin başlaması | 2026-09-21 | |
| Ara sınav haftası | 2026-11-09 | 2026-11-15 |
| Ara sınav not girişi son günü | 2026-11-27 | |
| Final haftası | 2027-01-04 | 2027-01-15 |
| Final not girişi son günü | 2027-01-20 | |

# Haftalık ders programı

| Gün | Saat | Ders | Yer |
|---|---|---|---|
| Pazartesi | 10.00-12.00 | Meyvecilik (BBB301) | Z-12 dersliği |
| Çarşamba | 14.00-16.00 | Bağcılık (BBB305) | Z-14 dersliği |
```

## 5. Sınav haftası yaklaşırken

`aka2`: 4'teki dosya, ara sınav haftası 2026-10-12, not giriş son günü
2026-10-07 yapılarak. "bu hafta neler var" (son kural sürümüyle):

```
**Bu hafta (1–7 Ekim)**
- **Cumartesi 3 Ekim:** Tez ara raporu okuma (E.K.)
- **Salı 6 Ekim:** BAP proje ara raporu
- **Çarşamba 7 Ekim:** Ara sınav not girişi son günü

Bu haftanın dersleri: Pzt 5 Ekim 10.00 Meyvecilik (Z-12), Çar 7 Ekim 14.00 Bağcılık (Z-14).
…
Ara sınav haftası 12 Ekim'de başlıyor. Soruları hazırlamaya başlayalım mı?
Ara sınav not girişi 7 Ekim'e kadar. Değerlendirmeniz gereken kâğıt ya da ödev kaldı mı?
İsterseniz bu tarihleri takviminize de eklerim.
```

**İzin reddi yok.**
