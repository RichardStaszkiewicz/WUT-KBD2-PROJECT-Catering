-- Kategorie Podatkowe
INSERT INTO sl_kategorie_podatkowe VALUES (1, 'Slodycze', 8);
INSERT INTO sl_kategorie_podatkowe VALUES (2, 'Nabial', 8);
INSERT INTO sl_kategorie_podatkowe VALUES (3, 'Domyslny VAT', 23);

-- Jednostki
INSERT INTO sl_jednostki VALUES (1, 'kilogram', 'kg');
INSERT INTO sl_jednostki VALUES (2, 'sztuka', 'szt');
INSERT INTO sl_jednostki VALUES (3, 'metr', 'm');
INSERT INTO sl_jednostki VALUES (4, 'litr', 'l');

-- Towary
INSERT INTO towary VALUES (1, 'jajka', 100, 2, 3);
INSERT INTO towary VALUES (2, 'mleko', 100, 4, 2);
INSERT INTO towary VALUES (3, 'czekolada', 15, 1, 1);
INSERT INTO towary VALUES (4, 'jogurt', 50, 4, 2);
INSERT INTO towary VALUES (5, 'maka', 100, 1, 3);
INSERT INTO towary VALUES (6, 'cukier', 130, 1, 1);
INSERT INTO towary VALUES (7, 'boczek', 10, 1, 3);
INSERT INTO towary VALUES (8, 'wino', 10, 4, 3);

-- Banki
INSERT INTO sl_banki VALUES (1, 'Krzak Bank');
INSERT INTO sl_banki VALUES (2, 'Bank Spolka Zlo');
INSERT INTO sl_banki VALUES (3, 'Skok Na Kase');

-- Statusy
INSERT INTO sl_statusy_zamowien VALUES (1, 'Przyjete');
INSERT INTO sl_statusy_zamowien VALUES (2, 'Zrealizowane');
INSERT INTO sl_statusy_zamowien VALUES (3, 'Auto odwolane');

-- Kontrahenci
INSERT INTO KONTRAHENCI VALUES (1, null, null, 'KBD2 Katering Bazodanowy', '5333181396', 'kdb2@pw.edu.pl', 'Plac Politechniki 1, Warszawa', '123456789', 1, '12345678901234567890', 1);
INSERT INTO KONTRAHENCI VALUES (2, null, null, 'Dostawy Towarow 365', '5333181394', 'kdb3@pw.edu.pl', 'Testowa 11, Testowo, 01-123', '223456789', 2, '452757345678901234567890', 1);
INSERT INTO KONTRAHENCI VALUES (3, 'Jan', 'Kowalski', NULL, NULL, 'JKOWALSKI@wp.pl', 'Kowalska 123, Bytom, 05-252', '676886787', 3, '5765678901234567890', 0);
INSERT INTO KONTRAHENCI VALUES (4, 'Stefan', 'Dostawca',  NULL, NULL, 'SDOSTAWCA@gmail.com', 'Towarowa 135, Warszawa', '1234561314', 1, '5675778901234567890', 0);

-- Faktury
INSERT INTO FAKTURY 
(id_faktury, nr_faktury, id_nabywcy, id_sprzedawcy, data_wystawienia, data_zaplaty, termin_zaplaty, stawka_vat, sposob_zaplaty, netto, vat, brutto, wartosc_kwoty_slownie)
VALUES
(1, '01/2023', 1, 4, sysdate-50, sysdate-40, sysdate-30, 23, 'przelew', 180, 41.4, 221.4, 'dwiescie dwadziescia jeden zloty i czterdziesci groszy');

INSERT INTO FAKTURY_POZYCJE VALUES
(1, 1, 'Dostawa boczku', 20, 2, sysdate-50, 80, 20, 100);

INSERT INTO FAKTURY_POZYCJE VALUES
(1, 2, 'Dostawa wina', 2, 4, sysdate-50, 65, 15, 80);

INSERT INTO FAKTURY 
(id_faktury, nr_faktury, id_nabywcy, id_sprzedawcy, data_wystawienia, data_zaplaty, termin_zaplaty, stawka_vat, sposob_zaplaty, netto, vat, brutto, wartosc_kwoty_slownie)
VALUES
(2, '02/2023', 3, 1, sysdate-60, sysdate-50, sysdate-50, 23, 'przelew', 72.35, 16.65, 89, 'osiemdziesiat dziewiec zloty');

