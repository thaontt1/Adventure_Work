-- UNION sale cac nam
SELECT
	*
FROM
	adventure.sales_2015 s
UNION ALL
SELECT
	*
FROM
	adventure.sales_2016 s2
UNION ALL
SELECT
	*
FROM
	adventure.sales_2017 s3;

-- total ORDER quantity BY YEAR AND BY productkey
WITH orders AS (SELECT
	date_format(OrderDate, "%Y") AS years,
	ProductKey,
	SUM(OrderQuantity) AS num_order
FROM
	(
	SELECT
		*
	FROM
		adventure.sales_2015 s
UNION ALL
	SELECT
		*
	FROM
		adventure.sales_2016 s2
UNION ALL
	SELECT
		*
	FROM
		adventure.sales_2017 s3) AS sales
GROUP BY
	years,
	ProductKey),
-- total RETURN item BY YEAR AND BY productkey
re AS (SELECT
	date_format(ReturnDate, "%Y") AS years,
	ProductKey,
	sum(ReturnQuantity) AS num_return
FROM
	`returns` r
GROUP BY
	years,
	ProductKey)
-- JOIN 2 tables together
SELECT orders.years, orders.ProductKey, ps.ProductSubcategoryKey ,
	ps.SubcategoryName,p.ProductName, orders.num_order, re.num_return, IF(re.num_return > 0, re.num_return/orders.num_order, 0) AS return_rate
FROM orders
LEFT JOIN re
ON orders.years = re.years AND orders.ProductKey = re.ProductKey
INNER JOIN adventure.products p ON
p.ProductKey =orders.ProductKey
INNER JOIN adventure.product_subcategories ps ON
p.ProductSubcategoryKey  = ps.ProductSubcategoryKey
ORDER BY years, return_rate DESC;

