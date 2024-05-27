---------------------------------------------------------------------------------DB ����
alter system set processes=300 scope=spfile;
---------------------------------------------------------------------------------���̺� ����
CREATE TABLE COINS (
	COIN_NAME	VARCHAR2(20)	NOT NULL,
	COIN_PRICE	NUMBER	NOT NULL
);

CREATE TABLE MEMBERS (
	MEMBER_ID	VARCHAR2(32)	NOT NULL,
	MEMBER_PW	VARCHAR2(32)	NOT NULL,
	MEMBER_NAME	VARCHAR2(20)	NOT NULL,
	MEMBER_KRW	NUMBER	DEFAULT 0 NOT NULL	
);

CREATE TABLE MYCOINS (
	MEMBER_ID	VARCHAR2(32)	NOT NULL,
	COIN_NAME	VARCHAR2(20)	NOT NULL,
	MY_QUANTITY	NUMBER	NOT NULL,
	PURCHASE_PRICE	NUMBER not null
);

CREATE TABLE ORDERS (
	ORDER_NUM	NUMBER	NOT NULL,
	MEMBER_ID	VARCHAR2(32)	NOT NULL,
	ORDER_TYPE	CHAR(16)	NOT NULL,
	ORDER_QUANTITY	NUMBER	NOT NULL,
	ORDER_PRICE	NUMBER	NOT NULL,
	ORDER_TIME	DATE	NOT NULL,
	COIN_NAME	VARCHAR2(20)	NOT NULL
);

ALTER TABLE COINS ADD CONSTRAINT PK_COINS PRIMARY KEY (
	COIN_NAME
);

ALTER TABLE MEMBERS ADD CONSTRAINT PK_MEMBERS PRIMARY KEY (
	MEMBER_ID
);

ALTER TABLE MYCOINS ADD CONSTRAINT PK_MYCOINS PRIMARY KEY (
	MEMBER_ID,
	COIN_NAME
);

ALTER TABLE ORDERS ADD CONSTRAINT PK_ORDERS PRIMARY KEY (
	ORDER_NUM
);

ALTER TABLE MYCOINS ADD CONSTRAINT FK_MEMBERS_TO_MYCOINS_1 FOREIGN KEY (
	MEMBER_ID
)
REFERENCES MEMBERS (
	MEMBER_ID
);

ALTER TABLE MYCOINS ADD CONSTRAINT FK_COINS_TO_MYCOINS_1 FOREIGN KEY (
	COIN_NAME
)
REFERENCES COINS (
	COIN_NAME
);

--------------------------------------------------------------------------------- ������ Ʈ����, ���ν��� ����
-- ORDERS COIN_NUM ������ ����
CREATE SEQUENCE order_num_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

-- ������ Ʈ���� ����
CREATE OR REPLACE TRIGGER trg_before_insert_orders
BEFORE INSERT ON ORDERS
FOR EACH ROW
BEGIN
    SELECT order_num_seq.NEXTVAL INTO :new.ORDER_NUM FROM dual;
END;
/

--------------------------------------------------------------------------------------------------------------- �ż����ν����� �κиż� �߰�
CREATE OR REPLACE PROCEDURE process_buy_order_proc (
    p_order_num IN NUMBER,
    p_member_id IN VARCHAR2,
    p_order_quantity IN NUMBER,
    p_coin_name IN VARCHAR2
)
IS
    v_price NUMBER;
    v_remaining_quantity NUMBER; -- �ֹ� ������ ������ ����
BEGIN
    -- �ŵ� �ֹ� ���� ��ȸ
    SELECT ORDER_PRICE INTO v_price
    FROM ORDERS
    WHERE ORDER_NUM = p_order_num;

    -- �ֹ� ���� ��ȸ
    SELECT ORDER_QUANTITY INTO v_remaining_quantity
    FROM ORDERS
    WHERE ORDER_NUM = p_order_num;

    -- �κ� �ż��� ���� ����
    WHILE v_remaining_quantity > 0 AND p_order_quantity > 0 LOOP
        -- �ż����� ���� �ֹ������� ���� ��
        IF p_order_quantity <= v_remaining_quantity THEN
            -- �ż� MYCOINS.MY_QUANTITY ����
            UPDATE MYCOINS
            SET MY_QUANTITY = MY_QUANTITY + p_order_quantity
            WHERE MEMBER_ID = p_member_id
            AND COIN_NAME = p_coin_name;

            -- �ż��� KRW ����
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW - (v_price * p_order_quantity)
            WHERE MEMBER_ID = p_member_id;

            -- �ŵ��� KRW ����
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW + (v_price * p_order_quantity)
            WHERE MEMBER_ID = (SELECT MEMBER_ID FROM ORDERS WHERE ORDER_NUM = p_order_num);

            -- COINS.COIN_PRICE(�ֱٰŷ���) ����
            UPDATE COINS
            SET COIN_PRICE = v_price
            WHERE COIN_NAME = p_coin_name;

            -- �ֹ� ���� ������Ʈ
            v_remaining_quantity := v_remaining_quantity - p_order_quantity;

            -- �ֹ� ���ڵ��� ���� �ŵ��� ������Ʈ
            UPDATE ORDERS
            SET ORDER_QUANTITY = v_remaining_quantity
            WHERE ORDER_NUM = p_order_num;

            -- �ż�����ŭ �ֹ��� ó�������Ƿ� ���� ����
            EXIT;
        ELSE -- �ż����� ���� �ֹ������� ���� ��
            -- �ż� MYCOINS.MY_QUANTITY ����
            UPDATE MYCOINS
            SET MY_QUANTITY = MY_QUANTITY + v_remaining_quantity
            WHERE MEMBER_ID = p_member_id
            AND COIN_NAME = p_coin_name;

            -- �ż��� KRW ����
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW - (v_price * v_remaining_quantity)
            WHERE MEMBER_ID = p_member_id;

            -- �ŵ��� KRW ����
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW + (v_price * v_remaining_quantity)
            WHERE MEMBER_ID = (SELECT MEMBER_ID FROM ORDERS WHERE ORDER_NUM = p_order_num);

            -- COINS.COIN_PRICE(�ֱٰŷ���) ����
            UPDATE COINS
            SET COIN_PRICE = v_price
            WHERE COIN_NAME = p_coin_name;

            -- �ż�����ŭ �ֹ��� ó�������Ƿ� ���� ����
            EXIT;
        END IF;
    END LOOP;

    -- �ֹ� ������ 0 �����̸� �ֹ� ���ڵ� ����
    IF v_remaining_quantity <= 0 THEN
        DELETE FROM ORDERS
        WHERE ORDER_NUM = p_order_num;
    ELSE -- �ֹ� ������ �������� ������Ʈ
        UPDATE ORDERS
        SET ORDER_QUANTITY = v_remaining_quantity
        WHERE ORDER_NUM = p_order_num;
    END IF;

    COMMIT; -- ������� Ŀ��
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ֹ���ȣ�� �ش��ϴ� �����Ͱ� �����ϴ�.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END process_buy_order_proc;
/

