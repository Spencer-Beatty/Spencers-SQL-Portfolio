--sql tables for relational translation
DROP TABLE Mother;
DROP TABLE Father;
DROP TABLE Couple;
DROP TABLE Healthclinic;
DROP TABLE BirthingCenter;
DROP TABLE CommunityClinic;
DROP TABLE Midwife;
DROP TABLE Labtech;
DROP TABLE Pregnancy;
DROP TABLE Baby;
DROP TABLE Tests;
DROP TABLE Infosession;
Drop TABLE Appointment;
DROP TABLE Notes;
DROP TABLE Inforegistration;


CREATE TABLE Mother
(
    qid        INTEGER     NOT NULL,
    mname      VARCHAR(40) NOT NULL,
    phone      VARCHAR(60)     NOT NULL,
    dob        DATE        NOT NULL,
    addr       VARCHAR(50) NOT NULL,
    profession VARCHAR(30) NOT NULL,
    email      VARCHAR(75) NOT NULL,
    bloodtype  VARCHAR(15),
    PRIMARY KEY(qid)
);

CREATE TABLE Father
(
    fid        INTEGER     NOT NULL,
    qid        INTEGER     ,
    fname      VARCHAR(40) NOT NULL,
    phone      VARCHAR(60)     NOT NULL,
    dob        DATE        NOT NULL,
    addr       VARCHAR(50),
    profession VARCHAR(30) NOT NULL,
    email      VARCHAR(75),
    bloodtype  VARCHAR(15),
    PRIMARY KEY (fid)
);

CREATE TABLE Couple
(
    cid     INTEGER     NOT NULL,
    qid     INTEGER     NOT NULL,
    fid     INTEGER,
    PRIMARY KEY (cid),
    FOREIGN KEY (qid) REFERENCES Mother (qid),
    FOREIGN KEY (fid) REFERENCES Father (fid)
);

CREATE TABLE Healthclinic
(
    hid     INTEGER     NOT NULL,
    address VARCHAR(50) NOT NULL,
    hname    VARCHAR(40) NOT NULL,
    phone      VARCHAR(60)     NOT NULL,
    email   VARCHAR(75) NOT NULL,
    website VARCHAR(100),
    PRIMARY KEY (hid)
)
;

CREATE TABLE BirthingCenter
(
    hid     INTEGER     NOT NULL,
    PRIMARY KEY (hid),
    FOREIGN KEY (hid) REFERENCES HealthClinic(hid)
);

CREATE TABLE CommunityClinic
(
    hid INTEGER NOT NULL,
        PRIMARY KEY (hid),
        FOREIGN KEY (hid) REFERENCES HealthClinic(hid)
);

CREATE TABLE Midwife
(
    practid     INTEGER     NOT NULL,
    mname    VARCHAR(40) NOT NULL,
    phone      VARCHAR(60) NOT NULL,
    email   VARCHAR(75) NOT NULL,
    hid     INTEGER     NOT NULL,
    PRIMARY KEY(practid),
    FOREIGN KEY(hid) REFERENCES HealthClinic(hid)
);

CREATE TABLE Labtech
(
    techid      INTEGER     NOT NULL,
    phone      VARCHAR(60) NOT NULL,
    name    VARCHAR(40) NOT NULL,
    PRIMARY KEY (techid)
);

CREATE TABLE Pregnancy
(
    pregnum     INTEGER     NOT NULL,
    cid         INTEGER     NOT NULL,
    initialexp  DATE        NOT NULL,
    lmpdued     DATE        NOT NULL,
    ultexp      DATE        ,
    finalest    DATE        ,
    interested  VARCHAR(3)  NOT NULL,
    homebirth   VARCHAR(3)  ,
    ppractid    INTEGER     NOT NULL,
    bpractid    INTEGER     ,
    hid         INTEGER     ,
    PRIMARY KEY (pregnum,cid),
    FOREIGN KEY (ppractid) REFERENCES MidWife(practid),
    FOREIGN KEY (bpractid) REFERENCES MidWife(practid),
    CONSTRAINT diffmidwife CHECK (ppractid<>bpractid),
    FOREIGN KEY (cid) REFERENCES Couple(cid),
    FOREIGN KEY (hid) REFERENCES BirthingCenter(hid)
);

