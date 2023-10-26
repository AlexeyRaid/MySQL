select gr.employee, gr.day, gr.time_start, gr.time_end, gr.`year_month`,

-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)) as DTSmen,

-- Создаем ДатуВремя начала смены
concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)), " ", gr.time_start) as DTStart,

-- Создаем ДатуВремя конца смены
if(gr.time_start<gr.time_end,
    -- Если смена не припадает на смену дат - просто делаем то же самое
    concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)), " ", gr.time_end),
    "11111")
        as DTEnd

-- Считаем продолжительность смены.



from analyticdb.gs_schedule as gr

where date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)) >='2023-10-01' and gr.department = 'Фронт-Офис' or gr.department = 'Менеджер аптека' and gr.employee is not null


