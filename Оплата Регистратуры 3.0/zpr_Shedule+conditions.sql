select
    gr.employee,
    emp.fio,
    gr.clinic,
    gr.shift,
    gr.department,
    gr.post,
    lev.level as level,
    pay.rate,

-- Делаем дату смены. Берем дату начала месяца, убираем день и вставляем вместо него дату
date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) as DTSmen,

-- Создаем ДатуВремя начала смены
       -- Если есть эта запись в корректировке - ставим ее. Если нет - оставляем "родную"
if(cor.employee is null,
    -- Родная запись
   DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),'%Y-%m-%d %H:%i'),
   -- Коректированная запись
   DATE_FORMAT(concat(cor.shift_date, " ", cor.time_start), '%Y-%m-%d %H:%i')
) as DTStart,

-- Создаем ДатуВремя конца смены
           -- Если есть эта запись в корректировке - ставим ее. Если нет - оставляем "родную"
if(cor.employee is null,
        -- Родная запись
   if(gr.time_start < gr.time_end,
       -- Если смена не припадает на смену дат - просто делаем то же самое
      date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                  '%Y-%m-%d %H:%i'),
       -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
      date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                           interval 1 day), '%Y-%m-%d %H:%i')
   ),
        -- Корректированная запись
   if(gr.time_start < gr.time_end,
       -- Если смена не припадает на смену дат - просто делаем то же самое
      DATE_FORMAT(concat(cor.shift_date, " ", cor.time_end), '%Y-%m-%d %H:%i'),
       -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
      date_add(DATE_FORMAT(concat(cor.shift_date, " ", cor.time_end), '%Y-%m-%d %H:%i'), interval 1 day)
      )
  ) as DTEnd,

-- Считаем продолжительность смены.
format(
        timestampdiff(hour,
                    (DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start), '%Y-%m-%d %H:%i')),
                             (if(gr.time_start < gr.time_end,
                                 -- Если смена не припадает на смену дат - просто делаем то же самое
                                 date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end), '%Y-%m-%d %H:%i'),
                                 -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                                 date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end), interval 1 day), '%Y-%m-%d %H:%i')
                                 )
                            )
               ), 2) * 3600 / 60 / 60 as DlSmen,

-- Вставляем метку корректировки
if(cor.employee is not null, '1', null) as Korr


from analyticdb.gs_schedule as gr

-- Подтягиваем "корректированные смены"
left join analyticdb.gs_correction as cor on
                                            date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) = cor.shift_date
                                        and gr.clinic = cor.clinic
                                        and gr.department = cor.department
                                        and gr.post = cor.post
                                        and gr.role = cor.role
                                        and gr.shift = cor.shift
                                        and gr.employee = cor.employee
                                        and cor.shift_date >= '2023-10-01' and cor.department = 'Фронт-Офис'

-- Тянем ФИО для дальнейших связей
left join analyticdb.gsf_employee as emp on gr.employee = emp.fio_schedule
#
-- Тянем уровень на дату
         left join analyticdb.zpr_level as lev on emp.fio = lev.fio
    and gr.post = lev.post
    and DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),
                    '%Y-%m-%d %H:%i') >= lev.date_from and DATE_FORMAT(concat(
                                                                               date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start), '%Y-%m-%d %H:%i') <= lev.date_to

-- Тянем условия оплаты смены по дата-клиника-смена-пост-департамент-уровень
left join analyticdb.zpr_payconditions as pay on gr.clinic = pay.clinic
                                      and gr.post = pay.post
                                      and gr.shift = pay.shift
                                      and lev.level = pay.level
                                      and
                                            -- Создаем ДатуВремя начала смены
                                                   -- Если есть эта запись в корректировке - ставим ее. Если нет - оставляем "родную"
                                            if(cor.employee is null,
                                                -- Родная запись
                                               DATE_FORMAT(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_start),'%Y-%m-%d %H:%i'),
                                               -- Коректированная запись
                                               DATE_FORMAT(concat(cor.shift_date, " ", cor.time_start), '%Y-%m-%d %H:%i')
                                            )
                                      >= pay.date_from
                                      and
                                            -- Создаем ДатуВремя конца смены
                                                       -- Если есть эта запись в корректировке - ставим ее. Если нет - оставляем "родную"
                                            if(cor.employee is null,
                                                    -- Родная запись
                                               if(gr.time_start < gr.time_end,
                                                   -- Если смена не припадает на смену дат - просто делаем то же самое
                                                  date_format(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                                                              '%Y-%m-%d %H:%i'),
                                                   -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                                                  date_format(date_add(concat(date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)), " ", gr.time_end),
                                                                       interval 1 day), '%Y-%m-%d %H:%i')
                                               ),
                                                    -- Корректированная запись
                                               if(gr.time_start < gr.time_end,
                                                   -- Если смена не припадает на смену дат - просто делаем то же самое
                                                  DATE_FORMAT(concat(cor.shift_date, " ", cor.time_end), '%Y-%m-%d %H:%i'),
                                                   -- Если смена припадает на смену дат - добавляем сутки к дате начала смены
                                                  date_add(DATE_FORMAT(concat(cor.shift_date, " ", cor.time_end), '%Y-%m-%d %H:%i'), interval 1 day)
                                                  )
                                              )
                                      <= pay.date_end


where date(concat(DATE_FORMAT(gr.`year_month`, '%Y-%m-'), gr.day)) >= '2023-10-01' and gr.department = 'Фронт-Офис'