--Baby(bid, gender, dob, btime, bloodtype, bname, pregnum, cid) (pregnum, cid) ref Pregnancy
CREATE TABLE Baby
(
    bid     INTEGER     NOT NULL,
    gender  VARCHAR(10),
    dob     DATE,
    btime   VARCHAR(20),
    bloodtype   VARCHAR(20),
    bname   VARCHAR(30),
    pregnum INTEGER,
    cid     INTEGER     NOT NULL,
    PRIMARY KEY(bid),
    FOREIGN KEY(pregnum, cid) REFERENCES Pregnancy
);

CREATE TABlE Tests
(
    tid     INTEGER     NOT NULL,
    testtype    VARCHAR(100)    NOT NULL,
    prescdate   DATE        NOT NULL,
    sampdate    DATE,
    labdate     DATE    ,
    labresult VARCHAR(100),
    practid     INTEGER     NOT NULL,
    pregnum     INTEGER     ,
    cid         INTEGER     ,
    bid         INTEGER     ,
    techid      INTEGER     NOT NULL,
    PRIMARY KEY (tid),
    FOREIGN KEY (bid) REFERENCES Baby(bid),
    CONSTRAINT parenttest CHECK (bid IS NULL AND cid IS NOT NULL AND pregnum IS NOT NULL
    OR bid IS NOT NULL AND cid IS NULL AND pregnum IS NULL),
    --7
    CONSTRAINT lineartime CHECK (labdate > prescdate),
    FOREIGN KEY (pregnum, cid) REFERENCES Pregnancy(pregnum, cid),
    FOREIGN KEY (techid) REFERENCES Labtech(techid)

);

CREATE TABLE Infosession
(
    iid     INTEGER     NOT NULL,
    idate    DATE       NOT NULL,
    itime    VARCHAR(20)       NOT NULL,
    language  VARCHAR(40)   NOT NULL,
    practid   INTEGER       NOT NULL,
    PRIMARY KEY (iid),
    FOREIGN KEY (practid) REFERENCES Midwife(practid)
);

CREATE TABLE Appointment
(
    aid     INTEGER NOT NULL,
    adate   DATE    NOT NULL,
    atime   VARCHAR(20)   NOT NULL,
    pregnum INTEGER NOT NULL,
        cid INTEGER NOT NULL,
    practid INTEGER NOT NULL,
    PRIMARY KEY (aid),
    FOREIGN KEY (pregnum, cid) REFERENCES Pregnancy (pregnum, cid),
    FOREIGN KEY (practid) REFERENCES Midwife (practid)
);

CREATE TABLE Notes
(
    ntime VARCHAR(20) NOT NULL,
    aid INTEGER NOT NULL,
    note VARCHAR(100) NOT NULL,
    PRIMARY KEY (ntime,aid),
    FOREIGN KEY (aid) REFERENCES Appointment(aid)

);

CREATE TABLE Inforegistration
(
    iid INTEGER NOT NULL,
    cid INTEGER NOT NULL,
    attended VARCHAR(10) NOT NULL
);

---INSERT STATEMENTS START HERE---
INSERT INTO Mother(qid,mname,phone,dob,addr,profession,email,bloodtype)
VALUES
    (1,'Reagan','1-514-415-7554',DATE'1978-09-14','381-7185 A, Rd.','Asset Management','sem@yahoo.ca','AB'),
    (2,'Cherokee','1-246-531-4564',DATE'1989-12-28','915-8547 Sed Road','Quality Assurance','maecenas.iaculis.aliquet@outlook.org','AB'),
    (3,'Kathleen','1-327-596-0204',DATE'2001-01-03','Ap #558-9686 Euismod Avenue','Asset Management','accumsan.sed@yahoo.com','B'),
    (4,'Angela','1-559-565-8322',DATE'1971-04-29','P.O. Box 538, 1969 Malesuada Ave','Research and Development','et.ultrices.posuere@icloud.ca','O'),
    (5,'Savannah','1-225-217-1135',DATE'1994-06-06','925-8640 Posuere, Avenue','Media Relations','suspendisse.ac@hotmail.org','O'),
    (6,'Victoria Gutierrez','1-524-457-3672',DATE'1994-07-18','9851 Ante Rd.','Human Resources','est.congue@icloud.com','B'),
    (7,'Hannah','1-749-854-4177',DATE'1983-03-28','6382 Diam St.','Finances','nam.consequat@outlook.org','A'),
    (8,'Katelyn','1-717-211-4167',DATE'1990-03-27','801-6727 Nullam St.','Research and Development','leo.cras.vehicula@icloud.com','AB'),
    (9,'Yael','1-548-166-6461',DATE'1984-01-12','1026 Consectetuer Rd.','Human Resources','eu.eros@hotmail.org',NULL),
    (10,'Yen','1-858-760-7612',DATE'1997-04-16','Ap #535-9797 Aenean Ave','Media Relations','orci.luctus.et@icloud.ca',NULL);

