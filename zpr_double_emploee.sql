select emp.ref_key, emp.fio, emp.fio_schedule
from analyticdb.gsf_employee as emp

 group by emp.ref_key, emp.fio, emp.fio_schedule
having count(*) >1