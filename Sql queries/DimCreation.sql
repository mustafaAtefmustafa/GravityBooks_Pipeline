---- Author DIM

SELECT *
FROM author

----- Book Dim
SELECT b.book_id, b.title, b.isbn13,b.num_pages, b.language_id, bl.language_code, 
		bl.language_name, pub.publisher_name, b.publication_date, b.publisher_id
FROM book b
LEFT JOIN book_language bl
ON b.language_id = bl.language_id
LEFT JOIN publisher pub
ON b.publisher_id = pub.publisher_id


---- BookAuthor Dim
----------------------------
---- Address Dim
SELECT ad.address_id, ad.street_number, ad.street_name, ad.city, ad.country_id, ct.country_name
FROM address ad
LEFT JOIN country ct
ON ad.country_id = ct.country_id


---- Customer Dim
SELECT c.customer_id, c.first_name, c.last_name, 
		c.email, ca.address_id, ca.status_id, ass.address_status
FROM customer c
LEFT JOIN customer_address ca
ON c.customer_id = ca.customer_id
LEFT JOIN address_status ass
ON ca.status_id = ass.status_id


---- CustomerAddress Dim
SELECT ca.customer_id, ca.address_id, ca.status_id, ass.address_status
FROM customer_address ca
LEFT JOIN address_status ass
ON ca.status_id = ass.status_id


----- ShippingMethod Dim
SELECT * FROM shipping_method


---- SalesFact Table
SELECT co.order_id, co.order_date, co.customer_id,
		co.shipping_method_id, ol.line_id, ol.book_id, ol.price
FROM cust_order co
LEFT JOIN order_line ol
ON co.order_id = ol.order_id
ORDER BY co.order_id



-- OrderStatus Dim
SELECT * FROM order_status


GO
-- StatusHistory Fact
WITH StatusSequence AS (
    SELECT 
        oh.history_id AS source_history_id,
        oh.order_id,
        oh.status_id,
        oh.status_date,
        -- Get the previous status date for the same order
        LAG(oh.status_date) OVER (
            PARTITION BY oh.order_id 
            ORDER BY oh.status_date
        ) AS previous_status_date,
        -- Create a sequence number for statuses per order
        ROW_NUMBER() OVER (
            PARTITION BY oh.order_id 
            ORDER BY oh.status_date
        ) AS status_sequence
    FROM order_history oh
)
SELECT 
    source_history_id,
    order_id,
    status_id,
    status_date,
    previous_status_date,
    -- Calculate days in previous status (NULL for first status)
    DATEDIFF(DAY, previous_status_date, status_date) AS days_in_previous_status,
    status_sequence
FROM StatusSequence
