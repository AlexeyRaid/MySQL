select gr.clinic,
       gr.department,
       gr.post,
       gr.role,
       gr.shift,
       gr.employee,
       emp.fio                                            as fio,

-- Формируем дату смены с числовых значений
       date_add(gr.year_month, INTERVAL (gr.day - 1) day) as DateSm,

-- Формируем датувремя Смены с учетом корректировки
       -- ДатаВремя начала смены
       case
           when kor.time_start is null
               then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
               cast(concat((date_add(gr.year_month, INTERVAL (gr.day - 1) day)), " ", gr.time_start) as datetime)
           else
               cast(concat(kor.shift_date, " ", kor.time_start) as datetime)
           END                                            as DTStart,
       -- Формируем дату конца смены, если смена переходит на другой день - добавляем сутки к дате начала смены
       case
           when kor.time_end is null
               then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
               case
                   when gr.time_start < gr.time_end then
                       cast(concat(date_add(gr.year_month, INTERVAL (gr.day - 1) day), " ", gr.time_start) as datetime)
                   else
                           cast(concat(date_add(gr.year_month, INTERVAL (gr.day - 1) day), " ",
                                       gr.time_start) as datetime) + INTERVAL 1 DAY
                   END
           else
               case
                   when gr.time_start < gr.time_end then
                       cast(concat(kor.shift_date, " ", kor.time_end) as datetime)
                   else
                           cast(concat(kor.shift_date, " ", kor.time_end) as datetime) + INTERVAL 1 DAY
                   END
           END                                            as DTEnd,

-- Вычисляем длительность смены, с учетом корректировки
       timediff(
               case
                   when kor.time_end is null
                       then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
                       case
                           when gr.time_start < gr.time_end then
                               cast(concat(date_add(gr.year_month, INTERVAL (gr.day - 1) day), " ",
                                           gr.time_start) as datetime)
                           else
                                   cast(concat(date_add(gr.year_month, INTERVAL (gr.day - 1) day), " ",
                                               gr.time_start) as datetime) + INTERVAL 1 DAY
                           END
                   else
                       case
                           when gr.time_start < gr.time_end then
                               cast(concat(kor.shift_date, " ", kor.time_end) as datetime)
                           else
                                   cast(concat(kor.shift_date, " ", kor.time_end) as datetime) + INTERVAL 1 DAY
                           END
                   END
           ,
               case
                   when kor.time_start is null
                       then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
                       cast(concat(date_add(gr.year_month, INTERVAL (gr.day - 1) day), " ", gr.time_start) as datetime)
                   else
                       cast(concat(kor.shift_date, " ", kor.time_start) as datetime)
                   END)
                                                          as DlSmen,

-- Вставляем метку, если смена корректированная
       kor.time_start is not null                         as Korr

from analyticdb.gs_schedule_tmp as gr

-- Тянем смены корректировки.
         left join analyticdb.gs_correction_tmp as kor
                   on (date_add(gr.year_month, INTERVAL (gr.day - 1) day)) = kor.shift_date and
                      (concat(gr.clinic, "_", gr.department, "_", gr.post, "_", gr.role, "_", gr.shift)) =
                      (concat(kor.clinic, "_", kor.department, "_", kor.post, "_", kor.role, "_", kor.shift)) and
                      gr.employee = kor.employee

-- Подставляем полное имя сотрудника
         left join gs_employee as emp on gr.employee = emp.fio_schedule

where gr.employee is not null
  and gr.`year_month` >= '2023-02-01'
  and gr.`year_month` < '2023-03-01'

  and gr.day = 9
  and gr.employee = 'Кошик'

# UNION
# select cor.clinic,
#        cor.department,
#        cor.post,
#        cor.role,
#        cor.shift,
#        cor.employee,
#        cor.fio,
#        cor.shift_date,
#        cor.DTStart,
#        cor.DTEnd,
#        cor.DlSmen,
#        '1'
# from zpn_correction as cor

