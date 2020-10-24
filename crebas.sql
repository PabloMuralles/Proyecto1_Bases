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
   STATUS				bit							   not null
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
   EMAILADDRES          varchar(50)     UNIQUE         not null,
   BIRTHDATE            date                           not null,
   MAXFRIENDS           int  default 50                not null,
   REGISTRATIONDATE		datetime					   not null,
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

-----------------------------------------------------------------------------------------------------------------------------------------
  --Data for user
  
--insert into "TYPE" values ('Publicación')
--insert into "TYPE" values ('Noticia')
--insert into "TYPE" values ('Imagen')

--insert into DEVICE values ('Google pixel')
--insert into DEVICE values ('Apple iPhone')
--insert into DEVICE values ('Windows desktop')
--insert into DEVICE values ('Web client')
--insert into DEVICE values ('Unknown')
