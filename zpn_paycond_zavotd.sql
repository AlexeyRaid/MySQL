select pay.date_from,
       pay.department,
       pay.donor,
       pay.recipient,
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