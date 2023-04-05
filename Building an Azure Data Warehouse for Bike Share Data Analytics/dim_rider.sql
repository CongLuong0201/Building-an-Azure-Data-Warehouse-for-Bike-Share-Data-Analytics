Begin
    Drop table Dim_rider
end;

GO

CREATE Table Dim_rider(
    rider_id int,
    first varchar(50),
    last varchar(50),
    address varchar(255),
    account_start_date date,
    account_end_date date,
    birthday date,
    account_age int,
    is_member bit
)

GO

Insert into Dim_rider(rider_id, first, last, address, account_start_date, account_end_date, birthday, account_age, is_member)
Select 
    r.rider_id as rider_id,
    r.first as first,
    r.last as last,
    r.address as address,
    Convert(Datetime, SUBSTRING(r.account_start_date,1,19),120) as account_start_date,
    Convert(Datetime, SUBSTRING(r.account_end_date,1,19),120) as account_end_date,
    Convert(Datetime, SUBSTRING(r.birthday,1,19),120) as birthday,
    (DATEDIFF(YEAR,Convert(Datetime, SUBSTRING(r.birthday,1,19),120),Convert(Datetime, SUBSTRING(r.account_start_date,1,19),120)) - 
        CASE When MONTH(Convert(Datetime, SUBSTRING(r.birthday,1,19),120)) > Month(Convert(Datetime, SUBSTRING(r.account_start_date,1,19),120))
            OR MONTH(Convert(Datetime, SUBSTRING(r.birthday,1,19),120)) = MOnth(Convert(Datetime, SUBSTRING(r.account_start_date,1,19),120))
                AND Day(Convert(Datetime, SUBSTRING(r.birthday,1,19),120)) > Day(Convert(Datetime, SUBSTRING(r.account_start_date,1,19),120))
        Then 1 else 0 end
    ) as account_age,
    r.is_member as is_member
From staging_rider as r

go 

Select top 10 * from Dim_rider


