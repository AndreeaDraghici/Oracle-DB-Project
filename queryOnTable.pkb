--Crearea index-ului ' index_nume' pe coloana Nume_Echipaj din tabelul Echipaj
CREATE Index index_nume ON Echipaj (Nume_Echipaj);

--1.Se afiseaza numele navelor 
SELECT Nume_Nava FROM Nava;
--2.Se afiseaza alimentele cu categoria asociata acestora in functie de id
SELECT * FROM Alimente INNER JOIN Categorie USING (ID_Categorie);

--3.Se afiseaza numele navei ce are anul de constructie 1990
SELECT Nume_Nava FROM Nava  WHERE An_Constructie='1990';

--4.Se afiseaza numele echipajului cu ID-ul 128
SELECT Nume_Echipaj FROM Echipaj WHERE ID_Echipaj='128';

--5.Se afiseaza numele echipajului care apartine navei cu ID-ul 252
SELECT E.Nume_Echipaj FROM Echipaj E, Nava N WHERE N.ID_Nava='254' AND N.ID_Nava=E.ID_Nava;

--6.Se afiseaza numele echipajului din care face parte membrul cu ID-ul 1320 
SELECT E.Nume_Echipaj FROM Echipaj E,Membrii M WHERE M.ID_Membru='1320' AND M.ID_Echipaj=E.ID_Echipaj;

--7.Se afiseaza numele alimentelor ce apartin categoriei cu ID-ul 310
SELECT A.Nume_Al FROM Alimente A,Categorie C WHERE C.ID_Categorie='310' AND C.ID_Categorie=A.ID_Categorie;

--8.Se afiseaza functia membrilor care apartin echipajului cu numele Havre
SELECT Functie FROM Membrii M,Echipaj E WHERE E.Nume_Echipaj='Havre' AND M.ID_Echipaj=E.ID_Echipaj;

--9.Se afiseaza numele croazierelor 
SELECT Nume_Croaziera FROM Croaziera;

--10.Se afiseaza puntea unde sunt pasagerului cu CNP-ul 1870517101243
SELECT Punte FROM Pasager G,Persoana P WHERE P.CNP='1870517101243' AND G.CNP=P.CNP;

--11.Se afiseaza CNP-ul, numele si data nasterii tuturor persoanelor 
SELECT CNP,Nume,Data_nastere FROM Persoana;

--12.Se afiseaza numele echipajelor cu ID-ul mai mic de 126
SELECT Nume_Echipaj FROM Echipaj WHERE ID_Echipaj <Some(SELECT ID_Echipaj FROM Echipaj WHERE ID_Echipaj='126');

--13.Se afiseaza alimentele in ordine alfabetica 
SELECT ID_Aliment,Nume_Al,ID_Categorie FROM Alimente ORDER BY Nume_Al ASC;

--14.Se afiseaza categoriile pentru alimente in ordine alfabetica 
SELECT ID_Categorie, Tip_Categorie FROM Categorie ORDER BY ID_Categorie ASC;

--15.Se afiseaza numele pasagerilor in ordine inversa
SELECT Nume FROM Persoana, Pasager WHERE Pasager.CNP=Persoana.CNP ORDER BY Nume DESC;

--16.Se afiseaza ID-ul, numele si categoria alimentelor de care dispune croaziera cu ID-ul 621
SELECT A.ID_Aliment, A.Nume_Al,A.ID_Categorie FROM Alimente A,Dispune D,Croaziera C 
WHERE D.ID_Croaziera='621' AND D.ID_Aliment=A.ID_Aliment
			 And D.ID_Croaziera=C.ID_Croaziera;

--17.Se afiseaza numele, traseul si pretul croazierei din portul cu ID-ul 420
SELECT R.Nume_Croaziera,R.Traseu,R.Pret FROM Croaziera R,Trece T,Port P 
WHERE P.ID_Port='420' AND T.ID_Croaziera=R.ID_Croaziera
		    AND T.ID_Port=P.ID_Port;

--18.Se afiseaza echipajul cu id-ul=116 care se afla in croziera ce are ca traseu Barcelona si Durata de 8 nopti
SELECT * FROM Echipaj E NATURAL JOIN Croaziera C WHERE E.ID_Echipaj='116' AND C.Traseu='Barcelona' AND C.Durata='8 nopti';

--19.Se afiseaza numarul total de persoane 
SELECT COUNT(*) FROM Persoana;

--20.Se afiseaza categoriile de alimente grupandu-le dupa tipul lor
SELECT Tip_Categorie FROM Categorie GROUP BY Tip_Categorie;

--21.Se afiseaza durata minim de stationare si maxima a navelor in port
SELECT MIN(Durata_stationare), MAX(Durata_stationare) FROM Port;

--22.Se afiseaza in ordine functia membrilor cu ID-ul cuprins intre 1320 si 1321	
SELECT * FROM Membrii WHERE ID_Membru BETWEEN 1320 AND 1322 ORDER BY Functie;



