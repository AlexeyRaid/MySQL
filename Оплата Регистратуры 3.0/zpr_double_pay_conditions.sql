select pay.date_from, pay.clinic, pay.shift, pay.post, pay.rate, pay.level, count(*)
from analyticdb.gsf_pay_conditions as pay

group by pay.date_from, pay.clinic, pay.shift, pay.post, pay.rate, pay.level
having count(*) >1