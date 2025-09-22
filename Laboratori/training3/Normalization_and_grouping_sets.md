# Training 3: Normalization and grouping sets

## Pregunta 1

Suposa que volem mantenir informació dels diferents tipus de peixos d'aquari. Concretament, volem mantenir el nom tècnic de l'espècie, la família a la qual pertanyen, el color que presenten, el mecanisme de reproducció i la seva raresa.

Per crear la base de dades, partim d'aquesta relació:

    Peixos(especie, familia, color, reproduccio, raresa)

Se sap que dins d'una família de peixos n'hi ha que són més o menys rars, que totes les espècies de la mateixa família tenen el mateix mecanisme de reproducció, que una espècie pertany només a una família i que tots els peixos d'una espècie tenen el mateix color. També se sap que no pot haver dues espècies dins de la mateixa família que tinguin el mateix color.

Es dedueixen les dependències següents:
* Familia -> Reproduccio
* Especie -> Familia
* Especie -> Color
* Familia, Color -> Especie
* Especie -> Raresa

Normalitza-ho fins a BCNF tenint en compte que la solució ha de constar d'una sèrie "CREATE TABLES" on NO importa el nom que doneu a les taules, NI els tipus de dades que utilitzeu, pero SÍ els noms dels atributs (que han de coincidir exactament amb els de la relació donada). A més, cal que no oblideu definir les claus foranes i alternarives (UNIQUE+NOT NULL) necessàries. Considerarem també que els atributs que no siguin clau candidata admeten valor nul.

## Pregunta 2

Volem mantenir informació sobre el PIB dels països, el deute que mantenen entre ells i sobre agències de qualificació que existeixen en els països. Per crear la base de dades, partim d'aquesta relació:

    R(ag, paisAg, pib, paisD, paisAc, deute)

Coneixem aquestes dependències:
* ag -> paisAg
* paisD, paisAc -> deute
* paisAg -> pib  

Feu servir l'algoritme d'anàlisi per obtenir un model normalitzat. Si hi ha diverses solucions, trieu aquella en què hi hagi alguna taula T tal que:
* T és referenciada per una altra taula que no és T.
* T conté una clau forana que referencia una altra taula que no és T.

Tingueu en compte que la solució ha de constar d'una sèrie "CREATE TABLES" on NO importa el nom que doneu a les taules, NI els tipus de dades que utilitzeu, pero SÍ els noms dels atributs (que han de ser exactament els que apareixen a la relació de partida). A més, cal que no oblideu definir les claus foranes i alternarives (UNIQUE+NOT NULL) necessàries. Considerarem també que els atributs que no siguin clau candidata admeten valor nul.

## Pregunta 3

Ens plantegem posar en marxa un sistema peer-to-peer per l'intercanvi de material (legal) amb els teus companys. Discutint com hauria de ser el disseny de la base de dades, arribeu a les següents conclusions:

Un usuari puja un fitxer a un peer. Des d'aquest moment, aquest fitxer queda emmagatzemat en aquest peer, i podeu asumir que mai es mourà d'allà (com es comuniquen els peers entre ells està fora de les nostres preocupacions, ara mateix). Tot seguit, es compara aquest fitxer amb tots els altres continguts al peer, i es computen unes mètriques de similitud. D'acord amb aquestes mètriques, s'assigna un id_object únic a tots els fitxers que es reconeixen com el mateix objecte (per exemple, la mateixa pel·lícula o la mateixa cançó). Per tant, dintre d'un mateix peer, un id_object pot estar relacionat amb molts fitxers diferents, però un fitxer només pot referenciar un id_object (que té associat una descripció). Adona't que res impedeix a un usuari pujar el mateix fitxer a un altre peer, però en aquest cas, podeu asumir que les vostres mètriques funcionen prou bé, com per a que sigui quin sigui el peer d'entrada, l'id_object associat al fitxer serà sempre el mateix.
Sabem que un peer s'identifica pel seu id intern de sistema i que, similarment, cada fitxer pujat s'identifica amb un id que li assigna el sistema peer-to-peer.

