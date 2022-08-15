-----adding,modifying and dropping a column from customer table------

alter table customer add middle_name number(5);

alter table customer modify middle_name varchar(10);

alter table customer drop column middle_name;

describe customer;


---update value of phone number in customer table whose id is 1------
update customer set phone_number='01777526970' where customer_id=1;

select * from customer;

---delete the row of phone number in customer table whose id is 7------

delete from customer where customer_id=7;

----range search----

select source_branch,dest_branch from billing where total_cost>=300 and total_cost<=400;

----order by total_cost ----

select source_branch,dest_branch,total_cost from billing order by total_cost,delivery_time_days desc;

----pattern matching---

select fname,lname from customer where address like '%d___a%';


------aggregate functions-------

select count(*) from customer;

select count(phone_number) from customer;

select max(total_cost) from billing;

select avg(total_cost) from billing;

select avg(nvl(total_cost,0)) from billing;

------group by and having-----

select customer_from,count(shipment_id) from shipment_details group by customer_from;

select customer_from,count(shipment_id) from shipment_details group by customer_from having count(shipment_id)>1;

----finding second max total_cost from billing using subquery------

select max(total_cost) from billing where total_cost<(select max(total_cost) from billing);

---finding customer details who have sent item from mohammadpur---

select a.fname,a.lname from customer a where a.customer_id in(select x.customer_from from shipment_details x,branch y where x.source_branch=y.branch_id and y.branch_name='mohammadpur');

---finding customer details who have sent item from mohammadpur or last name is sakib using union---

select fname,lname from customer where lname='sakib' union select a.fname,a.lname from customer a where a.customer_id in(select x.customer_from from shipment_details x,branch y where x.source_branch=y.branch_id and y.branch_name='mohammadpur');

---finding customer details who have sent item from mohammadpur and last name is rahman using intersection---

select fname,lname from customer where lname='rahman' union select a.fname,a.lname from customer a where a.customer_id in(select x.customer_from from shipment_details x,branch y where x.source_branch=y.branch_id and y.branch_name='mohammadpur');

---finding customer details who have not sent item from mohammadpur using minus---

select fname,lname from customer minus select a.fname,a.lname from customer a where a.customer_id in(select x.customer_from from shipment_details x,branch y where x.source_branch=y.branch_id and y.branch_name='mohammadpur');

---join----

---to know every shipment destination name using join---

select a.shipment_id,b.branch_name from shipment_details a join branch b on a.dest_branch=b.branch_id;

----to know every employee working branch using natural join----
select a.fname,a.lname,b.branch_name from employee a natural join branch b;

----to check currently which branch is destination for which shipment,status and cost using left outer join----

select a.branch_name,b.shipment_id,b.itemname,b.status from branch a left outer join shipment_details b on a.branch_id=b.dest_branch;

-----full outer join-----


select a.branch_name,b.shipment_id from branch a full outer join shipment_details b on a.branch_id=b.source_branch;


-----self join to show every employee and their corresponding branch manager------

select a.fname "employee",b.fname "manager" from employee a join  employee b on a.manager_id=b.employee_id;

----cross join to find source branch name and dest branch name those parcel are on the way----

select a.branch_name,b.branch_name from branch a cross join branch b join shipment_details c on a.branch_id=c.source_branch and b.branch_id=c.dest_branch where c.status='on the way';

----pl/sql---

----finding the customer details who have to pay most after receiving item using pl/sql-----

SET SERVEROUTPUT ON

DECLARE
id customer.customer_id%type;
fname customer.fname%type;
lname  customer.lname%type;
address customer.address%type;
phone_number customer.phone_number%type;
max_due payment_details.due_amount%type;


BEGIN
select max(due_amount) into max_due from payment_details;
select shipment_details.customer_to into id from shipment_details,payment_details where shipment_details.shipment_id=payment_details.shipment_id and payment_details.due_amount=max_due;
select fname,lname,address,phone_number into fname,lname,address,phone_number from customer where customer_id=id;
dbms_output.put_line('Name: '||fname||' '||lname);
dbms_output.put_line('Address: '||address);
dbms_output.put_line('Phone Number: '||phone_number);
END;
/

----printing details of customers using loop----

SET SERVEROUTPUT ON

DECLARE
id customer.customer_id%type;
fname customer.fname%type;
lname  customer.lname%type;
address customer.address%type;
phone_number customer.phone_number%type;
i number;
BEGIN
i:=1;
loop
select fname,lname,address,phone_number into fname,lname,address,phone_number from customer where customer_id=i;
dbms_output.put_line('Name: '||fname||' '||lname);
dbms_output.put_line('Address: '||address);
dbms_output.put_line('Phone Number: '||phone_number);
i:=i+1;
exit when i>6;
end loop;

END;
/


------adding a new branch using procedure------

create OR replace procedure add_branch(
  id branch.branch_id%type,
  name branch.branch_name%type,
  address branch.address%type,
  district branch.district%type) is
BEGIN
 insert into branch values(id,name,address,district);
END add_branch;
/

