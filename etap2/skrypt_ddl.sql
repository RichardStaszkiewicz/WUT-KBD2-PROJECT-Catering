SET SQLBLANKLINES ON

CREATE OR REPLACE PACKAGE OGOLNE
-- zawiera stale globalne
AS
  FUNCTION F_ID_FIRMY_GLOWNEJ RETURN number DETERMINISTIC RESULT_CACHE;
  ID_FIRMY_GLOWNEJ CONSTANT NUMBER(7, 0) := 1;
END OGOLNE;
/

CREATE OR REPLACE PACKAGE BODY OGOLNE
-- zawiera stale globalne
AS
  FUNCTION F_ID_FIRMY_GLOWNEJ RETURN number DETERMINISTIC RESULT_CACHE
  -- umozliwia uzycie stalej OGOLNE.ID_FIRMY_GLOWNEJ w skryptach DDL
  IS
  BEGIN
    RETURN OGOLNE.ID_FIRMY_GLOWNEJ;
  END F_ID_FIRMY_GLOWNEJ;
END OGOLNE;
/

CREATE SEQUENCE BANKI_SEQ INCREMENT BY 1 start with 1 MAXVALUE 999;
CREATE SEQUENCE DANIA_SEQ INCREMENT BY 1 start with 1 MAXVALUE 999;
CREATE SEQUENCE DOSTAWY_SEQ INCREMENT BY 1 start with 1 MAXVALUE 9999999;
CREATE SEQUENCE FAKTURY_SEQ INCREMENT BY 1 start with 1 MAXVALUE 9999999;
CREATE SEQUENCE JEDNOSTKI_SEQ INCREMENT BY 1 start with 1 MAXVALUE 99;
CREATE SEQUENCE KAT_POD_SEQ INCREMENT BY 1 start with 1 MAXVALUE 99;
CREATE SEQUENCE KONTRAHENCI_SEQ INCREMENT BY 1 start with 1 MAXVALUE 99999;
CREATE SEQUENCE STA_ZAM_SEQ INCREMENT BY 1 start with 1 MAXVALUE 99;
CREATE SEQUENCE TOWARY_SEQ INCREMENT BY 1 start with 1 MAXVALUE 9999;
CREATE SEQUENCE ZAMOWIENIA_SEQ INCREMENT BY 1 start with 1 MAXVALUE 9999999;

CREATE TABLE BANKI 
(
  ID_BANKU NUMBER(3, 0) DEFAULT ON NULL BANKI_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(50) NOT NULL 
, CONSTRAINT BANKI_PK PRIMARY KEY 
  (
    ID_BANKU 
  )
  ENABLE 
) 
ORGANIZATION INDEX;

CREATE TABLE DANIA 
(
  ID_DANIA NUMBER(3, 0) DEFAULT ON NULL DANIA_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(30) NOT NULL 
, OPIS VARCHAR2(200) 
, CENA NUMBER(5, 2) NOT NULL 
, DOSTEPNOSC NUMBER(3, 0) DEFAULT 0 NOT NULL 
, CONSTRAINT DANIA_PK PRIMARY KEY 
  (
    ID_DANIA 
  )
  ENABLE 
);

CREATE TABLE JEDNOSTKI 
(
  ID_JEDNOSTKI NUMBER(2, 0) DEFAULT ON NULL JEDNOSTKI_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(30) NOT NULL 
, SKROT VARCHAR2(10) NOT NULL 
, CONSTRAINT JEDNOSTKI_PK PRIMARY KEY 
  (
    ID_JEDNOSTKI 
  )
  ENABLE 
) 
ORGANIZATION INDEX;

CREATE TABLE KATEGORIE_PODATKOWE 
(
  ID_KATEGORII NUMBER(2, 0) ON NULL KAT_POD_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(30) NOT NULL 
, OPODATKOWANIE NUMBER(2, 0) NOT NULL 
, CONSTRAINT KATEGORIE_PK PRIMARY KEY 
  (
    ID_KATEGORII 
  )
  ENABLE 
) 
ORGANIZATION INDEX;

CREATE TABLE STATUSY_ZAMOWIEN 
(
  ID_STATUSU NUMBER(2, 0) ON NULL STA_ZAM_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(20) NOT NULL 
, CONSTRAINT STATUSY_ZAMOWIEN_PK PRIMARY KEY 
  (
    ID_STATUSU 
  )
  ENABLE 
) 
ORGANIZATION INDEX;

CREATE TABLE KONTRAHENCI 
(
  ID_KONTRAHENTA NUMBER(5, 0) ON NULL KONTRAHENCI_SEQ.NEXTVAL NOT NULL 
, IMIE VARCHAR2(20) 
, NAZWISKO VARCHAR2(40) 
, NAZWA VARCHAR2(50) 
, NIP CHAR(10) 
, MAIL VARCHAR2(40) NOT NULL 
, TELEFON VARCHAR2(15) NOT NULL 
, ID_BANKU NUMBER(3, 0) 
, NR_KONTA VARCHAR2(26) 
, CZY_FIRMA CHAR(1) DEFAULT 0 NOT NULL
, MIEJSCOWOSC VARCHAR2(40) NOT NULL 
, KOD_POCZTOWY VARCHAR2(6) NOT NULL 
, NAZWA_ULICY VARCHAR2(40) 
, NR_BUDYNKU VARCHAR2(10) NOT NULL 
, NR_LOKALU VARCHAR2(10) 
, CONSTRAINT KONTRAHENCI_PK PRIMARY KEY 
  (
    ID_KONTRAHENTA 
  )
  ENABLE 
);

