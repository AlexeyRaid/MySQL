select
    gr.employee,

       emp.fio,
        gr.clinic,
       gr.shift,
gr.department,
       gr.post,

       lev.level                                                    as level,
       pay.rate,

-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
       date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) as DTSmen,

-- Создаем ДатуВремя начала смены
       DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),
                   '%Y-%m-%d %H:%i')                                as DTStart,

-- Создаем ДатуВремя конца смены
       if(gr.time_start < gr.time_end,
           -- Если смена не припадает на смену дат - просто делаем то же самое
          date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                      '%Y-%m-%d %H:%i'),
           -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
          date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                               interval 1 day), '%Y-%m-%d %H:%i')
       )                                                            as DTEnd,

-- Считаем продолжительность смены.

       format(
               timestampdiff(hour,
                             (DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ",
                                                 gr.time_start), '%Y-%m-%d %H:%i')),
                             (if(gr.time_start < gr.time_end,
                                 -- Если смена не припадает на смену дат - просто делаем то же самое
                                 date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ",
                                                    gr.time_end),
                                             '%Y-%m-%d %H:%i'),
                                 -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                                 date_format(date_add(concat(
                                                              date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)),
                                                              " ",
                                                              gr.time_end), interval 1 day), '%Y-%m-%d %H:%i')
                              )
                                 )
               ), 2) * 3600 / 60 / 60
                                                                    as DlSmen

from analyticdb.gs_schedule as gr

-- Корректировка!!


-- Тянем ФИО для дальнейших связей
         left join analyticdb.gsf_employee as emp on gr.employee = emp.fio_schedule

-- Тянем уровень на дату
         left join analyticdb.zpr_level as lev on emp.fio = lev.fio
    and gr.post = lev.post
    and DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),
                    '%Y-%m-%d %H:%i') >= lev.date_from and DATE_FORMAT(concat(
                                                                               date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)),
                                                                               " ", gr.time_start), '%Y-%m-%d %H:%i') <=
                                                           lev.date_to

-- Тянем условия оплаты смены по дата-клиника-смена-пост-департамент-уровень
left join analyticdb.zpr_payconditions as pay on gr.clinic = pay.clinic
                                      and gr.post = gr.post
                                      and gr.shift = pay.shift
                                      and lev.level = pay.level
                                      and DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),'%Y-%m-%d %H:%i') >= pay.date_from
                                      and if(gr.time_start < gr.time_end,
                                           -- Если смена не припадает на смену дат - просто делаем то же самое
                                          date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                                                      '%Y-%m-%d %H:%i'),
                                           -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                                          date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                                                               interval 1 day), '%Y-%m-%d %H:%i'))
                                          <= pay.date_end


where date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) >= '2023-10-01' and gr.department = 'Фронт-Офис'
