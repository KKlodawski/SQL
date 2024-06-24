--Zad1
SELECT DISTINCT Imie,Nazwisko FROM studenci
INNER JOIN oceny ON oceny.student = studenci.osoba_id
INNER JOIN przedmioty ON przedmioty.przedmiot_id = oceny.przedmiot_id
INNER JOIN osoby ON osoby.osoba_id = studenci.osoba_id
WHERE Przedmiot LIKE 'Matematyka' AND ocena >= 3 AND YEAR(Data_wystawienia) = 2004

--Zad2
SELECT Nazwisko FROM studenci
INNER JOIN osoby ON osoby.osoba_id = studenci.osoba_id
WHERE imie LIKE '%A%' AND imie NOT LIKE '%B%'

--Zad3
SELECT Stopien_skrot, count(*) as Ilosc FROM dydaktycy
INNER JOIN stopnie_tytuly ON dydaktycy.stopien_id = stopnie_tytuly.stopien_id
WHERE Stopien_skrot NOT LIKE 'Inż'
GROUP BY Stopien_skrot
ORDER BY ilosc DESC

--Zad4
SELECT imie, nazwisko, AVG(ocena) as Średnia FROM studenci
INNER JOIN osoby ON osoby.osoba_id = studenci.osoba_id
INNER JOIN oceny ON oceny.student = studenci.osoba_id
GROUP BY imie, nazwisko
HAVING AVG(ocena) > (
SELECT AVG(ocena) FROM studenci
INNER JOIN osoby ON osoby.osoba_id = studenci.osoba_id
INNER JOIN oceny ON oceny.student = studenci.osoba_id
WHERE imie LIKE 'Róża' AND nazwisko LIKE 'Ananas'
GROUP BY imie, nazwisko
)

--Zad5
SELECT imie, nazwisko FROM dydaktycy
INNER JOIN Osoby ON Dydaktycy.Osoba_id = Osoby.Osoba_id
WHERE Dydaktycy.Osoba_id NOT IN (SELECT Dydaktyk FROM oceny) AND YEAR(Data_zatrudnienia) = 2003