INSERT INTO Father(fid,qid,fname,phone,dob,addr,profession,email,bloodtype)
VALUES
    (11,11,'Kennedy','1-264-953-6375',DATE'2002-09-06','Ap #479-6352 Interdum Rd.','Asset Management','parturient.montes@google.ca','O'),
    (12,12,'Magee','1-752-937-2621',DATE'1988-09-18','Ap #791-1760 Porttitor Street','Public Relations','dui.nec@hotmail.ca','A'),
    (13,13,'Jermaine','1-457-301-9768',DATE'1973-03-31','778-6646 Tellus. Street','Research and Development','mollis@icloud.org','B'),
    (14,14,'Perry','1-214-672-6276',DATE'1978-09-02','965-6191 Nec Rd.','Finances','at.velit.cras@outlook.org','AB'),
    (15,15,'Scott','1-535-287-4231',DATE'1998-09-02',NULL,'Media Relations','pede.praesent.eu@yahoo.org','B'),
    (16,16,'Peter','1-955-457-4186',DATE'1988-09-21','794-1829 Suspendisse Av.','Public Relations','erat.neque@hotmail.ca',NULL),
    (17,NULL,'Octavius','1-896-366-4043',DATE'1996-01-22',NULL,'Legal Department',NULL,NULL),
    (18,18,'Aladdin','1-294-528-3573',DATE'2000-11-24','9436 Diam. Av.','Finances','pellentesque.massa@google.com','A'),
    (19,19,'Donovan','1-882-866-2088',DATE'1998-06-27','Ap #813-303 Semper Rd.','Customer Service','phasellus.libero@hotmail.com','AB'),
    (20,20,'Barry','1-863-407-8490',DATE'1988-01-14','296-5418 Nunc Avenue','Accounting','duis.gravida@outlook.org','A');

INSERT INTO Couple(cid,qid,fid)
VALUES
    (1,5,20),
    (2,2,14),
    (3,6,18),
    (4,3,null),
    (5,1,19),
    (6,3,19),
    (7,7,15),
    (8,7,13),
    (9,8,12),
    (10,1,18);


INSERT INTO Healthclinic (hid,address,hname,phone,email,website)
VALUES
    (1,'P.O. Box 656, 1067 Quam Rd.','Lac-Saint-Louis','1-653-717-3159','fringilla.ornare.placerat@icloud.org','bowls9820@a.com'),
    (2,'Ap #977-1071 Diam. Rd.','Randys','1-923-379-1424','risus.donec@yahoo.com','soup@a.com'),
    (3,'Ap #666-4379 Fringilla, Road','St-Josephs','1-222-470-6187','etiam.vestibulum.massa@protonmail.net','barns@a.com'),
    (4,'5583 Dolor Street','Lac-Saint-Louis','1-532-757-6438','nostra@google.edu','prego6958@a.com'),
    (5,'Ap #531-1865 Donec Av.','St-Josephs','1-885-610-6250','vestibulum.ante@aol.edu','gloria5768@a.com'),
    (6,'Ap #996-549 Semper Rd.','St-Josephs','1-436-627-5285','torquent.per.conubia@protonmail.net','bowls@a.com'),
    (7,'Ap #354-5294 Nec Rd.','St-Josephs','1-201-216-0486','augue.malesuada@yahoo.couk','eggo4444@a.com'),
    (8,'1931 Eget, Rd.','Lac-Saint-Louis','1-281-338-3269','pede.ac@protonmail.edu',NULL),
    (9,'666-8432 A St.','Randys','1-206-528-1496','dolor.quisque@google.ca',NULL),
    (10,'3779 A, Ave','Lac-Saint-Louis','1-610-575-0757','eget.dictum@outlook.org',NULL);

INSERT INTO BirthingCenter (hid)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7)
       ;

INSERT INTO CommunityClinic (hid)
VALUES
    (8),
    (9),
    (10)
    ;

