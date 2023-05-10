-- Kategorie Podatkowe
INSERT INTO kategorie_podatkowe VALUES (1, 'Slodycze', 8);
INSERT INTO kategorie_podatkowe VALUES (2, 'Nabial', 8);
INSERT INTO kategorie_podatkowe VALUES (3, 'Domyslny VAT', 23);

-- Jednostki
INSERT INTO jednostki VALUES (1, 'kilogram', 'kg');
INSERT INTO jednostki VALUES (2, 'sztuka', 'szt');
INSERT INTO jednostki VALUES (3, 'metr', 'm');
INSERT INTO jednostki VALUES (4, 'litr', 'l');

-- Towary
INSERT INTO towary VALUES (1, 'jajka', 'Swieze jaja kurzece z pobliskiej fermy', 100, 2, 3);
INSERT INTO towary VALUES (2, 'mleko', 'Swieze krowie mleko z pobliskiej fermy',100, 4, 2);
INSERT INTO towary VALUES (3, 'czekolada', 'Czekolada wytwarzana przez najlepszych szwajcarskich mistrzow',15, 1, 1);
INSERT INTO towary VALUES (4, 'jogurt', 'Jogurt naturalny bezglutenowy',50, 4, 2);
INSERT INTO towary VALUES (5, 'maka','Tradycyjna maka tortowa', 100, 1, 3);
INSERT INTO towary VALUES (6, 'cukier', null,130, 1, 1);
INSERT INTO towary VALUES (7, 'boczek', null,10, 1, 3);
INSERT INTO towary VALUES (8, 'wino', null,10, 4, 3);

-- Banki
INSERT INTO banki VALUES (1, 'Krzak Bank');
INSERT INTO banki VALUES (2, 'Bank Spolka Zlo');
INSERT INTO banki VALUES (3, 'Skok Na Kase');

-- Statusy
INSERT INTO statusy_zamowien VALUES (1, 'Przyjete');
INSERT INTO statusy_zamowien VALUES (2, 'Zrealizowane');
INSERT INTO statusy_zamowien VALUES (3, 'Auto odwolane');

-- Kontrahenci
INSERT INTO KONTRAHENCI VALUES (1, null, null, 'KBD2 Katering Bazodanowy', '5333181396', 'kdb2@pw.edu.pl', '123456789', 1, '12345678901234567890', 1, 'Warszawa', '01-248', 'Plac Politechniki', '1', null);
INSERT INTO KONTRAHENCI VALUES (2, null, null, 'Dostawy Towarow 365', '5333181394', 'kdb3@pw.edu.pl', '223456789', 2, '452757345678901234567890', 1, 'Testowo', '01-234', 'Testowa', '123B', '456A');
INSERT INTO KONTRAHENCI VALUES (3, 'Jan', 'Kowalski', NULL, NULL, 'JKOWALSKI@wp.pl', 3, '676886787', '5765678901234567890', 0, 'Bytom', '02-252', 'Kowalskiego', '123', null);
INSERT INTO KONTRAHENCI VALUES (4, 'Stefan', 'Dostawca',  NULL, NULL, 'SDOSTAWCA@gmail.com', '1234561314', 1, '5675778901234567890', 0, 'Bytom', '02-252', 'Kowalskiego', '122', null);

-- Faktury
INSERT INTO FAKTURY 
(id_faktury, nr_faktury, id_nabywcy, id_sprzedawcy, data_wystawienia, data_zaplaty, termin_zaplaty, stawka_vat, sposob_zaplaty, netto, vat, brutto, wartosc_kwoty_slownie)
VALUES
(1, '01/2023', 1, 4, sysdate-50, sysdate-40, sysdate-30, 23, '1', 180, 41.4, 221.4, 'dwiescie dwadziescia jeden zloty i czterdziesci groszy');

INSERT INTO POZYCJE_FAKTUR VALUES
(1, 1, 'Dostawa boczku', 20, 2, sysdate-50, 80, 20, 100);

INSERT INTO POZYCJE_FAKTUR VALUES
(1, 2, 'Dostawa wina', 2, 4, sysdate-50, 65, 15, 80);

