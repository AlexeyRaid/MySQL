select  ch.ref_key, ch.date, ch.responsible_key,  ch.amount+ch.amount_cashless as Suum, emp.fio,

-- Тянем с графика Post. Если подтянулся - значит был в графике. Если не подтянулся - значит Самозванец
ifnull (gr.post, 0) as post,
lev.level,
gr.level


from analyticdb.et_money_check as ch

-- Тянем ФИО сотрудника
left join analyticdb.gsf_employee as emp on ch.responsible_key = emp.ref_key

-- Определяем, это смена, или самозванец
left join analyticdb.zpr_shedule_ws_conditions as gr on ch.date >= gr.DTStart and ch.date < gr.DTEnd
                                                and  ch.responsible_key = gr.ref_key

-- Тянем уровень сотрудника на Дату
left join analyticdb.zpr_level as lev on ch.responsible_key = emp.ref_key
                            and ch.date >= lev.date_from and ch.date < lev.date_to
                            and gr.post = lev.post


where ch.date >= '2023-10-01' and ch.is_posted = 1


  -- and emp.fio is not null
  and ch.ref_key = '00040a0a-68da-11ee-638f-e607dc9b591c'