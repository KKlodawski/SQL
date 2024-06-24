--1
select imie, nazwisko, count(idRezerwacja) as IloscRezerwacji from gosc
INNER JOIN rezerwacja ON gosc.idgosc = rezerwacja.IdGosc
GROUP BY imie, nazwisko
HAVING count(idRezerwacja) > 1;

--2
select NrPokoju from pokoj
WHERE liczba_miejsc = (select TOP 1 Liczba_miejsc from pokoj 
ORDER BY Liczba_miejsc DESC);

--3
SELECT NrPokoju,MAX(DataOd) as OstWynaj FROM Rezerwacja
GROUP BY NrPokoju

--4 
select Pokoj.NrPokoju,count(idRezerwacja) as IloscRezerwacji from Rezerwacja
INNER JOIN Pokoj ON Pokoj.NrPokoju = Rezerwacja.NrPokoju
INNER JOIN Kategoria ON Pokoj.IdKategoria = Kategoria.IdKategoria
WHERE Kategoria.Nazwa NOT LIKE 'Luksusowy'
GROUP BY Pokoj.NrPokoju
HAVING count(idRezerwacja) > 1

--5
SELECT TOP 1 imie,nazwisko,nrpokoju, DataOd FROM rezerwacja
INNER JOIN Gosc ON gosc.IdGosc=Rezerwacja.IdGosc
ORDER BY DataOd DESC

--6 
SELECT NrPokoju FROM Pokoj
WHERE NrPokoju NOT IN (SELECT DISTINCT NrPokoju FROM Rezerwacja)

--7
SELECT Imie,Nazwisko FROM GOSC A
WHERE NOT EXISTS (SELECT DISTINCT Imie,Nazwisko FROM Gosc B
INNER JOIN Rezerwacja ON B.IdGosc = Rezerwacja.IdGosc
INNER JOIN Pokoj ON Rezerwacja.NrPokoju = Pokoj.NrPokoju
INNER JOIN Kategoria ON Pokoj.IdKategoria = Kategoria.IdKategoria
WHERE Nazwa LIKE 'Luksusowy' AND B.IdGosc = A.IdGosc)

--8 
SELECT DISTINCT Imie,Nazwisko, ISNULL(Convert(varchar,DataOd),'Brak'),ISNULL(Convert(varchar,DataDo),'Brak') 
FROM Gosc
LEFT JOIN Rezerwacja ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE NrPokoju = 101 OR Gosc.IdGosc NOT IN 
(
Select Gosc.IdGosc FROM Gosc 
INNER JOIN Rezerwacja ON Gosc.IdGosc = Rezerwacja.IdGosc
)

--9
SELECT TOP 1 nazwa, count(NrPokoju) as Ilosc FROM Pokoj
INNER JOIN Kategoria ON Pokoj.IdKategoria = Kategoria.IdKategoria
GROUP BY nazwa
ORDER BY Ilosc DESC

--10
SELECT nazwa, NrPokoju, Liczba_miejsc FROM Pokoj A
INNER JOIN Kategoria ON A.IdKategoria = Kategoria.IdKategoria
WHERE Liczba_miejsc IN (
SELECT MAX(Liczba_miejsc) FROM Pokoj B
INNER JOIN Kategoria ON B.IdKategoria = Kategoria.IdKategoria
GROUP BY nazwa)
