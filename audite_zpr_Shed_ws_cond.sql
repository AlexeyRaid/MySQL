select employee, fio, clinic, shift, department, post, level, DTSmen, DTStart, DTEnd, DlSmen, Korr, count(*) as dbl
    from analyticdb.zpr_shedule_ws_conditions as sh
group by employee, fio, clinic,shift, department, level, DTSmen, DTStart, DTEnd, DlSmen, Korr
having count(*)>1