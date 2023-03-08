-- Обор дублей с условий оплаты
SELECT COUNT(*) AS col_rows,
       pay.clinic,
       pay.role,
       pay.post,
       pay.level,
       pay.department,
       pay.fio,
       pay.shift,
       pay.date_from

FROM analyticdb.zpn_payconditions pay
GROUP BY pay.clinic, pay.role, pay.post, pay.level, pay.department, pay.fio, pay.shift, pay.date_from
HAVING COUNT(*) > 1