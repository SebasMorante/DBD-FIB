# Solucions L1

## Ex1 (AT-10)
```sql
SELECT p.num_proj, p.nom_proj, COUNT(DISTINCT d.ciutat_dpt)
FROM projectes p
LEFT OUTER JOIN empleats e ON p.num_proj = e.num_proj
LEFT OUTER JOIN departaments d ON d.num_dpt = e.num_dpt
GROUP BY p.num_proj, p.nom_proj;
```

## Ex2 (AT-17)
> Feu atenció que a l'enunciat diu que els empleats que es compten han de viure a la ciutat del departament, però en lloc diu que hi hagin de treballar.

```sql
SELECT d.num_dpt, COUNT(e.num_empl)
FROM departaments d
LEFT OUTER JOIN empleats e ON (d.ciutat_dpt = e.ciutat_empl)
GROUP BY d.num_dpt
ORDER BY d.num_dpt;
```

## Ex3 (AT-272)
> Cal combinar el producte amb les línies de comanda on apareix. Aleshores cada combinació <producte, línia> es combina amb totes les línies de la mateixa comanda (per trobar tots els productes que surten a la comanda). Llavors, agrupant, tens cada producte amb totes les línies de comanda on apareix.

```sql
SELECT p.idProducte, COUNT(DISTINCT lc2.idProducte)
FROM productes p
LEFT JOIN liniescomandes lc ON p.idProducte = lc.idProducte
LEFT JOIN liniescomandes lc2 ON lc2.numComanda = lc.numComanda
GROUP BY p.idProducte
ORDER BY p.idProducte;
```

## Ex4 (AT-271)
> Feu atenció que els domicilis que han fet més comandes, són aquells pels que no existeix un altre domicili que n'hagi fet més que ells.
>
> Cal fer atenció que cal distinct.

```sql
SELECT DISTINCT d.nomCarrer, d.numCarrer
FROM domicilis d
RIGHT JOIN comandes c ON d.numTelf = c.numTelf
WHERE NOT EXISTS (
  SELECT *
  FROM domicilis d2
  WHERE (
    SELECT COUNT(*)
    FROM comandes c2
    WHERE c2.numTelf = d2.numTelf
  ) > (
    SELECT COUNT(*)
    FROM comandes c3
    WHERE c3.numTelf = d.numTelf
  )
)
ORDER BY nomCarrer, numCarrer;
```

## Ex5 (AT-608)
```sql
SELECT p.idProducte, d.nomCarrer, COUNT(lc.numComanda)
FROM productes p
CROSS JOIN domicilis d
LEFT JOIN comandes c ON (c.numTelf = d.numTelf)
LEFT JOIN liniescomandes lc ON (lc.numComanda = c.numComanda AND lc.idProducte = p.idProducte)
GROUP BY p.idProducte, d.nomCarrer
ORDER BY p.idProducte, d.nomCarrer;
```

## Ex6 (AT-609)
```sql
SELECT p.idProducte
FROM productes p
WHERE NOT EXISTS (
  SELECT *
  FROM domicilis d
  WHERE NOT EXISTS (
    SELECT *
    FROM liniesComandes lc
    JOIN comandes c ON (lc.numComanda = c.numComanda)
    WHERE lc.idProducte = p.idProducte AND c.numTelf = d.numTelf
  )
)
ORDER BY p.idProducte;
```

## Ex7 (AT-61)
> Feu atenció que les ciutats on NO treballa cap empleat, són ciutats que només sortiran a la taula d'empleats però no a la taula de departaments.
>
> Cal reanomenar en els dos selects per ordenar.

```sql
SELECT d.ciutat_dpt AS ciutat, COUNT(e.num_empl)
FROM empleats e
RIGHT OUTER JOIN departaments d ON e.num_dpt = d.num_dpt
WHERE d.ciutat_dpt IS NOT NULL
GROUP BY d.ciutat_dpt
UNION
SELECT ciutat_empl AS ciutat, 0
FROM empleats
WHERE ciutat_empl IS NOT NULL
  AND NOT EXISTS (
    SELECT *
    FROM departaments
    WHERE ciutat_dpt = ciutat_empl
  )
ORDER BY ciutat;
```
