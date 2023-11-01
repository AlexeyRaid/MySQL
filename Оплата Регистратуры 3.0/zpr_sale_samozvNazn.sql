SELECT s.period,
       s.recorder, s.line_number,
       date(s.period) as DT,
       s.organization_key,
cl.clinic,
s.employee,
       emp.fio,
price-s.amount_of_costs as VP,
     ifnull (gr.post, 'Самозванец') as post,
        coalesce(pay.part_prod_assign, pay2.part_prod_assign) as Prem, -- Проверка на товары аптеки. Если нет в справочнике номенклатуры - тогда нулл)
        coalesce(pay.part_prod_assign, pay2.part_prod_assign)*(s.price-s.amount_of_costs) as ZP

FROM (SELECT * FROM analyticdb.et_sales WHERE period >= '2023-10-01 0:00:00' AND active = 1 and recorder= 'ac7adf52-761d-11ee-f192-e607dc9b591c'
                                        ) as s

LEFT JOIN analyticdb.zpr_spr_nom as n ON s.nomenclature_key = n.ref_key

LEFT JOIN analyticdb.gsf_employee as emp ON s.employee = emp.ref_key

LEFT JOIN analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key

lEFT JOIN analyticdb.zpr_shedule_ws_conditions as gr ON s.period >= gr.DTStart and s.period < gr.DTEnd and  s.employee= gr.ref_key


LEFT JOIN analyticdb.zpr_payconditions as pay ON pay.clinic_ref = s.organization_key     AND ifnull (gr.post, 'Самозванец') = pay.post     AND s.period >= pay.date_from and s.period < pay.date_end
LEFT JOIN analyticdb.zpr_payconditions as pay2 ON 'ANY' = pay2.clinic AND ifnull (gr.post, 'Самозванец') = pay2.post AND s.period >= pay2.date_from and s.period <= pay2.date_end

WHERE emp.fio IS NOT NULL and n.code is not null
and gr.post is null