--------------------------------------------------------------------------------- �⺻���� �ʱ� ����
-- �⺻���� ����
INSERT INTO MEMBERS VALUES ('guny1117','guny7128','��°�',1000000000);
INSERT INTO MEMBERS VALUES ('seller','seller','ȫ�浿',0);
-- 4�� ���� ����, �ֱٰŷ��� ����(���κ����ڿ��� �ݿ�)
INSERT INTO COINS VALUES ('BTC',108000); 
INSERT INTO COINS VALUES ('ETH',9800);
INSERT INTO COINS VALUES ('XRP',2100);
INSERT INTO COINS VALUES ('DOGE',90);
-- ���� ���� �ʱ� ����
INSERT INTO MYCOINS VALUES ('guny1117','BTC',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','ETH',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','XRP',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','DOGE',500,0);
INSERT INTO MYCOINS VALUES ('seller','BTC',100000,0);
INSERT INTO MYCOINS VALUES ('seller','ETH',100000,0);
INSERT INTO MYCOINS VALUES ('seller','XRP',100000,0);
INSERT INTO MYCOINS VALUES ('seller','DOGE',100000,0);
-- �ʱ� �ֹ� ����
INSERT INTO ORDERS VALUES (990,'guny1117','SELL',100,98000,'24/05/10','ETH');
INSERT INTO ORDERS VALUES (991,'guny1117','SELL',100,99000,'24/05/10','ETH');
INSERT INTO ORDERS VALUES (992,'guny1117','SELL',100,100000,'24/05/10','ETH');
INSERT INTO ORDERS VALUES (993,'guny1117','SELL',100,101000,'24/05/10','ETH');
INSERT INTO ORDERS VALUES (1000,'seller','SELL',100,107000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1001,'seller','SELL',10,108000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1002,'seller','SELL',100,109000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1003,'seller','SELL',1,110000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1004,'seller','SELL',10,111000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1005,'seller','SELL',10,112000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1006,'seller','SELL',5,113000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1007,'seller','SELL',50,114000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1008,'seller','SELL',100,115000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (1009,'seller','SELL',10,116000,'24/05/10','BTC');
INSERT INTO ORDERS VALUES (980,'guny1117','SELL',100,2100,'24/05/10','XRP');
INSERT INTO ORDERS VALUES (981,'guny1117','SELL',100,2200,'24/05/10','XRP');
INSERT INTO ORDERS VALUES (982,'seller','SELL',50,2300,'24/05/10','XRP');
INSERT INTO ORDERS VALUES (983,'seller','SELL',5,1900,'24/05/10','XRP');
--------------------------------------------------------------------------------- ȸ������ Ʈ���� ����
-- ȸ������ �� �ʱ� MYCOINS ���� Ʈ����
CREATE OR REPLACE TRIGGER init_mycoins_trigger
AFTER INSERT ON MEMBERS
FOR EACH ROW
BEGIN
    INSERT INTO MYCOINS (MEMBER_ID, COIN_NAME, MY_QUANTITY, PURCHASE_PRICE)
    VALUES (:NEW.MEMBER_ID, 'BTC', 0, 0);
    
    INSERT INTO MYCOINS (MEMBER_ID, COIN_NAME, MY_QUANTITY, PURCHASE_PRICE)
    VALUES (:NEW.MEMBER_ID, 'ETH', 0, 0);
    
    INSERT INTO MYCOINS (MEMBER_ID, COIN_NAME, MY_QUANTITY, PURCHASE_PRICE)
    VALUES (:NEW.MEMBER_ID, 'XRP', 0, 0);
    
    INSERT INTO MYCOINS (MEMBER_ID, COIN_NAME, MY_QUANTITY, PURCHASE_PRICE)
    VALUES (:NEW.MEMBER_ID, 'DOGE', 0, 0);
END;
/

COMMIT;
---------------------------------------------------------------------------------- ���̺� �ʱ�ȭ

DROP TABLE MYCOINS;
DROP TABLE COINS;
DROP TABLE ORDERS;
DROP TABLE MEMBERS; 
COMMIT;

