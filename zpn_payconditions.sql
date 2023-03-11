select pc.date_from                                          as date_from,
       pc.clinic                                             as clinic,
       pc.role                                               as role,
       pc.post                                               as post,
       pc.level                                              as level,
       pc.department                                         as department,
       pc.fio                                                as fio,
       pc.shift                                              as shift,

-- Формируем дату по
       if(
               (select pc2.date_from + interval -1 day
                from analyticdb.gs_pay_conditions_tmp as pc2
                where pc2.date_from > pc.date_from
                  and pc2.clinic = pc.clinic
                  and pc2.role = pc.role
                  and pc2.post = pc.post
                  and pc2.level = pc.level
                  and pc2.department = pc.department
                  and pc2.fio = pc.fio
                  and pc2.shift = pc.shift
                order by pc2.clinic, pc2.role, pc2.post, pc2.level, pc2.department, pc2.fio, pc2.shift, pc2.date_from
                limit 1) is null, curdate(),
               (select pc2.date_from + interval -1 day
                from analyticdb.gs_pay_conditions_tmp as pc2
                where pc2.date_from > pc.date_from
                  and pc2.clinic = pc.clinic
                  and pc2.role = pc.role
                  and pc2.post = pc.post
                  and pc2.level = pc.level
                  and pc2.department = pc.department
                  and pc2.fio = pc.fio
                  and pc2.shift = pc.shift
                order by pc2.clinic, pc2.role, pc2.post, pc2.level, pc2.department, pc2.fio, pc2.shift, pc2.date_from
                limit 1)
           )                                                 as date_to,
       pc.block_date,
       pc.team_share_of_serv_assign                          AS team_share_of_serv_assign,
       pc.team_share_of_serv_used                            AS team_share_of_serv_used,
       pc.team_share_of_prescribed_med                       AS team_share_of_prescribed_med,
       pc.team_share_of_used_med                             AS team_share_of_used_med,
       pc.team_share_of_assign_pharmacy_prem_under_limit     AS team_share_of_assign_pharmacy_prem_under_limit,
       pc.team_share_of_used_pharmacy_prem_under_limit       AS team_share_of_used_pharmacy_prem_under_limit,
       pc.team_share_of_assign_pharmacy_above_prem_threshold AS team_share_of_assign_pharmacy_above_prem_threshold,
       pc.team_share_of_used_pharmacy_above_prem_threshold   AS team_share_of_used_pharmacy_above_prem_threshold,
       pc.team_norm_pharmacy_mid_shift                       AS team_norm_pharmacy_mid_shift,
       pc.team_norm_pharmacy_by_shift                        AS team_norm_pharmacy_by_shift,
       pc.team_rate                                          AS team_rate,
       pc.team_mid_in_month_gar                              AS team_mid_in_month_gar,
       pc.team_in_shift_gar                                  AS team_in_shift_gar,
       pc.team_diff_percent                                  AS team_diff_percent,
       pc.pers_of_serv_assign                                AS pers_of_serv_assign,
       pc.pers_of_serv_used                                  AS pers_of_serv_used,
       pc.pers_of_prescribed_med                             AS pers_of_prescribed_med,
       pc.pers_of_used_med                                   AS pers_of_used_med,
       pc.pers_of_assign_pharmacy_prem_under_limit           AS pers_of_assign_pharmacy_prem_under_limit,
       pc.pers_of_used_pharmacy_prem_under_limit             AS pers_of_used_pharmacy_prem_under_limit,
       pc.pers_of_assign_pharmacy_above_prem_threshold       AS pers_of_assign_pharmacy_above_prem_threshold,
       pc.pers_of_used_pharmacy_above_prem_threshold         AS pers_of_used_pharmacy_above_prem_threshold,
       pc.pers_norm_pharmacy_mid_shift                       AS pers_norm_pharmacy_mid_shift,
       pc.pers_norm_pharmacy_by_shift                        AS pers_norm_pharmacy_by_shift,
       pc.pers_rate                                          AS pers_rate,
       pc.pers_mid_in_month_gar                              AS pers_mid_in_month_gar,
       pc.pers_in_shift_gar                                  AS pers_in_shift_gar


from analyticdb.gs_pay_conditions_tmp as pc
where pc.date_from is not null
