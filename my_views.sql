-- Vue ALL_WORKERS : Affiche les informations sur les employés toujours présents.
CREATE OR REPLACE VIEW ALL_WORKERS AS
SELECT last_name AS lastname,
       first_name AS firstname,
       age,
       COALESCE(first_day, start_date) AS start_date
FROM (
    SELECT last_name, first_name, age, first_day, NULL AS start_date, last_day
    FROM WORKERS_FACTORY_1
    UNION ALL
    SELECT last_name, first_name, NULL AS age, start_date, end_date
    FROM WORKERS_FACTORY_2
)
WHERE last_day IS NULL OR last_day > SYSDATE
ORDER BY start_date DESC;

-- Vue ALL_WORKERS_ELAPSED : Calcule le nombre de jours depuis l'arrivée de chaque employé.
CREATE OR REPLACE VIEW ALL_WORKERS_ELAPSED AS
SELECT lastname, firstname, age, start_date,
       TRUNC(SYSDATE) - start_date AS days_elapsed
FROM ALL_WORKERS;

-- Vue BEST_SUPPLIERS : Affiche les fournisseurs ayant livré plus de 1000 pièces, triés par le total des pièces livrées.
CREATE OR REPLACE VIEW BEST_SUPPLIERS AS
SELECT s.name, SUM(quantity) AS total_pieces
FROM SUPPLIERS s
JOIN SUPPLIERS_BRING_TO_FACTORY_1 sbf1 ON s.supplier_id = sbf1.supplier_id
JOIN SUPPLIERS_BRING_TO_FACTORY_2 sbf2 ON s.supplier_id = sbf2.supplier_id
GROUP BY s.name
HAVING SUM(sbf1.quantity + sbf2.quantity) > 1000
ORDER BY total_pieces DESC;

-- Vue ROBOTS_FACTORIES : Associe chaque robot à l'usine qui l'a assemblé.
CREATE OR REPLACE VIEW ROBOTS_FACTORIES AS
SELECT r.id AS robot_id, r.model, f.id AS factory_id, f.main_location
FROM ROBOTS r
JOIN ROBOTS_FROM_FACTORY rf ON r.id = rf.robot_id
JOIN FACTORIES f ON rf.factory_id = f.id;
