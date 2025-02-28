WITH yearly_category_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS order_year,
        p.category,
        SUM(f.sales_amount) AS current_sales
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY order_year, p.category
)
SELECT 
    order_year,
    category,
    current_sales,
	sum(current_sales) over(partition by order_year) as yearly_sales,
	concat(round((current_sales * 100)/sum(current_sales) over(partition by order_year),2),'%') as percentage_sales
FROM yearly_category_sales
order by order_year asc, percentage_sales desc;