RESET ROLE;

SET ROLE gestor_pagos;

SELECT current_user;  

SET app.current_tenant = '2';

SELECT * FROM pagos LIMIT 1;

INSERT INTO pagos (tenant_id,pedido_id,monto,fecha_pago,metodo_pago)
VALUES (1,1,50.00,NOW(),'test');

UPDATE pagos
   SET monto = 75.00
 WHERE id = (SELECT MAX(id) FROM pagos WHERE tenant_id = 1);

DELETE FROM pagos
 WHERE id = (SELECT MAX(id) FROM pagos WHERE tenant_id = 1);