---------------------------------------------------------------------------------DB 설정
alter system set processes=300 scope=spfile;
---------------------------------------------------------------------------------테이블 생성
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

--------------------------------------------------------------------------------- 시퀀스 트리거, 프로시저 생성
-- ORDERS COIN_NUM 시퀀스 생성
CREATE SEQUENCE order_num_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

-- 시퀀스 트리거 생성
CREATE OR REPLACE TRIGGER trg_before_insert_orders
BEFORE INSERT ON ORDERS
FOR EACH ROW
BEGIN
    SELECT order_num_seq.NEXTVAL INTO :new.ORDER_NUM FROM dual;
END;
/

--------------------------------------------------------------------------------------------------------------- 매수프로시저에 부분매수 추가
CREATE OR REPLACE PROCEDURE process_buy_order_proc (
    p_order_num IN NUMBER,
    p_member_id IN VARCHAR2,
    p_order_quantity IN NUMBER,
    p_coin_name IN VARCHAR2
)
IS
    v_price NUMBER;
    v_remaining_quantity NUMBER; -- 주문 수량을 저장할 변수
BEGIN
    -- 매도 주문 가격 조회
    SELECT ORDER_PRICE INTO v_price
    FROM ORDERS
    WHERE ORDER_NUM = p_order_num;

    -- 주문 수량 조회
    SELECT ORDER_QUANTITY INTO v_remaining_quantity
    FROM ORDERS
    WHERE ORDER_NUM = p_order_num;

    -- 부분 매수를 위한 루프
    WHILE v_remaining_quantity > 0 AND p_order_quantity > 0 LOOP
        -- 매수량이 남은 주문량보다 적을 때
        IF p_order_quantity <= v_remaining_quantity THEN
            -- 매수 MYCOINS.MY_QUANTITY 증가
            UPDATE MYCOINS
            SET MY_QUANTITY = MY_QUANTITY + p_order_quantity
            WHERE MEMBER_ID = p_member_id
            AND COIN_NAME = p_coin_name;

            -- 매수자 KRW 감소
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW - (v_price * p_order_quantity)
            WHERE MEMBER_ID = p_member_id;

            -- 매도자 KRW 증가
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW + (v_price * p_order_quantity)
            WHERE MEMBER_ID = (SELECT MEMBER_ID FROM ORDERS WHERE ORDER_NUM = p_order_num);

            -- COINS.COIN_PRICE(최근거래가) 갱신
            UPDATE COINS
            SET COIN_PRICE = v_price
            WHERE COIN_NAME = p_coin_name;

            -- 주문 수량 업데이트
            v_remaining_quantity := v_remaining_quantity - p_order_quantity;

            -- 주문 레코드의 남은 매도량 업데이트
            UPDATE ORDERS
            SET ORDER_QUANTITY = v_remaining_quantity
            WHERE ORDER_NUM = p_order_num;

            -- 매수량만큼 주문을 처리했으므로 루프 종료
            EXIT;
        ELSE -- 매수량이 남은 주문량보다 많을 때
            -- 매수 MYCOINS.MY_QUANTITY 증가
            UPDATE MYCOINS
            SET MY_QUANTITY = MY_QUANTITY + v_remaining_quantity
            WHERE MEMBER_ID = p_member_id
            AND COIN_NAME = p_coin_name;

            -- 매수자 KRW 감소
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW - (v_price * v_remaining_quantity)
            WHERE MEMBER_ID = p_member_id;

            -- 매도자 KRW 증가
            UPDATE MEMBERS
            SET MEMBER_KRW = MEMBER_KRW + (v_price * v_remaining_quantity)
            WHERE MEMBER_ID = (SELECT MEMBER_ID FROM ORDERS WHERE ORDER_NUM = p_order_num);

            -- COINS.COIN_PRICE(최근거래가) 갱신
            UPDATE COINS
            SET COIN_PRICE = v_price
            WHERE COIN_NAME = p_coin_name;

            -- 매수량만큼 주문을 처리했으므로 루프 종료
            EXIT;
        END IF;
    END LOOP;

    -- 주문 수량이 0 이하이면 주문 레코드 삭제
    IF v_remaining_quantity <= 0 THEN
        DELETE FROM ORDERS
        WHERE ORDER_NUM = p_order_num;
    ELSE -- 주문 수량이 남았으면 업데이트
        UPDATE ORDERS
        SET ORDER_QUANTITY = v_remaining_quantity
        WHERE ORDER_NUM = p_order_num;
    END IF;

    COMMIT; -- 변경사항 커밋
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('주문번호에 해당하는 데이터가 없습니다.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END process_buy_order_proc;
/

--------------------------------------------------------------------------------- 기본계정 초기 설정
-- 기본계정 생성
INSERT INTO MEMBERS VALUES ('guny1117','guny7128','양승건',1000000000);
INSERT INTO MEMBERS VALUES ('seller','seller','홍길동',0);
-- 4개 코인 생성, 최근거래가 설정(코인보유자에게 반영)
INSERT INTO COINS VALUES ('BTC',108000); 
INSERT INTO COINS VALUES ('ETH',9800);
INSERT INTO COINS VALUES ('XRP',2100);
INSERT INTO COINS VALUES ('DOGE',90);
-- 보유 코인 초기 설정
INSERT INTO MYCOINS VALUES ('guny1117','BTC',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','ETH',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','XRP',500,0);
INSERT INTO MYCOINS VALUES ('guny1117','DOGE',500,0);
INSERT INTO MYCOINS VALUES ('seller','BTC',100000,0);
INSERT INTO MYCOINS VALUES ('seller','ETH',100000,0);
INSERT INTO MYCOINS VALUES ('seller','XRP',100000,0);
INSERT INTO MYCOINS VALUES ('seller','DOGE',100000,0);
-- 초기 주문 생성
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
--------------------------------------------------------------------------------- 회원가입 트리거 생성
-- 회원가입 후 초기 MYCOINS 생성 트리거
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
---------------------------------------------------------------------------------- 테이블 초기화

DROP TABLE MYCOINS;
DROP TABLE COINS;
DROP TABLE ORDERS;
DROP TABLE MEMBERS; 
COMMIT;