Els camps que us interesa guardar de tota aquesta discussió són els següents (i només aquests):

shares (id_object, descr_object, peer_url, peer_id, file_id, file_size, file_extension)

De cara a normalitzar, tingueu en compte aquestes dependències:

file_id -> file_size, file_extension
id_object -> descr_object
peer_id -> peer_url
file_id -> id_object

A més, sabem que un peer també es podria identificar per la seva URL.

Normalitza-ho tenint en compte que la solució ha de constar d'una sèrie "CREATE TABLES" on no importa el nom que doneu a les taules, ni els tipus de dades que utilitzeu, pero sí els noms dels atributs (que han de coincidir exactament amb els de les relacions donades). A més, cal que no oblideu definir les claus foranes i alternarives (UNIQUE+NOT NULL) necessàries. Considerarem també que els atributs que no siguin clau candidata admeten valor nul.

## Pregunta 4

Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals, i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tots els Països Catalans, no només a Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:

|            | Bàsica | Comand. | Total |
|------------|--------|---------|-------|
| Barcelona  | 100    | 4       | 104   |
| Tarragona  | 2      | 1       | 3     |
| Lleida     | 20     | 1       | 21    |
| Girona     | 30     | 1       | 31    |
| **Total**  |        |         | 159   |

La taula conté per l'any 2009, la suma de mossos de l'especialitat "Antidisturbi" que hi ha assignats, a les quatre províncies catalanes, segons si pertanyen a l'escala de rangs bàsica (valor "Basica"), o són comandaments (valor "Comand.", noteu el punt final). Poseu al SELECT els atributs del nom de la escala i província, seguits per la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.

```sql
--fitxer adjunt
CREATE TABLE perfil (
	Id INTEGER,
	Sexe CHAR CHECK (sexe='M' OR sexe='F') NOT NULL,
	Edat INTEGER,
           CONSTRAINT perfil_PK PRIMARY KEY (id)
);

CREATE TABLE poblacio (
	Nom CHAR(30),
	Provincia CHAR(10),
	Comarca CHAR(15),
           CONSTRAINT poblacio_PK PRIMARY KEY (nom)
	);

CREATE TABLE data (
	Id DATE,
mes CHAR(8) NOT NULL CHECK (mes IN ('Gener', 'Febrer', 'Marc', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost', 'Setembre', 'Octubre', 'Novembre', 'Decembre')), 
anyo CHAR(4) NOT NULL,
          CONSTRAINT data_PK PRIMARY KEY (id)
);

CREATE TABLE especialitat (
	Nom CHAR(12),
	Tipus CHAR(18),
           CONSTRAINT especialitat_PK PRIMARY KEY (nom)
);

CREATE TABLE rang (
	Nom CHAR(13),
	Escala CHAR(9),
           CONSTRAINT rang_PK PRIMARY KEY (nom)
	);

CREATE TABLE destinacio (
	perfilId INTEGER ,
	poblacioId CHAR(30) ,
	dataId DATE,
	especialitatId CHAR(12) ,
	rangId CHAR(13),
	mossos INTEGER,
           CONSTRAINT destinacio_PK PRIMARY KEY (perfilId,poblacioId,dataId,especialitatId,rangId),
          CONSTRAINT destinacio_FK_perfil FOREIGN KEY (perfilId) REFERENCES perfil(id),
          CONSTRAINT destinacio_FK_rang FOREIGN KEY (rangId) REFERENCES rang(nom),
          CONSTRAINT destinacio_FK_especialitat FOREIGN KEY (especialitatId) REFERENCES especialitat(nom),
          CONSTRAINT destinacio_FK_data FOREIGN KEY (dataId) REFERENCES data(id),
          CONSTRAINT destinacio_FK_poblacio FOREIGN KEY (poblacioId) REFERENCES poblacio(nom)
	);

-------------------------------------------------------------------

INSERT INTO perfil VALUES (1, 'F', 23);
INSERT INTO especialitat VALUES ('Transit','A');
INSERT INTO especialitat VALUES ('TEDAX','B');
INSERT INTO especialitat VALUES ('Antidisturbi','A');
INSERT INTO rang VALUES ('Mosso', 'Basica');
INSERT INTO rang VALUES ('Caporal', 'Basica');
INSERT INTO rang VALUES ('Inspector', 'Comand.');
INSERT INTO poblacio VALUES ('Badalona', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Hospitalet', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Lleida', 'Lleida', 'Segria');
INSERT INTO poblacio VALUES ('Ponts', 'Lleida', 'Noguera');
INSERT INTO poblacio VALUES ('Tarragona', 'Tarragona', 'Tarragones');
INSERT INTO poblacio VALUES ('Girona', 'Girona', 'Girones');
INSERT INTO data VALUES (to_date('10/10/2003', 'DD/MM/YY'),'Octubre', '2003');
INSERT INTO data VALUES (to_date('10/10/2004', 'DD/MM/YY'),'Octubre', '2004');
INSERT INTO data VALUES (to_date('10/10/2009', 'DD/MM/YY'),'Octubre', '2009');
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 150);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 6);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 200);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 201);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 50);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 2);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 200);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 20);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 250);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 23);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 137);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 15);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 50);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Tarragona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 2);
INSERT INTO destinacio VALUES (1, 'Tarragona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector',1);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso',100);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector',4);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 20);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector', 1);
INSERT INTO destinacio VALUES (1, 'Girona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 30);
INSERT INTO destinacio VALUES (1, 'Girona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector', 1);
```

