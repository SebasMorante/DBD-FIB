# Solucions L6-Training Workload Optimization

## QÜESTIÓ 1 (AT-450)

```sql
--Attachment
CREATE TABLE seus (
  id INTEGER,
  ciutat CHAR(40)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats (		
  id INTEGER, 
  nom CHAR(200), 
  sou INTEGER,
  edat INTEGER,
  dpt INTEGER, 
  historial CHAR(500)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE departaments (		
  id INTEGER,
  nom CHAR(200),
  seu INTEGER,
  tasques CHAR(2000)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

DECLARE
  i INTEGER;
BEGIN
DBMS_RANDOM.seed(0);

-- Insercions de seus
INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
-- Insercions de departaments
FOR i IN 1..1300 LOOP
  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
    i,
    LPAD(dbms_random.string('U',10),200,'*'),
    dbms_random.value(1,10),
    LPAD(dbms_random.string('U',10),2000,'*')
    );
  END LOOP;
-- Insercions d'empleats
FOR i IN 1..(13000) LOOP
  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
    i,
    LPAD(dbms_random.string('U',10),200,'*'),
    dbms_random.value(15000,50000),
    dbms_random.value(19,64),
    dbms_random.value(1,1500),
    LPAD(dbms_random.string('U',10),500,'*')
    );
  END LOOP;
END;

ALTER TABLE empleats SHRINK SPACE;
ALTER TABLE departaments SHRINK SPACE;
ALTER TABLE seus SHRINK SPACE;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
select value INTO i0
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');
  
SELECT MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r FROM empleats WHERE nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));

select value INTO i1
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT MAX(LENGTH(nom)) INTO r FROM empleats WHERE edat<20 AND sou>1000;

select value INTO i2
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r FROM empleats e, departaments d, seus s WHERE e.dpt=d.id AND d.seu=s.id;

select value INTO i3
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT MAX(LENGTH(id||nom||seu||tasques)) INTO r FROM departaments WHERE seu=4;

select value INTO i4
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure;
DROP TABLE measure PURGE;
```

**Q1 - (25%)**  
`SELECT * FROM empleats WHERE nom=TO_CHAR(LPAD('MMMMMMMMMM',200,'*'));`

**Q2 - (03%)**  
`SELECT nom FROM empleats WHERE sou>1000 AND edat<20;`

**Q3 - (25%)**  
`SELECT * FROM empleats e, departaments d, seus s WHERE e.dpt=d.id AND d.seu=s.id;`

**Q4 - (47%)**  
`SELECT * FROM departaments WHERE seu=4;`

- taula seus - 10 files, 8 blocs sense índex  
- taula departaments 1300 files, 456 blocs sense índex  
- taula empleats - 13000 files, 1216 blocs sense índex  

**Resultats de consultes:**  
- Q1 - 0 files al resultat  
- Q2 - 139 files al resultat  
- Q3 - 11255 files al resultat  
- Q4 - 143 files al resultat  

---

- 13000 empleats que cobren més de 1000  
- 139 empleats que tenen menys de 20 anys  
- 13000 valors diferents en l'atribut nom de la taula empleats  
- 10797 valors diferents en l'atribut sou a la taula empleats (coincideix amb el nombre de sous diferents d'empleats que cobren per sobre de 1000).  
- 46 valors diferents de l'atribut "edat" de la taula empleats (1 valor només de l'atribut en empleats de menys de 20 anys)  
- 10 valors diferents de l'atribut "seu" de la taula departaments  

### Opció 1 - sense estructures

**Cost:**  
- 945,22

**Ocupació:**  
* 1688 Blocs

**Cost per consulta tenint en compte el % d'ús:**  
**1.** 296.75  
**2**. 35.61  
**3**. 407  
**4**. 205.86  

**Cost per consulta sense tenir en compte el % d'ús**  
**1.** 1187  
**2.** 1187  
**3.** 1628  
**4.** 438  

**Plans d'accés**  
- Q1: Table access (full)  
- Q2: Table access (full)  
- Q3: Hash join entre departaments i empleats i del resultat amb seus  
- Q4: Table access (full)  

---

### Opció 2

**depts + empleats CLUSTERED STRUCTURE - per reduir el cost de Q3**  

**Cost:**  
* 3858,25  

