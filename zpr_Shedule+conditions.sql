select gr.employee,
       emp.fio,
       gr.day, gr.time_start, gr.time_end, gr.`year_month`, gr.shift,

-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)) as DTSmen,

-- Создаем ДатуВремя начала смены
DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)), " ", gr.time_start),'%Y-%m-%d %H:%i') as DTStart,

-- Создаем ДатуВремя конца смены
if(gr.time_start < gr.time_end,
           -- Если смена не припадает на смену дат - просто делаем то же самое
   date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),'%Y-%m-%d %H:%i'),
           -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
   date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end), interval 1 day),'%Y-%m-%d %H:%i')
    )as DTEnd,

-- Считаем продолжительность смены.
timestampdiff(hour,
                  (DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)), " ", gr.time_start),'%Y-%m-%d %H:%i')),
              (if(gr.time_start < gr.time_end,
                  -- Если смена не припадает на смену дат - просто делаем то же самое
                  date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                              '%Y-%m-%d %H:%i'),
                  -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                  date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ",
                                              gr.time_end), interval 1 day), '%Y-%m-%d %H:%i')
               )
              )
             ) as DlSmen

from analyticdb.gs_schedule as gr


-- Тянем ФИО для дальнейших связей
left join analyticdb.gsf_employee as emp on gr.employee = emp.fio_schedule

where date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'),gr.day)) >='2023-10-01' and gr.department = 'Фронт-Офис' or gr.department = 'Менеджер аптека' and gr.employee is not null