INSERT INTO FAKTURY 
(id_faktury, nr_faktury, id_nabywcy, id_sprzedawcy, data_wystawienia, data_zaplaty, termin_zaplaty, stawka_vat, sposob_zaplaty, netto, vat, brutto, wartosc_kwoty_slownie)
VALUES
(2, '02/2023', 3, 1, sysdate-60, sysdate-50, sysdate-50, 23, '0', 72.35, 16.65, 89, 'osiemdziesiat dziewiec zloty');

INSERT INTO POZYCJE_FAKTUR VALUES
(2, 1, 'Boczek w ciescie', 1, 2, sysdate-60, 65, 15, 80);

INSERT INTO POZYCJE_FAKTUR VALUES
(2, 2, 'Dostarczenie kateringu', 1, 2, sysdate-60, 7, 2, 9);

-- ZAMOWIENIA
INSERT INTO ZAMOWIENIA VALUES (1, sysdate-60, 2, 3);
INSERT INTO ZAMOWIENIA VALUES (2, sysdate-40, 2, 4);
INSERT INTO ZAMOWIENIA VALUES (3, sysdate-20, 2, 3);
INSERT INTO ZAMOWIENIA VALUES (4, sysdate, 1, 2);

-- ZAMOWIENIA POZYCJE
INSERT INTO POZYCJE_ZAMOWIEN VALUES (1, 1, 2, 71);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (1, 2, 1, 16);

INSERT INTO POZYCJE_ZAMOWIEN VALUES (2, 3, 10, 200);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (2, 2, 10, 150);

INSERT INTO POZYCJE_ZAMOWIEN VALUES (3, 4, 1, 32);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (3, 3, 1, 22);

INSERT INTO POZYCJE_ZAMOWIEN VALUES (4, 1, 3, 90);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (4, 4, 2, 60);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (4, 2, 5, 80);
INSERT INTO POZYCJE_ZAMOWIEN VALUES (4, 3, 1, 2);

-- Dostawy
Insert into dostawy values (1, sysdate-50, 4);
insert into dostawy values (2, sysdate-30, 4);
insert into dostawy values (3, sysdate-10, 3);

-- Dostawy Pozycje
Insert into Pozycje_dostaw values (1,7, 20, 5, '1', sysdate+50);
Insert into Pozycje_dostaw values (1,8, 2, 40, '2', sysdate+365);

Insert into Pozycje_dostaw values (2,1, 50, 1, '123456-XCBFNT', sysdate-5);
Insert into Pozycje_dostaw values (2,4, 20, 3, '123456-XCBFNT', sysdate-5);
Insert into Pozycje_dostaw values (2,6, 20, 4.56, '123456-XCBFNT', sysdate-5);

Insert into Pozycje_dostaw values (3,1, 10, 1, '46576-X77FNT', sysdate+5);
Insert into Pozycje_dostaw values (3,4, 10, 3, '46576-X77FNT', sysdate+5);
Insert into Pozycje_dostaw values (3,6, 15, 4.56, '46576-X77FNT', sysdate+5);
Insert into Pozycje_dostaw values (3,5, 7.5, 4.56, '46576-X77FNT', sysdate+5);

-- Dania
Insert Into Dania Values (1, 'Boczek w ciescie', 'Kilka plasterkow boczku owiniete kruchym ciastem.', 35.50, 0);
Insert Into Dania Values (2, 'Szejk czekoladowy', 'Czekoladowy szejk na bazie jogurtu.', 15.99, 0);
Insert Into Dania Values (3, 'Kruche ciastka', 'Zestaw kruchych ciastek z ciasta francuskiego.', 21.99, 0);
Insert Into Dania Values (4, 'Winny boczek', 'Boczek przyrzadzony w winie.', 31.21, 0);

-- Dania skladniki
Insert into skladniki_dan values (1, 7, 0.5);
insert into skladniki_dan values (1, 1, 3);
insert into skladniki_dan values (1, 5, 0.25);
insert into skladniki_dan values (1, 6, 0.1);

Insert into skladniki_dan values (2, 2, 0.25);
insert into skladniki_dan values (2, 3, 0.4);
insert into skladniki_dan values (2, 4, 0.33);
insert into skladniki_dan values (2, 6, 0.15);

Insert into skladniki_dan values (3, 1, 2);
insert into skladniki_dan values (3, 5, 0.6);
insert into skladniki_dan values (3, 6, 0.5);

Insert into skladniki_dan values (4, 6, 0.25);
insert into skladniki_dan values (4, 7, 1);
insert into skladniki_dan values (4, 8, 0.75);