INSERT INTO FAKTURY_POZYCJE VALUES
(2, 1, 'Boczek w ciescie', 1, 2, sysdate-60, 65, 15, 80);

INSERT INTO FAKTURY_POZYCJE VALUES
(2, 2, 'Dostarczenie kateringu', 1, 2, sysdate-60, 7, 2, 9);

-- ZAMOWIENIA
INSERT INTO ZAMOWIENIA VALUES (1, sysdate-60, 2, 3);
INSERT INTO ZAMOWIENIA VALUES (2, sysdate-40, 2, 4);
INSERT INTO ZAMOWIENIA VALUES (3, sysdate-20, 2, 3);
INSERT INTO ZAMOWIENIA VALUES (4, sysdate, 1, 2);

-- ZAMOWIENIA POZYCJE
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (1, 1, 2, 71);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (1, 2, 1, 16);

INSERT INTO ZAMOWIENIA_POZYCJE VALUES (2, 3, 10, 200);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (2, 2, 10, 150);

INSERT INTO ZAMOWIENIA_POZYCJE VALUES (3, 4, 1, 32);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (3, 3, 1, 22);

INSERT INTO ZAMOWIENIA_POZYCJE VALUES (4, 1, 3, 90);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (4, 4, 2, 60);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (4, 2, 5, 80);
INSERT INTO ZAMOWIENIA_POZYCJE VALUES (4, 3, 1, 2);

-- Dostawy
Insert into dostawy values (1, sysdate-50, 4);
insert into dostawy values (2, sysdate-30, 4);
insert into dostawy values (3, sysdate-10, 3);

-- Dostawy Pozycje
Insert into dostawy_pozycje values (1,7, 20, 5, '1', sysdate+50);
Insert into dostawy_pozycje values (1,8, 2, 40, '2', sysdate+365);

Insert into dostawy_pozycje values (2,1, 50, 1, '123456-XCBFNT', sysdate-5);
Insert into dostawy_pozycje values (2,4, 20, 3, '123456-XCBFNT', sysdate-5);
Insert into dostawy_pozycje values (2,6, 20, 4.56, '123456-XCBFNT', sysdate-5);

Insert into dostawy_pozycje values (3,1, 10, 1, '46576-X77FNT', sysdate+5);
Insert into dostawy_pozycje values (3,4, 10, 3, '46576-X77FNT', sysdate+5);
Insert into dostawy_pozycje values (3,6, 15, 4.56, '46576-X77FNT', sysdate+5);
Insert into dostawy_pozycje values (3,5, 7.5, 4.56, '46576-X77FNT', sysdate+5);

-- Dania
Insert Into Dania Values (1, 'Boczek w ciescie', 'Kilka plasterkow boczku owiniete kruchym ciastem.', 35.50, 0);
Insert Into Dania Values (2, 'Szejk czekoladowy', 'Czekoladowy szejk na bazie jogurtu.', 15.99, 0);
Insert Into Dania Values (3, 'Kruche ciastka', 'Zestaw kruchych ciastek z ciasta francuskiego.', 21.99, 0);
Insert Into Dania Values (4, 'Winny boczek', 'Boczek przyrzadzony w winie.', 31.21, 0);

-- Dania skladniki
Insert into Dania_skladniki values (1, 7, 0.5);
insert into dania_skladniki values (1, 1, 3);
insert into dania_skladniki values (1, 5, 0.25);
insert into dania_skladniki values (1, 6, 0.1);

Insert into Dania_skladniki values (2, 2, 0.25);
insert into dania_skladniki values (2, 3, 0.4);
insert into dania_skladniki values (2, 4, 0.33);
insert into dania_skladniki values (2, 6, 0.15);

Insert into Dania_skladniki values (3, 1, 2);
insert into dania_skladniki values (3, 5, 0.6);
insert into dania_skladniki values (3, 6, 0.5);

Insert into Dania_skladniki values (4, 6, 0.1);
insert into dania_skladniki values (4, 7, 1);
insert into dania_skladniki values (4, 8, 0.75);