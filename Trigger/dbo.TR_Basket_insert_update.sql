/*
    Создаем триггер для обновления поля "DiscountValue" в таблице "Basket" после вставки или обновления записей.
    Если за раз добавляются 2 и более записей одного "ID_SKU", то вычисляем скидку в 5% от значения поля "Value", иначе скидка равна 0
*/
create or alter trigger dbo.TR_Basket_insert_update on dbo.Basket
after insert, update
as
set nocount on
begin
	-- Обновляем поле "DiscountValue" в таблице "Basket"
    update b
	set DiscountValue =
		case 
			when i.CountPerSKU > 1 
				then b.Value * 0.05 
			else 0 
		end
    from dbo.Basket as b
		-- Связываем таблицу "Basket" с подзапросом, который возвращает количество записей для каждого "ID_SKU" из вставленных/обновленных данных
		inner join (
			select i.ID_SKU, count(*) as CountPerSKU
			from inserted as i
			group by i.ID_SKU
		) as i on i.ID_SKU = b.ID_SKU
	-- Связываем таблицу "Basket" с таблицей "inserted" по полю "ID" для обновления только вставленных/обновленных записей
    inner join inserted as i_temp on i_temp.ID = b.ID 
end
