select s.recorder, s.line_number, s.period, s.organization_key, s.employee, s.price-s.amount_of_costs as VP,
       emp.fio, cl.clinic,
        s.organization_key,
        gr.shift,
        ifnull (gr.post, 0) as post, -- Тянем с графика Post. Если подтянулся - значит был в графике. Если не подтянулся - значит Самозванец
        gr.level, -- Тут все должно работать, но нюанс - уровень тянется не с условий, а с графика. Но так как мы один хрен джойним график, грех не взять оттуда левел. Смысл в еще одном джойне?
        coalesce(pay.part_prod_assign, pay2.part_prod_assign) as Prem,
        coalesce(pay.part_prod_assign, pay2.part_prod_assign)*(s.price-s.amount_of_costs) as ZP


from analyticdb.et_sales as s




-- Тянем аналитику по ЗП
left join analyticdb.et_nomenclature as n on s.nomenclature_key = n.ref_key

-- Тянем ФИО сотрудника под назначившего
left join analyticdb.gsf_employee as emp on s.employee = emp.ref_key

-- Тянем клинику
left join analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key

-- Тянем график для должности, уровня по назначившему
left join analyticdb.zpr_shedule_ws_conditions as gr on s.period >= gr.DTStart and s.period < gr.DTEnd
                                                and  s.employee= gr.ref_key

-- Тянем условия оплаты за чек по полному совпадению
left join analyticdb.zpr_payconditions as pay on cl.ref_key = pay.clinic_ref
                                        and gr.level = pay.level
                                        and gr.post = pay.post
                                        and gr.shift = pay.shift
                                        and s.period >= pay.date_from and s.period < pay.date_end

-- Тянем условия оплаты за чек по ANY pay.clinic
left join analyticdb.zpr_payconditions as pay2 on 'ANY' = pay2.clinic
                                        and gr.level = pay2.level
                                        and gr.post = pay2.post
                                        and gr.shift = pay2.shift
                                        and s.period >= pay2.date_from and s.period <= pay2.date_end




where s.period >= '2023-10-28' and n.salary_analytics_key = '4cf516b4-17bf-11e3-5888-08606e6953d2' and s.active = 1