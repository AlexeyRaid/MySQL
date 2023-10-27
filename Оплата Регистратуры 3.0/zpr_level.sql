select lev.date_from,
       lev.fio,
       lev.post,
       lev.level,
       lev.block_date,

       if(lev.block_date is null,
          if(
                  (select lev.date_from + interval -1 day
                   from analyticdb.gsf_employees_level as lev2
                   where lev2.fio = lev.fio
                     and lev2.post = lev.post
                     and lev2.date_from > lev2.date_from
                   order by lev2.fio, lev2.post, lev2.date_from
                   limit 1) is null, curdate() + interval 30 day,
                  (select lev3.date_from + interval -1 day
                   from analyticdb.gsf_employees_level lev3
                   where lev3.fio = lev.fio
                     and lev3.post = lev.post
                     and lev3.date_from > lev.date_from
                   order by lev3.fio, lev3.post, lev3.date_from
                   limit 1)
          ),
          lev.block_date) as date_to


from analyticdb.gsf_employees_level as lev

-- Если блокдата имеет место быть - значит ставим ее в date_to. Если блокдаты нет - тогда ищем строку с такими же столбцами fio, post, но хотя бы на один день больше, чем date_to, значит значение ev.date_from-1 и есть конечная дата для искомого столбца
