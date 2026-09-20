# E-Commerce SQL Practice Challenge

A slightly harder SQL practice project simulating a small e-commerce store,
built for data engineering interview prep (fresher/entry-level, second
challenge in the series).

## What this is

A relational database with four tables (`customers`, `products`, `orders`,
`order_items`) and sample data, plus a set of SQL problems covering
multi-table joins, aggregation, `HAVING`, subqueries, `NOT EXISTS`/`NOT IN`,
and ranking window functions.

## Schema

- **customers** — customer_id, name, city
- **products** — product_id, name, category, price
- **orders** — order_id, customer_id, order_date
- **order_items** — order_item_id, order_id, product_id, quantity

`order_items` is the bridge table connecting orders to products — the key
relationship to get right when joining.

## Problems covered

1. Multi-table join (customers → orders → order_items → products)
2. Aggregation across joins (total spend per customer)
3. `HAVING` (filtering on an aggregated result)
4. Subquery (`NOT IN` / `NOT EXISTS`) — products never ordered
5. CTE + subquery — customers spending above the average
6. Ranking window function (`RANK()` vs `DENSE_RANK()`)
7. `GROUP BY` on a joined column — revenue by product category
8. Conceptual: subquery in `WHERE` vs. subquery in `FROM` (derived table)

## How to use

Run the `CREATE TABLE` and `INSERT` statements first to build the dataset,
then work through the problems in order. The core skill being tested is
identifying the correct join relationship (primary key → foreign key) across
a multi-table schema before writing any aggregation or window function.
