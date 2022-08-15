drop table payment_details;
drop table shipment_details;
drop table employee;
drop table billing;
drop table customer;
drop table branch;

create table customer(
customer_id number(5) not null,
fname varchar(7),
lname varchar(7),
address varchar(25),
phone_number varchar(13),
primary key(customer_id));

create table branch(
branch_id number(5) not null,
branch_name varchar(15),
address varchar(25),
district varchar(10),
primary key(branch_id));

create table billing(
source_branch number(3) not null,
dest_branch number(3) not null,
total_cost number(5),
delivery_time_days number(10),
primary key(source_branch,dest_branch));

create table shipment_details(
Shipment_id number(3) not null,
customer_from number(5),
customer_to number(5),
source_branch number(3),
dest_branch number(3),
itemname varchar(11),
current_location number(3),
status varchar(12),
shipment_date date,
delivery_date date,
total_cost number(5),
primary key(shipment_id),
foreign key (customer_from) references customer(customer_id) on delete cascade,
foreign key (customer_to) references customer(customer_id) on delete cascade,
foreign key (source_branch,dest_branch) references billing(source_branch,dest_branch) on delete cascade,
foreign key (current_location) references branch(branch_id) on delete cascade);

create table employee(
employee_id number(5) not null,
fname varchar(10),
lname varchar(10),
phone_number varchar(13),
emp_address varchar(25),
manager_id varchar(5),
branch_id number(5),
joining_date date,
primary key(employee_id),
foreign key(branch_id) references branch(branch_id) on delete cascade);

create table payment_details(
payment_id number(3) not null,
shipment_id number(3),
total_amount number(3),
paid_amount number(3),
due_amount number(3),
primary key(payment_id),
foreign key(shipment_id) references shipment_details(shipment_id) on delete cascade
);

insert into customer values(1,'sadman','sakib','2/a,fullbari,khulna','01777234567');
insert into customer values(2,'adnan','akib','43/c,demra,dhaka','017457234567');
insert into customer values(3,'ishraq','ahmed','4/d,kendua,netrokona','01777234534');
insert into customer values(4,'fatin','ishraq','56/b,dhanmondi,dhaka','01777234567');
insert into customer values(5,'obaidur','rahman','1/a,mohammadpur,dhaka','01777234567');
insert into customer values(6,'rustom','ali','4/b,lohaga,chittagong','01777234567');
insert into customer values(7,'rustom','ali','4/b,lohaga,chittagong',null);
insert into customer values(8,'rustom','ali','4/b,lohaga,chittagong',null);


insert into branch values(1,'mohammadpur','1/a,townhall,dhaka','Dhaka');
insert into branch values(2,'demra','4/r,demra,dhaka','Dhaka');
insert into branch values(3,'kendua','3/f,paikmara,kendua','Netrkona');
insert into branch values(4,'lohaga','3/e,lohaga,chittagong','Chittagong');
insert into branch values(5,'fullbari','33/e,fullbari,khulna','Khulna');
insert into branch values(6,'full','33/e,full,khulna','Khulna');


insert into billing values(1,2,300,3);
insert into billing values(2,1,300,3);
insert into billing values(1,3,500,4);
insert into billing values(3,1,500,4);
insert into billing values(1,4,400,3);
insert into billing values(4,1,400,3);
insert into billing values(1,5,400,3);
insert into billing values(5,1,400,3);
insert into billing values(2,3,200,2);
insert into billing values(3,2,200,2);
insert into billing values(2,4,300,3);
insert into billing values(4,2,300,3);
insert into billing values(2,5,400,3);
insert into billing values(5,2,400,3);
insert into billing values(3,4,400,3);
insert into billing values(4,3,400,3);
insert into billing values(3,5,400,3);
insert into billing values(5,3,400,3);
insert into billing values(4,5,400,3);
insert into billing values(5,4,400,3);
insert into billing values(5,6,null,3);
insert into billing values(6,5,null,3);

insert into employee values(3,'Nafiul','Karim','01777794433','43/c,arambag,dhaka',null,2,'12-JAN-1956');
insert into employee values(1,'Md','Alam','01777794567','5/d,demra,dhaka',3,2,'13-FEB-1955');
insert into employee values(2,'Rupok','Ahsan','01777794588','65/d,polton,dhaka',3,2,'11-JAN-1945');
insert into employee values(4,'Masud','Ahsan','01777234367','33/a,bagmara,kendua',null,3,'13-DEC-1953');
insert into employee values(5,'Shaila','Parvin','01777234367','56/b,shonagati,kendua',4,3,'12-MAR-1955');
insert into employee values(6,'Ashfaq','Mahmud','01777234367','69/c,telimara,kendua',4,3,'2-APR-1955');
insert into employee values(9,'Hasan','Masud','01777234657','3/c,chadhousing,dhaka',null,1,'1-MAY-1955');
insert into employee values(7,'Abrar','Hasan','01777234657','1/a,asadgate,dhaka',9,1,'3-JUN-1955');
insert into employee values(8,'Khosru','Miya','01777234657','2/b,shiamosjid,dhaka',9,1,'12-JUL-1955');
insert into employee values(11,'Mir','Kashim','01767234567','89/b,lohaga,chittagong',null,4,'22-AUG-1955');
insert into employee values(10,'Hanif','Ahmed','01767234567','66/a,sonaga,chittagong',11,4,'13-SEP-1955');
insert into employee values(12,'Mir','Jafr','01767234567','34/c,mirsorai,chittagong',11,4,'12-OCT-1955');


insert into shipment_details values(1,1,2,5,2,'book',4,'on the way','09-JAN-2022','12-JAN-1955',(select total_cost from billing where billing.source_branch=5 and billing.dest_branch=2));
insert into shipment_details values(2,3,4,3,1,'bedsheet',1,'delivered','10-JAN-2022','14-JAN-1955',(select total_cost from billing where billing.source_branch=3 and billing.dest_branch=1));
insert into shipment_details values(3,5,6,1,4,'inventory',2,'on the way','09-JAN-2022','11-JAN-1955',(select total_cost from billing where billing.source_branch=1 and billing.dest_branch=4));
insert into shipment_details values(4,1,2,5,2,'cycle',4,'delivered','09-JAN-2022','12-JAN-1955',(select total_cost from billing where billing.source_branch=5 and billing.dest_branch=2));
insert into shipment_details values(5,3,4,3,1,'luggage',1,'on the way','12-JAN-2022','15-JAN-1955',(select total_cost from billing where billing.source_branch=3 and billing.dest_branch=1));






insert into payment_details values(1,1,(select total_cost from shipment_details where shipment_details.shipment_id=1),300,(select total_cost from shipment_details where shipment_details.shipment_id=1)-200);
insert into payment_details values(2,2,(select total_cost from shipment_details where shipment_details.shipment_id=2),200,(select total_cost from shipment_details where shipment_details.shipment_id=2)-200);
insert into payment_details values(3,3,(select total_cost from shipment_details where shipment_details.shipment_id=3),200,(select total_cost from shipment_details where shipment_details.shipment_id=3)-200);









  