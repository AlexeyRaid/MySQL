select gr.employee, gr.day, gr.time_start, gr.time_end, gr.`year_month`,

-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)) as DTSmen



from analyticdb.gs_schedule as gr

where gr.`year_month` >='2023-10-01' and gr.department = 'Фронт-Офис' or gr.department = 'Менеджер аптека' and gr.employee is not null


