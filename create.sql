CREATE TABLE Nava (
    ID_Nava INT NOT NULL PRIMARY KEY,
    Nume_Nava VARCHAR(255) NOT NULL,
    Capacitate VARCHAR(255) NOT NULL,
    An_Constructie INT NOT NULL,
    Status VARCHAR(255) NOT NULL
);

CREATE TABLE Echipaj (
    ID_Echipaj INT NOT NULL PRIMARY KEY,
    ID_Nava INT NOT NULL,
    Nume_Echipaj VARCHAR(255) NOT NULL,
    Persoane_Echipaj INT NOT NULL,
    constraint fk_Echipaj_ID_Nava foreign key (ID_Nava) 
      references Nava (ID_Nava)
);

CREATE TABLE Persoana (
    CNP INT NOT NULL PRIMARY KEY,
    Nume VARCHAR(255) NOT NULL,
    Data_nastere DATE NOT NULL
);


CREATE TABLE Pasager (
    ID_Pasager INT NOT NULL PRIMARY KEY,
    CNP INT NOT NULL,
    Punte INT NOT NULL,
    constraint fk_Pasager_CNP foreign key (CNP) 
      references Persoana(CNP)
);

CREATE TABLE Membrii (
    ID_Membru INT NOT NULL PRIMARY KEY,
    CNP INT NOT NULL,
    ID_Echipaj INT NOT NULL,
    Functie VARCHAR(255) NOT NULL,
    constraint fk_Membrii_CNP foreign key (CNP) 
      references Persoana(CNP),
    constraint fk_Membrii_ID_Echipaj foreign key (ID_Echipaj) 
      references Echipaj(ID_Echipaj)
);

CREATE TABLE Croaziera (
    ID_Croaziera INT NOT NULL PRIMARY KEY,
    Nume_Croaziera VARCHAR(255) NOT NULL,
    Traseu VARCHAR(255) NOT NULL,
    Durata VARCHAR(255) NOT NULL,
    Pret VARCHAR(255) NOT NULL
);

CREATE TABLE Port (
    ID_Port INT NOT NULL PRIMARY KEY,
    Nume_Port VARCHAR(255) NOT NULL,
    Durata_stationare VARCHAR(255) NOT NULL
);

CREATE TABLE Categorie (
    ID_Categorie INT NOT NULL PRIMARY KEY,
    Tip_Categorie VARCHAR(255) NOT NULL
);

CREATE TABLE Alimente (
    ID_Aliment INT NOT NULL PRIMARY KEY,
    Nume_Al VARCHAR(255) NOT NULL,
    ID_Categorie INT NOT NULL,
    constraint fk_Alimente_ID_Categorie foreign key (ID_Categorie) 
      references Categorie(ID_Categorie)
);

CREATE TABLE Ofera (
    ID_Nava INT NOT NULL,
    ID_Croaziera INT NOT NULL,
    constraint fk_Ofera_ID_Nava foreign key (ID_Nava) 
      references Nava(ID_Nava),
    constraint fk_Ofera_ID_Croaziera foreign key (ID_Croaziera) 
      references Croaziera(ID_Croaziera)  
);


CREATE TABLE Trece (
    ID_Croaziera INT NOT NULL,
    ID_Port INT NOT NULL,
    constraint fk_Trece_ID_Croaziera foreign key (ID_Croaziera) 
      references Croaziera(ID_Croaziera),
    constraint fk_Trece_ID_Port foreign key (ID_Port) 
      references Port(ID_Port)  
);

CREATE TABLE Dispune (
    ID_Croaziera INT NOT NULL,
    ID_Aliment INT NOT NULL,
    constraint fk_Dispune_ID_Croaziera foreign key (ID_Croaziera) 
      references Croaziera(ID_Croaziera),
    constraint fk_Dispune_ID_Aliment foreign key (ID_Aliment) 
      references Alimente(ID_Aliment)
);

CREATE TABLE Are (
    ID_Croaziera INT NOT NULL,
    ID_Pasager INT NOT NULL,
    constraint fk_Are_ID_Croaziera foreign key (ID_Croaziera) 
      references Croaziera(ID_Croaziera),
    constraint fk_Are_ID_Pasager foreign key (ID_Pasager) 
      references Pasager(ID_Pasager)
);