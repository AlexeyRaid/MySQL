select emp.ref_key, emp.fio, emp.fio_schedule, count(*) as doubl
from analyticdb.gsf_employee as emp

 group by emp.ref_key, emp.fio, emp.fio_schedule
having count(*) >1