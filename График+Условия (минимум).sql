select gr.clinic,
       cl.ref_key                                             as clinic_ref,
       gr.department,
       gr.post,
       gr.role,
       gr.shift,
       gr.fio,
       emp.ref_key                                            as fio_ref,
       gr.DateSm,
       gr.DTStart,
       gr.DTEnd,
       gr.DlSmen,
       gr.Korr,
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
       pay.team_norm_pharmacy_by_shift                        as БрНормаАптеки_в_Смену,
       pay.team_rate                                          as БрСтавка,
       pay.team_mid_in_month_gar                              as БрСрМесГар,
       pay.team_in_shift_gar                                  as БрГарСм,
       pay.team_diff_percent                                  as Перикос_Бригадного_,
       pay.pers_of_serv_assign                                as ПерсНазУсл,
       pay.pers_of_serv_used                                  as ПерсИспУсл,
       pay.pers_of_prescribed_med                             as ПерсНазМед,
       pay.pers_of_used_med                                   as ПерсИспМед,
       pay.pers_of_assign_pharmacy_prem_under_limit           as ПерсНазнАптекаДоЛимита,
       pay.pers_of_used_pharmacy_prem_under_limit             as ПерсИспАптекаДоЛимита,
       pay.pers_of_assign_pharmacy_above_prem_threshold       as ПерсНазнАптекаПремия,
       pay.pers_of_used_pharmacy_above_prem_threshold         as ПерсИспАптекаПремия,
       pay.pers_norm_pharmacy_mid_shift                       as НормаАптекиСрСмена,
       pay.pers_norm_pharmacy_by_shift                        as НормаАптеки_в_Смену,
       pay.pers_rate                                          as ПерсСтавка,
       pay.pers_mid_in_month_gar                              as ПерсСрМесГар,
       pay.pers_in_shift_gar                                  as ПерсГарСм

from analyticdb.zpn_sched_lev as gr

         -- Подтягиваем условия
         left join analyticdb.zpn_payconditions as pay on gr.DateSm >= pay.date_from and gr.DateSm <= pay.date_to and
                                                          gr.clinic = pay.clinic and
                                                          gr.role = pay.role and
                                                          gr.post = pay.post and
                                                          gr.level = pay.level
-- Подтягиваем Рефы сотрудника со справочников
         left join analyticdb.gs_employee as emp on gr.fio = emp.fio

-- Подтягиваем рефы клиники
         left join analyticdb.gs_clinics as cl on gr.clinic = cl.clinic


