# Training 5: Access Structures

## Solucions

* QÜESTIÓ 1

Hash Obres(id)

* QÜESTIÓ 2

Sense índex

* QÜESTIÓ 3

Unique B+ Obres(id)


* QÜESTIÓ 4

Hash Projectes(id)
Hash Obres(proj)

* QÜESTIÓ 5

Índex Cluster Projectes(id)
Hash Obres(proj)

## Analisi

### Pregunta 1

* **Btree**
````sql
Begin
for s in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||s.sequence_name);
end loop;
for mv in (select mview_name from user_mviews) loop
execute immediate ('drop materialized view '||mv.mview_name);
end loop;
for t in (select table_name from user_tables) loop
execute immediate ('drop table '||t.table_name||' cascade constraints');
end loop;
for i in (select index_name from user_indexes) loop
execute immediate ('drop index '||i.index_name);
end loop;
for c in (select cluster_name from user_clusters) loop
execute immediate ('drop cluster '||c.cluster_name);
end loop;
execute immediate ('purge recyclebin');
End;

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
) PCTFREE 0 ENABLE ROW MOVEMENT;


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

ALTER TABLE OBRES SHRINK SPACE;

CREATE UNIQUE INDEX indexId ON obres (id)
PCTFREE 33;

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

SELECT sum(pressupost) from obres where id = 500;
-- r: TABLE ACCESS (BY INDEX ROWID) OBRES cost=2
-- R: INDEX (UNIQUE SCAN) INDEXID cost=1

-- Select attributes
 SELECT TABLE_NAME, BLOCKS, NUM_ROWS, PCT_FREE, 
CLUSTER_NAME, IOT_TYPE, IOT_NAME, LAST_ANALYZED
 FROM USER_TABLES;
-- R: OBRES	112	1000	0	null	null	null	2025-05-12 15:07:35.000

-- Select attributes
 SELECT INDEX_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS, 
PCT_FREE, BLEVEL, LEAF_BLOCKS,
 DISTINCT_KEYS, LAST_ANALYZED, JOIN_INDEX
 FROM USER_INDEXES
 -- R: INDEXID	OBRES	NORMAL	UNIQUE	33	1	3	1000	2025-05-12 15:07:35.000	NO
 
 -- Select attributes
 SELECT CLUSTER_NAME, PCT_FREE,
 CLUSTER_TYPE, HASHKEYS, SINGLE_TABLE
 FROM USER_CLUSTERS
 -- R: res
 
 -- Select attributes
 SELECT SEGMENT_NAME, SEGMENT_TYPE, BYTES, BLOCKS
 FROM USER_SEGMENTS;
 -- R: OBRES	TABLE	1048576	128
 -- R: INDEXID	INDEX	65536	8
````

* **Taula amb Hash**

````sql
Begin
for s in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||s.sequence_name);
end loop;
for mv in (select mview_name from user_mviews) loop
execute immediate ('drop materialized view '||mv.mview_name);
end loop;
for t in (select table_name from user_tables) loop
execute immediate ('drop table '||t.table_name||' cascade constraints');
end loop;
for i in (select index_name from user_indexes) loop
execute immediate ('drop index '||i.index_name);
end loop;
for c in (select cluster_name from user_clusters) loop
execute immediate ('drop cluster '||c.cluster_name);
end loop;
execute immediate ('purge recyclebin');
End;

CREATE CLUSTER hashObresId (id NUMBER (8,0)) SINGLE TABLE
HASHKEYS 305 PCTFREE 0;

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
) CLUSTER hashObresId(id);


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

SELECT sum(pressupost) from obres where id = 500;
-- r: TABLE ACCESS (HASH) OBRES ANALYZED cost=0

-- Select attributes
 SELECT TABLE_NAME, BLOCKS, NUM_ROWS, PCT_FREE, 
CLUSTER_NAME, IOT_TYPE, IOT_NAME, LAST_ANALYZED
 FROM USER_TABLES;
-- R: OBRES	321	1000	0	HASHOBRESID			2025-05-12 14:59:14.000


-- Select attributes
 SELECT INDEX_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS, 
PCT_FREE, BLEVEL, LEAF_BLOCKS,
 DISTINCT_KEYS, LAST_ANALYZED, JOIN_INDEX
 FROM USER_INDEXES
 -- R: res
 
 -- Select attributes
 SELECT CLUSTER_NAME, PCT_FREE,
 CLUSTER_TYPE, HASHKEYS, SINGLE_TABLE
 FROM USER_CLUSTERS
 -- R: HASHOBRESID	0	HASH	307	    Y
 
 -- Select attributes
 SELECT SEGMENT_NAME, SEGMENT_TYPE, BYTES, BLOCKS
 FROM USER_SEGMENTS;
 -- R:HASHOBRESID	CLUSTER	3145728	384
````

### Pregunta 3

