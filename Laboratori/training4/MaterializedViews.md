# Training 4: Materialized views

## Pregunta 1

Suposa que tenim una taula CentMilResp(ref, pobl, edat, cand, val) (pots trobar la sentencia de creació al fitxer adjunt).
* D=1seg; C=0; BT=10000; |T| = 100000; Ndist(pobl)= 200; Ndist(edat)=100; Ndist(cand)=10  
* La mitjana d'informació de control (es a dir, metadades) per tupla ocupa el mateix que un atribut  
* Tots els atributs ocupen el mateix i la freqüència de les consultes és:  
  * 35%: SELECT cand, MAX(val) FROM CentMilResp GROUP BY cand;  
  * 20%: SELECT cand, edat, AVG(val), MAX(val), MIN(val) FROM CentMilResp GROUP BY cand, edat;  
  * 20%: SELECT pobl, MAX(val) FROM CentMilResp GROUP BY cand, pobl;  
  * 25%: SELECT pobl, MAX(val) FROM CentMilResp GROUP BY pobl;

Considera les dades donades i fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, que tenim 10140 blocs de disc i donant preferència a vistes que coincideixen amb alguna consulta en cas d'empat). Suposa també que el mecanisme de rescriptura és prou bo com per utilitzar una vista materialitzada encara que no coincideixi exactament amb la consulta si amb la informació de la vista es pot calcular el que especifica la consulta.

Manté sempre els noms dels atributs de la taula original (es a dir, no utilitzis cap alias a la definició de la vista). Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

````sql
--Fitxer adjunt
CREATE TABLE CentMilResp(
  ref INTEGER PRIMARY KEY,
  pobl INTEGER NOT NULL,
  edat INTEGER NOT NULL,
  cand INTEGER NOT NULL,
  val INTEGER NOT NULL,
  UNIQUE (pobl, edat, cand)
);
````


## Pregunta 2

Suposa que tenim una taula CentMilResp(ref, pobl, edat, cand, val) (pots trobar la sentencia de creació al fitxer adjunt).  
* D=1seg; C=0; BT=10000; |T| = 100000; Ndist(pobl)= 200; Ndist(edat)=100; Ndist(cand)=10
* La mitjana d'informació de control per tupla ocupa el mateix que un atribut
* Tots els atributs ocupen el mateix i la freqüència de les consultes és:
  * 15%: SELECT cand, AVG(val) FROM CentMilResp GROUP BY cand;
  * 15%: SELECT cand, edat, AVG(val), MAX(val) FROM CentMilResp GROUP BY cand, edat;
  * 70%: SELECT edat, pobl, MAX(val), AVG(val) FROM CentMilResp GROUP BY edat, pobl;  

Considera les dades donades i **fes servir l'algorisme greedy** per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, que tenim 10100 blocs de disc i donant preferència a vistes que coincideixen amb alguna consulta en cas d'empat). Suposa també que el mecanisme de rescriptura és prou bo com per utilitzar una vista materialitzada encara que no coincideixi exactament amb la consulta si amb la informació de la vista es pot calcular el que especifica la consulta.

Manté sempre els noms dels atributs de la taula original (es a dir, no utilitzis cap alias a la definició de la vista). Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

````sql
--Fitxer adjunt
CREATE TABLE CentMilResp(
  ref INTEGER PRIMARY KEY,
  pobl INTEGER NOT NULL,
  edat INTEGER NOT NULL,
  cand INTEGER NOT NULL,
  val INTEGER NOT NULL
);
````
## Pregunta 3

Suposa que tenim una taula T(A,B,C,D) (pots trobar la sentencia de creació al fitxer adjunt).
* D=1seg; C=0; BT=1000; |T| = 50000; Ndist(A)= 500; Ndist(B)=4000; Ndist(C)=40000; Ndist(D)=5
* La mitjana d'informació de control per tupla ocupa el mateix que un atribut
* Tots quatre atributs ocupen el mateix i la freqüència de les consultes és:
  * 20%: SELECT A, B, SUM(C) FROM T GROUP BY A, B;
  * 30%: SELECT A, C, SUM(B) FROM T GROUP BY A, C;
  * 30%: SELECT A, SUM(B), SUM(C), SUM(D), COUNT(*) FROM T GROUP BY A;
  * 20%: SELECT A, D, SUM(B) FROM T GROUP BY A, D;  
  
Considera les dades donades i que només ens plantegem la materialització de les vistes que coincideixen exactament amb aquestes consultes (que anomenarem respectivament V1, V2, V3 i V4). Fes servir l'algorisme greedy per a decidir quines vistes materialitzar (suposant que el temps de la update window és il·limitat, però tenim només 2000 blocs de disc).

Posa sempre els atributs seguint l'ordre en que apareixen a la taula. Totes les vistes han de tenir la reescriptura activada, construir-se de forma inmediata y refrescar-se de forma completa sota demanda.

````sql
--Fitxer adjunt
CREATE TABLE T (
  A INTEGER,
  B INTEGER,
  C INTEGER NOT NULL,
  D INTEGER NOT NULL,
  PRIMARY KEY (A, B)
);
````