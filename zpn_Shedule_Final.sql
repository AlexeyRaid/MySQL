select gr.fio,
       gr.employee,
       gr.DateSm,
       gr.DTStart,
       gr.DTEnd,
       gr.DlSmen,
       gr.Korr,
       gr.clinic,
       gr.department,
       gr.post,
       gr.role,
       gr.level,
       pay.team_share_of_serv_assign                          as БрНазУсл,
       pay.team_share_of_serv_used                            as БрИспУсл,
       pay.team_share_of_prescribed_med                       as БрНазМед,
       pay.team_share_of_used_med                             as БрИспМед,
       pay.team_share_of_assign_pharmacy_prem_under_limit     as БрНазнАптекаДоЛимита,
       pay.team_share_of_used_pharmacy_prem_under_limit       as БрИспАптекаДоЛимита,
       pay.team_share_of_assign_pharmacy_above_prem_threshold as БрНазнАптекаПремия,
       pay.team_share_of_used_pharmacy_above_prem_threshold   as БрИспАптекаПремия,
       pay.team_norm_pharmacy_mid_shift                       as БрНормаАптекиСрСмена,
       pay.team_norm_pharmacy_by_shift                        as БрНормаАптеки_в_Смену


from analyticdb.zpn_sched_lev_uniqp as gr

         left join analyticdb.zpn_payconditions as pay on gr.UniqPay = pay.Uniq
