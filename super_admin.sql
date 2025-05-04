RESET ROLE;

SET ROLE super_admin;

SELECT current_user;  

SET app.current_tenant = '1';

SELECT * FROM direcciones_envio LIMIT 1;

INSERT INTO direcciones_envio (tenant_id,cliente_id,calle,ciudad,estado,codigo_postal,pais)
VALUES (1,1,'Test Calle','CiudadX','','99999','PaísX');

UPDATE direcciones_envio
   SET ciudad = 'CiudadY'
 WHERE id = (SELECT MAX(id) FROM direcciones_envio);

DELETE FROM direcciones_envio
 WHERE id = (SELECT MAX(id) FROM direcciones_envio);