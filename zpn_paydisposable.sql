select dis.date_from,
       dis.ref_key,
       dis.name,
       dis.share_of_check,
       if(
               (select dis2.date_from + interval -1 day
                from analyticdb.gs_disposable as dis2
                where dis2.ref_key = dis.ref_key
                  and dis2.date_from > dis.date_from
                order by dis2.ref_key, dis2.date_from
                limit 1) is null, curdate(),
               (select dis2.date_from + interval -1 day
                from analyticdb.gs_disposable as dis2
                where dis2.ref_key = dis.ref_key
                  and dis2.date_from > dis.date_from
                order by dis2.ref_key, dis2.date_from
                limit 1)) AS date_to
from analyticdb.gs_disposable as dis