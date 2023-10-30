select pay.date_from,
       pay.clinic,
       pay.shift,
       pay.post,
       pay.level,
       pay.rate,
       pay.part_prod_assign,
       pay.part_prod_used,
       pay.part_clinic_assign,
       pay.part_clinic_used,
       pay.per_check,
       pay.block_date,

       if(pay.block_date is null,
          if(
                  (select pay2.date_from + interval -1 day
                   from analyticdb.gsf_pay_conditions as pay2
                   where pay2.clinic = pay.clinic
                     and pay2.shift = pay.clinic
                     and pay2.shift = pay.shift
                     and pay2.post = pay.post
                     and pay2.level = pay.level
                   order by pay2.clinic, pay2.shift, pay2.post, pay2.level
                   limit 1) is null,
                  curdate() + interval 30 day,
                  (select pay3.date_from + interval -1 day
                   from analyticdb.gsf_pay_conditions as pay3
                   where pay3.clinic = pay.clinic
                     and pay3.shift = pay.clinic
                     and pay3.shift = pay.shift
                     and pay3.post = pay.post
                     and pay3.level = pay.level
                   order by pay3.clinic, pay3.shift, pay3.post, pay3.level
                   limit 1)
          ),
          pay.block_date) as date_end,
    cl.ref_key as clinic_ref



from analyticdb.gsf_pay_conditions as pay
-- Если блокдата имеет место быть - значит ставим ее в date_to. Если блокдаты нет - тогда ищем строку с такими же столбцами xxxxxxxx но хотя бы на один день больше, чем date_to, значит значение ev.date_from-1 и есть конечная дата для искомого столбца

-- Подтягиваем реф клиник
left join analyticdb.gs_clinics as cl on pay.clinic = cl.clinic