select ch.ref_key,
        ch.date,
        date(ch.date) as DT,
        ch.responsible_key,
        ch.amount_document as Suum,
        emp.fio, cl.clinic,
        ch.organization_key,

        ifnull (gr.post, 'Самозванец') as post, -- Тянем с графика Post. Если подтянулся - значит был в графике. Если не подтянулся - значит Самозванец

        coalesce(pay.per_check, pay2.per_check) as Zp_Chek

from analyticdb.et_retail_check as ch

-- Тянем ФИО сотрудника
left join analyticdb.gsf_employee as emp on ch.responsible_key = emp.ref_key

-- Тянем клинику
left join analyticdb.gs_clinics as cl on ch.organization_key = cl.ref_key

-- Тянем график для должности, уровня....
left join analyticdb.zpr_shedule_ws_conditions as gr on ch.date >= gr.DTStart and ch.date < gr.DTEnd
                                                and  ch.responsible_key = gr.ref_key

-- Тянем условия оплаты за чек по полному совпадению
left join analyticdb.zpr_payconditions as pay on cl.ref_key = pay.clinic_ref

                                        and 'Самозванец' = pay.post

                                        and ch.date >= pay.date_from and ch.date < pay.date_end

-- Тянем условия оплаты за чек по ANY pay.clinic
left join analyticdb.zpr_payconditions as pay2 on 'ANY' = pay2.clinic

                                        and 'Самозванец' = pay2.post

                                        and ch.date >= pay2.date_from and ch.date <= pay2.date_end

where ch.date >= '2023-10-01' and ch.is_posted = 1 and emp.fio is not null and gr.post is null
