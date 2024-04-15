-- Создаем представление для отображения информации о продуктах с расчетной стоимостью
create or alter view dbo.vw_SKUPrice
as
select
	s.ID
	,s.Code
	,s.Name
	,dbo.udf_GetSKUPrice(s.ID) as gsp
from
	dbo.SKU as s
