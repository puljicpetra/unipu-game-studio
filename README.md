# Projekt: GAME STUDIO (Fork)

**Kolegij:** Baze podataka II
**Nositelj kolegija:** doc. dr. sc. Goran Oreški
**Izvođač vježbi:** Romeo Šajina, mag. inf.
**Fakultet:** Fakultet Informatike u Puli
**Originalni Tim:** „Tim-1“

**Napomena:** Ovaj repozitorij je **fork** originalnog timskog projekta "GAME STUDIO" rađenog u sklopu kolegija "Baze podataka II". Služi prvenstveno za prikaz mog individualnog doprinosa i rada na tom projektu te kao arhiva projektnih materijala.

---

## O Projektu "GAME STUDIO"

Projekt "GAME STUDIO" fokusira se na razvoj sveobuhvatne baze podataka koja podržava stolnu igru uloga (RPG) temeljenu na popularnom sustavu "Dungeons and Dragons" (D&D). Cilj je bio detaljno proučiti temu, osmisliti i implementirati programsko rješenje koje koristi relacijsku bazu podataka (MySQL) za pohranu, upravljanje i olakšavanje igranja.

Sustav je osmišljen za upravljanje različitim aspektima igre, uključujući:
*   **Likove (Creatures/Characters):** Atributi (rase, klase, poravnanja, veličine), sposobnosti (skills, proficiencies), životni bodovi (health), inicijativa.
*   **Svijet Igre:** Mape, objekti na mapama, instance igre.
*   **Mehanike Igre:** Čarolije (spells), komponente magije, oblici djelovanja (AoE), oprema (oružja, oklopi), borba (damage types, conditions, napadi), iskustveni bodovi (challenge rating, experience).
*   **Igrače (Players):** Stvaranje likova, praćenje inventara, pozadina likova (backgrounds), osobnosti.

Baza podataka je dizajnirana da bude kompleksna i detaljna, s naglaskom na što razvijenijoj implementaciji SQL elemenata kao što su:
*   Velik broj **tablica** (preko 50 u finalnoj verziji) za modeliranje svih aspekata igre.
*   **Složeni upiti** za dohvaćanje i manipulaciju podacima.
*   **Pogledi (Views)** za pojednostavljeni pristup često korištenim podacima.
*   **Pohranjene procedure** za enkapsulaciju kompleksnih operacija (npr. izrada lika, borbeni potezi).
*   **Okidači (Triggers)** za automatizaciju procesa (npr. ažuriranje životnih bodova, provjera inventara).
*   **Funkcije** za izračune unutar igre (npr. izračun štete, ishoda akcija).
*   **Transakcije** za osiguravanje integriteta podataka.

Uz bazu podataka, planiran je i razvoj softverskog sučelja (konzolnog ili grafičkog) koje bi omogućilo korisnicima interakciju sa sustavom.

---

## Originalni Tim Projekta "Tim-1" i Moj Doprinos

**Članovi originalnog tima:**
*   **Karlo Bazina:** Programer - Frontend developer
*   **Tomas Mikašinović-Komšo:** Programer - Graphics designer
*   **Petra Puljić:** Osoba za komunikaciju - Menadžer manufakture dokumentacije
*   **Jakov Benedikt Ružić:** Quality assurance engineer - Human resources
*   **Juraj Štern-Vukotić:** Voditelj - Tech Lead Senior Software Architect
*   **Mateo Udovičić:** Programer - Backend developer

### Moj Specifični Doprinos Projektu (Petra Puljić):

Moj doprinos projektu uključivao je rad na osiguravanju funkcionalnosti i integriteta podataka kroz SQL triggere, funkcije i procedure, kao i održavanje i ažuriranje projektne dokumentacije. Specifično sam implementirala i prezentirala:

*   **SQL Triggeri za tablicu `notes`:**
    *   **`bi_notes`:** Trigger koji automatski generira naslov nove bilješke (npr. "Note X") ako korisnik nije unio naslov ili je unio prazan string.
    *   **`bi_notes_timestamp`:** Trigger koji automatski postavlja vrijeme kreiranja (`created_at`) i vrijeme posljednje izmjene (`modified_at`) na trenutni vremenski žig prilikom umetanja nove bilješke.
    *   **`bu_notes_timestamp`:** Trigger koji automatski ažurira vrijeme posljednje izmjene (`modified_at`) na trenutni vremenski žig prilikom svake izmjene postojeće bilješke.
*   **SQL Funkcija `get_player_character_info`:**
    *   Funkcija koja prima `player_character_id` kao ulazni parametar i vraća string s informacijama o igračkom liku, uključujući ime igrača, rasu, klasu i level. U slučaju da lik s traženim ID-jem ne postoji, funkcija vraća odgovarajuću poruku.
*   **SQL Pohranjena Procedura `GetPlayerInfo`:**
    *   Procedura koja prima `player_character_id` i dohvaća informacije o trenutnim životnim bodovima (`current_hp`) i imenu stvorenja (`creature_name`). Na temelju `current_hp`, procedura također vraća status lika ('Alive' ili 'Dead'). Ako lik ne postoji, vraća se poruka o tome.
*   **Održavanje i Ažuriranje Projektne Dokumentacije:**
    *   Kontinuirano sam radila na ažuriranju i usklađivanju svih dijelova projektne dokumentacije (Sažetak projekta, Izvješća, Završna dokumentacija) kako bi odražavala napredak i promjene u projektu.
*   **Koordinacija komunikacije s profesorom kao "Osoba za komunikaciju"**

---

## Planirane Funkcionalnosti Sustava (prema Sažetku Projekta)

*   Pregledavanje baze po logičnim kategorijama (pravila, tekuća igra).
*   Učitavanje i generiranje podataka iz/u .csv ili .json formata ("saves", pravila).
*   Mogućnost promjene pravila, dodavanja novih ili brisanja starih.
*   Izrada likova s prikazom svih relevantnih informacija i izbora.
*   Različita korisnička dopuštenja (Igrač vs. Game Master).
*   Automatske interakcije između različitih mehanika igre (npr. praćenje inventara, izračun ishoda napada, praćenje poteza).
*   Sustav za "odmaranje" likova.
*   Sustav za praćenje pozicija, efekata i kolizija na 2D "mapi".
*   Sustav za praćenje misija (nagrade, ciljevi, sudionici, ishodi) i alati za Game Mastera za njihovu izradu.
*   Tutorial za korištenje sustava (odvojeno za igrače i Game Mastera).

---

## Korišteni Alati i Tehnologije (Planirano i Korišteno)

*   **Baza podataka i modeliranje:**
    *   MySQL Workbench (Razvoj baze, EER Diagrami, pisanje upita i procedura)
    *   Lucidchart (Izrada ER Dijagrama)
    *   DBDiagramIO (Brzo skiciranje ERD-a - inicijalno)
*   **Verzioniranje:**
    *   GitHub / Git
*   **Programiranje sučelja (planirano):**
    *   Python (s bibliotekama poput `pyodbc` za bazu i `PyQt6` za UI)
    *   Web Tehnologije (HTML, CSS, JavaScript, s frameworkom poput Tailwind i Vue)
*   **Komunikacija:**
    *   Discord
    *   WhatsApp
*   **Dokumentacija:**
    *   Dillinger (za Markdown)
    *   Google Docs (za finalnu dokumentaciju)
*   **Razvojno okruženje:**
    *   VSCode

---

**Link na originalni timski repozitorij:** [https://github.com/JurajSternVukotic/unipu-game-studio](https://github.com/JurajSternVukotic/unipu-game-studio)