**DESCARTADA**  
- Com es veu en la solució sense estructures, l'Oracle resol la join amb una hash join que dóna menys cost que en cas d'usar clustered structure.  
- Si es mira, les altres consultes també tenen un cost més alt perquè al fer un recorregut de tota la taula, i tenir una cluster structure, s'ha de llegir més blocs quan només interessa buscar files corresponents a una única taula.  

---

### Opció 3: departaments hash(seu) - per reduir el cost de Q4

**Cost:**  
* 759,57  

**Espai:**  
* 2256 blocs  

**Cost per consulta tenint en compte el % d'ús:**  

**1.** 296.75  
**2.** 35.61  
**3.** 407  
**4.** 20.21 (redueix cost)  

**Cost per consulta sense tenir en compte el % d'ús** 

**1.** 1187  
**2.** 1187  
**3.** 1628  
**4.** 43 (redueix cost)  

Millora el cost de la consulta Q4, però **DESCARTADA** per l'espai que ocupa  

---

### Opció 4: departaments B+(seu) - per reduir el cost de Q4

**Cost:**  
* 798,58  

**Espai:**  
* 1696 blocs  

**Cost per consulta tenint en compte el % d'ús:**  
1 296.75  
2 35.61  
3 407  
4 59.22 (redueix cost)  

**Cost per consulta sense tenir en compte el % d'ús**  
1 1187  
2 1187  
3 1628  
4 126 (redueix cost)  

Podria ser una solució  

---

### Opció 5: departaments bitmap(seu) - per reduir el cost de Q4

L'atribut seu de la taula departaments només té 10 valors diferents, el bitmap afavoreix la búsqueda per atributs amb un número de valors diferents (per exemple, inferior a 100).

**Cost:**  
* 798,58  

**Espai:**  
* 1688 blocs  

**Cost per consulta tenint en compte el % d'ús:**  
1 296.75  
2 35.61  
3 407  
4 59.22  

**Cost per consulta sense tenir en compte el % d'ús**  
1 1187  
2 1187  
3 1628  
4 126  

**Millor solució que el B+**

---

### Opció 7: afegir una estructura d'accés per reduir el cost de Q1 - es DESCARTA

- un bitmap no és una opció, ja que l'atribut nom té milers de noms diferents a la taula  
- un B+ i hash es descarten per l'espai que ocupen, ja que els valors de l'atribut nom són grans i farà que les estructures necessàries ocupin molt espai.  

---

### Opció 8: afegir una estructura d'accés per reduir el cost de Q2

- es descarta un B+ per sou perquè la condició és poc selectiva (13000 empleats que cobren més de 1000)  
- es descarta un bitmap per sou perquè és un atribut amb molts valors diferents.  
- es prova un B+ per edat (és una condició selectiva ja que només la compleixen 139 empleats)  

**Cost**  
765,64  

**Espai**  
1736  

**Cost per consulta tenint en compte el % d'ús:**  
1 296.75  
2 4.08  
3 407  
4 57.81  

**Cost per consulta sense tenir en compte el % d'ús**  
1 1187  
2 136  
3 1628  
4 123  

---

### Solució:

- seus SENSE ESTRUCTURA  
- departaments bitmap(seu) per millorar l'eficiència de Q4  
- empleats B+(edat) per millorar eficiencia de Q2  

**Cost:** 765,64  
**Espai:** 1736 blocs  
**Millor que només tenir el bitmap(seu)**

---

## QÜESTIÓ 2 (AT-463)

