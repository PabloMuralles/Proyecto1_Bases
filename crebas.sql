/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     15/10/2020 12:03:46                          */
/*==============================================================*/


--drop database if exists BookFace

--drop table if exists "COMMENT";

--drop table if exists DEVICE;

--drop table if exists FRIENSHIP;

--drop table if exists INTERACTION;

--drop table if exists POST;

--drop table if exists TYPE;

--drop table if exists "USER";

--create database BookFace

/*==============================================================*/
/* Table: "COMMENT"                                             */
/*==============================================================*/
create table "COMMENT" 
(
   COMMENTID            int              IDENTITY(1,1) not null,
   USERID               int                            not null,
   POSTID               int                            not null,   
   DEVICEID             int                            not null,
   DEVICEIP             varchar(15)                    not null,
   COMMENTDATETIME      datetime                       not null,
   COMMENTCONTENT       varchar(200)                   not null,
   ACTIVESTATUS		bit			       not null,
   constraint PK_COMMENT primary key clustered (COMMENTID)
);

/*==============================================================*/
/* Table: DEVICE                                                */
/*==============================================================*/
create table DEVICE 
(
   DEVICEID             int              IDENTITY(1,1) not null,
   DEVICENAME           varchar(50)                    not null,
   constraint PK_DEVICE primary key clustered (DEVICEID)
);

/*==============================================================*/
/* Table: FRIENDSHIP                                             */
/*==============================================================*/
create table FRIENDSHIP 
(
   FRIENDSHIPID         int		 IDENTITY(1,1) not null,
   USERID               int                            not null,
   FRIENDID		int			       not null,
   constraint PK_FRIENDSHIP primary key clustered (FRIENDSHIPID)
);

/*==============================================================*/
/* Table: INTERACTION                                           */
/*==============================================================*/
create table INTERACTION 
(
   INTERACTIONID        int		 IDENTITY(1,1) not null,
   USERID               int                            not null,
   POSTID               int                            not null,
   DEVICEID		int			       not null,
   DEVICEIP             varchar(15)                    not null,
   INTERACTIONDATETIME  datetime                       not null,
   ISLIKE               bit                            not null,
   constraint PK_INTERACTION primary key clustered (INTERACTIONID)
);

/*==============================================================*/
/* Table: POST                                                  */
/*==============================================================*/
create table POST 
(
   POSTID               int              IDENTITY(1,1) not null,
   USERID               int                            not null,
   TYPEID               int                            not null,
   DEVICEID             int                            not null,
   DEVICEIP             varchar(15)                    not null,
   POSTDATETIME         datetime                       not null,
   POSTCONTENT          varchar(200)                   not null,
   constraint PK_POST primary key clustered (POSTID)
);

/*==============================================================*/
/* Table: TYPE                                                  */
/*==============================================================*/
create table TYPE 
(
   TYPEID               int              IDENTITY(1,1) not null,
   TYPEPOST             varchar(50)                    not null,
   constraint PK_TYPE primary key clustered (TYPEID)
);

/*==============================================================*/
/* Table: "USER"                                                */
/*==============================================================*/
create table "USER" 
(
   USERID               int              IDENTITY(1,1) not null,
   FIRSTNAME            varchar(50)                    not null,
   MIDDLENAME           varchar(50)                        null,
   LASTNAME             varchar(50)                    not null,
   EMAILADDRESS         varchar(50)     UNIQUE         not null,
   BIRTHDATE            date                           not null,
   MAXFRIENDS           int  default 50                not null,
   REGISTRATIONDATE     datetime		       not null,
   constraint PK_USER primary key clustered (USERID)
);

alter table "COMMENT"
   add constraint FK_COMMENT_REFERENCE_DEVICE foreign key (DEVICEID)
      references DEVICE (DEVICEID)


alter table "COMMENT"
   add constraint FK_COMMENT_REFERENCE_POST foreign key (POSTID)
      references POST (POSTID)
 

alter table "COMMENT"
   add constraint FK_COMMENT_REFERENCE_USER foreign key (USERID)
      references "USER" (USERID)
 
 
alter table FRIENDSHIP
   add constraint FK_FRIENDSHIP_REFERENCE_USER foreign key (USERID)
      references "USER" (USERID)

alter table FRIENDSHIP
   add constraint FK_FRIENDSHIP_REFERENCE_FRIEND foreign key (FRIENDID)
      references "USER" (USERID)  

