select ch.date, ch.responsible_key, emp.fio, ch.amount+ch.amount_cashless as Suum,

-- Если с графика не подтянулся - ставим 1, если не подтянулся - 0
if (gr.DTSmen is null , 1,0) as Samozv


from analyticdb.et_money_check as ch

-- Тянем ФИО сотрудника
left join analyticdb.gsf_employee as emp on ch.responsible_key = emp.ref_key

-- Определяем, это смена, или самозванец
left join analyticdb.zpr_shedule_ws_conditions as gr on ch.date >= gr.DTStart and ch.date < gr.DTEnd

where ch.date >= '2023-10-01' and ch.is_posted = 1