SELECT s.period,
       s.organization_key,
       cl.clinic,
       s.executor,
       emp.fio,
       price-s.amount_of_costs as VP,
       gr.shift,
        ifnull (gr.post, 0) as post,
        gr.level,
        coalesce(pay.part_prod_used, pay2.part_prod_used) as Prem,
        coalesce(pay.part_prod_used, pay2.part_prod_used)*(s.price-s.amount_of_costs) as ZP
FROM (SELECT * FROM analyticdb.et_sales WHERE period >= '2023-10-01' AND active = 1) as s
LEFT JOIN analyticdb.et_nomenclature as n ON s.nomenclature_key = n.ref_key AND n.salary_analytics_key = '4cf516b4-17bf-11e3-5888-08606e6953d2'
LEFT JOIN analyticdb.gsf_employee as emp ON s.executor = emp.ref_key
LEFT JOIN analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key
LEFT JOIN analyticdb.zpr_shedule_ws_conditions as gr ON s.period >= gr.DTStart and s.period < gr.DTEnd and  s.executor= gr.ref_key
LEFT JOIN analyticdb.zpr_payconditions as pay ON cl.ref_key = pay.clinic_ref AND gr.level = pay.level AND gr.post = pay.post AND gr.shift = pay.shift AND s.period >= pay.date_from and s.period < pay.date_end
LEFT JOIN analyticdb.zpr_payconditions as pay2 ON 'ANY' = pay2.clinic AND gr.level = pay2.level AND gr.post = pay2.post AND gr.shift = pay2.shift AND s.period >= pay2.date_from and s.period <= pay2.date_end
WHERE emp.fio IS NOT NULL