alter table INTERACTION
   add constraint FK_INTERACT_REFERENCE_POST foreign key (POSTID)
      references POST (POSTID)
  

alter table INTERACTION
   add constraint FK_INTERACT_REFERENCE_USER foreign key (USERID)
      references "USER" (USERID)
 

alter table POST
   add constraint FK_POST_REFERENCE_DEVICE foreign key (DEVICEID)
      references DEVICE (DEVICEID)
   

alter table POST
   add constraint FK_POST_REFERENCE_USER foreign key (USERID)
      references "USER" (USERID)
 

alter table POST
   add constraint FK_POST_REFERENCE_TYPE foreign key (TYPEID)
      references TYPE (TYPEID)

  

-----------------------------------------------------------------------------------------------------------------------------------
--Data for user
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Cassady','Fitzgerald','Fatima','libero.nec.ligula@nibh.ca','1991-05-21 05:41:46'),('Walker','Adria','Brenna','aliquam@nislMaecenasmalesuada.com','1987-08-06 12:21:25'),('Lana','Zeus','Walker','In.condimentum.Donec@miAliquamgravida.org','1976-04-26 06:20:40'),('Sydney','Quentin','Ann','dolor@sit.org','1983-04-01 21:13:36'),('Igor','Kasper','Dominic','dictum.Phasellus.in@necmaurisblandit.edu','1985-06-05 13:05:16'),('William','Roth','Drake','ipsum.Suspendisse.sagittis@Craspellentesque.org','1988-11-04 14:22:46'),('Zenia','Lillian','Kadeem','nisl.sem@libero.net','1973-04-28 10:29:45'),('Rachel','Richard','Iliana','ante.ipsum.primis@pellentesquea.ca','1979-08-06 13:17:56'),('Margaret','Bell','Xyla','sagittis@fermentummetus.org','1985-12-29 13:54:39'),('Teegan','Dorian','Derek','diam.dictum@vulputatemauris.edu','1983-08-25 15:18:00');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Raya','Joy','Halla','Cum@Etiam.com','1981-09-27 06:42:38'),('Clayton','Macaulay','Len','In.nec.orci@ullamcorpervelitin.edu','1979-11-11 01:34:05'),('Lester','Sylvia','Lacy','Cras@tellusSuspendissesed.org','2002-08-30 03:01:51'),('Dane','Mona','Fulton','ac.nulla.In@Donec.ca','1987-08-06 19:59:04'),('Orla','Addison','Amber','interdum@tellus.org','1996-09-01 22:25:06'),('MacKensie','Salvador','Isadora','semper.dui@Nullasempertellus.com','1990-03-10 00:27:21'),('Violet','Maile','Nathan','lectus.rutrum@ipsumleoelementum.org','1999-10-28 18:59:56'),('Sigourney','MacKenzie','Rooney','Nullam.nisl@Utnec.com','1973-10-22 07:57:12'),('Cleo','Amity','Tallulah','dis@ligula.edu','1975-07-20 03:15:43'),('Mercedes','Cailin','Celeste','fermentum.risus@semconsequat.ca','1978-07-07 00:26:10');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Chaim','Alea','Christopher','fringilla.mi.lacinia@nibhvulputatemauris.ca','1984-01-17 21:35:22'),('Dennis','Karly','Omar','tincidunt@CrasinterdumNunc.edu','1981-02-18 06:27:30'),('Hedley','Hall','Owen','arcu.Sed.eu@Maecenaslibero.ca','1991-10-01 23:54:46'),('Bruce','Zeus','Jackson','tortor.Integer@adipiscinglacus.com','1985-02-26 20:51:53'),('Ashton','Paul','Ina','nec@ut.ca','2000-12-07 15:16:01'),('Janna','Kamal','Alexa','risus.Nunc@nascetur.com','1999-08-12 14:01:05'),('Dai','Asher','Chaney','penatibus.et.magnis@ipsum.edu','1979-05-11 17:50:58'),('Tanner','Josiah','Leo','mauris.ipsum@penatibusetmagnis.net','2001-10-10 22:17:44'),('Fuller','Idola','Michael','convallis.ante@dolorQuisquetincidunt.co.uk','2001-06-27 02:38:44'),('Galvin','Logan','Susan','tempus.lorem@estcongue.edu','1994-09-28 09:47:26');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Elaine','Declan','Andrew','magna.Duis.dignissim@sit.net','1973-10-12 11:07:04'),('Vanna','Madeson','Kerry','Donec@nisidictum.com','1971-11-13 09:53:49'),('Cameron','Colby','Troy','nec.tellus.Nunc@utquamvel.org','1975-07-05 11:44:41'),('Eugenia','Wallace','Clementine','In@fermentum.com','1979-11-06 10:33:23'),('Hoyt','Kevyn','Charity','lectus.rutrum@placerataugue.net','1982-06-04 13:34:13'),('Penelope','Florence','Nina','cursus.non@felisullamcorperviverra.net','1976-05-13 23:34:20'),('Liberty','Avram','Virginia','viverra.Maecenas.iaculis@eleifend.net','1977-03-16 15:25:48'),('Indira','Callum','Cooper','congue.elit.sed@Duis.com','1996-03-19 18:48:59'),('Yoko','Irma','Nolan','faucibus.orci@Aeneaneget.edu','1990-01-05 01:06:43'),('Roanna','Lucy','Chava','libero.mauris.aliquam@Suspendisse.ca','1979-08-24 02:51:31');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Victor','Ella','Gray','arcu.Sed.et@auctorquis.org','1978-06-25 04:31:50'),('Maggie','Briar','Kuame','semper.Nam@eget.net','1972-12-30 20:53:08'),('Alana','Dean','Vincent','ligula.Nullam.feugiat@metusurnaconvallis.com','1988-11-15 08:21:37'),('Madison','Griffith','Ariel','turpis@pellentesqueSed.edu','1980-05-06 22:56:41'),('Ori','Abraham','Palmer','vulputate.eu.odio@miAliquam.com','1981-09-06 05:23:13'),('Aubrey','Vladimir','Jessica','ultrices@Inornare.co.uk','1998-11-06 00:11:10'),('Amity','Kato','Brian','dolor.egestas.rhoncus@parturient.ca','1986-06-17 20:51:30'),('Jin','Ivor','Rhonda','Maecenas@dui.com','2002-04-05 03:03:21'),('Cassady','Rebekah','Imani','velit@Proinvelarcu.ca','1979-09-10 02:22:55'),('Leilani','Ivory','Orli','Proin.eget.odio@duiCumsociis.edu','1984-10-22 10:23:12');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Kylee','Virginia','Shoshana','velit@eu.edu','1977-09-06 00:33:54'),('Thomas','Plato','Holmes','elementum.at.egestas@conubianostra.edu','1976-03-19 15:18:42'),('Keane','Len','Ashely','leo@ridiculusmus.com','1972-06-06 12:54:27'),('Paki','Elijah','Mechelle','tincidunt.adipiscing@nuncsed.co.uk','1986-06-21 00:50:59'),('Elliott','Harding','Lysandra','Nullam.enim@mauris.ca','1989-04-03 20:03:28'),('Kerry','Petra','Callum','elit.Curabitur.sed@eueratsemper.net','1993-05-31 10:42:32'),('Dana','Nerea','Rhoda','lorem.Donec.elementum@anequeNullam.ca','1970-12-04 17:35:56'),('Evelyn','Rajah','Steven','venenatis.lacus@metusAeneansed.edu','1997-10-21 06:41:55'),('Lana','Valentine','Maxine','lorem@vestibulum.net','1998-11-04 20:25:45'),('Isabella','Amos','Alan','massa.Quisque.porttitor@luctusetultrices.ca','1979-04-02 04:31:37');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Brynne','Dean','Guy','arcu.eu@Namacnulla.ca','1999-10-16 17:17:10'),('Dai','Kitra','Bernard','neque.sed.dictum@habitantmorbi.edu','1978-06-06 20:06:54'),('Lana','Igor','Maxwell','velit.eu@necmetusfacilisis.net','1977-03-09 07:33:15'),('Karleigh','Destiny','Cassandra','velit.Pellentesque@ullamcorpereueuismod.co.uk','1980-02-01 01:55:11'),('Honorato','Theodore','Jameson','libero.Proin@quispede.net','1992-11-06 06:33:41'),('Jin','Cara','Joy','et.magna.Praesent@Integer.ca','1997-11-14 16:36:58'),('Chandler','Alma','Sheila','Integer.aliquam@Cras.com','1999-02-15 07:32:30'),('Colt','Alyssa','Clinton','eleifend.vitae.erat@Aeneaneuismodmauris.com','1971-07-31 02:54:32'),('Armand','Herman','Eric','blandit.enim@est.co.uk','1975-08-30 06:33:00'),('Darryl','Ignatius','Isadora','sapien@mauriserateget.edu','2001-06-08 16:45:32');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Riley','Azalia','Gwendolyn','enim@semmagnanec.co.uk','1976-08-07 05:04:28'),('Kaseem','Neve','Prescott','Mauris.quis@tinciduntneque.org','2002-05-12 12:31:49'),('Zachary','Athena','Scott','Morbi.vehicula.Pellentesque@sedpedenec.com','1975-07-11 11:41:02'),('Boris','Amos','Sloane','a.mi.fringilla@aliquamarcu.com','1985-05-24 06:01:10'),('Beck','Amery','Hermione','Morbi.metus.Vivamus@at.net','1997-05-13 02:52:19'),('Carlos','Igor','Cameron','Integer@dictum.com','1975-01-19 08:18:57'),('Lavinia','Orla','Tamekah','ornare@tinciduntcongueturpis.net','1997-10-06 05:04:14'),('Marcia','Emmanuel','Aquila','convallis.dolor@Namnullamagna.edu','1976-12-15 16:49:34'),('Chloe','Naomi','Kevin','elit.pharetra@risus.edu','1994-03-05 16:03:50'),('Maxwell','Kamal','Iliana','magna.Praesent@lobortisultricesVivamus.ca','1979-08-04 13:33:00');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Leo','Martena','Kylie','gravida.sit.amet@Sedeu.edu','1999-07-05 06:44:44'),('Yuri','Shelley','Carson','nibh.vulputate.mauris@nisisem.ca','1979-04-20 05:49:33'),('Keegan','Lionel','Tamara','augue@vestibulumMauris.ca','1996-10-13 16:01:35'),('Inez','Sade','Oren','aliquam.eu@metusIn.org','2001-05-11 10:18:55'),('Laurel','Tyrone','Nasim','Integer.aliquam@risusInmi.edu','2002-06-02 01:19:33'),('Silas','Timon','Jonah','Vivamus.nibh.dolor@antebibendum.ca','2002-07-14 16:58:14'),('Beau','Tiger','Maite','ipsum.ac@tincidunt.org','1977-06-22 17:07:53'),('Yoshio','Brian','Dacey','ante.dictum.cursus@diameu.ca','1983-12-28 23:51:07'),('Fletcher','Frances','Ignatius','orci@pharetra.org','1988-09-21 15:13:42'),('Axel','Igor','Cheryl','ultrices.mauris@gravidaPraesenteu.net','1978-11-22 04:53:04');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Quyn','Dorian','Imelda','Cum.sociis.natoque@Phasellusdolorelit.edu','1978-07-14 06:19:44'),('Octavia','Alden','Ronan','sociis@luctus.co.uk','1971-01-01 13:02:31'),('Ishmael','Guinevere','Sacha','sem@adipiscingligula.ca','1998-10-27 11:39:14'),('Logan','Brenda','Kellie','sagittis.semper.Nam@sem.com','1992-12-03 02:36:20'),('Ori','Cameran','Zelenia','egestas@laciniaat.edu','2000-05-05 05:04:19'),('Anastasia','Britanney','Bryar','amet.nulla.Donec@ipsumportaelit.co.uk','1973-12-16 22:37:26'),('David','Ruth','Idola','feugiat.tellus.lorem@tellusNunc.com','1988-03-02 04:06:49'),('Eden','Tara','Carly','accumsan@erat.ca','1972-08-05 08:55:51'),('Jaden','Gray','Tarik','orci.Donec@ridiculusmus.net','1996-11-12 04:50:03'),('Uriel','Ignacia','Keane','sem@commodoipsumSuspendisse.net','1983-01-03 04:08:50');

--insert into "TYPE" values ('Publicación')
--insert into "TYPE" values ('Noticia')
--insert into "TYPE" values ('Imagen')

--insert into DEVICE values ('Google pixel')
--insert into DEVICE values ('Apple iPhone')
--insert into DEVICE values ('Windows desktop')
--insert into DEVICE values ('Web client')
--insert into DEVICE values ('Unknown')