```sql
-- attachment

CREATE TABLE seus (
  id INTEGER,
  ciutat CHAR(40)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE departaments (		
  id INTEGER,
  nom CHAR(200),
  seu INTEGER,
  tasques CHAR(2000)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats (		
  id INTEGER, 
  nom CHAR(20), 
  sou INTEGER,
  edat INTEGER,
  dpt INTEGER, 
  historial CHAR(50)
  )  PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

DECLARE
  i INTEGER;
BEGIN
DBMS_RANDOM.seed(0);

-- Insercions de seus
INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');


-- Insercions de departaments
FOR i IN 1..1100 LOOP
  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
    LPAD(dbms_random.string('U',10),200,'*'),
    dbms_random.value(1,10),
LPAD(dbms_random.string('U',10),2000,'*')
    );
  END LOOP;

-- Insercions d'empleats
FOR i IN 1..(120000) LOOP
  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
    i,
    LPAD(dbms_random.string('U',10),20,'*'),
    dbms_random.value(15000,50000),
    dbms_random.value(19,64),
    dbms_random.value(1,900),
    LPAD(dbms_random.string('U',10),50,'*')
    );
  END LOOP;
END;

ALTER TABLE empleats SHRINK SPACE;
ALTER TABLE departaments SHRINK SPACE;
ALTER TABLE seus SHRINK SPACE;

---------------------------------- Update Statistics ----------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
FOR taula IN c LOOP
  DBMS_STATS.GATHER_TABLE_STATS( 
    ownname => esquema, 
    tabname => taula.table_name, 
    estimate_percent => NULL,
    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
    granularity => 'GLOBAL',
    cascade => TRUE
    );
  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 

i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
select value INTO i0
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');
  
SELECT MAX(LENGTH(e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r FROM empleats e, departaments d  WHERE e.dpt = d.id AND sou > 30000;

select value INTO i1
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT AVG(sou) INTO r FROM empleats WHERE edat > 35;

select value INTO i2
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT COUNT(*) INTO r FROM empleats WHERE dpt = 4;

select value INTO i3
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

SELECT MAX(LENGTH(id||nom||seu||tasques)) INTO r FROM departaments WHERE seu=2 AND nom > 'CMP';

select value INTO i4
from v$statname c, v$sesstat a
where a.statistic# = c.statistic#
  and sys_context('USERENV','SID') = a.sid
  and c.name in ('consistent gets');

INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
INSERT INTO measure (id,weight,i,f) VALUES (2,0.25,i1,i2);
INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
INSERT INTO measure (id,weight,i,f) VALUES (4,0.25,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure;
DROP TABLE measure PURGE;
```

### Opció sense estructures

- seus - 10 files, 8 blocs sense índex  
- departaments 1100 files, 384 blocs sense índex  
- empleats - 120000 files, 1440 blocs sense índex  

**Q1 - 68836 files**  
**Q2 - 75886 files**  
**Q3 - 130 files**  
**Q4 - 0 files**  

- Hi ha 33851 sous diferents a la taula empleats  
- Hi ha 46 edats diferents a la taula empleats  
- Hi ha 900 departaments diferents a la taula empleats  
- Hi ha 10 seus diferents a la taula departaments  
- Hi ha 1100 noms diferents a la taula departaments  

**Cost del workload:**  
1243,75  

**Cost per consulta tenint en compte el % d'ús:**  
`SELECT id,(f-i)*weight FROM measure;`  
1 445.5  
2 352.75  
3 352.75  
4 92.75  

**Cost per consulta sense tenir en compte el % d'ús**  
`SELECT id,(f-i) FROM measure;`  
1 1782  
2 1411  
3 1411  
4 371  

**Ocupació:**  
1688 Blocs  

---

### Opció amb un Clustered Index per departaments (id)  
Per si millora la Q1  
**Descartat**, Oracle passa a usar Nested Loops i el cost puja a 18407  

---

### Opció amb un índex B+ per empleats (sou)  
Per si millora la Q1  
**NO** millora l'eficiència de cap consulta, usa el mateix pla d'accés que quan no hi ha cap estructura creada.  

---

### Opció amb un índex B+ per empleats(edat, sou)  
Per si millora la Q2. Es podria resoldre només amb l'índex  

**Cost del workload:**  
959,5  

**Cost tenint en compte pesos:**  
1 445.5  
2 68.5 (millora Q2 considerablement)  
3 352.75  
4 92.75  

**Espai ocupat:**  
2344 blocs (per sota de 2410 blocs que demana l'enunciat)  
De moment aquesta solució pot ser considerada  

---

### Opció amb un index B+ per empleats(edat,sou), i un bitmap per depts(seu)  

**Cost:**  
894  

**Cost tenint en compte pesos:**  
1 445.5  
2 68.5  
3 352.75  
4 27.25  

**Espai ocupat:**  
2352 blocs (per sota de 2410 blocs que demana l'enunciat)  

---

### Opció amb un índex B+ per empleats(edat,sou), i un bitmap per depts(seu), i un bitmap per empl(dpt)  

**Cost:**  
541  

**Cost tenint en compte pesos:**  
1 445.5  
2 68.5  
3 0.5  
4 27.25  

**Espai ocupat:**  
2400 blocs (per sota de 2410 blocs que demana l'enunciat)  

---

### SOLUCIÓ

- B+ Empleats(edat, sou)  
- Bitmap Empleats(dpt)  
- Bitmap Departaments(seu)