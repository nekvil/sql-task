/*
    Создаем процедуру для обновления бюджета семьи после покупки товаров.
    Входной параметр "@FamilySurName" - фамилия семьи
*/
create or alter procedure dbo.usp_MakeFamilyPurchase
    @FamilySurName varchar(255)
as
begin
	declare @TotalValue decimal(18, 2)

	-- Проверяем существование семьи с указанной фамилией
    if not exists (select 1 from dbo.Family where SurName = @FamilySurName)
    begin
        raiserror('Семьи с SurName "%s" не существует.', 16, 1, @FamilySurName)

        return
    end

	-- Вычисляем общую стоимость покупок для семьи
    select @TotalValue = sum(b.Value)
    from dbo.Basket as b
		inner join dbo.Family as f on b.ID_Family = f.ID
    where f.SurName = @FamilySurName

	-- Обновляем бюджет семьи
    update f
    set BudgetValue = f.BudgetValue - @TotalValue
    from dbo.Family as f
    where f.SurName = @FamilySurName
end
