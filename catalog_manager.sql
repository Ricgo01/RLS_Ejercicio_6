RESET ROLE;

SET ROLE catalog_manager;

SELECT current_user;  

SET app.current_tenant = '1';

SELECT * FROM categorias LIMIT 1;

INSERT INTO categorias (tenant_id,nombre,descripcion)
VALUES (1,'CatPrueba','Descripción X');

UPDATE categorias
   SET descripcion = 'Desc Actualizada'
 WHERE id = (SELECT MAX(id) FROM categorias WHERE tenant_id = 1);

DELETE FROM categorias
 WHERE id = (SELECT MAX(id) FROM categorias WHERE tenant_id = 1);