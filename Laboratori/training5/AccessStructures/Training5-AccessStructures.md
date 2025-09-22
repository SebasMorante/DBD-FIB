# Training 5: Access Structures

## Pregunta 1

Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

SELECT sum(pressupost) from obres where id = 500;

En cas que us faci falta afegir la clau primària a la taula obres, la clau primària d'aquest taula és l'atribut id.

Abans d'iniciar la correcció:
Només hi ha d'haver al teu espai els objectes corresponents a aquest exercici (el script per esborrar tots els objectes abans de crear-ne cap, es pot trobar als materials del curs).
La paperera de reciclatge ha d'estar buida ("PURGE RECYCLEBIN").
Les estadísitiques de tots els objectes han d'estar actualitzades (el script d'actualitzar estadístiques al fitxer adjunt, i als materials del curs).

````sql
-- Fitxer adjunt
create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
);


DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix VallËs'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'VallËs Orient'; END if;
	if (nz = 6) then zona := 'VallËs Occident'; END if;
	if (nz = 7) then zona := 'MoianËs'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
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
````

## Pregunta 2

## Pregunta 3

Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent SENSE OCUPAR MÉS DE 150 BLOCS (arrodoniu l'espai per fila a múltiples de 1k):

SELECT sum(pressupost) from obres where id >= 5 and id <= 10;

En cas que us faci falta afegir la clau primària a la taula obres, la clau primària d'aquest taula és l'atribut id.

Abans d'iniciar la correcció:
Només hi ha d'haver al teu espai els objectes corresponents a aquest exercici (el script per esborrar tots els objectes abans de crear-ne cap, es pot trobar als materials del curs).
La paperera de reciclatge ha d'estar buida ("PURGE RECYCLEBIN").
Les estadísitiques de tots els objectes han d'estar actualitzades (el script d'actualitzar estadístiques al fitxer adjunt, i als materials del curs).

````sql
-- Fitxer adjunt
create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
);


DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix VallËs'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'VallËs Orient'; END if;
	if (nz = 6) then zona := 'VallËs Occident'; END if;
	if (nz = 7) then zona := 'MoianËs'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
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
````

## Pregunta 4

Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

select sum(o.pressupost), sum(p.pressupost)
from obres o, projectes p
where o.proj = p.id and p.id = 50;

Abans d'iniciar la correcció:
Només hi ha d'haver al teu espai els objectes corresponents a aquest exercici (el script per esborrar tots els objectes abans de crear-ne cap, es pot trobar als materials del curs).
La paperera de reciclatge ha d'estar buida ("PURGE RECYCLEBIN").
Les estadísitiques de tots els objectes han d'estar actualitzades (el script d'actualitzar estadístiques al fitxer adjunt, i als materials del curs).

````sql
-- Fitxer adjunt
create table projectes(
 id  number(8,0),
 zona char(20),
 pressupost number(17, 0),
 nom char(100),
  descripcio char(250),
  qual_mediamb char(250)
 );
 
create table obres(
 id  number(8,0),
 proj number(8, 0),
  tipus  number(17,0),
 pressupost number(17, 0),
 empreses char(250),
 responsables char(250)
);

DECLARE id INT; pn INT; i INT;
nz INT;
zona CHAR(20);
tipus INT;
proj int;

begin

for i in 1..100 loop
  	nz := (i - 1) Mod 10 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vall?s'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vall?s Orient'; END if;
	if (nz = 6) then zona := 'Vall?s Occident'; END if;
	if (nz = 7) then zona := 'Moian?s'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
        insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
end loop;


pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
        proj := (id - 1) mod 100 + 1;
	insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;


-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
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
````

## Pregunta 5

Donades la taula i les dades al fitxer adjunt, feu el disseny físic de manera que sigui òptima l'execució de la consulta següent:

select sum(o.pressupost), sum(p.pressupost)
from obres o, projectes p
where o.proj = p.id and p.id >95;

Abans d'iniciar la correcció:
Només hi ha d'haver al teu espai els objectes corresponents a aquest exercici (el script per esborrar tots els objectes abans de crear-ne cap, es pot trobar als materials del curs).
La paperera de reciclatge ha d'estar buida ("PURGE RECYCLEBIN").
Les estadísitiques de tots els objectes han d'estar actualitzades (el script d'actualitzar estadístiques al fitxer adjunt, i als materials del curs).

````sql
-- Fitxer adjunt
create table projectes(
 id  number(8,0),
 zona char(20),
 pressupost number(17, 0),
 nom char(100),
  descripcio char(250),
  qual_mediamb char(250)
 );
 
create table obres(
 id  number(8,0),
 proj number(8, 0),
  tipus  number(17,0),
 pressupost number(17, 0),
 empreses char(250),
 responsables char(250)
);

DECLARE id INT; pn INT; i INT;
nz INT;
zona CHAR(20);
tipus INT;
proj int;

begin

for i in 1..100 loop
  	nz := (i - 1) Mod 10 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vall?s'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vall?s Orient'; END if;
	if (nz = 6) then zona := 'Vall?s Occident'; END if;
	if (nz = 7) then zona := 'Moian?s'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
        insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
end loop;


pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
        proj := (id - 1) mod 100 + 1;
	insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;


-- Actualitzar estadÌstiques
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
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
````
