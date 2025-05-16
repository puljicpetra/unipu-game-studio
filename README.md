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

---
---
*(English Version Below)*
---
---

# Project: GAME STUDIO (Fork)

**Course:** Databases II

**Course Supervisor:** Asst. Prof. Goran Oreški, PhD

**Lab Instructor:** Romeo Šajina, M.Sc. Inf.

**Faculty:** Faculty of Informatics in Pula

**Original Team:** "Tim-1"

**Note:** This repository is a **fork** of the original team project "GAME STUDIO" developed as part of the "Databases II" course. It primarily serves to showcase my individual contribution and work on that project, and as an archive of project materials.

---

## About the "GAME STUDIO" Project

The "GAME STUDIO" project focuses on the development of a comprehensive database supporting a tabletop role-playing game (RPG) based on the popular "Dungeons and Dragons" (D&D) system. The goal was to thoroughly study the subject, design, and implement a software solution using a relational database (MySQL) for data storage, management, and facilitation of gameplay.

The system is designed to manage various aspects of the game, including:
*   **Creatures/Characters:** Attributes (races, classes, alignments, sizes), abilities (skills, proficiencies), hit points (health), initiative.
*   **Game World:** Maps, objects on maps, game instances.
*   **Game Mechanics:** Spells, magic components, areas of effect (AoE), equipment (weapons, armor), combat (damage types, conditions, attacks), experience points (challenge rating, experience).
*   **Players:** Character creation, inventory tracking, character backgrounds, personalities.

The database is designed to be complex and detailed, with an emphasis on an advanced implementation of SQL elements such as:
*   A large number of **tables** (over 50 in the final version) to model all aspects of the game.
*   **Complex queries** for data retrieval and manipulation.
*   **Views** for simplified access to frequently used data.
*   **Stored procedures** to encapsulate complex operations (e.g., character creation, combat turns).
*   **Triggers** to automate processes (e.g., updating hit points, checking inventory).
*   **Functions** for in-game calculations (e.g., damage calculation, action outcomes).
*   **Transactions** to ensure data integrity.

In addition to the database, the development of a software interface (console or graphical) was planned to allow users to interact with the system.

---

## Original "Tim-1" Project Team and My Contribution

**Original team members:**
*   **Karlo Bazina:** Programmer - Frontend Developer
*   **Tomas Mikašinović-Komšo:** Programmer - Graphics Designer
*   **Petra Puljić:** Communication Lead - Documentation Production Manager
*   **Jakov Benedikt Ružić:** Quality Assurance Engineer - Human Resources
*   **Juraj Štern-Vukotić:** Team Lead - Tech Lead Senior Software Architect
*   **Mateo Udovičić:** Programmer - Backend Developer

### My Specific Contribution to the Project (Petra Puljić):

My contribution to the project included work on ensuring data functionality and integrity through SQL triggers, functions, and procedures, as well as maintaining and updating project documentation. Specifically, I implemented and presented:

*   **SQL Triggers for the `notes` table:**
    *   **`bi_notes`:** A trigger that automatically generates a title for a new note (e.g., "Note X") if the user did not enter a title or entered an empty string.
    *   **`bi_notes_timestamp`:** A trigger that automatically sets the creation time (`created_at`) and last modification time (`modified_at`) to the current timestamp when inserting a new note.
    *   **`bu_notes_timestamp`:** A trigger that automatically updates the last modification time (`modified_at`) to the current timestamp upon each modification of an existing note.
*   **SQL Function `get_player_character_info`:**
    *   A function that takes `player_character_id` as an input parameter and returns a string with information about the player character, including player name, race, class, and level. If a character with the requested ID does not exist, the function returns an appropriate message.
*   **SQL Stored Procedure `GetPlayerInfo`:**
    *   A procedure that takes `player_character_id` and retrieves information about current hit points (`current_hp`) and creature name (`creature_name`). Based on `current_hp`, the procedure also returns the character's status ('Alive' or 'Dead'). If the character does not exist, a corresponding message is returned.
*   **Maintenance and Updating of Project Documentation:**
    *   I continuously worked on updating and aligning all parts of the project documentation (Project Summary, Reports, Final Documentation) to reflect the project's progress and changes.
*   **Coordination of communication with the professor as "Communication Lead"**

---

## Planned System Functionalities (according to the Project Summary)

*   Browsing the database by logical and useful categories (rules, current game).
*   Loading and generating data from/to .csv or .json formats ("saves", rules).
*   Ability to change rules, add new ones, or delete old ones.
*   Character creation with a display of all relevant information and choices.
*   Different user permissions (Player vs. Game Master).
*   Automatic interactions between different game mechanics (e.g., inventory tracking, calculating attack outcomes, turn tracking).
*   System for character "resting."
*   System for tracking positions, effects, and collisions on a 2D "map."
*   System for tracking quests (rewards, objectives, participants, outcomes) and tools for the Game Master to create them.
*   Tutorial for using the system (separate for players and Game Masters).

---

## Tools and Technologies Used (Planned and Used)

*   **Database and Modeling:**
    *   MySQL Workbench (Database development, EER Diagrams, writing queries and procedures)
    *   Lucidchart (ER Diagram creation)
    *   DBDiagramIO (Quick ERD sketching - initial)
*   **Versioning:**
    *   GitHub / Git
*   **Interface Programming (planned):**
    *   Python (with libraries like `pyodbc` for database and `PyQt6` for UI)
    *   Web Technologies (HTML, CSS, JavaScript, with frameworks like Tailwind and Vue)
*   **Communication:**
    *   Discord
    *   WhatsApp
*   **Documentation:**
    *   Dillinger (for Markdown)
    *   Google Docs (for final documentation)
*   **Development Environment:**
    *   VSCode

---

**Link to the original team repository:** [https://github.com/JurajSternVukotic/unipu-game-studio](https://github.com/JurajSternVukotic/unipu-game-studio)