INSERT INTO Midwife (practid, mname, phone, email, hid)
VALUES
        (1,'Marion Girard','1-472-264-4284','nec.luctus.felis@hotmail.ca',8),
    (2,'Wynne Marks','1-658-465-4904','torquent.per.conubia@google.org',3),
    (3,'Melodie Fulton','1-514-558-2352','nunc.ac@protonmail.net',4),
    (4,'TaShya Hardin','1-724-322-4818','in.aliquet@outlook.ca',6),
    (5,'Veda Mcclain','1-550-207-1363','arcu.vivamus@aol.ca',6),
    (6,'Ulla Dean','1-533-408-8297','vitae.erat.vivamus@outlook.net',3),
    (7,'Frances Flores','1-872-168-1386','arcu@google.ca',6),
    (8,'Danielle Benjamin','1-415-806-7697','lacus.varius@google.com',5),
    (9,'Jamalia Richardson','1-793-712-6879','amet.ornare@google.ca',6),
    (10,'Nevada Soto','1-525-197-6625','dui.cras@protonmail.ca',3);

INSERT INTO Labtech(techid, phone, name)
VALUES
    (1,'Dylan Johnson','1-883-374-8904'),
    (2,'Aaron Cannon','1-385-532-3793'),
    (3,'Carlos Benson','1-379-563-4673'),
    (4,'Daquan William','1-895-118-3355'),
    (5,'Clayton Cantrell','1-463-812-3185'),
    (6,'Cedric Jefferson','1-567-256-7502'),
    (7,'Merrill Aguilar','1-362-245-1367'),
    (8,'Dexter Stewart','1-868-337-3351'),
    (9,'Norman Waller','1-246-523-9211'),
    (10,'Garrison Marshall','1-792-222-4518');

