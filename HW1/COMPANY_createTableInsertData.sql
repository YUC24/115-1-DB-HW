CREATE TABLE EMPLOYEE
(
    Fname CHARACTER VARYING(50) NOT NULL,
    Minit CHARACTER(1),
    Lname CHARACTER VARYING(50) NOT NULL,
    Ssn CHARACTER(9) NOT NULL,
    Bdate DATE,
    Address CHARACTER VARYING(255),
    Sex CHARACTER(1),
    Salary NUMERIC(10,2),
    Super_ssn CHARACTER(9),
    Dno INTEGER DEFAULT 1 NOT NULL,
    CONSTRAINT employee_pkey PRIMARY KEY (Ssn),
    CONSTRAINT employee_super_ssn_fkey FOREIGN KEY (Super_ssn) 
        REFERENCES EMPLOYEE (Ssn)
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

CREATE TABLE DEPARTMENT
(
    Dname CHARACTER VARYING(50) NOT NULL,
    Dnumber INTEGER NOT NULL,
    Mgr_ssn CHARACTER(9) NOT NULL,
    Mgr_start_date DATE,
    CONSTRAINT department_pkey PRIMARY KEY (Dnumber),
    CONSTRAINT department_unique_dname UNIQUE (Dname),
    CONSTRAINT department_fkey_mgr_ssn FOREIGN KEY (Mgr_ssn) 
        REFERENCES EMPLOYEE (Ssn) 
        ON DELETE SET DEFAULT 
        ON UPDATE CASCADE
);

CREATE TABLE DEPT_LOCATIONS
(
    Dnumber INTEGER NOT NULL,
    Dlocation CHARACTER VARYING(50) NOT NULL,
    CONSTRAINT dept_locations_pkey PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT dept_fkey_locations_dnumber 
        FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT (Dnumber)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE PROJECT
(
    Pname CHARACTER VARYING(50) NOT NULL,
    Pnumber INTEGER NOT NULL,
    Plocation CHARACTER VARYING(50),
    Dnum INTEGER NOT NULL,
    CONSTRAINT project_pkey PRIMARY KEY (Pnumber),
    CONSTRAINT project_unique_pname UNIQUE (Pname),
    CONSTRAINT project_fkey_dnum FOREIGN KEY (Dnum) 
        REFERENCES DEPARTMENT (Dnumber)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE WORKS_ON
(
    Essn CHARACTER(9) NOT NULL,
    Pno INTEGER NOT NULL,
    Hours NUMERIC(5,1),
    CONSTRAINT works_on_pkey PRIMARY KEY (Pno, Essn),
    CONSTRAINT works_on_essn_fkey FOREIGN KEY (Essn) 
        REFERENCES EMPLOYEE (Ssn)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT works_on_fkey_pno FOREIGN KEY (Pno) 
        REFERENCES PROJECT (Pnumber)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE DEPENDENT
(
    Essn CHARACTER(9) NOT NULL,
    Dependent_name CHARACTER VARYING(100) NOT NULL,
    Sex CHARACTER(1),
    Bdate DATE,
    Relationship CHARACTER VARYING(100),
	CONSTRAINT dependent_pkey PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT dependent_fkey_essn FOREIGN KEY (Essn) 
        REFERENCES EMPLOYEE (Ssn)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES
('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston, TX','M',30000,333445555,5),
('Franklin','T','Wong',333445555,'1955-12-08','638 Voss, Houston, TX','M',40000,888665555,5),
('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring, TX','F',25000,987654321,4),
('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire, TX','F',43000,888665555,4),
('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble, TX','M',38000,333445555,5),
('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston, TX','F',25000,333445555,5),
('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston, TX','M',25000,987654321,4),
('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston, TX','M',55000,NULL,1);

INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Research',5,333445555,'1988-05-22'),
('Administration',4,987654321,'1995-01-01'),
('Headquarters',1,888665555,'1981-06-19');

ALTER TABLE EMPLOYEE
ADD CONSTRAINT employee_fkey_dno FOREIGN KEY (Dno) 
    REFERENCES DEPARTMENT (Dnumber)
    ON DELETE SET DEFAULT    
    ON UPDATE CASCADE;

INSERT INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES
(1,'Houston'),
(4,'Stafford'),
(5,'Bellaire'),
(5,'Sugarland'),
(5,'Houston');

INSERT INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES
('ProductX',1,'Bellaire',5),
('ProductY',2,'Sugarland',5),
('ProductZ',3,'Houston',5),
('Computerization',10,'Stafford',4),
('Reorganization',20,'Houston',1),
('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES
(123456789,1,32.5),
(123456789,2,7.5),
(666884444,3,40.0),
(453453453,1,20.0),
(453453453,2,20.0),
(333445555,2,10.0),
(333445555,3,10.0),
(333445555,10,10.0),
(333445555,20,10.0),
(999887777,30,30.0),
(999887777,10,10.0),
(987987987,10,35.0),
(987987987,30,5.0),
(987654321,30,20.0),
(987654321,20,15.0),
(888665555,20,NULL);

INSERT INTO DEPENDENT (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
(333445555,'Alice','F','1986-04-05','Daughter'),
(333445555,'Theodore','M','1983-10-25','Son'),
(333445555,'Joy','F','1958-05-03','Spouse'),
(987654321,'Abner','M','1942-02-28','Spouse'),
(123456789,'Michael','M','1988-01-04','Son'),
(123456789,'Alice','F','1988-12-30','Daughter'),
(123456789,'Elizabeth','F','1967-05-05','Spouse');