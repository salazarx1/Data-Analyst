SELECT SUM(sales_amount)
FROM transactions t
JOIN date d
	ON  t.order_date = d.date
    WHERE month_name = 'February' and year = '2020'
    AND currency = "INR\r" OR currency = 'USD\r' -- DISTINCT has duplicate INR and INR\r and USD and USD\r using \r for both seems to be accurate data