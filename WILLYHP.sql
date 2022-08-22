CREATE VIEW log_foodrinks AS 
SELECT  id,nama, price, stock, kategori, id_log, method, info 
FROM FOODRINKS, TX_LOG;


CREATE OR REPLACE TRIGGER foodrink_log
INSTEAD OF INSERT ON log_foodrinks
FOR EACH ROW
ENABLE

BEGIN
INSERT INTO TX_LOG values(:new.id_log,:new.method,:new.info);    
END;



CREATE OR REPLACE TRIGGER foodrink_audit
INSTEAD OF UPDATE  ON log_foodrinks
FOR EACH ROW
ENABLE
    
BEGIN 
    UPDATE foodrinks set stock = :new.stock  WHERE id = :old.id;  
   
END;


DECLARE
    FOODNAME VARCHAR2(15);
    FOODPRICE NUMBER(15);
    FOODSTOCK NUMBER(15);
    FOODID NUMBER(15);
    CURSOR cur_foodrink is SELECT id,nama,price,stock from foodrinks;

BEGIN
    OPEN cur_foodrink;
    
    LOOP
        FETCH cur_foodrink INTO FOODID,FOODNAME,FOODPRICE,FOODSTOCK;
        IF FOODSTOCK < 5 THEN
        FOODSTOCK := FOODSTOCK+5;
        UPDATE log_foodrinks SET stock = FOODSTOCK WHERE  id = FOODID;
        INSERT INTO log_foodrinks(id_log,method,info)VALUES(FOODID,'UPDATE','Quantity Kurang Dari 5') ;
        DBMS_OUTPUT.PUT_LINE(FOODSTOCK);
      
        END IF;
        EXIT WHEN cur_foodrink%NOTFOUND;
    END LOOP;    
    CLOSE cur_foodrink;

END;
/







