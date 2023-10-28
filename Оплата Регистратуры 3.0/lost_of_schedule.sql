select
    gr.employee,
    emp.fio,
-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) as DTSmen

from analyticdb.gs_schedule as gr

-- Тянем ФИО для дальнейших связей
left join analyticdb.gsf_employee as emp on gr.employee = emp.fio_schedule

where date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) >= '2023-10-01' and gr.department = 'Фронт-Офис' and gr.employee is not null and emp.fio is null

