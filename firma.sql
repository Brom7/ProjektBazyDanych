-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 17 Gru 2020, 17:51
-- Wersja serwera: 10.4.16-MariaDB
-- Wersja PHP: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `firma`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_adres` (IN `miejscowosc` VARCHAR(45), IN `powiat` VARCHAR(45), IN `wojewodztwo` VARCHAR(45), IN `kraj` VARCHAR(45), IN `kod_pocztowy` VARCHAR(10), IN `ulica` VARCHAR(45), IN `nr_domu` VARCHAR(10), IN `nr_mieszkania` VARCHAR(10))  NO SQL
BEGIN
INSERT INTO firma.adres(miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania)
VALUES (miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_klienta` (IN `nazwisko` VARCHAR(45), IN `imie` VARCHAR(45), IN `login` VARCHAR(45), IN `haslo` VARCHAR(45))  NO SQL
BEGIN
INSERT INTO firma.klient(nazwisko,imie,login,haslo)
VALUES (nazwisko,imie,login,haslo);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_kontakt` (IN `nr_telefonu_1` VARCHAR(45), IN `nr_telefonu_2` VARCHAR(45), IN `fax` VARCHAR(45), IN `email` VARCHAR(45))  NO SQL
BEGIN
INSERT INTO firma.kontakt(nr_telefonu_1,nr_telefonu_2,fax,email)
VALUES (nr_telefonu_1,nr_telefonu_2,fax,email);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_pracownika` (IN `miejscowosc` VARCHAR(45), IN `powiat` VARCHAR(45), IN `wojewodztwo` VARCHAR(45), IN `kraj` VARCHAR(45), IN `kod_pocztowy` VARCHAR(10), IN `ulica` VARCHAR(45), IN `nr_domu` VARCHAR(10), IN `nr_mieszkania` VARCHAR(10), IN `nr_telefonu_1` VARCHAR(45), IN `nr_telefonu_2` VARCHAR(45), IN `fax` VARCHAR(45), IN `email` VARCHAR(45), IN `nazwisko` VARCHAR(45), IN `imie` VARCHAR(45), IN `login` VARCHAR(45), IN `haslo` VARCHAR(45), IN `uprawnienia` ENUM('0','1','2','3'), IN `konto_aktywne` ENUM('0','1'), IN `data_zatrudnienia` DATE)  NO SQL
BEGIN
DECLARE IDADRES INT DEFAULT 1;
DECLARE IDKONTAKT INT DEFAULT 1;
INSERT INTO firma.adres(miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania)
VALUES (miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania);
SET IDADRES = LAST_INSERT_ID();
INSERT INTO firma.kontakt(nr_telefonu_1,nr_telefonu_2,fax,email)
VALUES (nr_telefonu_1,nr_telefonu_2,fax,email);
SET IDKONTAKT = LAST_INSERT_ID();
INSERT INTO firma.pracownik(nazwisko,imie,login,haslo,id_adres,id_kontakt,uprawnienia,konto_aktywne,data_zatrudnienia)
VALUES (nazwisko,imie,login,haslo,IDADRES,IDKONTAKT,uprawnienia,konto_aktywne,data_zatrudnienia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_produkt_bez_polaczenia_z_magazynem` (IN `nazwa` VARCHAR(45), IN `typ` VARCHAR(45), IN `cena_netto` DECIMAL(10,2), IN `cena_brutto` DECIMAL(10,2), IN `opis` TEXT)  NO SQL
BEGIN

INSERT INTO firma.produkt(nazwa,typ, cena_netto,cena_brutto,opis)
VALUES(nazwa,typ,cena_netto,cena_brutto,opis);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DODAJ_PRODUKT_W_MAGAZYNIE` (IN `kod_produkt` VARCHAR(45), IN `ilosc_pierwszy_gatunek` INT, IN `ilosc_drugi_gatunek` INT, IN `lokalizacja` VARCHAR(45))  NO SQL
BEGIN
INSERT INTO firma.magazyn(kod_produkt,ilosc_pierwszy_gatunek,ilosc_drugi_gatunek,lokalizacja)
VALUES (kod_produkt,ilosc_pierwszy_gatunek,ilosc_drugi_gatunek,lokalizacja);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_produkt_z_pustym_magazynem` (IN `nazwa` VARCHAR(45), IN `typ` VARCHAR(45), IN `cena_netto` DECIMAL(10,2), IN `cena_brutto` DECIMAL(10,2), IN `opis` TEXT)  NO SQL
BEGIN
INSERT INTO firma.magazyn(kod_produkt,ilosc_pierwszy_gatunek,ilosc_drugi_gatunek,lokalizacja)
VALUES(NULL,NULL,NULL,NULL);
INSERT INTO firma.produkt(id_magazyn,nazwa,typ, cena_netto,cena_brutto,opis)
VALUES(LAST_INSERT_ID(),nazwa,typ,cena_netto,cena_brutto,opis);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_produkt_z_uzupelnieniem_magazynu` (IN `kod_produkt` VARCHAR(45), IN `ilosc_pierwszy_gatunek` INT, IN `ilosc_drugi_gatunek` INT, IN `lokalizacja` INT(45), IN `nazwa` VARCHAR(45), IN `typ` VARCHAR(45), IN `cena_netto` DECIMAL(10,2), IN `cena_crutto` DECIMAL(10,2), IN `opis` TEXT)  NO SQL
BEGIN
INSERT INTO firma.magazyn(kod_produkt,ilosc_pierwszy_gatunek,ilosc_drugi_gatunek,lokalizacja)
VALUES(kod_produkt,ilosc_pierwszy_gatunek,ilosc_drugi_gatunek,lokalizacja);
INSERT INTO firma.produkt(id_magazyn,nazwa,typ, cena_netto,cena_brutto,opis)
VALUES(LAST_INSERT_ID(),nazwa,typ,cena_netto,cena_brutto,opis);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edytuj_kontakt` (IN `id_kontakt` INT, IN `nr_telefonu_1` VARCHAR(45), IN `nr_telefonu_2` VARCHAR(45), IN `fax` VARCHAR(45), IN `email` VARCHAR(45))  NO SQL
BEGIN 

IF NOT EXISTS ( SELECT id_kontakt FROM kontakt WHERE kontakt.id_kontakt =id_kontakt)
THEN
SELECT 'Podanego ID nie ma w bazie';
ELSE

UPDATE kontakt
SET kontakt.nr_telefonu_1 = nr_telefonu_1
WHERE kontakt.id_kontakt = id_kontakt AND nr_telefonu_1 > 0;

UPDATE kontakt
SET kontakt.nr_telefonu_2= nr_telefonu_2
WHERE kontakt.id_kontakt = id_kontakt AND nr_telefonu_2>0;

UPDATE kontakt
SET kontakt.email = email
WHERE kontakt.id_kontakt = id_kontakt AND email LIKE '%@%';

UPDATE kontakt
SET kontakt.fax = fax
WHERE kontakt.id_kontakt = id_kontakt AND fax >0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rejestracja_nowego_uzytkownika` (IN `miejscowosc` VARCHAR(45), IN `powiat` VARCHAR(45), IN `wojewodztwo` VARCHAR(45), IN `kraj` VARCHAR(45), IN `kod_pocztowy` VARCHAR(10), IN `ulica` VARCHAR(45), IN `nr_domu` VARCHAR(10), IN `nr_mieszkania` VARCHAR(10), IN `nr_telefonu_1` VARCHAR(45), IN `nr_telefonu_2` VARCHAR(45), IN `fax` VARCHAR(45), IN `email` VARCHAR(45), IN `nazwisko` VARCHAR(45), IN `imie` VARCHAR(45), IN `login` VARCHAR(45), IN `haslo` VARCHAR(45))  NO SQL
BEGIN
DECLARE IDADRES INT DEFAULT 1;
DECLARE IDKONTAKT INT DEFAULT 1;
INSERT INTO firma.adres(miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania)
VALUES (miejscowosc,powiat,wojewodztwo,kraj,kod_pocztowy,ulica,nr_domu,nr_mieszkania);
SET IDADRES = LAST_INSERT_ID();
INSERT INTO firma.kontakt(nr_telefonu_1,nr_telefonu_2,fax,email)
VALUES (nr_telefonu_1,nr_telefonu_2,fax,email);
SET IDKONTAKT = LAST_INSERT_ID();
INSERT INTO firma.klient(nazwisko,imie,login,haslo,id_adres,id_kontakt)
VALUES (nazwisko,imie,login,haslo,IDADRES,IDKONTAKT);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usun_zdjecie` (IN `id_zdjecie` INT)  NO SQL
BEGIN
DELETE FROM galeria WHERE (id_zdjecie=id_zdjecie);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `wstaw_zdjecie` (IN `url` VARCHAR(3000), IN `id_produkt` INT)  NO SQL
BEGIN
INSERT INTO firma.galeria(url,data_dodania,id_produkt) VALUES(url,NOW(),id_produkt);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Wyswietl_zamowienie` (IN `Nazwisko` VARCHAR(45))  NO SQL
BEGIN
select zp.id_zamowienie as nr_zamowienia, p.nazwa, zp.ilosc
from zamowienie_produkt as zp
inner join produkt as p on zp.id_produkt = p.id_produkt
inner join zamowienie as z on zp.id_zamowienie = z.id_zamowienie
inner join klient as k on z.id_klient = k.id_klient
where k.nazwisko = Nazwisko;
END$$

--
-- Funkcje
--
CREATE DEFINER=`root`@`localhost` FUNCTION `IloscTowaruPierwszegoGatunku` (`nazwa` VARCHAR(45)) RETURNS INT(11) NO SQL
BEGIN
    DECLARE wynik INT DEFAULT 0;
    DECLARE wsk INT DEFAULT 0;
    DECLARE ilosc INT;
    SET wsk = (select id_produkt_magazyn from produkt where produkt.nazwa = nazwa);
    SET ilosc = (select ilosc_pierwszy_gatunek from magazyn where magazyn.id_produkt_magazyn = wsk);
    
    SET wynik=ilosc;
    RETURN wynik;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `SUMA_ODMIANY_MAGAZYN` (`id_produktu` INT) RETURNS INT(11) NO SQL
BEGIN
    DECLARE wynik INT DEFAULT 0;
    DECLARE pierwszy_gatunek INT;
    DECLARE drugi_gatunek INT;
    SET pierwszy_gatunek = (select ilosc_pierwszy_gatunek from magazyn where magazyn.id_magazyn = id_produktu);
    SET drugi_gatunek = (select ilosc_drugi_gatunek from magazyn where magazyn.id_magazyn = id_produktu);
    SET wynik=pierwszy_gatunek+drugi_gatunek;
    RETURN wynik;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `WyszukajNajtanszyProdukt` () RETURNS DECIMAL(10,2) NO SQL
BEGIN
DECLARE naj DECIMAL(10.2) DEFAULT 0;
SET naj =(SELECT MIN(cena_brutto) FROM produkt);
RETURN naj;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `WyszukanieNajdrozszegoProduktu` () RETURNS DECIMAL(10,2) NO SQL
BEGIN
DECLARE naj DECIMAL(10.2) DEFAULT 0;
SET naj =(SELECT MAX(cena_brutto) FROM produkt);
RETURN naj;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adres`
--

CREATE TABLE `adres` (
  `id_adres` int(11) NOT NULL,
  `miejscowosc` varchar(45) NOT NULL,
  `powiat` varchar(45) NOT NULL,
  `wojewodztwo` varchar(45) NOT NULL,
  `kraj` varchar(45) NOT NULL,
  `kod_pocztowy` varchar(10) NOT NULL,
  `ulica` varchar(45) DEFAULT NULL,
  `nr_domu` varchar(10) DEFAULT NULL,
  `nr_mieszkania` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `adres`
--

INSERT INTO `adres` (`id_adres`, `miejscowosc`, `powiat`, `wojewodztwo`, `kraj`, `kod_pocztowy`, `ulica`, `nr_domu`, `nr_mieszkania`) VALUES
(1, 'Wojnicz', 'Tarnowski', 'Małopolskie', 'Polska', '32-789', 'boczna', '23', ''),
(2, 'Brzesko', 'Brzeski', 'malopolskie', 'POLSKA', '31-456', 'Mickiewicza', '', '12b'),
(3, 'Szczecin', 'Szczecin', 'zachodniopomorskie', 'Polska', '12-678', 'ul.Adama Smitha', '23D', ''),
(4, 'OPOLE', 'opolski', 'Opolskie', 'POLSKA', '13-785', 'Krakowska', '12', ''),
(5, 'Wrocław', 'Wrocławski', 'Dolnośląskie', 'Polska', '14-876', 'Rynek', '32', '23b'),
(6, 'Gdańsk', 'Gdański', 'Pomorskie', 'polska', '07-222', 'Mickiewicza', '', '45c');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `galeria`
--

CREATE TABLE `galeria` (
  `id_zdjecie` int(11) NOT NULL,
  `id_produkt` int(11) DEFAULT NULL,
  `url` varchar(3000) DEFAULT NULL,
  `data_dodania` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `galeria`
--

INSERT INTO `galeria` (`id_zdjecie`, `id_produkt`, `url`, `data_dodania`) VALUES
(4, 1, 'https://www.rozeogrodowe.pl/environment/cache/images/0_0_productGfx_17460270832ef41887fa959d9106aeaf.jpg', '2020-12-16 19:16:46'),
(6, 3, 'https://www.rozeogrodowe.pl/environment/cache/images/0_0_productGfx_3f3d70c73bd2cb7624fce9bd4635cd4d.jpg', '2020-12-16 19:18:12'),
(7, 4, 'https://www.rozeogrodowe.pl/environment/cache/images/0_0_productGfx_6404/roza-rozowa-okrywowa-hotline-krzewy-kwiaty-szkolka-grzegorz-hyzy.jpg', '2020-12-16 19:18:53'),
(8, 5, 'https://www.rozeogrodowe.pl/environment/cache/images/0_0_productGfx_10985/crown1.jpg', '2020-12-17 16:59:47'),
(10, 1, 'https://www.rozeogrodowe.pl/environment/cache/images/0_0_productGfx_6654/roza-pomarszczona-dagmar-hastrup.jpg', '2020-12-17 17:03:11');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klient`
--

CREATE TABLE `klient` (
  `id_klient` int(11) NOT NULL,
  `id_adres` int(11) DEFAULT NULL,
  `id_kontakt` int(11) DEFAULT NULL,
  `nazwisko` varchar(45) NOT NULL,
  `imie` varchar(45) NOT NULL,
  `login` varchar(45) NOT NULL,
  `haslo` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `klient`
--

INSERT INTO `klient` (`id_klient`, `id_adres`, `id_kontakt`, `nazwisko`, `imie`, `login`, `haslo`) VALUES
(1, 2, 2, 'Mleczko', 'Arkadiusz', 'Arek123', 'ZBYCH456'),
(2, 4, 4, 'Gaweł', 'Daniel', 'kosmos777', 'botak04567890bastek'),
(3, 3, 3, 'Jamróz', 'Sebastian', 'Seba45', '123terazty');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kontakt`
--

CREATE TABLE `kontakt` (
  `id_kontakt` int(11) NOT NULL,
  `nr_telefonu_1` varchar(45) NOT NULL,
  `nr_telefonu_2` varchar(45) DEFAULT NULL,
  `fax` varchar(45) DEFAULT NULL,
  `email` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `kontakt`
--

INSERT INTO `kontakt` (`id_kontakt`, `nr_telefonu_1`, `nr_telefonu_2`, `fax`, `email`) VALUES
(1, '12345678', '6785436', '(61) 860-28-01', 'wacekkapusta@interia.pl'),
(2, '3456789999', '512789678', '(61) 543-24-41', 'allegro@gmail.com'),
(3, '43434324324', '', '', 'bursztyn123@wp.pl'),
(4, '12678907', '32222434', '23 5678903', 'dawidmizera8@wp.pl'),
(5, '18567435', '', '', 'grazynanowak78@wp.pl');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `magazyn`
--

CREATE TABLE `magazyn` (
  `id_magazyn` int(11) NOT NULL,
  `kod_produkt` varchar(45) DEFAULT NULL,
  `ilosc_pierwszy_gatunek` int(11) DEFAULT NULL,
  `ilosc_drugi_gatunek` int(11) DEFAULT NULL,
  `lokalizacja` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `magazyn`
--

INSERT INTO `magazyn` (`id_magazyn`, `kod_produkt`, `ilosc_pierwszy_gatunek`, `ilosc_drugi_gatunek`, `lokalizacja`) VALUES
(1, '11', 123, 56, 'paleta 36'),
(2, '12', 1230, 561, 'paleta 36'),
(3, '13', 3, 4, 'paleta 23'),
(4, '14', 3, 4, 'paleta 1'),
(5, '15', 123, 56, 'paleta 4'),
(8, '16', 45, 0, 'paleta 23'),
(9, '17', 9, 9, 'wózek 14'),
(10, '18', 43, 17, 'wózek 12'),
(11, '19', 345, 123, 'paleta 22'),
(13, '20', 3, 3, 'półka 2, poletko 17'),
(14, '21', 2, 2, 'półka 1 poletko 4'),
(15, '23', 456, 123, 'paleta 9');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `pracownik`
--

CREATE TABLE `pracownik` (
  `id_pracownik` int(11) NOT NULL,
  `imie` varchar(45) NOT NULL,
  `nazwisko` varchar(45) NOT NULL,
  `id_adres` int(11) DEFAULT NULL,
  `id_kontakt` int(11) DEFAULT NULL,
  `login` varchar(45) NOT NULL,
  `haslo` varchar(45) NOT NULL,
  `uprawnienia` enum('0','1','2','3') NOT NULL,
  `konto_aktywne` enum('0','1') NOT NULL,
  `data_zatrudnienia` date NOT NULL,
  `data_zwolnienia` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `pracownik`
--

INSERT INTO `pracownik` (`id_pracownik`, `imie`, `nazwisko`, `id_adres`, `id_kontakt`, `login`, `haslo`, `uprawnienia`, `konto_aktywne`, `data_zatrudnienia`, `data_zwolnienia`) VALUES
(1, 'Dawid', 'Mizera', 1, 1, 'dawidmizera45', 'makarena67', '3', '1', '2013-03-20', NULL),
(2, 'Grażyna', 'Nowak', 6, 5, 'grazyna78', '5678901234morze', '2', '1', '2014-12-11', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `produkt`
--

CREATE TABLE `produkt` (
  `id_produkt` int(11) NOT NULL,
  `id_magazyn` int(11) DEFAULT NULL,
  `nazwa` varchar(45) DEFAULT NULL,
  `typ` varchar(45) DEFAULT NULL,
  `cena_netto` decimal(10,2) DEFAULT NULL,
  `cena_brutto` decimal(10,2) DEFAULT NULL,
  `opis` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `produkt`
--

INSERT INTO `produkt` (`id_produkt`, `id_magazyn`, `nazwa`, `typ`, `cena_netto`, `cena_brutto`, `opis`) VALUES
(1, 1, 'BIG PURPLE', 'Wielkokwatowa', '23.99', '26.99', 'Tania różą wielkokwiatowa o pełnym czerwonym kwiecie.'),
(2, 2, 'BLACK FOREST ROSE', 'Rabatowa', '23.99', '25.99', 'Największą zaletą róży Black Forest Rose poza odpornością jest długie kwitnienie, trwały kolor kwiatów oraz ich niewrażliwość na deszcz.\r\n\r\nChoć pojedyncze kwiaty nie są duże, to cały kwiatostan złożony z kilkudziesięciu, stopniowo rozwijających się pąków robi nadzwyczajne wrażenie.\r\n\r\nJest to róża, która według hodowcy osiąga rozmiary 70 cm. W praktyce osiąga bardziej okazałe rozmiary.\r\n\r\nNadaje się do obsadzania miejsc półcienistych gdzie dobrze kwitnie, choć potrafi tam osiągać 1,5 m wysokości.\r\n\r\nWszystkie te cechy sprawiają, że Black Forest Rose jest idealną odmianą zarówno do nasadzeń miejskich jak i w prywatnych ogrodach, gdzie sadzona w dużych grupach (w odstępach 50 cm) tworzy długo kwitnący, jasnoczerwony akcent.\r\n\r\nPopularność czerwonych róż rabatowych od lat nie słabnie, niestety większość sprzedawanych w szkółkach czerwonych róż rabatowych jest dość podatna na czarną plamistość liści co sprawia, że w drugiej połowie lata takie rośliny nie stanowią ozdoby, a szpecą gołymi pędami i resztkami kwiatów na szczytach. Black Forest Rose jest godnym następcą wszystkich tych starych odmian, a do tego deklasuje je swoja odpornością .\r\n\r\nRóża rabatowa którą firma Kordes wprowadziła na rynek w 2010 roku zaliczając ją jednocześnie do swoich najodporniejszych odmian, do grupy Rigo Rosen. Potwierdzeniem tego jest przyznany certyfikat ADR. '),
(3, 3, 'GOLDSPATZ', 'Parkowa', '34.99', '36.99', 'Bardzo ładna róża o żółtych kwiatach.'),
(4, 4, 'ALOHA', 'Pnąca', '17.99', '19.99', 'Kolor Herbaciany'),
(5, 5, 'WELLENSPIEL', 'Parkowa', '34.99', '37.99', 'Róża pomarańczowa.'),
(8, 8, 'SOMMERABEND 120 CM', 'Pienna 120', '67.99', '69.99', 'Róża na pniu o wysokości 120 cm.'),
(9, 9, 'JAZZ', 'Okrywowa', '9.99', '12.99', 'Kolor herbaciany'),
(10, 10, 'MANDY', 'Miniaturka', '17.99', '19.99', 'Mała róża o czerwonym zabarwieniu'),
(11, 11, 'BOSCOBEL', 'Angielska', '23.99', '25.99', 'Róża angielska '),
(13, 13, 'THE PILGRIM', 'Angielska', '14.99', '17.99', 'Pachnąca róża o białym pełnym kwiacie.'),
(14, 14, 'DUFTZAUBER 84', 'Wielkokwatowa', '34.99', '37.99', 'Czerwona róża wielkokwiatowa'),
(18, 15, 'AMADEUS', 'Pnąca', '34.99', '37.99', 'Czerwona róża pnąca');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamowienie`
--

CREATE TABLE `zamowienie` (
  `id_zamowienie` int(11) NOT NULL,
  `id_klient` int(11) DEFAULT NULL,
  `data_zlozenia_zamowienia` datetime DEFAULT NULL,
  `czy_przyjeto_zamowienie` enum('0','1') DEFAULT NULL,
  `data_przyjecia_zamowienia` datetime DEFAULT NULL,
  `forma_zaplaty` varchar(45) DEFAULT NULL,
  `metoda_wysylki` varchar(45) DEFAULT NULL,
  `status_zamowienia` varchar(45) DEFAULT NULL,
  `data_realizacji_zamowienia` datetime DEFAULT NULL,
  `status_zaplaty` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `zamowienie`
--

INSERT INTO `zamowienie` (`id_zamowienie`, `id_klient`, `data_zlozenia_zamowienia`, `czy_przyjeto_zamowienie`, `data_przyjecia_zamowienia`, `forma_zaplaty`, `metoda_wysylki`, `status_zamowienia`, `data_realizacji_zamowienia`, `status_zaplaty`) VALUES
(1, 1, '2020-12-03 19:44:39', '1', '2020-12-05 19:54:39', 'przelew', 'kurier DHL', 'wysłano', '2020-12-08 09:44:39', 'zapłacono'),
(2, 3, '2020-12-03 19:44:39', '1', '2020-12-12 08:54:39', 'za pobraniem', 'kurier INPOST', 'w trakcie kompletowania', '2021-03-15 09:44:39', 'niezapłacono'),
(3, 2, '2020-12-16 19:44:39', '0', NULL, 'przelew', 'kurier GLS', 'nieprzyjęte', NULL, 'niezapłacono');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `zamowienie_produkt`
--

CREATE TABLE `zamowienie_produkt` (
  `id_zamowienie_produkt` int(11) NOT NULL,
  `id_zamowienie` int(11) DEFAULT NULL,
  `id_produkt` int(11) DEFAULT NULL,
  `ilosc` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `zamowienie_produkt`
--

INSERT INTO `zamowienie_produkt` (`id_zamowienie_produkt`, `id_zamowienie`, `id_produkt`, `ilosc`) VALUES
(1, 1, 1, 21),
(2, 1, 9, 12),
(3, 1, 13, 1),
(4, 2, 8, 1),
(5, 3, 9, 200);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adres`
--
ALTER TABLE `adres`
  ADD PRIMARY KEY (`id_adres`);

--
-- Indeksy dla tabeli `galeria`
--
ALTER TABLE `galeria`
  ADD PRIMARY KEY (`id_zdjecie`),
  ADD KEY `id_produkt` (`id_produkt`);

--
-- Indeksy dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD PRIMARY KEY (`id_klient`),
  ADD KEY `id_adres` (`id_adres`),
  ADD KEY `id_kontakt` (`id_kontakt`);

--
-- Indeksy dla tabeli `kontakt`
--
ALTER TABLE `kontakt`
  ADD PRIMARY KEY (`id_kontakt`);

--
-- Indeksy dla tabeli `magazyn`
--
ALTER TABLE `magazyn`
  ADD PRIMARY KEY (`id_magazyn`);

--
-- Indeksy dla tabeli `pracownik`
--
ALTER TABLE `pracownik`
  ADD PRIMARY KEY (`id_pracownik`),
  ADD KEY `id_adres` (`id_adres`),
  ADD KEY `id_kontakt` (`id_kontakt`);

--
-- Indeksy dla tabeli `produkt`
--
ALTER TABLE `produkt`
  ADD PRIMARY KEY (`id_produkt`),
  ADD KEY `id_magazyn` (`id_magazyn`);

--
-- Indeksy dla tabeli `zamowienie`
--
ALTER TABLE `zamowienie`
  ADD PRIMARY KEY (`id_zamowienie`),
  ADD KEY `id_klient` (`id_klient`);

--
-- Indeksy dla tabeli `zamowienie_produkt`
--
ALTER TABLE `zamowienie_produkt`
  ADD PRIMARY KEY (`id_zamowienie_produkt`),
  ADD KEY `id_zamowienie` (`id_zamowienie`),
  ADD KEY `id_produkt` (`id_produkt`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `adres`
--
ALTER TABLE `adres`
  MODIFY `id_adres` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `galeria`
--
ALTER TABLE `galeria`
  MODIFY `id_zdjecie` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `klient`
--
ALTER TABLE `klient`
  MODIFY `id_klient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT dla tabeli `kontakt`
--
ALTER TABLE `kontakt`
  MODIFY `id_kontakt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `magazyn`
--
ALTER TABLE `magazyn`
  MODIFY `id_magazyn` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT dla tabeli `pracownik`
--
ALTER TABLE `pracownik`
  MODIFY `id_pracownik` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `produkt`
--
ALTER TABLE `produkt`
  MODIFY `id_produkt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT dla tabeli `zamowienie_produkt`
--
ALTER TABLE `zamowienie_produkt`
  MODIFY `id_zamowienie_produkt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `galeria`
--
ALTER TABLE `galeria`
  ADD CONSTRAINT `galeria_ibfk_1` FOREIGN KEY (`id_produkt`) REFERENCES `produkt` (`id_produkt`),
  ADD CONSTRAINT `galeria_ibfk_2` FOREIGN KEY (`id_produkt`) REFERENCES `produkt` (`id_produkt`),
  ADD CONSTRAINT `galeria_ibfk_3` FOREIGN KEY (`id_produkt`) REFERENCES `produkt` (`id_produkt`);

--
-- Ograniczenia dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD CONSTRAINT `klient_ibfk_1` FOREIGN KEY (`id_adres`) REFERENCES `adres` (`id_adres`),
  ADD CONSTRAINT `klient_ibfk_2` FOREIGN KEY (`id_kontakt`) REFERENCES `kontakt` (`id_kontakt`);

--
-- Ograniczenia dla tabeli `pracownik`
--
ALTER TABLE `pracownik`
  ADD CONSTRAINT `pracownik_ibfk_1` FOREIGN KEY (`id_adres`) REFERENCES `adres` (`id_adres`),
  ADD CONSTRAINT `pracownik_ibfk_2` FOREIGN KEY (`id_kontakt`) REFERENCES `kontakt` (`id_kontakt`);

--
-- Ograniczenia dla tabeli `produkt`
--
ALTER TABLE `produkt`
  ADD CONSTRAINT `produkt_ibfk_1` FOREIGN KEY (`id_magazyn`) REFERENCES `magazyn` (`id_magazyn`);

--
-- Ograniczenia dla tabeli `zamowienie`
--
ALTER TABLE `zamowienie`
  ADD CONSTRAINT `zamowienie_ibfk_1` FOREIGN KEY (`id_klient`) REFERENCES `klient` (`id_klient`);

--
-- Ograniczenia dla tabeli `zamowienie_produkt`
--
ALTER TABLE `zamowienie_produkt`
  ADD CONSTRAINT `zamowienie_produkt_ibfk_1` FOREIGN KEY (`id_zamowienie`) REFERENCES `zamowienie` (`id_zamowienie`),
  ADD CONSTRAINT `zamowienie_produkt_ibfk_2` FOREIGN KEY (`id_produkt`) REFERENCES `produkt` (`id_produkt`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
