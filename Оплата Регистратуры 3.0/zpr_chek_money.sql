select ch.date, ch.responsible_key, emp.fio, ch.amount+ch.amount_cashless as Suum
from analyticdb.et_money_check as ch

left join analyticdb.gsf_employee as emp on ch.responsible_key = emp.ref_key

where ch.date >= '2023-10-01' and ch.is_posted = 1