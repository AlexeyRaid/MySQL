select s.period,
       s.executor,
       s.organization_key,
       s.nomenclature_key,
       s.quantity_paid,
       s.price,
       dis.share_of_check,
       ifnull(gr.post, post.post) as post

from analyticdb.zpn_paydisposable as dis

         left join analyticdb.et_sales as s on dis.ref_key = s.nomenclature_key and
                                               s.period >= dis.date_from and s.period <= dis.date_to

         left join analyticdb.zpn_schedule as gr on s.period >= gr.DTStart and s.period < gr.DTEnd

         RIGHT JOIN analyticdb.gs_employee AS em ON em.ref_key = s.executor
    
         left join analyticdb.gs_posts as post on
        (SELECT l.priority
         FROM analyticdb.zpn_levelsemployees AS l
         WHERE em.fio = l.fio
           AND s.period >= l.date_from
           AND s.period <= l.date_to
         ORDER BY l.priority desc
         LIMIT 1) = post.priority

where s.period >= '2023-02-01 00:00'
  and s.price <> 0