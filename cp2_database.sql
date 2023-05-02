set serveroutput on
set verify off

-- EXERCICIO 1
drop table produtos cascade constraints;
select * from produtos;

CREATE TABLE produtos(
cd_produto      NUMBER(1)   PRIMARY KEY,
nm_produto      VARCHAR2(20),
vl_preco        NUMBER(5),
qt_estoque      NUMBER(5)
);

INSERT ALL
    INTO produtos VALUES(1, 'garrafa pet', 3, 10)
    INTO produtos VALUES(2, 'mochila', 50, 4)
    INTO produtos VALUES(3, 'tenis', 150, 6)
    INTO produtos VALUES(4, 'camisa', 100, 7)
SELECT * FROM dual;

DECLARE
    v_qt_produto NUMBER(2);
    produto_cheio EXCEPTION;
BEGIN
    INSERT INTO produtos VALUES(&cd, '&nm', null, null);
    
    SELECT COUNT(cd_produto) INTO v_qt_produto FROM produtos;
    IF v_qt_produto > 5 then
        RAISE produto_cheio;
    END IF;
    EXCEPTION
        WHEN dup_val_on_index then
            dbms_output.put_line('Produto com codigo ja existente.');
        WHEN produto_cheio then
            dbms_output.put_line('Produto com estoque cheio!');
END;

-- EXERCICIO 2

DECLARE
    v_cd_produto   produtos.cd_produto%TYPE;
    v_nm_produto   produtos.nm_produto%TYPE;
    v_vl_preco     produtos.vl_preco%TYPE;
    v_qt_estoque   produtos.qt_estoque%TYPE;
    
    v_compra_prod   NUMBER(1) := &compra;
    v_qt_compra     NUMBER(2) := &qtd;
    
    sem_estoque EXCEPTION;
BEGIN
    
    SELECT cd_produto, nm_produto, vl_preco, qt_estoque
    INTO v_cd_produto, v_nm_produto, v_vl_preco, v_qt_estoque
    FROM produtos WHERE cd_produto = v_compra_prod;
    
    IF v_qt_estoque >= 1 and v_qt_compra <= v_qt_estoque then
        UPDATE produtos SET qt_estoque = qt_estoque - v_qt_compra
        WHERE cd_produto = v_cd_produto;
    ELSE
        RAISE sem_estoque;
    END IF;
    dbms_output.put_line('valor total da compra: ' || v_qt_compra * v_vl_preco);
    dbms_output.put_line('quantidade a ser comprada: ' || v_qt_compra);
    EXCEPTION
        WHEN no_data_found then
            dbms_output.put_line('Produto com codigo inexistente.');
        WHEN sem_estoque then
            dbms_output.put_line('Produto esgotado!');
    
END;
