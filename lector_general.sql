RESET ROLE;

SET ROLE lector_general;

SELECT current_user;  

SET app.current_tenant = '2';

SELECT * FROM direcciones_envio LIMIT 1;

INSERT INTO direcciones_envio (tenant_id,cliente_id,calle,ciudad,estado,codigo_postal,pais)
VALUES (1,1,'Nope','Nope','','00000','Nope');

UPDATE direcciones_envio
   SET ciudad = 'Nada'
 WHERE id = 1;

DELETE FROM direcciones_envio
 WHERE id = 1;