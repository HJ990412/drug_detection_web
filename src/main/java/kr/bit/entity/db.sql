
create table tblMember(
                          memIdx int not null,
                          memID varchar(50) not null,
                          memPwd varchar(68) not null,
                          memName varchar(50) not null,
                          primary key(memID)
);

create table mem_auth(
                         no int not null auto_increment,
                         memID varchar(50) not null,
                         auth varchar(50) not null,
                         primary key(no),
                         constraint fk_member_auth foreign key(memID) references tblMember(memID)
);

select * from tblBoard;
select * from mem_auth;
select * from tblMember;
select * from tblFood;
select * from tblDrugSearch;

delete from tblDrugSearch where memID='roh3';

CREATE TABLE DrugList (
    id INT AUTO_INCREMENT PRIMARY KEY,
    drugName VARCHAR(255) NOT NULL,
    foodIngredient VARCHAR(255) NOT NULL
);

insert into DrugList (drugName, foodIngredient)
values ('AdvilPM', 'calcium, magnesium, vitaminK, iron');

insert into DrugList (drugName, foodIngredient)
values ('ferrousGluconate', 'glutamic, lLysine, potassium, hexadecanoic1, hexadecanoic2, lactose, phosphorus, lThreonine');

select * from DrugList;
drop table DrugList;


CREATE TABLE images (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id VARCHAR(255),
                        message VARCHAR(255),
                        image LONGTEXT
);

select * from images;


delete from tblMember where memID='hong4';

drop table tblDrugSearch;
drop table images;
drop table tblMember;
drop table mem_auth;