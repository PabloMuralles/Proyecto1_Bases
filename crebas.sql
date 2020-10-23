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
   POSTID               int                            not null,
   USERID               int                            not null,
   DEVICEID             int                            not null,
   DEVICEIP             varchar(15)                    not null,
   COMMENTDATETIME      datetime                       not null,
   COMMENTCONTENT       varchar(200)                   not null,
   ACTIVE				bit							   not null
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
   DIVICEID				int							   not null,
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
   EMAILADDRES          varchar(50)      UNIQUE        not null,
   BIRTHDATE            date                           not null,
   MAXFRIENDS           int  		 default 50    not null,
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

  

----------------------------------------------------------------------
  --Data for user

  
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Erin','Pace','mauris@nisia.net','12/31/1969',50),('Blossom','Norman','arcu.Vivamus.sit@volutpatnuncsit.org','12/31/1969',50),('Kenneth','Lang','Aenean@consequatdolorvitae.co.uk','12/31/1969',50),('Chaim','Key','ultricies.sem@montesnascetur.co.uk','12/31/1969',50),('Hyacinth','Higgins','convallis.in@ac.co.uk','12/31/1969',50),('Lionel','Chen','porttitor.vulputate@dictum.ca','12/31/1969',50),('Gannon','Cortez','neque@facilisiSedneque.com','12/31/1969',50),('Tatyana','Berry','ipsum.sodales.purus@Sednunc.com','12/31/1969',50),('Kieran','Johnson','scelerisque.neque.sed@iderat.edu','12/31/1969',50),('Ulric','Branch','viverra@disparturient.ca','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Hedy','Rowe','eu.tellus@elitpellentesquea.org','12/31/1969',50),('Tobias','Sheppard','commodo.hendrerit@eratSed.co.uk','12/31/1969',50),('Caleb','Best','sed@varius.co.uk','12/31/1969',50),('Cheyenne','Meadows','erat@velitCraslorem.ca','12/31/1969',50),('Moses','Logan','ante.dictum.cursus@vel.edu','12/31/1969',50),('Zena','Koch','ipsum@eratvitae.edu','12/31/1969',50),('Hunter','Nunez','ac.urna@Sed.co.uk','12/31/1969',50),('Eve','Oneal','et.lacinia@semperpretium.edu','12/31/1969',50),('Philip','Dotson','porttitor@vitaeerat.net','12/31/1969',50),('Grady','Mendoza','interdum.enim.non@acurnaUt.ca','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Sierra','Goodman','felis.ullamcorper.viverra@quis.co.uk','12/31/1969',50),('Cameron','Goodwin','Pellentesque@turpis.ca','12/31/1969',50),('Jocelyn','Gilliam','diam@euligulaAenean.net','12/31/1969',50),('Connor','Byers','tincidunt@orciquis.co.uk','12/31/1969',50),('Gisela','Sanford','consectetuer.euismod@libero.net','12/31/1969',50),('Martha','Ramirez','tincidunt.dui.augue@afacilisisnon.ca','12/31/1969',50),('Brandon','Williamson','sit.amet@antelectus.ca','12/31/1969',50),('Victor','Mack','metus.Aliquam.erat@orci.co.uk','12/31/1969',50),('Kato','Brady','mi@Cum.ca','12/31/1969',50),('Madeson','Wolf','sem.egestas@Donec.co.uk','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Declan','Grimes','Sed@imperdietornare.edu','12/31/1969',50),('Jared','Morgan','aliquam@tincidunt.ca','12/31/1969',50),('Glenna','Jackson','Integer.id@utipsumac.edu','12/31/1969',50),('Joan','Sampson','egestas.Aliquam.nec@ascelerisquesed.net','12/31/1969',50),('Thane','Moody','auctor.quis.tristique@a.ca','12/31/1969',50),('Raymond','Conley','sed.sapien.Nunc@egettincidunt.org','12/31/1969',50),('Jessamine','Martin','augue.eu.tempor@nisiCum.ca','12/31/1969',50),('Eric','Cobb','Sed@cursuset.ca','12/31/1969',50),('Keegan','Camacho','tincidunt.Donec.vitae@lectuspede.edu','12/31/1969',50),('Ann','Guerra','orci.adipiscing.non@tristique.edu','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Raven','Boyer','turpis@Namligula.org','12/31/1969',50),('Marah','Roberson','pellentesque@ipsumdolor.com','12/31/1969',50),('Merritt','Norman','sociis.natoque.penatibus@purusgravidasagittis.org','12/31/1969',50),('Renee','Terry','vestibulum@quamvel.ca','12/31/1969',50),('Chava','Durham','tellus.sem@rutrum.com','12/31/1969',50),('Camille','Mccarthy','vel@maurissapien.com','12/31/1969',50),('Xena','Turner','ultricies.ligula.Nullam@sedlibero.net','12/31/1969',50),('Lareina','Oneal','nec.luctus@nuncsed.com','12/31/1969',50),('Lester','Holland','Proin.mi.Aliquam@inaliquet.edu','12/31/1969',50),('Audrey','Golden','Praesent@Aliquam.net','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('George','Cardenas','convallis@Maurisquis.ca','12/31/1969',50),('Hamish','White','ornare@fermentumvelmauris.edu','12/31/1969',50),('Vladimir','Justice','Aenean@nunc.net','12/31/1969',50),('Wing','Gilbert','mus.Donec.dignissim@pede.ca','12/31/1969',50),('Amaya','Hardin','ante.iaculis.nec@dolor.edu','12/31/1969',50),('Nell','Miles','ante.Nunc.mauris@id.net','12/31/1969',50),('Alan','Manning','non.egestas.a@Curabitur.ca','12/31/1969',50),('Georgia','Phillips','ante.Vivamus.non@egestas.com','12/31/1969',50),('Lewis','Villarreal','mi@vulputatedui.edu','12/31/1969',50),('Aladdin','Waters','vestibulum@rutrum.ca','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Vernon','Hickman','facilisis.eget@velitCraslorem.ca','12/31/1969',50),('MacKensie','Wright','lectus.a@dapibus.co.uk','12/31/1969',50),('Justina','Jackson','natoque.penatibus.et@tinciduntcongueturpis.edu','12/31/1969',50),('Bradley','Rojas','ligula@volutpatornare.co.uk','12/31/1969',50),('Taylor','Wyatt','non.hendrerit@Nullam.com','12/31/1969',50),('Lane','Fowler','sagittis.augue.eu@magnaPhasellusdolor.com','12/31/1969',50),('Miranda','Marsh','fringilla.ornare.placerat@purus.org','12/31/1969',50),('Porter','Cervantes','commodo@auctornuncnulla.edu','12/31/1969',50),('Castor','Brennan','varius.ultrices.mauris@felisDonec.net','12/31/1969',50),('Keiko','Oneal','dictum.magna.Ut@fermentum.co.uk','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Michelle','May','Curabitur.ut.odio@ornarelectusjusto.org','12/31/1969',50),('Wynne','Peters','ligula.Donec@orciadipiscing.com','12/31/1969',50),('Macaulay','Becker','dolor@AeneanmassaInteger.com','12/31/1969',50),('Ramona','Mills','Vestibulum.ante.ipsum@facilisisegetipsum.net','12/31/1969',50),('Upton','Vaughan','mauris.id.sapien@magnisdisparturient.org','12/31/1969',50),('Mohammad','Glass','sed@estcongue.com','12/31/1969',50),('Nelle','Matthews','imperdiet.erat@odioNam.org','12/31/1969',50),('Zephania','Hull','amet.dapibus.id@augueeu.edu','12/31/1969',50),('Neil','Hatfield','egestas.urna@duinecurna.edu','12/31/1969',50),('Ella','Vaughn','consequat.nec.mollis@acmattissemper.com','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Philip','Wallace','Cras.interdum@euismodurnaNullam.net','12/31/1969',50),('Jaquelyn','Levine','lectus.justo.eu@Donecporttitortellus.org','12/31/1969',50),('Jared','Gallagher','Nullam.scelerisque@Nuncullamcorpervelit.com','12/31/1969',50),('Demetria','Wiley','et@necluctus.co.uk','12/31/1969',50),('Salvador','Fry','tristique@tristique.com','12/31/1969',50),('Beatrice','Bailey','orci@tempor.org','12/31/1969',50),('Leah','Oneil','ac.orci.Ut@fringilla.net','12/31/1969',50),('Alec','Jacobs','eleifend.egestas@torquentper.com','12/31/1969',50),('Maryam','Fernandez','massa.Integer@Nunclaoreet.org','12/31/1969',50),('Kevyn','Jacobs','urna@temporarcuVestibulum.edu','12/31/1969',50);
--INSERT INTO "USER" ([FIRSTNAME],[LASTNAME],[EMAILADDRES],[BIRTHDATE],[MAXFRIENDS]) VALUES('Zephania','Nolan','Mauris.ut@massarutrummagna.ca','12/31/1969',50),('Noel','Frederick','nisl.Nulla.eu@massarutrum.org','12/31/1969',50),('Aurelia','Mills','semper.pretium.neque@Suspendisse.edu','12/31/1969',50),('Alden','Slater','morbi.tristique.senectus@dignissim.co.uk','12/31/1969',50),('Shaeleigh','Mayer','auctor.odio@lobortisrisusIn.co.uk','12/31/1969',50),('Axel','Alvarado','tempus.lorem@molestie.co.uk','12/31/1969',50),('Dawn','Kinney','sollicitudin.commodo.ipsum@Sed.ca','12/31/1969',50),('Odessa','Keller','nibh@Duisa.ca','12/31/1969',50),('Howard','Morton','ante@magna.org','12/31/1969',50),('Kelly','Rodriguez','Phasellus.dapibus.quam@sagittis.com','12/31/1969',50);

--insert into "TYPE" values ('Publicación')
--insert into "TYPE" values ('Noticia')
--insert into "TYPE" values ('Imagen')

--insert into DEVICE values ('Google pixel')
--insert into DEVICE values ('Apple iPhone')
--insert into DEVICE values ('Windows desktop')
--insert into DEVICE values ('Web client')
--insert into DEVICE values ('Unknown')
