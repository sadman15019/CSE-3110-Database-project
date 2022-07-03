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
delivery_time varchar(10),
primary key(source_branch,dest_branch));

create table shipment_details(
Shipment_id number(3) not null,
customer_from number(3),
customer_to number(3),
source_branch number(3),
dest_branch number(3),
itemname varchar(11),
current_location number(3),
status varchar(12),
shipment_date varchar(10),
delivery_date varchar(10),
total_cost number(5),
primary key(shipment_id),
foreign key (customer_from) references customer(customer_id) on delete cascade,
foreign key (customer_to) references customer(customer_id) on delete cascade,
foreign key (source_branch,dest_branch) references billing(source_branch,dest_branch) on delete cascade,
foreign key (current_location) references branch(branch_id) on delete cascade);

create table employee(
employee_id number(5) not null,
fname varchar(6),
lname varchar(6),
phone_number varchar(13),
address varchar(25),
branch_id number(3),
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


insert into branch values(1,'mohammadpur','1/a,townhall,dhaka','Dhaka');
insert into branch values(2,'demra','4/r,demra,dhaka','Dhaka');
insert into branch values(3,'kendua','3/f,paikmara,kendua','Netrkona');
insert into branch values(4,'lohaga','3/e,lohaga,chittagong','Chittagong');
insert into branch values(5,'fullbari','33/e,fullbari,khulna','Khulna');


insert into billing values(1,2,300,'3 days');
insert into billing values(2,1,300,'3 days');
insert into billing values(1,3,500,'4 days');
insert into billing values(3,1,500,'4 days');
insert into billing values(1,4,400,'3 days');
insert into billing values(4,1,400,'3 days');
insert into billing values(1,5,400,'3 days');
insert into billing values(5,1,400,'3 days');
insert into billing values(2,3,200,'2 days');
insert into billing values(3,2,200,'2 days');
insert into billing values(2,4,300,'3 days');
insert into billing values(4,2,300,'3 days');
insert into billing values(2,5,400,'3 days');
insert into billing values(5,2,400,'3 days');
insert into billing values(3,4,400,'3 days');
insert into billing values(4,3,400,'3 days');
insert into billing values(3,5,400,'3 days');
insert into billing values(5,3,400,'3 days');
insert into billing values(4,5,400,'3 days');
insert into billing values(5,4,400,'3 days');


insert into employee values(1,'Md','Alam','01777794567','5/d,demra,dhaka',2);
insert into employee values(2,'Khairu','Vuiya','01777234367','3/f,bagmara,kendua',3);
insert into employee values(3,'Khosru','Miya','01777234657','1/a,asadgate,dhaka',1);
insert into employee values(4,'Hanif','Ahmed','01767234567','3/e,sonaga,chittagong',4);


insert into shipment_details values(1,1,2,5,2,'book',4,'on the way','7-2-2022','8-2-2022',(select total_cost from billing where billing.source_branch=5 and billing.dest_branch=2));
insert into shipment_details values(2,3,4,3,1,'bedsheet',1,'delivered','4-2-2022','8-2-2022',(select total_cost from billing where billing.source_branch=3 and billing.dest_branch=1));
insert into shipment_details values(3,5,6,1,4,'inventory',2,'on the way','7-2-2022','10-2-2022',(select total_cost from billing where billing.source_branch=1 and billing.dest_branch=4));


insert into payment_details values(1,1,(select total_cost from shipment_details where shipment_details.shipment_id=1),200,(select total_cost from shipment_details where shipment_details.shipment_id=1)-200);
insert into payment_details values(2,2,(select total_cost from shipment_details where shipment_details.shipment_id=2),200,(select total_cost from shipment_details where shipment_details.shipment_id=2)-200);
insert into payment_details values(3,3,(select total_cost from shipment_details where shipment_details.shipment_id=3),200,(select total_cost from shipment_details where shipment_details.shipment_id=3)-200);









  