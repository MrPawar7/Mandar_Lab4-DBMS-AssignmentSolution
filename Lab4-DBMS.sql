create database if not exists e_commerce_database;
use e_commerce_database;

create table if not exists SUPPLIER(
SUPP_ID INT PRIMARY KEY,
SUPP_NAME VARCHAR(50),
SUPP_CITY VARCHAR(50),
SUPP_PHONE VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS CUSTOMER (
  CUS_ID INT NOT NULL,
  CUS_NAME VARCHAR(20) NULL DEFAULT NULL,
  CUS_PHONE VARCHAR(10),
  CUS_CITY varchar(30) ,
  CUS_GENDER CHAR,
  PRIMARY KEY (CUS_ID)
 );
 
 CREATE TABLE IF NOT EXISTS CATEGORY (
  CAT_ID INT NOT NULL,
  CAT_NAME VARCHAR(20) NULL DEFAULT NULL,
   PRIMARY KEY (CAT_ID)
  );
  
  
   CREATE TABLE IF NOT EXISTS PRODUCT (
  PRO_ID INT NOT NULL,
  PRO_NAME VARCHAR(20) NULL DEFAULT NULL,
  PRO_DESC VARCHAR(60) NULL DEFAULT NULL,
  CAT_ID INT NOT NULL,
  PRIMARY KEY (PRO_ID),
  FOREIGN KEY (CAT_ID) REFERENCES CATEGORY (CAT_ID)  
  );
  
   CREATE TABLE IF NOT EXISTS PRODUCT_DETAILS (
  PROD_ID INT NOT NULL,
  PRO_ID INT NOT NULL,
  SUPP_ID INT NOT NULL,
  PROD_PRICE INT NOT NULL,
  PRIMARY KEY (PROD_ID),
  FOREIGN KEY (PRO_ID) REFERENCES PRODUCT (PRO_ID),
  FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER(SUPP_ID)  
  );
  
  CREATE TABLE IF NOT EXISTS ORDERS (
  ORD_ID INT NOT NULL,
  ORD_AMOUNT INT NOT NULL,
  ORD_DATE DATE,
  CUS_ID INT NOT NULL,
  PROD_ID INT NOT NULL,
  PRIMARY KEY (ORD_ID),
  FOREIGN KEY (CUS_ID) REFERENCES CUSTOMER(CUS_ID),
  FOREIGN KEY (PROD_ID) REFERENCES PRODUCT_DETAILS(PROD_ID)
  );
  
  CREATE TABLE IF NOT EXISTS RATING (
  RAT_ID INT NOT NULL,
  CUS_ID INT NOT NULL,
  SUPP_ID INT NOT NULL,
  RAT_RATSTARS INT NOT NULL,
  PRIMARY KEY (RAT_ID),
  FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER (SUPP_ID),
  FOREIGN KEY (CUS_ID) REFERENCES CUSTOMER(CUS_ID)
  ); 
  
insert into supplier values(1,"Rajesh Retails","Delhi",'1234567890');
insert into supplier values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into supplier values(3,"Knome products","Banglore",'9785462315');
insert into supplier values(4,"Bansal Retails","Kochi",'8975463285');
insert into supplier values(5,"Mittal Ltd.","Lucknow",'7898456532');

INSERT INTO customer VALUES(1,"AAKASH",'9999999999',"DELHI",'M');
INSERT INTO customer VALUES(2,"AMAN",'9785463215',"NOIDA",'M');
INSERT INTO customer VALUES(3,"NEHA",'9999999999',"MUMBAI",'F');
INSERT INTO customer VALUES(4,"MEGHA",'9994562399',"KOLKATA",'F');
INSERT INTO customer VALUES(5,"PULKIT",'7895999999',"LUCKNOW",'M');

INSERT INTO category VALUES( 1,"BOOKS");
INSERT INTO category VALUES(2,"GAMES");
INSERT INTO category VALUES(3,"GROCERIES");
INSERT INTO category VALUES (4,"ELECTRONICS");
INSERT INTO category VALUES(5,"CLOTHES");

INSERT INTO `PRODUCT` VALUES(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
INSERT INTO `PRODUCT` VALUES(2,"TSHIRT","DFDFJDFJDKFD",5);
INSERT INTO `PRODUCT` VALUES(3,"ROG LAPTOP","DFNTTNTNTERND",4);
INSERT INTO `PRODUCT` VALUES(4,"OATS","REURENTBTOTH",3);
INSERT INTO `PRODUCT` VALUES(5,"HARRY POTTER","NBEMCTHTJTH",1);
  
INSERT INTO PRODUCT_DETAILS VALUES(1,1,2,1500);
INSERT INTO PRODUCT_DETAILS VALUES(2,3,5,30000);
INSERT INTO PRODUCT_DETAILS VALUES(3,5,1,3000);
INSERT INTO PRODUCT_DETAILS VALUES(4,2,3,2500);
INSERT INTO PRODUCT_DETAILS VALUES(5,4,1,1000);
  
INSERT INTO ORDERS VALUES (50,2000,"2021-10-06",2,1);
INSERT INTO ORDERS VALUES(20,1500,"2021-10-12",3,5);
INSERT INTO ORDERS VALUES(25,30500,"2021-09-16",5,2);
INSERT INTO ORDERS VALUES(26,2000,"2021-10-05",1,1);
INSERT INTO ORDERS VALUES(30,3500,"2021-08-16",4,3);

INSERT INTO RATING VALUES(1,2,2,4);
INSERT INTO RATING VALUES(2,3,4,3);
INSERT INTO RATING VALUES(3,5,1,5);
INSERT INTO RATING VALUES(4,1,3,2);
INSERT INTO RATING VALUES(5,4,5,4);
  
  SELECT * FROM SUPPLIER;
  SELECT * FROM customer;
  SELECT * FROM category;
  SELECT * FROM product;
  SELECT * FROM product_details;
  SELECT * FROM ORDERS;
  SELECT * FROM rating;
  
  /*3) Display the number of the customer group by their genders who have placed any order
of amount greater than or equal to Rs.3000.*/

SELECT 
    COUNT(c.CUS_ID) AS CUSTOMER_ID, c.CUS_GENDER
FROM
    customer c,
    ORDERS o
WHERE
    o.CUS_ID = c.CUS_ID
        AND o.ORD_AMOUNT >= 3000
GROUP BY CUS_GENDER;
 
 /*4) Display all the orders along with the product name ordered by a customer having
Customer_Id=2.*/

SELECT 
    o.ORD_ID AS Order_ID,
    p.PRO_ID AS Product_ID,
    p.PRO_NAME AS Product_name,
    P.PRO_DESC AS Prdouct_Description,
    o.CUS_ID AS Customer_ID
FROM
    product p,
    product_details pd,
    orders o
WHERE
    p.PRO_ID = pd.PRO_ID
        AND pd.PROD_ID = o.PROD_ID
        AND o.CUS_ID = 2;
    
/*5) Display the Supplier details who can supply more than one product.*/

SELECT 
    *
FROM
    supplier
WHERE
    SUPP_ID IN (SELECT 
            SUPP_ID
        FROM
            product_details
        GROUP BY SUPP_ID
        HAVING COUNT(SUPP_ID) > 1);

/*6) Find the category of the product whose order amount is minimum.*/

SELECT 
    c.*
FROM
    orders o
        JOIN
    product_details pd ON pd.PROD_ID = o.PROD_ID
        JOIN
    product p ON p.PRO_ID = pd.PRO_ID
        JOIN
    category c ON c.CAT_ID = p.CAT_ID
HAVING MIN(o.ORD_AMOUNT);

/*7) Display the Id and Name of the Product ordered after “2021-10-05”.*/

SELECT 
    p.PRO_ID, p.PRO_NAME
FROM
    orders o
        JOIN
    product_details pd ON (o.PROD_ID = PD.PROD_ID)
        JOIN
    product p ON (p.PRO_ID = pd.PRO_ID)
WHERE
    o.ORD_DATE > '2021-10-05';

/*8) Print the top 3 supplier name and id and their rating on the basis of their rating along
with the customer name who has given the rating.*/

SELECT 
    s.SUPP_ID, s.SUPP_NAME, c.CUS_NAME, r.RAT_RATSTARS
FROM
    rating r
        JOIN
    supplier s ON (r.SUPP_ID = s.SUPP_ID)
        JOIN
    customer c ON (r.CUS_ID = c.CUS_ID)
ORDER BY r.RAT_RATSTARS DESC
LIMIT 3;

/*9) Display customer name and gender whose names start or end with character 'A'.*/
SELECT 
    CUS_NAME, CUS_GENDER
FROM
    customer
WHERE
    CUS_NAME LIKE '%A' OR CUS_NAME LIKE 'A%';
    
    /*10) Display the total order amount of the male customers.*/
    
select 
    SUM(o.ORD_AMOUNT)
FROM
    orders o,
    customer c
WHERE
    c.cus_id = o.cus_id
        AND c.cus_gender = 'M';
        
/*11) Display all the Customers left outer join with the orders.*/

SELECT 
    *
FROM
    customer c
        LEFT JOIN
    orders o ON c.CUS_ID = o.CUS_ID;
    
    


/*12) Create a stored procedure to display the Rating for a Supplier if any along with the
Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average
Supplier” else “Supplier should not be considered”.*/

/*CREATE DEFINER=`root`@`localhost` PROCEDURE `rate_suppliers`()
BEGIN
   select s.supp_id, s.supp_name, r.rat_ratstars,
   CASE
   when r.rat_ratstars > 4 then 'Genuine supplier'
   when r.rat_ratstars > 2 then 'Average supplier'
   else
     'SUPLLIER  NOT  CONSIDERED'
     END AS verdict from  rating r inner join supplier s ON s.supp_id=r.supp_id;
END*/

call rate_suppliers();

/*END*/