DROP TEMPORARY TABLE IF EXISTS ttt_zpn_schedule;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_payconditions;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_levelsemployees;

CREATE TEMPORARY TABLE ttt_zpn_schedule (SELECT *
                                         FROM analyticdb.zpn_schedule);
CREATE INDEX ind_fio ON ttt_zpn_schedule (fio);
CREATE INDEX ind_DTStart ON ttt_zpn_schedule (DTStart);
CREATE INDEX ind_DTEnd ON ttt_zpn_schedule (DTEnd);
CREATE TEMPORARY TABLE ttt_zpn_payconditions (SELECT ppp.`role`,
                                                     ppp.date_from,
                                                     ppp.date_to,
                                                     ppp.post,
                                                     ppp.`level`,
                                                     ppp.clinic,
                                                     ppp.pers_of_serv_used,
                                                     ppp.pers_of_used_med,
                                                     ppp.pers_of_used_pharmacy_prem_under_limit
                                              FROM analyticdb.zpn_payconditions AS ppp
                                              WHERE ppp.pers_of_serv_used is not null
                                                 or ppp.pers_of_used_med is not null
                                                 or ppp.pers_of_used_pharmacy_prem_under_limit is not null);
CREATE INDEX ind_role_ppp ON ttt_zpn_payconditions (`role`);
CREATE INDEX ind_date_from_ppp ON ttt_zpn_payconditions (date_from);
CREATE INDEX ind_date_to_ppp ON ttt_zpn_payconditions (date_to);
CREATE INDEX ind_post_ppp ON ttt_zpn_payconditions (post);
CREATE INDEX ind_level_ppp ON ttt_zpn_payconditions (`level`);
CREATE INDEX ind_clinic_ppp ON ttt_zpn_payconditions (clinic);
CREATE INDEX ind_pers_of_serv_used_ppp ON ttt_zpn_payconditions (pers_of_serv_used);
CREATE INDEX ind_pers_of_used_med_ppp ON ttt_zpn_payconditions (pers_of_used_med);
CREATE INDEX ind_pers_of_used_pharmacy_prem_under_limit_ppp ON ttt_zpn_payconditions (pers_of_used_pharmacy_prem_under_limit);
CREATE TEMPORARY TABLE ttt_zpn_levelsemployees (SELECT *
                                                FROM analyticdb.zpn_levelsemployees);
CREATE INDEX ind_fio_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (fio);
CREATE INDEX ind_date_from_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (date_from);
CREATE INDEX ind_date_to_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (date_to);
CREATE INDEX ind_priority_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (priority);

SELECT s.period,
       post.priority,
       date(s.period)                                       as DTSale,
       cast(date_format(s.period, '%H:%mm') as time)        as TMSale,
       s.organization_key,
       s.executor,
       round(s.price, 2)                                    as price,
       round(s.price_without_discounts, 2)                  as price_without_discounts,
       round(s.amount_of_costs, 2)                          as amount_of_costs,
       anal.description,
       pay.clinic,
       pay.role,
       pay.post,
       pay.level,
       round(pay.pers_of_serv_used, 2)                      as ПерсНазнУсл,
       round(pay.pers_of_used_med, 2)                       as ПерсНазнМед,
       round(pay.pers_of_used_pharmacy_prem_under_limit, 2) as ПерсНазнАптекаДоЛимита

from analyticdb.et_sales AS s
         RIGHT JOIN analyticdb.gs_employee AS em ON em.ref_key = s.executor
         LEFT JOIN ttt_zpn_schedule AS sh ON em.fio = sh.fio AND s.period >= sh.DTStart AND s.period < sh.DTEnd

         left join analyticdb.gs_posts as post on
        (SELECT l.priority
         FROM ttt_zpn_levelsemployees AS l
         WHERE em.fio = l.fio
           AND s.period >= l.date_from
           AND s.period <= l.date_to
         ORDER BY l.priority desc
         LIMIT 1) = post.priority

         left join analyticdb.et_nomenclature as n on s.nomenclature_key = n.ref_key
         left join analyticdb.et_salary_analytics as anal on n.salary_analytics_key = anal.ref_key

         left join analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key
-- Тянем условия
         left join ttt_zpn_payconditions as pay on pay.role = 'Самозванец' and
                                                   s.period >= pay.date_from and s.period <= pay.date_to and
                                                   pay.post = post.post and
                                                   pay.level = post.level and
                                                   cl.clinic = pay.clinic
where s.period >= '2023-01-01 00:00'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  AND sh.DTStart IS null
  and anal.description in ('Клиника', 'Медикаменты', 'Аптека+Зоомагазин')
  and (pay.pers_of_serv_used is not null or pers_of_used_med is not null or
       pay.pers_of_used_pharmacy_prem_under_limit is not NULL);

DROP TEMPORARY TABLE IF EXISTS ttt_zpn_schedule;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_payconditions;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_levelsemployees;