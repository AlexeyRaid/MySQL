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
                                                     ppp.pers_of_serv_assign,
                                                     ppp.pers_of_prescribed_med,
                                                     ppp.pers_of_assign_pharmacy_prem_under_limit
                                              FROM analyticdb.zpn_payconditions AS ppp
                                              WHERE ppp.pers_of_serv_assign is not null
                                                 or ppp.pers_of_prescribed_med is not null
                                                 or ppp.pers_of_assign_pharmacy_prem_under_limit is not null);
CREATE INDEX ind_role_ppp ON ttt_zpn_payconditions (`role`);
CREATE INDEX ind_date_from_ppp ON ttt_zpn_payconditions (date_from);
CREATE INDEX ind_date_to_ppp ON ttt_zpn_payconditions (date_to);
CREATE INDEX ind_post_ppp ON ttt_zpn_payconditions (post);
CREATE INDEX ind_level_ppp ON ttt_zpn_payconditions (`level`);
CREATE INDEX ind_clinic_ppp ON ttt_zpn_payconditions (clinic);
CREATE INDEX ind_pers_of_serv_used_ppp ON ttt_zpn_payconditions (pers_of_serv_assign);
CREATE INDEX ind_pers_of_used_med_ppp ON ttt_zpn_payconditions (pers_of_prescribed_med);
CREATE INDEX ind_pers_of_used_pharmacy_prem_under_limit_ppp ON ttt_zpn_payconditions (pers_of_assign_pharmacy_prem_under_limit);
CREATE TEMPORARY TABLE ttt_zpn_levelsemployees (SELECT *
                                                FROM analyticdb.zpn_levelsemployees);
CREATE INDEX ind_fio_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (fio);
CREATE INDEX ind_date_from_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (date_from);
CREATE INDEX ind_date_to_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (date_to);
CREATE INDEX ind_priority_ttt_zpn_levelsemployees ON ttt_zpn_levelsemployees (priority);

SELECT s.period,
       s.recorder,
       s.line_number,
       sh.Korr,
       sh.clinic,
       sh.employee,
       post.priority,
       sh.DateSm,
       sh.DTStart,
       sh.DTEnd,
       sh.department,
       sh.department,
       date(s.period)                                as DTSale,
       cast(date_format(s.period, '%H:%mm') as time) as TMSale,
       s.organization_key,
       s.executor,
       s.price,
       s.price_without_discounts,
       s.amount_of_costs,
       post.post,
       post.level,
       anal.description,
       pay.pers_of_serv_assign                       as ПерсИспУсл,
       pay.pers_of_prescribed_med                    as ПерсИспМед,
       pay.pers_of_assign_pharmacy_prem_under_limit  as ПерсИспАптекаДоЛимита

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
         left join analyticdb.analytic_salaries as anal on n.salary_analytics_key = anal.ref_key

         left join analyticdb.gs_clinics as cl on s.organization_key = cl.ref_key
-- Тянем условия
         left join ttt_zpn_payconditions as pay on pay.role = 'Самозванец' and
                                                   s.period >= pay.date_from and s.period <= pay.date_to and
                                                   pay.post = post.post and
                                                   pay.level = post.level and
                                                   cl.clinic = pay.clinic
where s.period >= '2022-01-01 00:00'
  and (s.price <> 0
    or s.amount_of_costs <> 0
    or s.price_without_discounts <> 0)
  --  AND sh.DTStart IS null
  and anal.description in ('Клиника', 'Медикаменты', 'Аптека+Зоомагазин')
  and (pay.pers_of_serv_assign is not null or pay.pers_of_prescribed_med is not null or
       pay.pers_of_assign_pharmacy_prem_under_limit is not NULL);

DROP TEMPORARY TABLE IF EXISTS ttt_zpn_schedule;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_payconditions;
DROP TEMPORARY TABLE IF EXISTS ttt_zpn_levelsemployees;