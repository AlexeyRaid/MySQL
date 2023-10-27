select lvl.date_from, lvl.fio, lvl.post, lvl.level, lvl.date_to, lvl.block_date, count(*)
from analyticdb.zpr_level as lvl

group by lvl.date_from, lvl.fio, lvl.post, lvl.level, lvl.date_to
having count(*) >1