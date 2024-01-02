select mch.date,
       mch.number,
       mch.is_posted,
       mch.amount,
       mch.amount_cashless,
       mch.money_account_key,
       mch.money_account_cashless_key,
       mch.fiscal_number_check,

       -- Проверяем на фискализацию. Если до точки цифра больше 1000 - значит, фискализирован
       CASE
           WHEN CAST(SUBSTRING_INDEX(mch.fiscal_number_check, '.', 1) AS SIGNED) > 1000 THEN TRUE
           ELSE FALSE
           END                                                                           AS IsFiscalised,

       mch.transfer_direction,
       z2.ID,
       if(mch.transfer_direction = 'Приход', mch.amount + mch.amount_cashless,
          (mch.amount + mch.amount_cashless) * -1)                                       as ИтоговаяСумма,
       IF(CAST(SUBSTRING(mch.fiscal_number_check, 1, 5) AS UNSIGNED) > 100, TRUE, FALSE) as fiskaliz,
       z2.ClosinDate                                                                     as CloseDate,
       z2.IsClosed
from analyticdb.et_money_check as mch

         left join
     (SELECT z.ref_key                                      as ID,
             z.opening_date                                 as OpenDate,
             z.date                                         as ClosinDate,
             z.posted,
             z.deletion_mark,
             z.organization_key,
             z.cash_account_key,
             z.non_cash_account_key                         as money_account_cashless_key,
             z.closed                                       as IsClosed,
             IF(z.closed = 1, TIMESTAMPDIFF(HOUR, z.opening_date, z.date),
                TIMESTAMPDIFF(HOUR, NOW(), z.opening_date)) AS DurH
      FROM analyticdb.et_retail_sales_report AS z
      WHERE z.date >= '2023-01-01 00:00:00') as z2 on
                 mch.money_account_key = z2.cash_account_key and
                 mch.money_account_cashless_key = z2.money_account_cashless_key and
                 mch.date >= z2.OpenDate and mch.date <= z2.ClosinDate

where mch.date >= '2023-01-01 00:00:00'
  and mch.transfer_type = 'РасчетыСПокупателями'