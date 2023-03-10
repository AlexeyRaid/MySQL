select pay.date_from,
       pay.department,
       pay.donor,
       em_don.ref_key                              as ref_donor,
       pay.recipient,
       em_rec.ref_key                              as ref_rec,
       pay.share_donor_assigned_services,
       pay.share_donor_used_services,

       if((select pay2.date_from + interval -1 day
           from analyticdb.gs_pay_conditions_chief_tmp as pay2
           where pay2.department = pay.department
             and pay2.donor = pay.donor
             and pay2.recipient = pay.recipient
             and pay2.date_from > pay.date_from
           order by pay2.department, pay2.donor, pay2.recipient, pay2.date_from
           limit 1) is null, curdate(), (select pay2.date_from + interval -1 day
                                         from analyticdb.gs_pay_conditions_chief_tmp as pay2
                                         where pay2.department = pay.department
                                           and pay2.donor = pay.donor
                                           and pay2.recipient = pay.recipient
                                           and pay2.date_from > pay.date_from
                                         order by pay2.department, pay2.donor, pay2.recipient, pay2.date_from
                                         limit 1)) AS date_to

from analyticdb.gs_pay_conditions_chief_tmp as pay

         left join analyticdb.gs_employee as em_rec on pay.recipient = em_rec.fio
         left join analyticdb.gs_employee as em_don on pay.donor = em_don.fio