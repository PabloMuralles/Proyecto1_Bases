/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     15/10/2020 12:03:46                          */
/*==============================================================*/


--drop database if exists BookFace

drop table if exists "COMMENT";

drop table if exists DEVICE;

drop table if exists FRIENSHIP;

drop table if exists INTERACTION;

drop table if exists POST;

drop table if exists TYPE;

drop table if exists "USER";

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
   ACTIVE		bit			       not null
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
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Amal','Lisandra','Colette','placerat.orci@nonante.co.uk','29/07/1990'),('Kimberley','Chaney','Rashad','metus.Aliquam.erat@semutdolor.org','04/03/1992'),('Gil','Jason','Shannon','quam@eu.net','03/01/1974'),('Denise','Ina','Joelle','felis@interdumCurabiturdictum.ca','08/02/1973'),('Cedric','Ezekiel','Kieran','et@ligulaDonec.com','23/05/1985'),('Amery','Otto','Jared','aliquam.adipiscing.lacus@euismodurna.net','02/01/1975'),('Lillian','Meghan','Erin','In.faucibus.Morbi@mattis.ca','23/07/1989'),('Winifred','Lucius','Phillip','quis.diam.Pellentesque@urnaVivamusmolestie.org','25/06/1999'),('Dante','Ginger','Tiger','ridiculus@sed.edu','13/11/1972'),('Dalton','Delilah','Wanda','facilisi.Sed@scelerisquelorem.org','21/01/1985');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Ivor','Yael','Halla','vel.est.tempor@odioAliquam.co.uk','05/06/1982'),('Elaine','Kenyon','Chaney','dictum@suscipitnonummyFusce.net','25/10/1983'),('Shaine','Price','Phyllis','mattis.semper.dui@Donecfeugiatmetus.net','10/04/1976'),('Indira','Cameron','Uta','iaculis@taciti.com','18/07/1971'),('Cheyenne','Blaine','Wylie','sit@Suspendisse.edu','26/09/1991'),('Mari','Macaulay','Bo','Nunc@vestibulumnequesed.ca','16/07/1974'),('Ivor','Stuart','Allen','Integer.tincidunt.aliquam@ametloremsemper.org','26/09/1981'),('Vernon','Medge','Faith','purus.sapien.gravida@maurisid.edu','02/03/1993'),('Elton','Dalton','Sybil','malesuada@utdolor.net','07/03/1975'),('Fitzgerald','Isabelle','Paul','nonummy@lorem.co.uk','28/11/1983');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Amela','Britanni','MacKenzie','at.velit.Pellentesque@vestibulumloremsit.ca','19/03/1980'),('Brady','Nina','Melinda','dolor.egestas@augueeutellus.edu','03/06/1973'),('Erasmus','Harriet','Sydney','Maecenas.iaculis@nislelementum.net','18/12/1970'),('Kane','Mannix','Bevis','arcu.Vestibulum@facilisismagna.edu','11/04/1999'),('Micah','Christopher','Andrew','sodales@semper.ca','11/11/1998'),('Lila','Jelani','Jada','Pellentesque.habitant.morbi@adipiscing.com','14/09/1974'),('Wyoming','Steven','Grady','ultricies.sem@sapienmolestieorci.org','21/03/2000'),('Ishmael','Malachi','Brett','at.nisi.Cum@Morbi.edu','05/05/2001'),('Eleanor','Wylie','Sylvia','cursus.non.egestas@sociisnatoque.net','02/03/1991'),('Danielle','Jolene','Norman','nisl.Nulla.eu@vitaeerat.edu','15/10/1991');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Lareina','Uriah','Laurel','a.magna@malesuadaut.edu','12/12/2001'),('Rana','Ila','Bevis','congue@justo.net','19/06/1996'),('Cullen','Gage','Hall','Sed.diam.lorem@infaucibusorci.net','05/12/1988'),('Brody','Beau','Basia','enim.Suspendisse@ipsumnunc.org','28/03/1972'),('Basia','Steel','Quinn','auctor.non@faucibusorci.net','13/08/1971'),('Geoffrey','Autumn','Steven','dis.parturient.montes@velarcuCurabitur.org','14/04/1982'),('Alyssa','Basil','Anthony','amet.risus@rutrumlorem.com','24/07/1990'),('Yeo','Ezra','Ori','tortor@malesuada.org','06/03/1976'),('Orli','Oscar','Lila','sem.consequat@vulputatevelit.co.uk','10/08/2001'),('Abra','TaShya','Kasper','dapibus.ligula@maurisMorbi.net','05/11/1972');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Autumn','Cedric','Kirk','Fusce.aliquam.enim@Vivamusnonlorem.ca','22/10/1979'),('Kato','Blaine','Pandora','tempor.diam.dictum@sit.co.uk','26/06/1975'),('Kermit','Britanni','Elvis','diam@Quisqueliberolacus.edu','09/12/2001'),('Aurora','Dominique','Yolanda','a@amalesuadaid.edu','26/10/1974'),('Emmanuel','Noel','Brian','pede@velitinaliquet.edu','11/08/1981'),('Barbara','Alea','Guinevere','dui.semper@nibhenimgravida.com','25/06/2002'),('Tarik','Georgia','Kyra','purus.ac@atnisiCum.co.uk','06/03/1977'),('Luke','William','Nash','dolor.sit@sapien.net','11/09/2001'),('Kay','Ariel','Jana','eget.ipsum@magnis.com','14/12/1980'),('Asher','Dale','Raja','non.leo@risusDonecnibh.co.uk','28/07/1971');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Ryder','Hermione','Ulric','non.egestas@maurisrhoncusid.com','14/04/1976'),('Lucy','Karen','Kennan','risus.Nunc@enim.org','06/05/1975'),('Alden','Austin','Cedric','Aenean.eget@vel.net','24/12/1973'),('Halee','Jameson','Rinah','Praesent.eu@massa.org','03/10/1990'),('Petra','Denton','Amal','feugiat.placerat.velit@lorem.co.uk','31/05/1975'),('Micah','Anastasia','Tarik','nulla.Cras.eu@loremsit.com','23/10/1978'),('Harding','Jordan','Abbot','pellentesque.eget.dictum@egestas.com','19/08/1986'),('Macaulay','Eugenia','Gannon','elementum@eunequepellentesque.ca','17/07/1999'),('Alexander','Gary','Althea','pharetra.Nam@dolorsitamet.com','10/05/1996'),('Declan','Lydia','Fatima','egestas.rhoncus.Proin@vulputate.edu','08/08/1971');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Ulla','Tobias','Bradley','diam.Sed.diam@turpisegestasFusce.com','21/10/1997'),('Carson','Briar','Kamal','dui@magnatellusfaucibus.com','29/05/1998'),('Fitzgerald','Emily','Ori','lorem.ipsum@ornaresagittis.net','09/01/1979'),('Wallace','Connor','Ray','enim.diam@nequesedsem.edu','04/08/1987'),('Dalton','Zorita','Marvin','et@vulputate.com','03/03/1983'),('Sebastian','Emily','Garrison','iaculis.enim.sit@nonlobortis.org','29/02/2000'),('Hollee','Alice','Shay','sagittis.semper@posuere.edu','19/11/1989'),('Maile','Stuart','Alec','Fusce.diam.nunc@liberomaurisaliquam.net','06/04/1987'),('Oren','Sasha','Shafira','velit.in@neque.org','07/06/1997'),('Dieter','Jenna','Zia','in.sodales@Integeridmagna.net','02/11/1981');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Chandler','Len','Brennan','sit@disparturient.com','01/04/1973'),('Ebony','Ariana','Gail','Donec@Proindolor.co.uk','21/04/1992'),('Ashton','Cathleen','Madonna','varius.ultrices@egestasligulaNullam.edu','22/02/1981'),('Baxter','Samson','Maggie','ac.turpis.egestas@massaQuisque.org','19/09/1987'),('Dominique','Oren','Barclay','Phasellus@a.co.uk','21/10/1996'),('Lara','Naomi','Sasha','nunc.In@sit.co.uk','25/11/1983'),('Sylvester','Chastity','Lester','Aliquam.tincidunt@atarcu.ca','06/04/1977'),('Troy','Gareth','Hannah','sit.amet@mattis.org','31/10/2000'),('Noah','Adam','Ivan','dictum@nonquam.ca','24/10/1995'),('Gray','Shafira','Alexa','at.risus.Nunc@idnunc.ca','24/05/2001');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Shay','Megan','Sylvester','varius@eget.org','11/01/1974'),('Dylan','Luke','Chiquita','dis.parturient.montes@CrasinterdumNunc.co.uk','22/11/1988'),('Cameron','Deanna','Martena','Nam@dolor.com','12/07/1989'),('Lydia','Brianna','Felix','ipsum.dolor.sit@egestas.edu','01/06/1997'),('Caleb','Megan','Rinah','cursus.in.hendrerit@acmattissemper.net','22/12/1998'),('Illana','Dacey','Madison','ornare.elit.elit@anteblandit.ca','31/03/1994'),('Kai','Maggy','Chiquita','Sed@Donecdignissimmagna.edu','17/03/2001'),('Jenette','Wilma','Guinevere','Donec.luctus.aliquet@Proinvel.edu','04/08/1975'),('Marny','Brian','Ivory','Phasellus.ornare.Fusce@enimEtiam.net','06/06/1989'),('Reuben','Hope','Noelani','nec@congueturpisIn.com','08/10/1978');
INSERT INTO "USER"([FIRSTNAME],[MIDDLENAME],[LASTNAME],[EMAILADDRESS],[BIRTHDATE]) VALUES('Patrick','Steel','Kylynn','ante@nonfeugiat.org','02/05/2001'),('Simon','Xander','Brett','sagittis.placerat@velitjusto.org','29/08/1984'),('Minerva','Barclay','Trevor','semper@Nunclectuspede.org','01/12/1970'),('Ivor','Orli','Tanner','pede@Namporttitorscelerisque.ca','19/07/1980'),('Abdul','Imelda','Zephania','tellus.non@dis.ca','03/05/1981'),('Craig','Jamal','Aspen','quis.pede@vellectus.edu','14/06/1987'),('Wanda','Ariana','Ezekiel','Aenean.egestas@ligulaconsectetuerrhoncus.ca','24/05/2001'),('Halla','Kylan','Carly','Suspendisse@dui.com','01/08/1978'),('Ralph','Miranda','Paki','Aliquam.adipiscing@malesuadavelvenenatis.ca','18/03/2001'),('Adele','Halla','Justin','Donec@metusvitae.ca','28/06/1984');

--insert into "TYPE" values ('Publicación')
--insert into "TYPE" values ('Noticia')
--insert into "TYPE" values ('Imagen')

--insert into DEVICE values ('Google pixel')
--insert into DEVICE values ('Apple iPhone')
--insert into DEVICE values ('Windows desktop')
--insert into DEVICE values ('Web client')
--insert into DEVICE values ('Unknown')