CREATE TABLE TOWARY 
(
  ID_TOWARU NUMBER(4, 0) ON NULL TOWARY_SEQ.NEXTVAL NOT NULL 
, NAZWA VARCHAR2(40) NOT NULL 
, OPIS VARCHAR2(150) 
, ILOSC NUMBER(5, 2) DEFAULT 0 NOT NULL 
, ID_JEDNOSTKI NUMBER(2, 0) NOT NULL 
, ID_KATEGORII NUMBER(2, 0) NOT NULL 
, CONSTRAINT TOWARY_PK PRIMARY KEY 
  (
    ID_TOWARU 
  )
  ENABLE 
);

CREATE TABLE DOSTAWY 
(
  ID_DOSTAWY NUMBER(7, 0) ON NULL DOSTAWY_SEQ.NEXTVAL NOT NULL 
, DATA_DOSTAWY DATE NOT NULL 
, ID_DOSTAWCY NUMBER(5, 0) NOT NULL 
, CONSTRAINT DOSTAWY_PK PRIMARY KEY 
  (
    ID_DOSTAWY 
  )
  ENABLE 
);

CREATE TABLE FAKTURY 
(
  ID_FAKTURY NUMBER(7, 0) ON NULL FAKTURY_SEQ.NEXTVAL NOT NULL 
, NR_FAKTURY VARCHAR2(20) NOT NULL 
, ID_NABYWCY NUMBER(5, 0) NOT NULL 
, ID_SPRZEDAWCY NUMBER(5, 0) NOT NULL 
, DATA_WYSTAWIENIA DATE NOT NULL 
, DATA_ZAPLATY DATE 
, TERMIN_ZAPLATY DATE NOT NULL 
, STAWKA_VAT NUMBER(3, 0) NOT NULL 
, SPOSOB_ZAPLATY CHAR(1) DEFAULT 0 
, NETTO NUMBER(7, 2) NOT NULL 
, VAT NUMBER(7, 2) NOT NULL 
, BRUTTO NUMBER(7, 2) NOT NULL 
, WARTOSC_KWOTY_SLOWNIE VARCHAR2(100) NOT NULL
, CZY_WYCHODZACA CHAR(1 BYTE) AS ( CASE "ID_NABYWCY" WHEN OGOLNE.F_ID_FIRMY_GLOWNEJ() THEN '1' ELSE '0' END ) VIRTUAL
, CONSTRAINT FAKTURY_PK PRIMARY KEY 
  (
    ID_FAKTURY 
  )
  ENABLE 
)
PARTITION BY RANGE (DATA_WYSTAWIENIA) 
(
  PARTITION FAKTURY_STARE VALUES LESS THAN (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_4 
, PARTITION FAKTURY_2021 VALUES LESS THAN (TO_DATE(' 2022-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_3 
, PARTITION FAKTURY_2022 VALUES LESS THAN (TO_DATE(' 2023-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_2   
, PARTITION FAKTURY_2023 VALUES LESS THAN (TO_DATE(' 2024-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_1  
);

CREATE TABLE ZAMOWIENIA 
(
  ID_ZAMOWIENIA NUMBER(7, 0) ON NULL ZAMOWIENIA_SEQ.NEXTVAL NOT NULL 
, DATA_ZAMOWIENIA DATE NOT NULL 
, STATUS NUMBER(2, 0) NOT NULL 
, ID_KLIENTA NUMBER(5, 0) NOT NULL 
, CONSTRAINT ZAMOWIENIA_PK PRIMARY KEY 
  (
    ID_ZAMOWIENIA 
  )
  ENABLE 
) 
PARTITION BY RANGE (DATA_ZAMOWIENIA) 
(
  PARTITION ZAMOWIENIA_STARE VALUES LESS THAN (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_1 
, PARTITION ZAMOWIENIA_2021 VALUES LESS THAN (TO_DATE(' 2022-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_2 
, PARTITION ZAMOWIENIA_2022 VALUES LESS THAN (TO_DATE(' 2023-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_3   
, PARTITION ZAMOWIENIA_2023 VALUES LESS THAN (TO_DATE(' 2024-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) 
  TABLESPACE KBD2_4
);

CREATE TABLE SKLADNIKI_DAN 
(
  ID_DANIA NUMBER(3, 0) NOT NULL 
, ID_TOWARU NUMBER(4, 0) NOT NULL 
, ILOSC NUMBER(4, 2) NOT NULL 
, CONSTRAINT SKLADNIKI_DAN_PK PRIMARY KEY 
  (
    ID_DANIA 
  , ID_TOWARU 
  )
  ENABLE 
);

CREATE TABLE POZYCJE_DOSTAW 
(
  ID_DOSTAWY NUMBER(7, 0) NOT NULL 
, ID_TOWARU NUMBER(4, 0) NOT NULL 
, ILOSC NUMBER(5, 2) NOT NULL 
, CENA_JEDNOSTKOWA NUMBER(6, 2) NOT NULL 
, SERIA VARCHAR2(30) 
, DATA_WAZNOSCI DATE 
, CONSTRAINT POZYCJE_DOSTAW_PK PRIMARY KEY 
  (
    ID_DOSTAWY 
  , ID_TOWARU 
  )
  ENABLE 
);

CREATE TABLE POZYCJE_FAKTUR 
(
  ID_FAKTURY NUMBER(7, 0) NOT NULL 
, NR_POZYCJI NUMBER(4, 0) NOT NULL 
, NAZWA VARCHAR2(50) NOT NULL 
, ILOSC NUMBER(4, 0) NOT NULL 
, ID_JEDNOSTKI NUMBER(2, 0) 
, DATA_WYKONANIA DATE 
, NETTO NUMBER(6, 2) NOT NULL 
, VAT NUMBER(6, 2) NOT NULL 
, BRUTTO NUMBER(6, 2) NOT NULL 
, CONSTRAINT POZYCJE_FAKTUR_PK PRIMARY KEY 
  (
    ID_FAKTURY 
  , NR_POZYCJI 
  )
  ENABLE 
, CONSTRAINT POZYCJE_FAKTUR_F_FK FOREIGN KEY
  (
    ID_FAKTURY 
  )
  REFERENCES FAKTURY
  (
    ID_FAKTURY 
  )
  ENABLE
)
PARTITION BY REFERENCE (POZYCJE_FAKTUR_F_FK);

CREATE TABLE POZYCJE_ZAMOWIEN 
(
  ID_ZAMOWIENIA NUMBER(7, 0) NOT NULL 
, ID_DANIA NUMBER(3, 0) NOT NULL 
, ILOSC NUMBER(3, 0) NOT NULL 
, WARTOSC NUMBER(6, 2) NOT NULL 
, CONSTRAINT POZYCJE_ZAMOWIEN_PK PRIMARY KEY 
  (
    ID_ZAMOWIENIA 
  , ID_DANIA 
  )
  ENABLE
, CONSTRAINT POZYCJE_ZAMOWIEN_FK FOREIGN KEY
  (
    ID_ZAMOWIENIA 
  )
  REFERENCES ZAMOWIENIA
  (
    ID_ZAMOWIENIA 
  )
  ON DELETE CASCADE ENABLE
)
PARTITION BY REFERENCE (POZYCJE_ZAMOWIEN_FK);

CREATE INDEX FAKTURY_ROK_MIESIAC_INDEX ON FAKTURY (EXTRACT(YEAR FROM "DATA_WYSTAWIENIA") DESC, EXTRACT(MONTH FROM "DATA_WYSTAWIENIA") DESC);

CREATE INDEX DOSTAWY_DOSTAWCY_INDEX ON DOSTAWY (ID_DOSTAWCY ASC);

CREATE INDEX FAKTURY_NABYWCY_INDEX ON FAKTURY (ID_NABYWCY ASC);

CREATE INDEX FAKTURY_SPRZEDAWCY_INDEX ON FAKTURY (ID_SPRZEDAWCY ASC);

CREATE INDEX KONTRAHENCI_BANK_INDEX ON KONTRAHENCI (ID_BANKU ASC);

CREATE INDEX POZYCJE_DOSTAW_T_INDEX ON POZYCJE_DOSTAW (ID_TOWARU ASC);

CREATE INDEX POZYCJE_ZAMOWIEN_D_INDEX ON POZYCJE_ZAMOWIEN (ID_DANIA ASC);

CREATE INDEX SKLADNIKI_DAN_T_INDEX ON SKLADNIKI_DAN (ID_TOWARU ASC);

CREATE INDEX TOWARY_JEDNOSTKI_INDEX ON TOWARY (ID_JEDNOSTKI ASC);

CREATE INDEX TOWARY_KATEGORIE_INDEX ON TOWARY (ID_KATEGORII ASC);

CREATE INDEX ZAMOWIENIA_KLIENCI_INDEX ON ZAMOWIENIA (ID_KLIENTA ASC);

CREATE INDEX ZAMOWIENIA_STATUSY_INDEX ON ZAMOWIENIA (STATUS ASC);

ALTER TABLE BANKI
ADD CONSTRAINT BANKI_NAZWA_UK UNIQUE 
(
  NAZWA 
)
ENABLE;

ALTER TABLE JEDNOSTKI
ADD CONSTRAINT JEDNOSTKI_NAZWA_UK UNIQUE 
(
  NAZWA 
)
USING INDEX 
(
    CREATE UNIQUE INDEX JEDNOSTKI_UK ON JEDNOSTKI (NAZWA ASC) 
)
 ENABLE;

ALTER TABLE KATEGORIE_PODATKOWE
ADD CONSTRAINT KATEGORIE_NAZWA_UK UNIQUE 
(
  NAZWA 
)
USING INDEX 
(
    CREATE UNIQUE INDEX KATEGORIE_PODATKOWE_UK ON KATEGORIE_PODATKOWE (NAZWA ASC) 
)
 ENABLE;

ALTER TABLE KONTRAHENCI
ADD CONSTRAINT KONTRAHENCI_MAIL_UK UNIQUE 
(
  MAIL 
)
ENABLE;

ALTER TABLE KONTRAHENCI
ADD CONSTRAINT KONTRAHENCI_NIP_UK UNIQUE 
(
  NIP 
)
ENABLE;

ALTER TABLE STATUSY_ZAMOWIEN
ADD CONSTRAINT STATUSY_NAZWA_UK UNIQUE 
(
NAZWA
  )
ENABLE;

ALTER TABLE TOWARY
ADD CONSTRAINT TOWARY_NAZWA_UK UNIQUE 
(
NAZWA
  )
ENABLE;

ALTER TABLE DOSTAWY
ADD CONSTRAINT DOSTAWY_DOSTAWCY_FK FOREIGN KEY
(
  ID_DOSTAWCY 
)
REFERENCES KONTRAHENCI
(
  ID_KONTRAHENTA 
)
ENABLE;

ALTER TABLE FAKTURY
ADD CONSTRAINT FAKTURY_NABYWCY_FK FOREIGN KEY
(
  ID_NABYWCY 
)
REFERENCES KONTRAHENCI
(
  ID_KONTRAHENTA 
)
ENABLE;

ALTER TABLE FAKTURY
ADD CONSTRAINT FAKTURY_SPRZEDAWCY_FK FOREIGN KEY
(
  ID_SPRZEDAWCY 
)
REFERENCES KONTRAHENCI
(
  ID_KONTRAHENTA 
)
ENABLE;

ALTER TABLE KONTRAHENCI
ADD CONSTRAINT KONTRAHENCI_BANK_FK FOREIGN KEY
(
  ID_BANKU 
)
REFERENCES BANKI
(
  ID_BANKU 
)
ENABLE;

ALTER TABLE POZYCJE_DOSTAW
ADD CONSTRAINT POZYCJE_DOSTAW_DOSTAWY_FK FOREIGN KEY
(
  ID_DOSTAWY 
)
REFERENCES DOSTAWY
(
  ID_DOSTAWY 
)
ON DELETE CASCADE ENABLE;

ALTER TABLE POZYCJE_DOSTAW
ADD CONSTRAINT POZYCJE_DOSTAW_TOWARY_FK FOREIGN KEY
(
  ID_TOWARU 
)
REFERENCES TOWARY
(
  ID_TOWARU 
)
ON DELETE CASCADE ENABLE;

ALTER TABLE POZYCJE_FAKTUR
ADD CONSTRAINT POZYCJE_FAKTUR_J_FK FOREIGN KEY
(
  ID_JEDNOSTKI 
)
REFERENCES JEDNOSTKI
(
  ID_JEDNOSTKI 
)
ENABLE;

ALTER TABLE POZYCJE_ZAMOWIEN
ADD CONSTRAINT POZYCJE_ZAMOWIEN_DANIA_FK FOREIGN KEY
(
  ID_DANIA 
)
REFERENCES DANIA
(
  ID_DANIA 
)
ON DELETE CASCADE ENABLE;

ALTER TABLE SKLADNIKI_DAN
ADD CONSTRAINT SKLADNIKI_DAN_DANIA_FK FOREIGN KEY
(
  ID_DANIA 
)
REFERENCES DANIA
(
  ID_DANIA 
)
ON DELETE CASCADE ENABLE;

ALTER TABLE SKLADNIKI_DAN
ADD CONSTRAINT SKLADNIKI_DAN_TOWARY_FK FOREIGN KEY
(
  ID_TOWARU 
)
REFERENCES TOWARY
(
  ID_TOWARU 
)
ON DELETE CASCADE ENABLE;

ALTER TABLE TOWARY
ADD CONSTRAINT TOWARY_JEDNOSTKI_FK FOREIGN KEY
(
  ID_JEDNOSTKI 
)
REFERENCES JEDNOSTKI
(
  ID_JEDNOSTKI 
)
ENABLE;

ALTER TABLE TOWARY
ADD CONSTRAINT TOWARY_KATEGORIE_FK FOREIGN KEY
(
  ID_KATEGORII 
)
REFERENCES KATEGORIE_PODATKOWE
(
  ID_KATEGORII 
)
ENABLE;

ALTER TABLE ZAMOWIENIA
ADD CONSTRAINT ZAMOWIENIA_KLIENCI_FK FOREIGN KEY
(
  ID_KLIENTA 
)
REFERENCES KONTRAHENCI
(
  ID_KONTRAHENTA 
)
ENABLE;

ALTER TABLE ZAMOWIENIA
ADD CONSTRAINT ZAMOWIENIA_STATUS_FK FOREIGN KEY
(
  STATUS 
)
REFERENCES STATUSY_ZAMOWIEN
(
  ID_STATUSU 
)
ENABLE;

ALTER TABLE FAKTURY
ADD CONSTRAINT FAKTURY_PARTIE_CHK CHECK 
(ID_NABYWCY != ID_SPRZEDAWCY)
ENABLE;

ALTER TABLE KONTRAHENCI
ADD CONSTRAINT KONTRAHENCI_CZY_FIRMA_CHK CHECK 
(CZY_FIRMA IN ('0', '1'))
ENABLE;

ALTER TABLE KONTRAHENCI
ADD CONSTRAINT KONTRAHENCI_WYMAGANE_DANE CHECK
(1 = (CASE WHEN CZY_FIRMA = 1 AND NIP IS NOT NULL AND NAZWA IS NOT NULL THEN 1 WHEN CZY_FIRMA = 0 AND IMIE IS NOT NULL AND NAZWISKO IS NOT NULL THEN 1 ELSE 0 END))
ENABLE;

COMMENT ON COLUMN KONTRAHENCI.KOD_POCZTOWY IS 'Polski format kodu pocztowego';

COMMENT ON TABLE JEDNOSTKI IS 'Tabela slownikowa z dostepnymi jednostkami, w ktorych wyrazone moga byc produkty.';

COMMENT ON TABLE KATEGORIE_PODATKOWE IS 'Tabela slownikowa z kategoriami produktow spozywczych';

COMMENT ON TABLE DANIA IS 'Zawiera dania z menu wraz z obecna dostepnoscia i cena.';

COMMENT ON TABLE SKLADNIKI_DAN IS 'Zawiera przyporzadkowania uzywanych skladnikow do dan.';

COMMENT ON TABLE DOSTAWY IS 'Zawiera odebrane dostawy.';

COMMENT ON TABLE POZYCJE_DOSTAW IS 'Zawiera dostarczone towary z ich iloscia, cena i data waznosci.';

COMMENT ON TABLE FAKTURY IS 'Zawiera szczegolowe dane faktur, zarowno wystawione firmie jak i przez firme.';

COMMENT ON TABLE POZYCJE_FAKTUR IS 'Zawiera pojedyncze pozycje na fakturze. Sumy wartosci netto vat i brutto pozycji sa zapisywane na fakturze.';

COMMENT ON TABLE KONTRAHENCI IS 'Zawiera dane kontrahentow, ktorzy moga byc osoba fizyczna i firma (koniecznie jeden rekord musi reprezentowac firme korzystajaca z systemu).';

COMMENT ON TABLE BANKI IS 'Zawiera informacje o bankach uzywanych przez kontrahentow.';

COMMENT ON TABLE STATUSY_ZAMOWIEN IS 'Zawiera wszystkie statusy, w ktorych moga byc zamowienia.';

COMMENT ON TABLE TOWARY IS 'Zawiera skladowane przez firme towary wraz z ich aktualnym stanem na magazynie.';

COMMENT ON TABLE ZAMOWIENIA IS 'Zawiera zamowienia zlozone przez klientow.';

COMMENT ON TABLE POZYCJE_ZAMOWIEN IS 'Zawiera zamowione przez klientow dania, wraz z iloscia w sztukach.';

COMMENT ON COLUMN DANIA.DOSTEPNOSC IS 'Ile sztuk danego dania mozna obecnie wytworzyc z towarow na magazynie.';

COMMENT ON COLUMN FAKTURY.NETTO IS 'Suma netto pozycji faktury.';

COMMENT ON COLUMN FAKTURY.VAT IS 'Suma VAT pozycji faktury.';

COMMENT ON COLUMN FAKTURY.BRUTTO IS 'Suma brutto pozycji faktury.';

COMMENT ON COLUMN FAKTURY.CZY_WYCHODZACA IS 'Ma wartosc ''1'' jesli firma musi za nia zaplacic lub ''0'' jesli ktos za nia zaplaci firmie''.';

COMMENT ON TABLE BILANS_ZESTAWIENIE IS 'Suma netto przychodow i rozchodow oraz roznica za kazdy miesiac dzialalnosci. Wygodne podsumowanie zyskow i strat firmy';

COMMENT ON TABLE DANIA_ZAMOWIENIA_ZESTAWIENIE IS 'Miesieczne zestawienie najpopularniejszych dan. Prosta analiza popularnosci poszczegolnych dan.';

COMMENT ON TABLE K_ZAMOWIENIA_MIESIAC IS 'Analiza czestotliwosci korzystania z uslug przez danych klientow wraz z sumaryczna kwota przez nich wydana.';

COMMENT ON TABLE PRZYCHODY_ZESTAWIENIE IS 'Lista przychodow w danym miesiacu uzyskanych przez firme.';

COMMENT ON TABLE ROZCHODY_ZESTAWIENIE_PODATKI IS 'Suma VATu zaplaconego w danym miesiacu wg danej stawki.';

COMMENT ON TABLE ROZCHODY_ZESTAWIENIE_TOWARY IS 'Zestawienie wydatkow na dane towary z uwzgledeniem ceny jednostkowej.';

COMMENT ON TABLE K_ZAMOWIENIA_MIESIAC IS 'Zestawienie klientow korzystajacych z uslug w ostatnim miesiacu.';


CREATE TRIGGER TR_USUNIETE_DANIA 
    AFTER DELETE ON dania
    FOR EACH ROW
-- wyzwalacz usuwajacy zamowienia usunietych dan
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    -- kursor iterujacy po zamowieniach
    CURSOR c_zamowienia IS
    SELECT z.status
    FROM zamowienia z INNER JOIN POZYCJE_ZAMOWIEN zp
    ON z.id_zamowienia = zp.id_zamowienia
    WHERE zp.id_dania = :old.id_dania;

    row_zamowienia c_zamowienia%ROWTYPE;
BEGIN
    OPEN c_zamowienia;

    LOOP
    -- petla przechodzaca po kolejnych zamowieniach
    FETCH c_zamowienia INTO row_zamowienia;
    EXIT WHEN c_zamowienia%NOTFOUND;

    -- ustawianie statusu na 'odwoany automatycznie'
    row_zamowienia.status := 3;
    END LOOP;

    CLOSE c_zamowienia;
    COMMIT;
END;
/

CREATE TRIGGER TR_ZMIENIONE_TOWARY 
    AFTER INSERT OR UPDATE OR DELETE ON towary
-- wyzwalacz aktualizujacy dostepnosc dan po zmianie ilosci towarow
DECLARE
    -- kursor iterujacy po daniach dotknietych zmiana
    CURSOR c_dania IS
    SELECT d.id_dania, d.dostepnosc
    FROM dania d
    INNER JOIN skladniki_dan dk
    ON d.id_dania = dk.id_dania
    INNER JOIN towary t
    ON dk.id_towaru = t.id_towaru
    FOR UPDATE OF dostepnosc;

    row_dania c_dania%ROWTYPE;
BEGIN
    OPEN c_dania;    
    LOOP 
    FETCH c_dania INTO row_dania;
    EXIT WHEN c_dania%NOTFOUND;
     -- obliczamy maksymalna ilosc dan jaka mozemy wyprodukowac oraz ustawiamy ja jako dostepnosc
    SELECT MIN(FLOOR(t.ilosc / dk.ilosc)) INTO row_dania.dostepnosc
    FROM towary t
    INNER JOIN SKLADNIKI_DAN dk
    ON dk.id_towaru = t.id_towaru
    WHERE dk.id_dania = row_dania.id_dania;
    UPDATE dania d SET d.dostepnosc = row_dania.dostepnosc WHERE d.id_dania = row_dania.id_dania;
    END LOOP;
    CLOSE c_dania;
END;
/

CREATE TRIGGER TR_ZMIENIONY_SKLAD_DAN 
    AFTER INSERT OR UPDATE OR DELETE ON SKLADNIKI_DAN
-- wyzwalacz aktualizujacy dostepnosc dan po zmianie skladnikow potrzebnych do wyprodukowania dan
DECLARE
    -- kursor iterujacy po daniach dotknietych zmiana
    CURSOR c_dania IS
    SELECT d.id_dania, d.dostepnosc
    FROM dania d
    INNER JOIN skladniki_dan dk
    ON d.id_dania = dk.id_dania
    INNER JOIN towary t
    ON dk.id_towaru = t.id_towaru
    FOR UPDATE OF dostepnosc;

    row_dania c_dania%ROWTYPE;
BEGIN
    OPEN c_dania;    
    LOOP 
    FETCH c_dania INTO row_dania;
    EXIT WHEN c_dania%NOTFOUND;
     -- obliczamy maksymalna ilosc dan jaka mozemy wyprodukowac oraz ustawiamy ja jako dostepnosc
    SELECT MIN(FLOOR(t.ilosc / dk.ilosc)) INTO row_dania.dostepnosc
    FROM towary t
    INNER JOIN SKLADNIKI_DAN dk
    ON dk.id_towaru = t.id_towaru
    WHERE dk.id_dania = row_dania.id_dania;
    UPDATE dania d SET d.dostepnosc = row_dania.dostepnosc WHERE d.id_dania = row_dania.id_dania;
    END LOOP;
    CLOSE c_dania;
END;
/

CREATE OR REPLACE TRIGGER TR_FAKTURY_ID_FIRMY_GLOWNEJ 
    BEFORE INSERT OR UPDATE ON FAKTURY
	FOR EACH ROW
-- wymusza zachowywanie w bazie tylko faktur zwiazanych z owczesna firma glowna
BEGIN
	IF (:NEW.ID_SPRZEDAWCY <> OGOLNE.F_ID_FIRMY_GLOWNEJ() AND :NEW.ID_NABYWCY <> OGOLNE.F_ID_FIRMY_GLOWNEJ())
	THEN
		RAISE_APPLICATION_ERROR(-20001, 'Faktura musi byc zwiazana z firma glowna');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER TR_ZMIANA_POZYCJI_FAKTURY
    AFTER INSERT OR UPDATE OR DELETE ON POZYCJE_FAKTUR
    FOR EACH ROW
-- wyzwalacz aktualizujacy faktury po zmianie w pozycjach
DECLARE
    old_netto faktury.netto%TYPE;
    old_vat faktury.vat%TYPE;
    old_brutto faktury.brutto%TYPE;
    new_netto faktury.netto%TYPE;
    new_vat faktury.vat%TYPE;
    new_brutto faktury.brutto%TYPE;
BEGIN
    -- przypisanie wartosci do zmiennych
    old_netto := NVL(:old.netto, 0);
    old_vat := NVL(:old.vat, 0);
    old_brutto := NVL(:old.brutto, 0);
    new_netto := NVL(:new.netto, 0);
    new_vat := NVL(:new.vat, 0);
    new_brutto := NVL(:new.brutto, 0);

    UPDATE faktury f
    SET
    -- aktualizowanie o roznice wartosci netto, vat i brutto zmienionej pozycji
        f.netto = f.netto - old_netto + new_netto,
        f.vat = f.vat - old_vat + new_vat,
        f.brutto = f.brutto - old_brutto + new_brutto
    WHERE f.id_faktury = :old.id_faktury
    OR f.id_faktury = :new.id_faktury;
END;
/

CREATE OR REPLACE TRIGGER TR_DOMYSLNA_WARTOSC 
    BEFORE INSERT OR UPDATE ON POZYCJE_ZAMOWIEN
    FOR EACH ROW
-- wyzwalacz wstawiajacy domyslna wartosc pozycji zamowienia, czyli ilosc zamowionych dan razy ich cena z menu
DECLARE
    cenaDania dania.cena%TYPE;
BEGIN
    IF (:NEW.WARTOSC IS NULL OR :NEW.ilosc <> :OLD.ilosc)
    THEN
        select cena into cenaDania
        from dania
        where ID_DANIA = :new.id_dania;

        :new.wartosc := :new.ilosc * cenaDania;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE dodaj_towary(p_id_dostawy IN NUMBER) AS
    -- Procedura dodajaca wszystkie towary z danej dostawy do stanu magazynowego
    CURSOR c_pozycje_dostaw IS
    SELECT ilosc, id_towaru
    FROM pozycje_dostaw
    WHERE id_dostawy = p_id_dostawy;
    
    row_pozycje_dostaw c_pozycje_dostaw%ROWTYPE;
BEGIN
    OPEN c_pozycje_dostaw;
    LOOP
    FETCH c_pozycje_dostaw INTO row_pozycje_dostaw;
    EXIT WHEN c_pozycje_dostaw%NOTFOUND;
    -- zwieksz ilosc w magazynie o dostarczona ilosc
    UPDATE towary SET ilosc = ilosc + row_pozycje_dostaw.ilosc
    WHERE id_towaru = row_pozycje_dostaw.id_towaru;
    END LOOP;
    CLOSE c_pozycje_dostaw;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE niezrealizowane_zamowienia AS
    -- Procedura wysylajaca liste niezrealizowanych i przedawnionych zamowien do pracownika oraz zmieniajaca status zamowien ktorych status nie zmienil sie zbyt dlugo na przedawnione
    -- kursor iterujacy po zamowieniach
    CURSOR c_zamowienia IS
    SELECT z.id_zamowienia, z.data_zamowienia, z.status, sz.nazwa, k.imie, k.nazwisko, k.nazwa knazwa
    FROM zamowienia z
    INNER JOIN statusy_zamowien sz
    ON z.status = sz.id_statusu
    INNER JOIN kontrahenci k
    ON k.id_kontrahenta = z.id_klienta
    FOR UPDATE OF z.status;
    
    row_zamowienia c_zamowienia%ROWTYPE;
    var_dzisiaj TIMESTAMP;
    var_klient VARCHAR(61 BYTE);
    var_wiadomosc VARCHAR2(10000 BYTE);
    var_przedawnione VARCHAR2(10000 BYTE);
BEGIN
    var_wiadomosc := 'Niezrealizowane zamowienia:' || chr(10);
    var_wiadomosc := var_wiadomosc || 'ID | Data zamowienia | Klient';
    var_przedawnione := chr(10) || 'Przedawnione zamowienia:' || chr(10);
    var_przedawnione := var_przedawnione || 'ID | Data zamowienia | Klient';
    
    -- pobieranie dzisiejszej daty
    SELECT CURRENT_TIMESTAMP 
    INTO var_dzisiaj
    FROM dual;
    
    OPEN c_zamowienia;    
    LOOP
    FETCH c_zamowienia INTO row_zamowienia;
    EXIT WHEN c_zamowienia%NOTFOUND;
    
    IF row_zamowienia.nazwa = 'Przyjete' THEN
    -- jezeli zamowienie zostalo przyjete i nie jest zrealizowane pracownik zostanie powiadomiony
        IF row_zamowienia.knazwa IS NOT NULL THEN
        -- nazwa klientow firm
            var_klient := row_zamowienia.knazwa;
        ELSE
        -- nazwa klientow osob prywatnych
            var_klient := row_zamowienia.imie || ' ' || row_zamowienia.nazwisko;
        END IF;
        
        IF var_dzisiaj - row_zamowienia.data_zamowienia < 30 THEN
        -- nieprzedawnione zamowienie
            var_wiadomosc := var_wiadomosc || chr(10) || row_zamowienia.id_zamowienia || '    ' || row_zamowienia.data_zamowienia || '          ' || var_klient;
        ELSE
        -- zmiana statusu na 'auto odwolane'
            var_przedawnione := var_przedawnione || chr(10) || row_zamowienia.id_zamowienia || '    ' || row_zamowienia.data_zamowienia || '          ' || var_klient;
            UPDATE zamowienia z SET z.status = 3 WHERE z.id_zamowienia = row_zamowienia.id_zamowienia;
        END IF;
    END IF;
    END LOOP;
    -- wyslanie maila pracownikowi
    var_wiadomosc := var_wiadomosc || var_przedawnione;
    wyslij_maila(p_do          => 'pracownik@catering.com',
                 p_od          => 'admin@catering.com',
                 p_wiadomosc   => var_wiadomosc,
                 p_smtp_host   => 'smtp.catering.com');
    -- dbms_output do testowanie
    --dbms_output.put_line(var_wiadomosc);
    CLOSE c_zamowienia;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE wyslij_maila (p_do IN VARCHAR2, p_od IN VARCHAR2, p_wiadomosc IN VARCHAR2, p_smtp_host IN VARCHAR2, p_smtp_port IN NUMBER DEFAULT 25) AS
-- Procera wysylajaca maila pracownikowi
    mail_conn UTL_SMTP.connection;
BEGIN
    mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);
    UTL_SMTP.helo(mail_conn, p_smtp_host);
    UTL_SMTP.mail(mail_conn, p_od);
    UTL_SMTP.rcpt(mail_conn, p_do);
    UTL_SMTP.data(mail_conn, p_wiadomosc || UTL_TCP.crlf || UTL_TCP.crlf);
    UTL_SMTP.quit(mail_conn);
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"KBD2"."REALIZACJA_ZADAN"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'EXEC niezrealizowane_zamowienia;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=DAILY;BYTIME=030000',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Harmonogram powiadamiajacy pracownikow o niezrealizowanych zamowieniach');
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"KBD2"."REALIZACJA_ZADAN"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"KBD2"."REALIZACJA_ZADAN"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
  
    DBMS_SCHEDULER.enable(
             name => '"KBD2"."REALIZACJA_ZADAN"');
END;
/

CREATE VIEW BILANS_ZESTAWIENIE
AS SELECT
  extract(YEAR FROM f.DATA_WYSTAWIENIA) ROK,
  extract(MONTH FROM f.DATA_WYSTAWIENIA) MIESIAC,
  SUM(CASE WHEN f.CZY_WYCHODZACA = '0' THEN f.NETTO ELSE 0 END) SUMA_NETTO_PRZYCHODOW,
  SUM(CASE WHEN f.CZY_WYCHODZACA = '1' THEN f.NETTO ELSE 0 END) SUMA_NETTO_ROZCHODOW,
  SUM(CASE WHEN f.CZY_WYCHODZACA = '0' THEN f.NETTO ELSE 0 END) - SUM(CASE WHEN f.CZY_WYCHODZACA = '1' THEN f.NETTO ELSE 0 END) BILANS
  FROM FAKTURY f
  GROUP BY extract(YEAR FROM f.DATA_WYSTAWIENIA), extract(MONTH FROM f.DATA_WYSTAWIENIA)
  ORDER BY ROK DESC, MIESIAC DESC;

CREATE VIEW DANIA_ZAMOWIENIA_ZESTAWIENIE
AS SELECT
  extract(YEAR FROM z.DATA_ZAMOWIENIA) ROK,
  extract(MONTH FROM z.DATA_ZAMOWIENIA) MIESIAC,
  d.NAZWA DANIE,
  COUNT(z.ID_ZAMOWIENIA) LICZBA_ZAMOWIEN
  FROM DANIA d
  JOIN POZYCJE_ZAMOWIEN zp ON (zp.ID_DANIA = d.ID_DANIA)
  JOIN ZAMOWIENIA z ON (z.ID_ZAMOWIENIA = zp.ID_ZAMOWIENIA)
  group by extract(YEAR FROM z.DATA_ZAMOWIENIA), extract(MONTH FROM z.DATA_ZAMOWIENIA), d.NAZWA
  ORDER BY ROK DESC, MIESIAC DESC;

CREATE VIEW K_ZAMOWIENIA_MIESIAC
AS SELECT k.ID_KONTRAHENTA ID,
  CASE WHEN k.CZY_FIRMA = '1' THEN k.NAZWA ELSE CONCAT (k.IMIE, CONCAT(' ', k.NAZWISKO)) END NAZWA, 
  COUNT(z.ID_ZAMOWIENIA) LICZBA_ZAMOWIEN,
  SUM(f.NETTO) SUMA_NETTO
  FROM KONTRAHENCI k
  JOIN ZAMOWIENIA z ON (z.ID_KLIENTA = k.ID_KONTRAHENTA)
  JOIN FAKTURY f ON (f.ID_NABYWCY = k.ID_KONTRAHENTA)
  WHERE f.DATA_WYSTAWIENIA > sysdate-30 and z.DATA_ZAMOWIENIA > sysdate-30 AND f.CZY_WYCHODZACA = '0'
  group by k.ID_KONTRAHENTA, CASE WHEN k.CZY_FIRMA = '1' THEN k.NAZWA ELSE CONCAT (k.IMIE, CONCAT(' ', k.NAZWISKO)) END;

CREATE VIEW K_ZAMOWIENIA_ZESTAWIENIE
AS SELECT
  extract(YEAR FROM f.DATA_WYSTAWIENIA) ROK,
  extract(MONTH FROM f.DATA_WYSTAWIENIA) MIESIAC,
  k.ID_KONTRAHENTA ID,
  CASE WHEN k.CZY_FIRMA = '1' THEN k.NAZWA ELSE CONCAT (k.IMIE, CONCAT(' ', k.NAZWISKO)) END NAZWA, 
  COUNT(z.ID_ZAMOWIENIA) LICZBA_ZAMOWIEN,
  SUM(f.NETTO) SUMA_NETTO
  FROM KONTRAHENCI k
  JOIN ZAMOWIENIA z ON (z.ID_KLIENTA = k.ID_KONTRAHENTA)
  JOIN FAKTURY f ON (f.ID_NABYWCY = k.ID_KONTRAHENTA)
  WHERE f.CZY_WYCHODZACA = '0'
  GROUP BY extract(YEAR FROM f.DATA_WYSTAWIENIA), extract(MONTH FROM f.DATA_WYSTAWIENIA), k.ID_KONTRAHENTA, CASE WHEN k.CZY_FIRMA = '1' THEN k.NAZWA ELSE CONCAT (k.IMIE, CONCAT(' ', k.NAZWISKO)) END
  ORDER BY ROK DESC, MIESIAC DESC;

CREATE VIEW PRZYCHODY_ZESTAWIENIE
AS SELECT
  extract(YEAR FROM f.DATA_WYSTAWIENIA) ROK,
  extract(MONTH FROM f.DATA_WYSTAWIENIA) MIESIAC,
  f.SPOSOB_ZAPLATY SPOSOB_PLATNOSCI,
  COUNT(f.ID_FAKTURY) LICZBA_FAKTUR,
  SUM(f.NETTO) SUMA_NETTO
  FROM FAKTURY f
  WHERE f.CZY_WYCHODZACA = '0'
  group by extract(YEAR FROM f.DATA_WYSTAWIENIA), extract(MONTH FROM f.DATA_WYSTAWIENIA), f.SPOSOB_ZAPLATY
  ORDER BY ROK DESC, MIESIAC DESC;

CREATE VIEW ROZCHODY_ZESTAWIENIE_PODATKI
AS SELECT
  extract(YEAR FROM f.DATA_WYSTAWIENIA) ROK,
  extract(MONTH FROM f.DATA_WYSTAWIENIA) MIESIAC,
  f.STAWKA_VAT VAT,
  COUNT(f.ID_FAKTURY) LICZBA_FAKTUR,
  SUM(f.VAT) SUMA_PODATKU
  FROM FAKTURY f
  WHERE f.CZY_WYCHODZACA = '1'
  group by extract(YEAR FROM f.DATA_WYSTAWIENIA), extract(MONTH FROM f.DATA_WYSTAWIENIA), f.STAWKA_VAT
  ORDER BY ROK DESC, MIESIAC DESC;

CREATE VIEW ROZCHODY_ZESTAWIENIE_TOWARY
AS SELECT
  extract(YEAR FROM d.DATA_DOSTAWY) ROK,
  extract(MONTH FROM d.DATA_DOSTAWY) MIESIAC,
  t.NAZWA TOWAR,
  SUM(dp.ILOSC) DOSTARCZONA_ILOSC,
  j.NAZWA JEDNOSTKA,
  SUM(dp.ILOSC) * dp.CENA_JEDNOSTKOWA KOSZT_DOSTAW
  FROM TOWARY t
  JOIN POZYCJE_DOSTAW dp ON (dp.ID_TOWARU = t.ID_TOWARU)
  JOIN DOSTAWY d ON (d.ID_DOSTAWY = dp.ID_DOSTAWY)
  JOIN JEDNOSTKI j ON (j.ID_JEDNOSTKI = t.ID_JEDNOSTKI)
  group by extract(YEAR FROM d.DATA_DOSTAWY), extract(MONTH FROM d.DATA_DOSTAWY), t.NAZWA, j.NAZWA, dp.CENA_JEDNOSTKOWA
  ORDER BY ROK DESC, MIESIAC DESC;