INSERT INTO Pregnancy(pregnum, cid, initialexp, lmpdued, ultexp, finalest, interested, homebirth, ppractid, bpractid, hid)
VALUES
    (1,1,DATE'2021-07-01',DATE'2021-5-27',DATE'2021-5-25',NULL,'Yes','No',1,6,1),
    (2,3,DATE'2021-12-01',DATE'2021-12-06',DATE'2021-12-10',NULL,'Yes','Yes',1,4,1),
    (3,4,DATE'2022-07-01',DATE'2022-07-12',DATE'2022-7-14',DATE'2022-07-14','No','Yes',2,6,2),
    (4,1,DATE'2022-07-02',DATE'2022-07-13',DATE'2022-07-15',DATE'2022-07-15','Yes','No',3,NULL,2),
    (5,1,DATE'2022-07-01',DATE'2022-07-01',DATE'2022-07-25',DATE'2022-07-25','No','Yes',3,4,3),
    (2,2,DATE'2022-07-01',DATE'2022-07-01',DATE'2022-07-25',NULL,'No','Yes',3,1,1),
    (2,4,DATE'2020-07-01',DATE'2020-06-12',DATE'2020-6-14',DATE'2020-01-12','No','Yes',3,1,2),
    (7,4,DATE'2020-07-01',DATE'2020-05-12',DATE'2020-5-14',DATE'2020-01-20','No','Yes',3,1,2),
    (2,1,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-7-14',DATE'2020-01-30','No','Yes',3,1,2),
    (3,1,DATE'2020-07-01',DATE'2020-06-12',DATE'2020-6-14',DATE'2020-01-25','No','Yes',3,1,2),
    (1,5,DATE'2020-07-01',DATE'2020-05-12',DATE'2020-5-14',DATE'2020-01-27','No','Yes',3,1,2),
    (2,5,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-12',DATE'2020-02-26','No','Yes',3,1,2),
    (3,5,DATE'2020-04-01',DATE'2020-07-12',DATE'2020-5-17',DATE'2020-02-25','No','Yes',3,1,2),
    (4,5,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-18',DATE'2020-02-24','No','Yes',3,1,2),
    (5,5,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-14',DATE'2020-02-23','No','Yes',3,1,2),
    (6,5,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-13',DATE'2020-02-21','No','Yes',3,1,2),
    (1,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-18',DATE'2020-02-24','No','Yes',3,1,2),
    (2,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-14',DATE'2020-02-23','No','Yes',3,1,2),
    (3,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-13',DATE'2020-02-21','No','Yes',3,1,2),
    (4,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-18',DATE'2020-02-24','No','Yes',3,1,2),
    (5,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-14',DATE'2020-02-23','No','Yes',3,1,2),
    (6,6,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-13',DATE'2020-02-07','No','Yes',3,1,2),
    (1,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-18',DATE'2020-03-06','No','Yes',3,1,2),
    (2,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-14',DATE'2020-03-05','No','Yes',3,1,2),
    (3,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-13',DATE'2020-03-04','No','Yes',3,1,2),
    (4,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-18',DATE'2020-03-03','No','Yes',3,1,2),
    (5,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-14',DATE'2020-03-02','No','Yes',3,1,2),
    (6,7,DATE'2020-07-01',DATE'2020-07-12',DATE'2020-5-13',DATE'2020-03-01','No','Yes',3,1,2)

    ;

INSERT INTO Baby(bid, gender, dob, btime, bloodtype, bname, pregnum, cid)
VALUES
    (1,'female',NULL,'23:06','A','Mason',1,1),
    (2,'male',DATE'2022-07-17','12:43','O','Frances',2,3),
    (3,'male',DATE'2022-07-19','22:33','AB','Joshua',3,4),
    (4,'female',NULL,'2:21','B','Ulysses',4,1),
    (5,'male',DATE'2022-07-18','16:38','A','Chantale',5,1),
    (6,'female',DATE'2022-07-15','3:26','O','Dillon',5,1);





INSERT INTO Infosession(iid, idate, itime, language, practid)
VALUES
    (1,DATE'2022-04-13','4:09','English',1),
    (2,DATE'2022-03-10','10:24','German',2),
    (3,DATE'2022-04-06','9:52','French',3),
    (4,DATE'2022-04-01','3:28','Spanish',1),
    (5,DATE'2022-03-26','11:33','German',4);

INSERT INTO Appointment(aid, adate, atime, pregnum, cid, practid)
VALUES
    (1,DATE'2022-03-19','1:46',3,4,2),
    (2,DATE'2022-03-24','3:49',2,3,1),
    (3,DATE'2022-03-22','3:04',4,1,3),
    (4,DATE'2022-03-22','5:31',1,1,1),
    (5,DATE'2022-03-26','2:53',3,4,2),
    (6,DATE'2022-03-23','6:06',1,1,1),
    (7,DATE'2022-03-21','11:20',3,4,2),
    (8,DATE'2022-03-29','6:50',2,3,1),
    (9,DATE'2022-03-30','6:30',5,1,3),
    (10,DATE'2022-03-30','8:57',3,4,2),
    (11,DATE'2022-03-22','20:00',2,2,1),
    (12,DATE'2022-03-24','8:57',2,4,1);


INSERT INTO Notes(ntime, aid, note)
VALUES
    ('5:12',6,'patient is nauseous'),
    ('11:23',4,'A little edgy'),
    ('10:18',6, 'not happy today'),
    ('8:10',8,'Baby has good movements'),
    ('13:09',7,'Mother is looking healthy'),
    ('9:09',5,'Baby has good movements'),
    ('7:15',3, 'Mother is in good condition'),
    ('11:27',8,'Baby has good movements'),
    ('13:11',9, 'A iron test should be scheduled soon'),
    ('14:32',1, 'Baby is looking like a baby, good');

INSERT INTO Inforegistration(iid, cid, attended)
VALUES
    (8,5,'No'),
    (7,3,'No'),
    (7,2,'Yes'),
    (5,4,'No'),
    (9,5,'Yes');



-- QUERIES

--5a
SELECT adate, atime, mom.qid, mname, phone
FROM MOTHER, (SELECT qid, adate, atime
              FROM Couple, (SELECT cid, adate, atime
                            FROM Appointment, (SELECT practid
                                               FROM Midwife
                                               WHERE mname = 'Marion Girard') mari
                            WHERE EXTRACT(YEAR from adate) = 2022
                                  AND Appointment.practid = mari.practid
                                  AND EXTRACT(MONTH from adate) = 03) apps
              WHERE apps.cid = Couple.cid) mom
WHERE Mother.qid = mom.qid
ORDER BY 1,2
;

--5b
SELECT labdate, labresult
FROM Tests, (SELECT cid
             FROM Couple, (SELECT qid
                           FROM Mother
                           WHERE mname = 'Victoria Gutierrez') vic
             WHERE Couple.qid = vic.qid) viccoup
WHERE Tests.cid = viccoup.cid
ORDER BY 1
;

--5c
SELECT hname, numpregs
FROM Healthclinic, (SELECT hid, COUNT(hid) numpregs
FROM (SELECT Midwife.hid
FROM Midwife, (SELECT cid, ppractid
      FROM Pregnancy
      WHERE finalest IS NOT NULL AND EXTRACT(MONTH from finalest) = 07
        AND EXTRACT(YEAR from finalest) = 2022
         OR finalest IS NULL AND EXTRACT(MONTH from initialexp) = 07
          AND EXTRACT(YEAR from initialexp) = 2022) july
WHERE Midwife.practid = july.ppractid)hospitals
group by hid) nums
WHERE nums.hid = Healthclinic.hid
ORDER BY 1
;

--5d
SELECT DISTINCT Mother.qid, mname, phone
FROM Mother, (SELECT qid
FROM Couple, (SELECT cid
FROM Healthclinic,
(SELECT cid, hid
FROM Midwife m, (SELECT ppractid, bpractid, p.cid
FROM Pregnancy p, (SELECT pregnum, cid
              FROM BABY
              WHERE dob IS NULL) b
WHERE b.pregnum = p.pregnum AND b.cid = p.cid) mids
WHERE m.practid = mids.ppractid OR mids.bpractid IS NOT NULL AND mids.bpractid = m.practid) locs
WHERE Healthclinic.hname = 'Lac-Saint-Louis' AND Healthclinic.hid = locs.hid) c
WHERE Couple.cid = c.cid)q
WHERE Mother.qid = q.qid
;


--5e
drop view midwifeinfo;
--6a
CREATE VIEW midwifeinfo AS
SELECT practid,mname,Midwife.phone,Midwife.email, hname, address
FROM Midwife, HealthClinic
WHERE Midwife.hid = Healthclinic.hid;

SELECT *
FROM Appointment
WHERE adate = DATE'2022-03-22'
ORDER BY atime DESC;


-- atime, midpractid, pregnancyPrimarypractid, name of mother, qid
SELECT atime, Pos, mname, Mother.qid, moms.pregnum, moms.cid, moms.adate, aid
FROM Mother,(SELECT atime, 'P' Pos, qid, a.pregnum, a.cid, a.adate, a.aid
             FROM Couple, (SELECT atime, a.cid, p.pregnum, a.adate, a.aid
                           FROM (SELECT *
                                 FROM Appointment
                                 WHERE adate = DATE'2022-03-22')a, Pregnancy p
                           WHERE practid = 1 AND p.pregnum = a.pregnum AND p.cid = a.cid AND practid = ppractid) a
             WHERE a.cid = Couple.cid
        UNION
             SELECT atime, 'B' Pos, qid, a.pregnum, a.cid, a.adate, a.aid
             FROM Couple, (SELECT atime, a.cid, p.pregnum, a.adate, a.aid
                   FROM (SELECT *
                         FROM Appointment
                         WHERE adate = DATE'2022-03-22')a, Pregnancy p
                   WHERE practid = 1 AND p.pregnum = a.pregnum AND p.cid = a.cid AND practid = bpractid) a
             WHERE a.cid = Couple.cid) moms
WHERE Mother.qid = moms.qid
ORDER BY atime;

--Appointment.adate, notes.atime, note  OrderBy descending order, date, time
SELECT adate, ntime, note
from Appointment a, Notes
WHERE a.cid = 1 AND a.pregnum = 1 AND a.aid = Notes.aid
ORDER BY adate DESC , ntime ASC;

SELECT tDate, testtype, labresult
FROM (SELECT labdate tDate, testtype, labresult, pregnum, cid
FROM Tests
UNION
SELECT prescdate date, testtype, labresult, pregnum, cid
FROM Tests
UNION
SELECT sampdate date, testtype, labresult, pregnum, cid
FROM Tests) allTests
WHERE tDate = ? AND pregnum = ?AND cid = ?
ORDER BY 1 DESC;

SELECT Max(tid)
FROM Tests;

SELECT tid, testtype, prescdate, sampdate,labdate, labresult,practid, tests.cid, tests.pregnum, bid, techid
FROM Tests, (SELECT Pregnancy.cid, Pregnancy.pregnum
                FROM Pregnancy, (SELECT cid
                    FROM Couple
                    WHERE Couple.qid = 5)momscid
                WHERE Pregnancy.cid = momscid.cid) pregs
WHERE Tests.cid = pregs.cid AND Tests.pregnum = pregs.pregnum
;

SELECT *
FROM Appointment, Couple
WHERE practid = 1 AND Appointment.cid = Couple.cid;

Create INDEX mothersAddress ON Mother (phone, addr);
Drop Index mothersAddress;


SELECT birthMonth, COUNT(birthMonth)
FROM (SELECT EXTRACT(MONTH from finalest) birthMonth
                 FROM Pregnancy
                 WHERE finalest IS NOT NULL AND Pregnancy.finalest<current_date ) months
GROUP BY birthMonth;
