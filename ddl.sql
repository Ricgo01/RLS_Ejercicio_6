--TABLAS

-- 1.  Tenats
CREATE TABLE tenants (
    id SERIAL PRIMARY KEY,
    nombre         VARCHAR(255)             NOT NULL,
    fecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- 2. Tabla de clientes
CREATE TABLE clientes (
    id         SERIAL PRIMARY KEY,
    tenant_id  INT                NOT NULL,
    nombre     VARCHAR(100)       NOT NULL,
    apellido   VARCHAR(100)       NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    telefono   VARCHAR(20)        NOT NULL,
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE
);

-- 3. Tabla de categorías
CREATE TABLE categorias (
    id         SERIAL PRIMARY KEY,
    tenant_id  INT          NOT NULL,
    nombre     VARCHAR(100) NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE
);

-- 4. Tabla de cupones
CREATE TABLE cupones (
    id                SERIAL PRIMARY KEY,
    tenant_id         INT                NOT NULL,
    codigo            VARCHAR(50)        NOT NULL,
    tipo_descuento    VARCHAR(20)        NOT NULL CHECK (tipo_descuento IN ('porcentaje','monto_fijo')),
    valor             NUMERIC(10,2)      NOT NULL CHECK (valor >= 0),
    fecha_inicio      DATE               NOT NULL,
    fecha_fin         DATE               NOT NULL,
    uso_maximo        INT    DEFAULT 1   NOT NULL CHECK (uso_maximo > 0),
    UNIQUE (tenant_id, codigo),
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE
);

-- 5. Tabla de productos
CREATE TABLE productos (
    id           SERIAL PRIMARY KEY,
    tenant_id    INT                NOT NULL,
    categoria_id INT,
    nombre       VARCHAR(255)       NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(10,2)      NOT NULL CHECK (precio >= 0),
    stock        INT    DEFAULT 0   NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id)
      REFERENCES categorias(id) ON DELETE SET NULL
);

-- 6. Tabla de direcciones de envío
CREATE TABLE direcciones_envio (
    id            SERIAL PRIMARY KEY,
    tenant_id     INT                NOT NULL,
    cliente_id    INT                NOT NULL,
    calle         VARCHAR(255)       NOT NULL,
    ciudad        VARCHAR(100)       NOT NULL,
    estado        VARCHAR(100),
    codigo_postal VARCHAR(20)        NOT NULL,
    pais          VARCHAR(100)       NOT NULL,
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id)
      REFERENCES clientes(id) ON DELETE CASCADE
);

-- 7. Tabla de pedidos
CREATE TABLE pedidos (
    id           SERIAL PRIMARY KEY,
    tenant_id    INT                NOT NULL,
    cliente_id   INT                NOT NULL,
    cupon_id     INT,
    fecha_pedido TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    estado       VARCHAR(50)        NOT NULL,
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (cliente_id)
      REFERENCES clientes(id) ON DELETE RESTRICT,
    FOREIGN KEY (cupon_id)
      REFERENCES cupones(id) ON DELETE SET NULL
);

-- 8. Tabla de detalle de pedidos
CREATE TABLE detalle_pedidos (
    id              SERIAL PRIMARY KEY,
    tenant_id       INT                NOT NULL,
    pedido_id       INT                NOT NULL,
    producto_id     INT                NOT NULL,
    cantidad        INT    NOT NULL    CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id)
      REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id)
      REFERENCES productos(id) ON DELETE RESTRICT
);

-- 9. Tabla de pagos
CREATE TABLE pagos (
    id           SERIAL PRIMARY KEY,
    tenant_id    INT                NOT NULL,
    pedido_id    INT                NOT NULL,
    monto        NUMERIC(10,2)      NOT NULL CHECK (monto >= 0),
    fecha_pago   TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    metodo_pago  VARCHAR(50)        NOT NULL,
    FOREIGN KEY (tenant_id)
      REFERENCES tenants(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id)
      REFERENCES pedidos(id) ON DELETE CASCADE
);

--ROLES

CREATE ROLE super_admin
  LOGIN PASSWORD 'SuP3rAdm!n2025';

CREATE ROLE gestor_tenant
  LOGIN PASSWORD 'Gt3n@ntAdm2025';

CREATE ROLE lector_general
  LOGIN PASSWORD 'L3ct0rG3n2025';

CREATE ROLE gestor_pagos
  LOGIN PASSWORD 'Pag0sGst2025';

