# StreamFlix SQL Practice Challenge

A small SQL practice project simulating a video-streaming service, built for
data engineering interview prep (fresher/entry-level level).

## What this is

A mini relational database (`users`, `subscriptions`, `payments`,
`watch_events`) with sample data, plus a set of SQL problems ranging from
basic filtering to joins, aggregation, `CASE` logic, window functions, and
CTEs.

## Schema

- **users** — user_id, signup_date, country
- **subscriptions** — sub_id, user_id, plan, start_date, end_date, monthly_fee
- **payments** — payment_id, sub_id, payment_date, amount, status
- **watch_events** — event_id, user_id, watched_at, title_id, minutes

## Problems covered

1. Filtering (`WHERE`)
2. Joins (`INNER JOIN`)
3. Aggregation (`GROUP BY`, `COUNT`)
4. Aggregation + filtering (`SUM`, date grouping)
5. Conditional logic (`CASE`)
6. Window functions (`ROW_NUMBER() OVER (PARTITION BY ...)`)
7. CTEs (`WITH ...`) combined with `LEFT JOIN`
8. Conceptual: `INNER JOIN` vs `LEFT JOIN`

## How to use

Run the `CREATE TABLE` and `INSERT` statements first to build the dataset,
then work through the problems in order — each one builds on a SQL concept
commonly tested in entry-level data engineering / analytics interviews.
