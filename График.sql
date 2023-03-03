use analyticdb;
select gr.clinic,
       gr.department,
       gr.post,
       gr.role,
       gr.shift,
       gr.employee,
       emp.fio                                                                          as fio,

-- Формируем дату смены с числовых значений
       date(concat(gr.year, "-", gr.month, "-", gr.day))                                as DateSm,

       -- Уник роли смены (без даты) для коректировок
       concat(gr.clinic, "_", gr.department, "_", gr.post, "_", gr.role, "_", gr.shift) as UnicAdjastm,

-- Формируем датувремя Смены с учетом корректировки
       -- ДатаВремя начала смены
       case
           when kor.time_start is null
               then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
               cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ", gr.time_start) as datetime)
           else
               cast(concat(kor.shift_date, " ", kor.time_start) as datetime)
           END                                                                          as DTStart,
       -- Формируем дату конца смены, если смена переходит на другой день - добавляем сутки к дате начала смены
       case
           when kor.time_end is null
               then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
               case
                   when gr.time_start < gr.time_end then
                       cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ",
                                   gr.time_end) as datetime)
                   else
                           cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ",
                                       gr.time_end) as datetime) + INTERVAL 1 DAY
                   END
           else
               case
                   when gr.time_start < gr.time_end then
                       cast(concat(kor.shift_date, " ", kor.time_end) as datetime)
                   else
                           cast(concat(kor.shift_date, " ", kor.time_end) as datetime) + INTERVAL 1 DAY
                   END
           END                                                                          as DTEnd,

-- Вычисляем длительность смены, с учетом корректировки
       timediff(
               case
                   when kor.time_end is null
                       then -- если корректировки нет - вносим данные с графика, если корректировка есть - тогда подменяем данные корректировкой
                       case
                           when gr.time_start < gr.time_end then
                               cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ",
                                           gr.time_end) as datetime)
                           else
                                   cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ",
                                               gr.time_end) as datetime) + INTERVAL 1 DAY
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
                       cast(concat(date(concat(gr.year, "-", gr.month, "-", gr.day)), " ",
                                   gr.time_start) as datetime)
                   else
                       cast(concat(kor.shift_date, " ", kor.time_start) as datetime)
                   END)
                                                                                        as DlSmen,

-- Вставляем метку, если смена корректированная
       kor.time_start is not null                                                       as Korr

from analyticdb.gs_schedule_tmp as gr

-- Тянем смены корректировки.
         left join analyticdb.gs_correction_tmp as kor
                   on (date(concat(gr.year, "-", gr.month, "-", gr.day))) = kor.shift_date and
                      (concat(gr.clinic, "_", gr.department, "_", gr.post, "_", gr.role, "_", gr.shift)) =
                      (concat(kor.clinic, "_", kor.department, "_", kor.post, "_", kor.role, "_", kor.shift)) and
                      gr.employee = kor.employee

-- Подставляем полное имя сотрудника
         left join gs_employee as emp on gr.employee = emp.fio_schedule

where gr.employee is not null
  and gr.month = 2