--Exploratory questions 
--Note: Using Postgresql 
--Given the order table, analyse its item re-order and recommending solution on how to improve its sales and generate more revenues.


--percentage item re-order.

SELECT
	item_name,
	COUNT (CASE WHEN times_user_reordered >1 THEN CAST (1 as INT) ELSE NULL END) *100/ COUNT (*) AS user_reorder_percentage,
	COUNT (CASE WHEN times_user_reordered =1 THEN CAST (1 AS INT) ELSE NULL END) *100/ COUNT (*) AS user_no_reorder_percentage
FROM 
	(
	SELECT
		user_id, item_name,
		COUNT (*) AS times_user_reordered
	FROM
		(SELECT 
			user_id,
			invoice_id,
			item_name,
			COUNT (item_name) as Count_item
		FROM
			dsv1069.orders orders	
		WHERE 
			paid_at is NOT NULL
		GROUP BY 
			user_id, invoice_id, item_name) count_item_same_invoice
	GROUP BY user_id,item_name) user_level
GROUP BY item_name
ORDER BY COUNT (CASE WHEN times_user_reordered >1 THEN CAST (1 as INT) ELSE NULL END) *100/ COUNT (*) DESC

--based on the analysis, Majority of items from current list do not have re-order by respective customers (over 90% of customers are not re-ordering). 
--Of those items that are having re-order by customers, the percentage of its re-order are very low.
--Thus, in order to sustain its revenue growth, company are are either recommended to bring in new items instead of adding more inventories on current item lists or looking for more new customers.


--draft code 

--item_count of user order the same item in the same orders). (Note: order counts means order at different timing. This means that invoiceID is different)

SELECT 
  user_id,
  invoice_id,
  item_name,
  COUNT (item_name) AS Count_item
FROM
  dsv1069.orders orders
WHERE 
  paid_at IS NOT NULL
GROUP BY 
  user_id, invoice_id, item_name
  
 --total number of times each item being order

SELECT 
	item_name,
	COUNT (item_name) AS total_orders_per_item
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at IS NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) count_item_same_invoice
GROUP BY item_name
ORDER BY COUNT (item_name) DESC

-- users that do have re-order the same items. (Note: order counts means order at different timing. This means that invoiceID is different)


SELECT 
	user_id,
	item_name,
	COUNT (item_name) AS times_user_reordered
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at IS NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) count_item_same_invoice
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) >1

-- users that do not have re-order the same items. (Note: order counts means order at different timing. This means that invoiceID is different)



SELECT
	user_id,
	item_name,
	COUNT (item_name) AS times_user_reordered
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at IS NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) count_item_same_invoice
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) =1 