````sql
-- Taula amb índex cluster
Begin
for s in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||s.sequence_name);
end loop;
for mv in (select mview_name from user_mviews) loop
execute immediate ('drop materialized view '||mv.mview_name);
end loop;
for t in (select table_name from user_tables) loop
execute immediate ('drop table '||t.table_name||' cascade constraints');
end loop;
for i in (select index_name from user_indexes) loop
execute immediate ('drop index '||i.index_name);
end loop;
for c in (select cluster_name from user_clusters) loop
execute immediate ('drop cluster '||c.cluster_name);
end loop;
execute immediate ('purge recyclebin');
End;

create table obres(
 id  number(8,0) PRIMARY KEY,
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
) ORGANIZATION INDEX PCTFREE 33;


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

ALTER TABLE obres MOVE;

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


SELECT sum(pressupost) from obres where id >= 5 and id <= 10;
-- R: SORT (AGGREGATE) - - cost=3 bytes=7
-- R: INDEX (RANGE SCAN) SYS_IOT_TOP_25... ANALYZED cost=3 bytes=49

-- Select blocks in the users_ts_quotas
SELECT TABLESPACE_NAME, BYTES, BLOCKS
FROM USER_TS_QUOTAS;

-- Select attributes
SELECT TABLE_NAME, BLOCKS, NUM_ROWS, PCT_FREE,
CLUSTER_NAME, IOT_TYPE, IOT_NAME, LAST_ANALYZED
FROM USER_TABLES;

-- Select attributes
SELECT INDEX_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS,
PCT_FREE, BLEVEL, LEAF_BLOCKS,
DISTINCT_KEYS, LAST_ANALYZED, JOIN_INDEX
FROM USER_INDEXES;

-- Select attributes
SELECT CLUSTER_NAME, PCT_FREE,
CLUSTER_TYPE, HASHKEYS, SINGLE_TABLE
FROM USER_CLUSTERS;

-- Select attributes
SELECT SEGMENT_NAME, SEGMENT_TYPE, BYTES, BLOCKS
FROM USER_SEGMENTS;
-- R: SYS_IOT_TOP_2524269	INDEX	2097152	256
````

````sql
-- B+ tree
Begin
for s in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||s.sequence_name);
end loop;
for mv in (select mview_name from user_mviews) loop
execute immediate ('drop materialized view '||mv.mview_name);
end loop;
for t in (select table_name from user_tables) loop
execute immediate ('drop table '||t.table_name||' cascade constraints');
end loop;
for i in (select index_name from user_indexes) loop
execute immediate ('drop index '||i.index_name);
end loop;
for c in (select cluster_name from user_clusters) loop
execute immediate ('drop cluster '||c.cluster_name);
end loop;
execute immediate ('purge recyclebin');
End;

create table obres(
 id  number(8,0),
 zona char(20),
 tipus  number(17,0),
 pressupost number(17, 0),
 nom char(100),
 empreses char(250),
 descripcio char(250),
 responsables char(250)
) PCTFREE 0 ENABLE ROW MOVEMENT;


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

ALTER TABLE obres SHRINK SPACE;

CREATE UNIQUE INDEX indexName ON obres(id)
PCTFREE 33;

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


SELECT sum(pressupost) from obres where id >= 5 and id <= 10;
-- R: SORT (AGGREGATE) - - cost=9 bytes=7
-- R: TABLE ACCES (BY | OBRES) ANALYZED cost=9
-- R: INDEX (RANGE SCAN INDEXNAME) INDEXNAME ... ANALYZED cost=2 bytes=0

-- Select blocks in the users_ts_quotas
SELECT TABLESPACE_NAME, BYTES, BLOCKS
FROM USER_TS_QUOTAS;

-- Select attributes
SELECT TABLE_NAME, BLOCKS, NUM_ROWS, PCT_FREE,
CLUSTER_NAME, IOT_TYPE, IOT_NAME, LAST_ANALYZED
FROM USER_TABLES;
-- R: OBRES	112	1000	0				2025-05-12 22:09:55.000

-- Select attributes
SELECT INDEX_NAME, TABLE_NAME, INDEX_TYPE, UNIQUENESS,
PCT_FREE, BLEVEL, LEAF_BLOCKS,
DISTINCT_KEYS, LAST_ANALYZED, JOIN_INDEX
FROM USER_INDEXES;
-- R: INDEXNAME	OBRES	NORMAL	UNIQUE	33	1	3	1000	2025-05-12 22:09:55.000

-- Select attributes
SELECT CLUSTER_NAME, PCT_FREE,
CLUSTER_TYPE, HASHKEYS, SINGLE_TABLE
FROM USER_CLUSTERS;

-- Select attributes
SELECT SEGMENT_NAME, SEGMENT_TYPE, BYTES, BLOCKS
FROM USER_SEGMENTS;
-- R: OBRES	TABLE	1048576	128
-- R: INDEXNAME	INDEX	65536	8
````