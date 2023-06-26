-- Mapeo de fechas
UPDATE data SET CustomerDOB = 
    CASE 
        WHEN CustomerDOB = '1/1/1800' THEN '1800-01-01'
        ELSE STR_TO_DATE(CustomerDOB, '%d/%m/%y')
    END;
    
UPDATE data SET TransactionDate = 
    CASE 
        WHEN TransactionDate = '1/1/1800' THEN '1800-01-01'
        ELSE STR_TO_DATE(TransactionDate, '%d/%m/%y')
    END;

-- Cambio a Date
ALTER TABLE data MODIFY CustomerDOB DATE;
ALTER TABLE data MODIFY TransactionDate DATE;

-- Cambio de string a hora
UPDATE data SET TransactionTime = STR_TO_DATE(LPAD(TransactionTime,6,'0'), '%H%i%s');


-- Cambio de IRN a USD
UPDATE data SET TransactionAmountINR = ROUND(TransactionAmountINR * 0.012, 2);
UPDATE data SET CustAccountBalance = ROUND(CustAccountBalance * 0.012, 2);

-- Cambio a float
ALTER TABLE data MODIFY TransactionAmountINR float;
ALTER TABLE data MODIFY CustAccountBalance float;

-- Creamos y calculamos la columna de edad.
ALTER TABLE data ADD COLUMN CustAge INT;
UPDATE data SET CustAge = FLOOR(DATEDIFF(TransactionDate, CustomerDOB)/365);

-- Creamos la columna tiempo y hora de la transacción.
ALTER TABLE data ADD COLUMN TransactionDateTime timestamp;
UPDATE data SET TransactionDateTime = CONCAT(TransactionDate,' ', TransactionTime);

-- Tabla cliente
CREATE TABLE customer AS (
  SELECT 
    CustomerID
    , CustomerDOB
    , CustGender
    , CustLocation
    , CustAccountBalance
    , CustAge
  FROM data
  WHERE CustAge > 13 AND CustAge < 110
    AND CustAccountBalance IS NOT NULL
    AND CustLocation IS NOT NULL
    AND CustGender IS NOT NULL
);

-- Tabla transacción
CREATE TABLE transaction AS (
  SELECT
    CustomerID
    , TransactionID
    , TransactionAmountINR AS TransactionAmountUSD
    , TransactionDateTime
  FROM data
  WHERE TransactionAmountINR >= 0
    
);

/* DROP TABLE IF EXISTS data;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS transaction; */