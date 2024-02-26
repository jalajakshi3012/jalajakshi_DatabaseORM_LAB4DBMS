
-- Question 3 Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000.
select count(CUS_ID) as NoOfCustomers,CUS_GENDER as Gender from customer where CUS_ID IN (select CUS_ID from `order` where ORD_AMOUNT>=3000) group by CUS_GENDER;

select C_O.CUS_GENDER as 'Gender', count(C_O.CUS_GENDER) as 'NoOfCustomers' from (
select c.cus_id, c.cus_name, c.cus_gender from customer c inner join
`order` o on c.cus_id = o.cus_id
where o.ORD_AMOUNT >= 3000
group by c.cus_id
) as C_O
group by C_O.cus_gender;

-- Question 4
-- Display all the orders along with product name ordered by a customer having Customer_Id=2
select o.cus_id, o.ord_id, o.ORD_AMOUNT, o.ORD_DATE, sp.SUPP_PRICE,
p.PRO_NAME as ProductName from `order` o
	inner join supplier_pricing sp
    inner join product p
on (o.PRICING_ID = sp.PRICING_ID AND sp.PRO_ID = p.PRO_ID)
where o.CUS_Id = 2;

-- Question 5
-- Display the Supplier details who can supply more than one product
select s.* , count(sp.PRO_ID) as noOfProducts from supplier_pricing sp,supplier s where sp.SUPP_ID=s.SUPP_ID group by sp.SUPP_ID HAVING count(sp.PRO_ID)>1;

-- Question 6


-- Question 7
-- Display the Id and Name of the Product ordered after “2021-10-05”.

select p.pro_id, p.pro_name
from `order` o
	inner join supplier_pricing sp
    inner join product p
on (o.PRICING_ID = sp.PRICING_ID AND sp.PRO_ID = p.PRO_ID)
where o.ORD_DATE >= "2021-10-05"
group by p.PRO_ID;

-- Question 8
-- Display customer name and gender whose names start or end with character 'A'.
select c.CUS_NAME,c.CUS_GENDER from customer c where (c.CUS_NAME LIKE '%A') OR ( c.CUS_NAME LIKE 'A%');

-- Question 9
--  Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
-- Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2   -- print “Average
-- Service” else print “Poor Service”. Note that there should be one rating per supplier.

-- stored procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `DisplaySupplierRatingDetails`()
BEGIN
select  SUPP_ID,SUPP_NAME,averagerating,
CASE when averagerating =5 THEN 'EXCELLENT SERVICE'
		 WHEN averagerating>4 THEN 'GOOD SERVICE'
         WHEN averagerating>2 THEN 'AVERAGE SERVICE'
         else  'POOR SERVICE'
	END AS ServiceType
    from(
select s.SUPP_ID,s.SUPP_NAME,avg(r.RAT_RATSTARS)  averagerating 
from rating r 
		inner join `order` o
        inner join supplier_pricing sp
        inner join supplier s
        on(
        r.ORD_ID=o.ORD_ID and
        o.PRICING_ID=sp.pricing_id and
        sp.SUPP_ID=s.SUPP_ID) group by SUPP_ID) as r_o_sp_s;
END
-- Procedure call
call DisplaySupplierRatingDetails();

