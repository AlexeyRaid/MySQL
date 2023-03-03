select gr.*,

-- Вносим уровень. Если уровень по правилам не найден - присваиваем низший для этой категории
       case
           when lvl.level is null and gr.post = 'Врач' and gr.role <> 'Узкопрофильный' then 2
           when lvl.level is null and gr.post = 'Ассистент' then 1
           else lvl.level
           END as Level,
       lvl.level


from analyticdb.zpn_schedule as gr


-- Подтягиваем уровень сотрудника на дату
         left join analyticdb.zpn_levelsemployees as lvl on gr.fio = lvl.fio and
                                                            gr.DateSm >= lvl.date_from and gr.DateSm <= lvl.date_to and
                                                            gr.post = lvl.post and
                                                            gr.department = lvl.department

-- Подтягиваем условия оплаты сотрудников
         left join analyticdb.zpn_payconditions as pay on gr.clinic = pay.clinic

where gr.DateSm >= '2023-02-01 00:00'
  and gr.DateSm < '2023-03-01 00:00' -- and3
