select s.period,
       DATE(s.period) AS DTSale,
       s.organization_key,
       s.nomenclature_key,
       dis.name,
       s.quantity_paid,
       s.price,
       dis.share_of_check,
       s.employee,

       IFNULL(sh.post,
              (SELECT lev.post
               FROM zpn_levelsemployees AS lev
               WHERE empl.fio = lev.fio
                 AND s.period >= lev.date_from
                 AND s.period <= lev.date_to
               ORDER BY lev.priority desc
               LIMIT 1)
           )          AS post


from analyticdb.et_sales as s

         left join analyticdb.zpn_paydisposable as dis on s.nomenclature_key = dis.ref_key

         left join analyticdb.gs_employee as empl on s.employee = empl.ref_key

         left join analyticdb.zpn_schedule AS sh
                   ON sh.employee = empl.fio_schedule AND s.period > sh.DTStart AND s.period <= sh.DTEnd


where s.period >= '2023-02-01 00:00'
  and s.price <> 0
  and dis.name is not NULL