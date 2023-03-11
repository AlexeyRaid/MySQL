select s.period, s.employee, s.nomenclature_key, s.quantity_paid, s.price, dis.share_of_check
from analyticdb.zpn_paydisposable as dis

         left join analyticdb.et_sales as s on dis.ref_key = s.nomenclature_key and
                                               s.period >= dis.date_from and s.period <= dis.date_to
where s.period >= '2023-02-01 00:00'
  and s.price <> 0