SELECT z.ref_key                                                                                                 as ID,
       z.opening_date                                                                                            as OpenDate,
       z.date                                                                                                    as ClosinDate,
       z.posted,
       z.deletion_mark,
       z.organization_key,
       z.cash_account_key,
       z.non_cash_account_key                                                                                    as money_account_cashless_key,
       z.closed                                                                                                  as IsClosed,
       IF(z.closed = 1, TIMESTAMPDIFF(HOUR, z.opening_date, z.date), TIMESTAMPDIFF(HOUR, NOW(), z.opening_date)) AS DurH

FROM analyticdb.et_retail_sales_report AS z
WHERE z.date >= '2023-01-01 00:00:00'