begin
 add_branch(20,'royalmor','5/ka,shonadanga,khulna','khulna');
end;
/
select * from branch


------calculating cost with 5%vat for each shipment using parameterized function----


create or replace function cost_with_vat(tot shipment_details.total_cost%type,x number) return number is
BEGIN
  RETURN (tot+tot*(x/100));
END cost_with_vat;
/ 

select shipment_id,itemname,cost_with_vat(total_cost,5) "cost_with_vat" from shipment_details where dest_branch=2;
/

 

-----find source branch and dest branch name from and to which the shipment took place on a given date using cursor----

DECLARE
cursor cus_cursor1 is (select a.branch_name as source,b.branch_name as dest from branch a cross join branch b join shipment_details c on a.branch_id=c.source_branch and b.branch_id=c.dest_branch where c.shipment_date='09-JAN-2022');
cus_record1 cus_cursor1%rowtype;
BEGIN
 open cus_cursor1;
 loop
   fetch cus_cursor1 into cus_record1;
   exit when cus_cursor1%notfound;
   dbms_output.put_line('Source Branch: '||cus_record1.source||'       '||'Dest Branch: '||cus_record1.dest);
  end loop;
 close cus_cursor1;
END;
/

drop trigger tr;
create or replace trigger tr before update or insert on shipment_details
for each row
begin
if:new.source_branch=1 and:new.dest_branch=2 then:new.total_cost:=300;
elsif:new.source_branch=2 and:new.dest_branch=1 then:new.total_cost:=300;
elsif:new.source_branch=1 and:new.dest_branch=3 then:new.total_cost:=500;
elsif:new.source_branch=3 and:new.dest_branch=1 then:new.total_cost:=500;
elsif:new.source_branch=1 and:new.dest_branch=4 then:new.total_cost:=400;
elsif:new.source_branch=4 and:new.dest_branch=1 then:new.total_cost:=400;
elsif:new.source_branch=1 and:new.dest_branch=5 then:new.total_cost:=400;
elsif:new.source_branch=2 and:new.dest_branch=3 then:new.total_cost:=400;
elsif:new.source_branch=3 and:new.dest_branch=2 then:new.total_cost:=200;
elsif:new.source_branch=2 and:new.dest_branch=4 then:new.total_cost:=200;
elsif:new.source_branch=4 and:new.dest_branch=2 then:new.total_cost:=300;
elsif:new.source_branch=2 and:new.dest_branch=5 then:new.total_cost:=300;
elsif:new.source_branch=5 and:new.dest_branch=2 then:new.total_cost:=400;
elsif:new.source_branch=3 and:new.dest_branch=4 then:new.total_cost:=400;
elsif:new.source_branch=4 and:new.dest_branch=3 then:new.total_cost:=400;
elsif:new.source_branch=3 and:new.dest_branch=5 then:new.total_cost:=400;
elsif:new.source_branch=5 and:new.dest_branch=3 then:new.total_cost:=400;
elsif:new.source_branch=4 and:new.dest_branch=5 then:new.total_cost:=400;
elsif:new.source_branch=5 and:new.dest_branch=4 then:new.total_cost:=400;
end if;
end tr;
/

 insert into shipment_details values(11,1,2,5,2,'book',4,'on the way','09-JAN-2022','12-JAN-1955',null);
select * from shipment_details;


----commit,rollback and savepoint---

insert into branch values(7,'mohammadpur','1/a,townhall,dhaka','Dhaka');
insert into branch values(8,'demra','4/r,demra,dhaka','Dhaka');
insert into branch values(9,'kendua','3/f,paikmara,kendua','Netrkona');
commit;

delete from branch;
select * from branch;

rollback;


select * from branch;

delete from branch where branch_id=7;
delete from branch where branch_id=8;
delete from branch where branch_id=9;
commit;

insert into customer values(10,'sadman','sakib','2/a,fullbari,khulna','01777234567');
savepoint a;
insert into customer values(11,'adnan','akib','43/c,demra,dhaka','017457234567');
savepoint b;
insert into customer values(12,'ishraq','ahmed','4/d,kendua,netrokona','01777234534');
savepoint c;

select * from customer;

rollback to a;

select * from customer;

-----date----


----find all the employees parmanent join date------
select ADD_MONTHS (joining_date,6) as parmanent_join from employee where employee_id=1;

----find all the employees parmanent joining month------
select fname,lname,EXTRACT(Month FROM joining_date) as Joining_Month from employee;

----find all the employees parmanent joining year------
select fname,lname,EXTRACT(Year FROM joining_date) as Joining_Year from employee;

----compare two employess joining date---

select least (TO_DATE('13-FEB-1955'),TO_DATE('11-JAN-1956')) from dual;

select sysdate from dual;

-----create view of source branch and dest branch those have higher shipment cost than average----


create or replace view costly_shipment as 
select a.branch_name source_branch,b.branch_name dest_branch from branch a cross join branch b join shipment_details c on a.branch_id=c.source_branch and b.branch_id=c.dest_branch where c.total_cost>(select avg(total_cost) from shipment_details);

select * from costly_shipment;


