select  ch.ref_key, ch.date, ch.responsible_key,  ch.amount+ch.amount_cashless as Suum, emp.fio, cl.clinic,

-- Тянем с графика Post. Если подтянулся - значит был в графике. Если не подтянулся - значит Самозванец
ifnull (gr.post, 0) as post,
gr.level -- Тут все должно работать, но нюанс - уровень тянется не с условий, а с графика. Но так как мы один хрен джойним график, грех не взять оттуда левел. Смысл в еще одном джойне?
# gr.*


from analyticdb.et_money_check as ch

-- Тянем ФИО сотрудника
left join analyticdb.gsf_employee as emp on ch.responsible_key = emp.ref_key

-- Тянем клинику
left join analyticdb.gs_clinics as cl on ch.organization_key = cl.ref_key

-- Определяем, это смена, или самозванец
left join analyticdb.zpr_shedule_ws_conditions as gr on ch.date >= gr.DTStart and ch.date < gr.DTEnd
                                                and  ch.responsible_key = gr.ref_key

where ch.date >= '2023-10-01' and ch.is_posted = 1