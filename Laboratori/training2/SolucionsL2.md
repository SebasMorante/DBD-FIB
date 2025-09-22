# Solucions L2

## Qüestió 1

```sql
CREATE TABLE Grup (
 nom varchar(1) ,
 monitor varchar(1) ,
 CONSTRAINT Grup_PK PRIMARY KEY (nom));
 
 CREATE TABLE Noi (
 Grup_nom varchar(1)  NOT NULL,
 nom varchar(1) ,
 edat varchar(1) ,
 Mascota_nom varchar(1),
 CONSTRAINT Noi_FK_Grup FOREIGN KEY (Grup_nom) REFERENCES Grup(nom),
 CONSTRAINT Noi_PK PRIMARY KEY (nom),
 CONSTRAINT Noi_UNIQUE UNIQUE (Mascota_nom));
 
 CREATE TABLE Amics (
 Noi1_nom varchar(1) NOT NULL,
 Noi2_nom varchar(1) NOT NULL,
 CONSTRAINT Amics1_FK_Noi FOREIGN KEY (Noi1_nom) REFERENCES Noi(nom),
 CONSTRAINT Amics2_FK_Noi FOREIGN KEY (Noi2_nom) REFERENCES Noi(nom),
 CONSTRAINT Amics_PK PRIMARY KEY (Noi1_nom, Noi2_nom),
CONSTRAINT Amics_check CHECK(Noi1_nom<>Noi2_nom));
 
 CREATE TABLE Incompatibles (
 Mascota1_nom varchar(1) NOT NULL,
 Mascota2_nom varchar(1) NOT NULL,
 CONSTRAINT Incompatibles1_FK_Mascota FOREIGN KEY (Mascota1_nom) REFERENCES Noi(Mascota_nom),
 CONSTRAINT Incompatibles2_FK_Mascota FOREIGN KEY (Mascota2_nom) REFERENCES Noi(Mascota_nom),
 CONSTRAINT Incompatibles_PK PRIMARY KEY (Mascota1_nom, Mascota2_nom),
CONSTRAINT incompatibles_check CHECK (Mascota1_nom<>Mascota2_nom) );
```


## Qüestió 2

```sql
CREATE TABLE Bicicleta (
 id VARCHAR(1) ,
 CONSTRAINT Bicicleta_PK PRIMARY KEY (id));
 
 CREATE TABLE corredorM (
 club VARCHAR(1) ,
 federacio VARCHAR(1) ,
 Corredor_id VARCHAR(1) ,
 CONSTRAINT M_PK PRIMARY KEY (Corredor_id));
 
 CREATE TABLE corredorC (
 edat VARCHAR(1) ,
 pes VARCHAR(1) ,
 alt VARCHAR(1) ,
 Corredor_id VARCHAR(1) ,
 CONSTRAINT C_PK PRIMARY KEY (Corredor_id));
 
 CREATE TABLE Usa (
 C_Corredor_id VARCHAR(1) NOT NULL,
 Bicicleta_id VARCHAR(1),
 CONSTRAINT Usa_FK_C FOREIGN KEY (C_Corredor_id) REFERENCES corredorC(Corredor_id),
 CONSTRAINT Usa_FK_Bicicleta FOREIGN KEY (Bicicleta_id) REFERENCES Bicicleta(id),
 CONSTRAINT Usa_PK PRIMARY KEY (Bicicleta_id));
```

## Qüestió 3

```sql
 CREATE TABLE Esplai (
 Nom VARCHAR(1) ,
 Adreca VARCHAR(1) ,
 CONSTRAINT Esplai_PK PRIMARY KEY (Nom));
 
 CREATE TABLE Jornada (
 Data VARCHAR(1) ,
 SortSol VARCHAR(1) ,
 PostaSol VARCHAR(1) ,
 CONSTRAINT Jornada_PK PRIMARY KEY (Data));
 
 CREATE TABLE Noi (
 Nom VARCHAR(1) ,
 Cognom1 VARCHAR(1) ,
 Cognom2 VARCHAR(1) ,
 Edat VARCHAR(1) ,
 CONSTRAINT Noi_PK PRIMARY KEY (Cognom2,  Nom,  Cognom1));
 
 CREATE TABLE Tanda (
 Ident VARCHAR(1) ,
 Esplai_PK_Nom VARCHAR(1) ,
 CONSTRAINT Tanda_FK_EsplaiPK FOREIGN KEY (Esplai_PK_Nom) REFERENCES Esplai(Nom),
 CONSTRAINT Tanda_PK PRIMARY KEY (Ident,  Esplai_PK_Nom));
 
 CREATE TABLE Calendari (
 Jornada_Data VARCHAR(1),
 Tanda_Ident VARCHAR(1),
 Tanda_Esplai_PK_Nom VARCHAR(1),
 CONSTRAINT Calendari_FK_Jornada FOREIGN KEY (Jornada_Data) REFERENCES Jornada(Data),
 CONSTRAINT Calendari_FK_Tanda FOREIGN KEY (Tanda_Ident, Tanda_Esplai_PK_Nom) REFERENCES Tanda(Ident, Esplai_PK_Nom),
 CONSTRAINT Calendari_PK PRIMARY KEY (Jornada_Data, Tanda_Ident, Tanda_Esplai_PK_Nom));
 
 CREATE TABLE Membre (
 Noi_Cognom2 VARCHAR(1),
 Noi_Nom VARCHAR(1),
 Noi_Cognom1 VARCHAR(1),
 Tanda_Ident VARCHAR(1),
 Tanda_Esplai_PK_Nom VARCHAR(1) NOT NULL,
 CONSTRAINT Membre_FK_Noi FOREIGN KEY (Noi_Cognom2, Noi_Nom, Noi_Cognom1) REFERENCES Noi(Cognom2, Nom, Cognom1),
 CONSTRAINT Membre_FK_Tanda FOREIGN KEY (Tanda_Ident, Tanda_Esplai_PK_Nom) REFERENCES Tanda(Ident, Esplai_PK_Nom),
 CONSTRAINT Membre_PK PRIMARY KEY (Noi_Cognom2, Noi_Nom, Noi_Cognom1, Tanda_Ident, Tanda_Esplai_PK_Nom));
 
 CREATE TABLE Sortida (
 Tanda_Ident VARCHAR(1) NOT NULL,
 Tanda_Esplai_PK_Nom VARCHAR(1) NOT NULL,
 Jornada_Data VARCHAR(1) NOT NULL,
 Noi_Cognom2 VARCHAR(1) NOT NULL,
 Noi_Nom VARCHAR(1) NOT NULL,
 Noi_Cognom1 VARCHAR(1) NOT NULL,
 CONSTRAINT Sortida_FK_Calendari FOREIGN KEY (Jornada_Data, Tanda_Ident, Tanda_Esplai_PK_Nom) REFERENCES Calendari(Jornada_Data, Tanda_Ident, Tanda_Esplai_PK_Nom),
 CONSTRAINT Sortida_FK_Membre FOREIGN KEY (Noi_Cognom2, Noi_Nom, Noi_Cognom1, Tanda_Ident, Tanda_Esplai_PK_Nom) REFERENCES Membre(Noi_Cognom2, Noi_Nom, Noi_Cognom1, Tanda_Ident, Tanda_Esplai_PK_Nom),
 CONSTRAINT Sortida_PK PRIMARY KEY (Jornada_Data, Noi_Cognom2, Noi_Nom, Noi_Cognom1));
```

