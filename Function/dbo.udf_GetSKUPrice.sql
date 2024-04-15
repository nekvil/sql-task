/*
    Создаем функцию для расчета стоимости продукта.
    Входной параметр "@ID_SKU" - идентификатор продукта.
    Функция возвращает стоимость продукта
*/
create or alter function dbo.udf_GetSKUPrice(
    @ID_SKU int
)
returns decimal(18, 2)
as
begin
    declare @Price decimal(18, 2)

	-- Вычисляем стоимость продукта
    select @Price = sum(b.Value) / nullif(sum(b.Quantity), 0)
    from dbo.Basket as b
    where b.ID_SKU = @ID_SKU

    return @Price
end
