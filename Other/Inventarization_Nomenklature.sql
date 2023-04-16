select n.ref_key,
       n.description,
       n.nomenclature_type,
       n.salary_analytics_key,

       n.parent_key

from analyticdb.et_nomenclature as n


where n.nomenclature_type = 'Товар'
  and n.is_folder = 0