/*
    Проверяем существование схемы "dbo" в базе данных.
    Если схема не существует, создаем ее
*/
if not exists (select 1 from sys.schemas as s where s.name = 'dbo')
begin
    exec('create schema dbo')
end

/*
    Проверяем существование таблицы "SKU".
    Если таблица не существует, создаем ее
*/
if object_id('dbo.SKU') is null
begin
    create table dbo.SKU (
        ID int not null identity,
        Code as 's' + cast(ID as varchar(255)) unique,
        Name varchar(255) not null,
		constraint PK_SKU primary key clustered (ID)
    )
    
    -- Добавляем ограничение уникальности для поля "Code"
	alter table dbo.SKU add constraint UK_SKU_Code unique (Code)
end

/*
    Проверяем существование таблицы "Family".
    Если таблица не существует, создаем ее
*/
if object_id('dbo.Family') is null
begin
    create table dbo.Family (
        ID int not null identity,
        SurName varchar(255) not null,
        BudgetValue decimal(18, 2) not null,
		constraint PK_Family primary key clustered (ID)
    )
end

/*
    Проверяем существование таблицы "Basket".
    Если таблица не существует, создаем ее
*/
if object_id('dbo.Basket') is null
begin
    create table dbo.Basket (
        ID int not null identity,
        ID_SKU int not null,
        ID_Family int not null,
        Quantity int not null check (Quantity >= 0),
        Value decimal(18, 2) not null check (Value >= 0),
        PurchaseDate datetime default getdate(),
        DiscountValue decimal(18, 2),
		constraint PK_Basket primary key clustered (ID)
    )
    
    -- Добавляем внешние ключи для связи с таблицами "SKU" и "Family"
	alter table dbo.Basket add constraint FK_Basket_ID_SKU_SKU foreign key (ID_SKU) references dbo.SKU(ID)
    alter table dbo.Basket add constraint FK_Basket_ID_Family_Family foreign key (ID_Family) references dbo.Family(ID)
end
