RESET ROLE;

SET ROLE gestor_tenant;

SELECT current_user;  

SET app.current_tenant = '1';

SELECT * FROM direcciones_envio WHERE tenant_id = 1 LIMIT 1;

INSERT INTO direcciones_envio (tenant_id,cliente_id,calle,ciudad,estado,codigo_postal,pais)
VALUES (1,2,'Prueba Calle','Mixco','','01111','Guatemala');

UPDATE direcciones_envio
   SET pais = 'GT'
 WHERE id = (SELECT MAX(id) FROM direcciones_envio WHERE tenant_id = 1);

DELETE FROM direcciones_envio
 WHERE id = (SELECT MAX(id) FROM direcciones_envio WHERE tenant_id = 1);