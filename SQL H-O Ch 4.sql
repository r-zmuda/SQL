--Q1
CREATE TABLE store_reps (
    rep_id NUMBER(5),
    last VARCHAR2(15),
    first VARCHAR2(10),
    comm CHAR(1) DEFAULT 'Y',
    CONSTRAINT rep_id_pk PRIMARY KEY (rep_id)
    );

--Q2
ALTER TABLE store_reps
    MODIFY (last CONSTRAINT store_reps_last_nn NOT NULL)
    MODIFY (first CONSTRAINT store_reps_first_nn NOT NULL);

--Q3
ALTER TABLE store_reps
    MODIFY (comm CONSTRAINT store_reps_comm_ck CHECK (comm IN ('Y','N')));

--Q4
ALTER TABLE store_reps
    ADD (base_salary NUMBER(7,2) CONSTRAINT store_reps_base_salary_ck CHECK (base_salary > 0));

--Q5
CREATE TABLE book_stores (
    store_id NUMBER(8),
    name VARCHAR2(30) NOT NULL,
    contact VARCHAR2(30),
    rep_id VARCHAR2(5),
    CONSTRAINT store_id_pk PRIMARY KEY (store_id),
    CONSTRAINT book_stores_name_uk UNIQUE (name)
    );

--Q6
ALTER TABLE book_stores
    MODIFY (rep_id NUMBER(5));
	
ALTER TABLE book_stores
    ADD CONSTRAINT book_stores_rep_id_fk FOREIGN KEY (rep_id)
        REFERENCES store_reps (rep_id);

--Q7
ALTER TABLE book_stores
    DROP CONSTRAINT book_stores_rep_id_fk;
	
ALTER TABLE book_stores
    ADD CONSTRAINT book_stores_rep_id_fk FOREIGN KEY (rep_id)
        REFERENCES store_reps (rep_id) ON DELETE CASCADE;

--Q8
CREATE TABLE rep_contracts (
    store_id NUMBER(8),
    name NUMBER(5),
    quarter CHAR(3),
    rep_id NUMBER(5),
    CONSTRAINT rep_contracts_pk PRIMARY KEY (rep_id, store_id, quarter),
    CONSTRAINT rep_contracts_rep_id_fk FOREIGN KEY (rep_id)
        REFERENCES store_reps (rep_id),
    CONSTRAINT rep_contracts_store_id_fk FOREIGN KEY (store_id)
        REFERENCES book_stores (store_id)
    );

--Q9
--SELECT constraint_name, search_condition FROM user_constraints WHERE TABLE_NAME = 'STORE_REPS';
SELECT * FROM user_constraints WHERE TABLE_NAME = 'STORE_REPS';

--Q10
ALTER TABLE store_reps
    DISABLE CONSTRAINT store_reps_base_salary_ck;
	
ALTER TABLE store_reps
    ENABLE CONSTRAINT store_reps_base_salary_ck;
