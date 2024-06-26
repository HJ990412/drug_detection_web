select * from tblBoard;
select * from tblMember;
select * from tblFood;
select * from tblDrugSearch;

delete from tblDrugSearch where memID='hong1';

create table tblDrugSearch (
    idx bigint auto_increment primary key,
    memID Char(36),
    filePath varchar(255),
    drugName varchar(255),
    foodIngredient varchar(255)
);

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