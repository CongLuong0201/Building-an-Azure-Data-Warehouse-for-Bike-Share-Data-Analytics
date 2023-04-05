Begin
    DROP TABLE Fact_payment
END;

Go

CREATE TABLE Fact_Payment(
    payment_id INT,
    date DATE,
    amount FLOAT,
    rider_id INT
)

GO

INSERT INTO Fact_Payment (payment_id, date, amount, rider_id)
SELECT p.payment_id as payment_id, p.date as date, p.amount as amount, p.rider_id as rider_id
FROM staging_payment as p

GO

SELECT TOP 10 * from Fact_Payment

Go