--1.functie ce are ca scop verificarea anului de constructie
CREATE OR REPLACE FUNCTION anConstructie 
RETURN INT IS 
   flag INT; 

BEGIN 
   FOR an IN (SELECT An_Constructie INTO flag FROM Nava)
   LOOP
   flag := an.An_Constructie;
     IF flag <= 1800 THEN  
          dbms_output.put_line('Nava este scoasa din uz.' ); 
        ELSE 
          dbms_output.put_line('Nava este in uz. Anul de constructie al acesteia este: ' || flag); 
    END IF;
   END LOOP;
   RETURN flag; 
END; 
/ 

DECLARE 
   rezultat INT; 
BEGIN 
   rezultat := anConstructie(); --apelam functia
END; 
/


--2. functie ce are ca scop calcularea numarului total de persoane
CREATE OR REPLACE FUNCTION totalPersoane 
RETURN number IS 
   total number(2) := 0; 
BEGIN 
   SELECT count(*) into total 
   FROM Persoana; 
    
   RETURN total; 
END; 
/ 

DECLARE 
   rezultat number(2); 
BEGIN 
   rezultat := totalPersoane(); --apelam functia
   dbms_output.put_line('Numarul total de persoane este: ' || rezultat); --se afiseaza rezultatul
END; 
/



--1.procedura ce care ca scop inserarea unei noi inregistrari in tabelul categorie.
CREATE OR replace PROCEDURE InsereazaCategorieNoua(ID_Categorie IN INT,Tip_Categorie IN VARCHAR)    
IS  

BEGIN    
   INSERT INTO Categorie VALUES(ID_Categorie,Tip_Categorie);    
END;    
/

--blocul in care se executa procedura
BEGIN    
   InsereazaCategorieNoua(666,'Test');  
   dbms_output.put_line('S-a inserat cu succes un nou tip categorie in tabel!');    
END;    
/   




--2. procedura ce are ca scop pe baza unui CNP ca input sa afiseze informatiile persoanei ce are acel CNP, altfel arunca o exceptie
CREATE OR REPLACE PROCEDURE afiseazaPersoana(id INT)
IS
  p Persoana%ROWTYPE; --ofera un tip de inregistrare care reprezinta un rand dintr-o tabela
BEGIN
  -- obtinem persoana pe baza CNP-ului
  SELECT * INTO p FROM Persoana WHERE CNP = id;

  -- afisam informatiile despre persoana a carui CNP a fost introdus
  dbms_output.put_line(' NUME: ' || p.Nume || ' DATA NASTERE: < ' || p.Data_nastere ||' > ' );

EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line( SQLERRM );
END;
/
--blocul in care se executa procedura
BEGIN    
   afiseazaPersoana(2870517101220);
END;    
/   


--1. Trigger - acesta are ca scop sa afiseze diferenta dintr numarul de persoane ce se aflau la inceput in echipaj si numarul actual
CREATE OR REPLACE TRIGGER afiseazaDiferentaPersoaneEchipaj 
BEFORE DELETE OR INSERT OR UPDATE ON Echipaj 
FOR EACH ROW 
WHEN (NEW.ID_Echipaj > 0) 
DECLARE 
   diferanta INT; 
BEGIN 
   diferanta := :NEW.Persoane_Echipaj  - :OLD.Persoane_Echipaj; 
   dbms_output.put_line('Nr persoane echipaj inainte de actualizare: ' || :OLD.Persoane_Echipaj); 
   dbms_output.put_line('Nr persoane echipaj acum: ' || :NEW.Persoane_Echipaj); 
   dbms_output.put_line('Diferenta nr persoane: ' || diferanta); 
END; 
/ 

BEGIN
   INSERT INTO Echipaj (ID_Echipaj,ID_Nava,Nume_Echipaj,Persoane_Echipaj) VALUES (133, 258, 'Test',1400); 

   UPDATE Echipaj SET Persoane_Echipaj=400 WHERE ID_Echipaj = 133; 
END;

--2. Trigger - acesta are ca scop sa afiseze diferenta dintre pretul initial si cel actual al unei croaziere
CREATE OR REPLACE TRIGGER afiseazaDiferentaPretCroaziere
BEFORE DELETE OR INSERT OR UPDATE ON Croaziera 
FOR EACH ROW 
WHEN (NEW.ID_Croaziera > 0) 
DECLARE 
   diferanta varchar(255); 
BEGIN 
   diferanta := :NEW.Pret  - :OLD.Pret; 
   dbms_output.put_line('Pret inainte de modificare: ' || :OLD.Pret); 
   dbms_output.put_line('Pret dupa modificare: ' || :NEW.Pret); 
   dbms_output.put_line('Diferenta: ' || diferanta); 
END; 
/ 

BEGIN
   INSERT INTO Croaziera (ID_Croaziera,Nume_Croaziera,Traseu,Durata,Pret) VALUES (1000, 'Test', 'Test','1400','200'); 

   UPDATE Croaziera SET Pret=Pret*10 WHERE ID_Croaziera = 1000; 
END;

