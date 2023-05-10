SELECT sh.department as Отделение, sh.role as "Предполагаемая роль"
FROM analyticdb.gs_schedule AS sh
where sh.post = 'Врач'
  and (sh.role = 'Бригада' or sh.role = 'Узкопрофильный')
GROUP BY sh.department, sh.role;