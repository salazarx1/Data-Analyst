Select * 
FROM transactions t
JOIN date d
   ON t.order_date = d.date
