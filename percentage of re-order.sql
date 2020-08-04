--Exploratory questions 
--Note: Using Postgresql 
--Given the order table, analyse its item re-order and recommending solution on how to expands inventories (To add more quantities of current item lists/or add in new item lists).


--percentage item no-reorder.
--based on the analysis, there are very few customers return for the same items. most of the products are being purchased only one time by respective customers.
--Thus, in order to sustain its revenue growth, company need to continuously find new items/new customers.  

select 
	didnot_reorder_table.item_name, 
	count (*) as didnot_reorder_count,
	count (*)*100/AVG (total_count) as percentage_didnot_reorder
FROM
	(SELECT 
		user_id,
		item_name,
		COUNT (item_name) as count_didnot_ordered_per_item
	FROM
		(SELECT 
			user_id,
			invoice_id,
			item_name,
			COUNT (item_name) as Count_item
		FROM
			dsv1069.orders orders
		WHERE 
			paid_at is not null
		GROUP BY 
			user_id, invoice_id, item_name) orders_summary
	GROUP BY 
		user_id, item_name 
	HAVING 
		COUNT (item_name) =1  ) didnot_reorder_table
  
JOIN

	(SELECT 
		item_name,
		count (item_name) as total_count
	FROM
		(SELECT 
			user_id,
			invoice_id,
			item_name,
			COUNT (item_name) as Count_item
		FROM
			dsv1069.orders orders
		WHERE 
			paid_at is not null
	GROUP BY 
		user_id, invoice_id, item_name) order_item_count_per_invoice
	GROUP BY item_name
	ORDER BY item_name desc) total_order_per_item

ON total_order_per_item.item_name=didnot_reorder_table.item_name

GROUP BY didnot_reorder_table.item_name

ORDER BY count (*)*100/AVG (total_count)


--based on the analysis, Majority of items from current list do not have re-order. Of those items that are having re-order, the percentage of its re-order are very low (over 90% of customer not re-ordering).
--This mean that there are very few customers return for the same items. most of the products are being purchased only one time by respective customers.
--Thus, in order to sustain its revenue growth, company are recommended to bring in new items instead of adding more inventories on current item lists.




--draft code 

--number of times each of items being ordered by respective users

SELECT 
  user_id,
  invoice_id,
  item_name,
  COUNT (item_name) as Count_item
FROM
  dsv1069.orders orders
WHERE 
  paid_at is not null
GROUP BY 
  user_id, invoice_id, item_name

--the date where the ordered is confirm

SELECT 
  distinct invoice_id,
  date (paid_at)
FROM 
  dsv1069.orders orders
WHERE 
  paid_at is not null
  
 --total number of times each item being order

SELECT 
	item_name,
	count (item_name) as total_order_per_item
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) as Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at is not null
	GROUP BY 
		user_id, invoice_id, item_name) order_item_count_per_invoice
GROUP BY item_name
ORDER BY count (item_name) DESC

-- list of items that is being re-ordered (order at different timing, invoiceID is different)

SELECT 
user_id,
	item_name,
	COUNT (item_name) as count_reordered_per_customer
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) as Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at is not null
	GROUP BY 
		user_id, invoice_id, item_name) orders_summary
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) >1

-- items that do not have re-order.

SELECT
	user_id,
	item_name,
	COUNT (item_name) AS count_reordered_per_item
FROM
	(SELECT 
		user_id,
		invoice_id,
		item_name,
		COUNT (item_name) AS Count_item
	FROM
		dsv1069.orders orders
	WHERE 
		paid_at is NOT NULL
	GROUP BY 
		user_id, invoice_id, item_name) orders_summary
GROUP BY 
  user_id, item_name 
HAVING 
  COUNT (item_name) =1  
  


  

 
