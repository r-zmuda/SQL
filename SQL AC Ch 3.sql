//SQL Advanced Challenge Chapter 3
//Ryan Zmuda

ALTER TABLE acctmanager ADD (
comm_id NUMBER(2) DEFAULT 10,
ben_id NUMBER(2)
);

CREATE TABLE commrate (
comm_id NUMBER(2) DEFAULT 10,
comm_rank VARCHAR2(15),
rate NUMBER(7,2)
);

CREATE TABLE benefits (
ben_id NUMBER(2),
ben_plan CHAR(1),
ben_provider NUMBER(3),
active CHAR(1)
);