CREATE ROLE catalog_manager
  LOGIN PASSWORD 'Cat4l0gMgr2025';

--GRANTS

GRANT ALL PRIVILEGES
  ON ALL TABLES IN SCHEMA public
  TO super_admin;

GRANT SELECT, INSERT, UPDATE, DELETE
  ON tenants,
     clientes,
     categorias,
     productos,
     pedidos,
     detalle_pedidos,
     pagos,
     direcciones_envio,
     cupones
  TO gestor_tenant;

GRANT SELECT
  ON tenants,
     clientes,
     categorias,
     productos,
     pedidos,
     detalle_pedidos,
     pagos,
     direcciones_envio,
     cupones
  TO lector_general;

GRANT SELECT, INSERT, update, DELETE
  ON pagos
  TO gestor_pagos;

GRANT SELECT, INSERT, UPDATE, DELETE
  ON productos,
     categorias
  TO catalog_manager;

GRANT USAGE ON SEQUENCE clientes_id_seq TO super_admin, gestor_tenant, catalog_manager;
GRANT USAGE ON SEQUENCE categorias_id_seq      TO super_admin, catalog_manager;
GRANT USAGE ON SEQUENCE productos_id_seq        TO super_admin, catalog_manager;
GRANT USAGE ON SEQUENCE direcciones_envio_id_seq TO super_admin, gestor_tenant;
GRANT USAGE ON SEQUENCE pedidos_id_seq          TO super_admin, gestor_tenant;
GRANT USAGE ON SEQUENCE detalle_pedidos_id_seq TO super_admin, gestor_tenant;
GRANT USAGE ON SEQUENCE pagos_id_seq            TO super_admin, gestor_pagos;
GRANT USAGE ON SEQUENCE cupones_id_seq          TO super_admin, gestor_tenant;


--POLICIES

CREATE POLICY clientes_select  ON clientes        FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY clientes_insert  ON clientes        FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY clientes_update  ON clientes        FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY clientes_delete  ON clientes        FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY categorias_select  ON categorias     FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY categorias_insert  ON categorias     FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY categorias_update  ON categorias     FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY categorias_delete  ON categorias     FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );

CREATE POLICY productos_select  ON productos       FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY productos_insert  ON productos       FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY productos_update  ON productos       FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY productos_delete  ON productos       FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY direcciones_envio_select  ON direcciones_envio FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY direcciones_envio_insert  ON direcciones_envio FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY direcciones_envio_update  ON direcciones_envio FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY direcciones_envio_delete  ON direcciones_envio FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY pedidos_select  ON pedidos         FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pedidos_insert  ON pedidos         FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pedidos_update  ON pedidos         FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pedidos_delete  ON pedidos         FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY detalle_pedidos_select  ON detalle_pedidos FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY detalle_pedidos_insert  ON detalle_pedidos FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY detalle_pedidos_update  ON detalle_pedidos FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY detalle_pedidos_delete  ON detalle_pedidos FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY pagos_select  ON pagos           FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pagos_insert  ON pagos           FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pagos_update  ON pagos           FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY pagos_delete  ON pagos           FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


CREATE POLICY cupones_select  ON cupones         FOR SELECT  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY cupones_insert  ON cupones         FOR INSERT  WITH CHECK ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY cupones_update  ON cupones         FOR UPDATE  USING ( tenant_id = current_setting('app.current_tenant')::int );
CREATE POLICY cupones_delete  ON cupones         FOR DELETE  USING ( tenant_id = current_setting('app.current_tenant')::int );


SELECT setval('direcciones_envio_id_seq',(SELECT COALESCE(MAX(id), 0) FROM direcciones_envio));
SELECT setval('clientes_id_seq',             (SELECT COALESCE(MAX(id), 0) FROM clientes));
SELECT setval('categorias_id_seq',           (SELECT COALESCE(MAX(id), 0) FROM categorias));
SELECT setval('productos_id_seq',            (SELECT COALESCE(MAX(id), 0) FROM productos));
SELECT setval('pedidos_id_seq',              (SELECT COALESCE(MAX(id), 0) FROM pedidos));
SELECT setval('detalle_pedidos_id_seq',      (SELECT COALESCE(MAX(id), 0) FROM detalle_pedidos));
SELECT setval('pagos_id_seq',                (SELECT COALESCE(MAX(id), 0) FROM pagos));
SELECT setval('cupones_id_seq',              (SELECT COALESCE(MAX(id), 0) FROM cupones));