## Pregunta 5

Utilitzant les clàusules del SQL'99 específiques per consultes multidimensionals, i l'esquema en estrella que pots trobar al fitxer adjunt (que representa la història de tots els mossos de tota Catalunya), creeu una vista que porti per nom "nomVista" que correspongui a la taula estadística següent:

| Especialitat     | Comarca    | 2003 | 2004 | Tots anys |
|------------------|------------|------|------|-----------|
| **Investigacio** |            |      |      |           |
|                  | Barcelones | 0    | 493  | 493       |
|                  | **Total Barcelona** | 0 | 493 | 493   |
|                  | Segria     | 0    | 152  | 152       |
|                  | Noguera    | 0    | 58   | 58        |
|                  | **Total Lleida**    | 0 | 210 | 210   |
| **Total Investigacio** |      | 0    | 703  | 703       |
| **Transit**      |            |      |      |           |
|                  | Barcelones | 364  | 0    | 364       |
|                  | **Total Barcelona** | 364 | 0 | 364   |
|                  | Segria     | 209  | 0    | 209       |
|                  | Noguera    | 52   | 0    | 52        |
|                  | **Total Lleida**    | 261 | 0 | 261   |
| **Total Transit**|            | 625  | 0    | 625       |
| **Totes especialitats** |      |      |      |           |
|                  | Barcelones | 364  | 493  | 857       |
|                  | **Total Barcelona** | 364 | 493 | 857 |
|                  | Segria     | 209  | 152  | 361       |
|                  | Noguera    | 52   | 58   | 110       |
|                  | **Total Lleida**    | 261 | 210 | 471 |
| **Total**        |            | 625  | 703  | 1328      |


La taula conté per als anys 2003 i 2004, la suma (d'entre tots els perfils, rangs i poblacions) de mossos de l'especialitat "Transit" i "Investigacio" que hi ha assignats, a les comarques del Barcelones, Segria i Noguera. Poseu al SELECT els atributs de la comarca, provincia, especialitat i any, seguits de la suma de la mesura, exactament en aquest ordre. No cal que rescribiu els valors nuls de la sortida com a 'Total' i no poseu ORDER BY, perque les vistes no ho accepten.