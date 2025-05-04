-- 1. Tenants
INSERT INTO tenants (id, nombre) VALUES
  (1, 'Empresa Alpha'),
  (2, 'Empresa Beta');

-- 2. Clientes
INSERT INTO clientes (id, tenant_id, nombre, apellido, email, telefono) VALUES
  (1, 1, 'Juan',   'Pérez',      'juan.perez@alpha.com',  '+502 3000-0001'),
  (2, 1, 'María',  'López',      'maria.lopez@alpha.com', '+502 3000-0002'),
  (3, 1, 'Carlos', 'García',     'carlos.garcia@alpha.com','+502 3000-0003'),
  (4, 2, 'Ana',    'Ruiz',       'ana.ruiz@beta.com',      '+502 3000-1001'),
  (5, 2, 'Luis',   'Martínez',   'luis.martinez@beta.com', '+502 3000-1002'),
  (6, 2, 'Sofía',  'Hernández',  'sofia.hernandez@beta.com','+502 3000-1003');

-- 3. Categorías
INSERT INTO categorias (id, tenant_id, nombre, descripcion) VALUES
  (1, 1, 'Electrónica', 'TV, móviles y laptops'),
  (2, 1, 'Ropa',        'Camisetas, jeans y más'),
  (3, 2, 'Hogar',       'Electrodomésticos para casa'),
  (4, 2, 'Deportes',    'Artículos deportivos');

-- 4. Cupones
INSERT INTO cupones (id, tenant_id, codigo, tipo_descuento, valor, fecha_inicio, fecha_fin, uso_maximo) VALUES
  (1, 1, 'WELCOME10', 'porcentaje', 10.00, '2025-01-01', '2025-12-31', 1),
  (2, 1, 'BF2025',    'monto_fijo', 20.00, '2025-11-25', '2025-11-30', 100),
  (3, 2, 'NEW15',     'porcentaje', 15.00, '2025-02-01', '2025-12-31', 1),
  (4, 2, 'SUMMER5',   'monto_fijo',  5.00, '2025-06-01', '2025-08-31', 5);

-- 5. Productos
INSERT INTO productos (id, tenant_id, categoria_id, nombre, descripcion, precio, stock) VALUES
  (1, 1, 1, 'Televisor 55"', 'Smart TV 4K UHD', 499.99,  25),
  (2, 1, 1, 'Smartphone X',  '128GB, 6GB RAM',   299.99, 100),
  (3, 1, 1, 'Laptop Pro',    'i5, 8GB RAM, 256GB SSD', 699.99, 50),
  (4, 1, 2, 'Camiseta Logo', '100% algodón',     19.99, 200),
  (5, 1, 2, 'Jeans Clásicos','Denim azul oscuro',49.99, 150),
  (6, 2, 3, 'Aspiradora X',  'Sin bolsa, 1200W', 149.99,  30),
  (7, 2, 3, 'Microondas 20L','700W, timer',      89.99,  40),
  (8, 2, 3, 'Colchón King',  'Espuma viscoelástica', 399.99,10),
  (9, 2, 4, 'Balón Fútbol',  'Talla 5, cosido',    29.99, 100),
  (10,2, 4, 'Raqueta Tenis', 'Fibra de carbono',  99.99,  25);

-- 6. Direcciones de envío
INSERT INTO direcciones_envio (id, tenant_id, cliente_id, calle, ciudad, estado, codigo_postal, pais) VALUES
  (1, 1, 1, 'Av. Reforma 123', 'Ciudad G', 'Guatemala', '01010','Guatemala'),
  (2, 1, 1, 'Calle Secundaria 45','Mixco', '',      '01100','Guatemala'),
  (3, 1, 2, 'Zona 10, 5ª avenida','Ciudad G','Guatemala','01010','Guatemala'),
  (4, 1, 2, 'Km 12 Carretera','Fraijanes','Guatemala', '01012','Guatemala'),
  (5, 1, 3, 'Boulevard 1','Antigua','Sacatepéquez','03001','Guatemala'),
  (6, 1, 3, 'Colonia San Rafael','Guatemala','','01009','Guatemala'),
  (7, 2, 4, 'Km 5 Carretera','Mixco','','01100','Guatemala'),
  (8, 2, 4, 'Residenciales Vista','Guatemala','','01014','Guatemala'),
  (9, 2, 5, 'Zona 9, 20 calle','Ciudad G','','01009','Guatemala'),
  (10,2, 5, 'Petapa Km 6','Villa Nueva','','01013','Guatemala'),
  (11,2, 6, 'Chinautla','Chinautla','','01016','Guatemala'),
  (12,2, 6, 'San Juan Sacatepéquez','','','01017','Guatemala');

-- 7. Pedidos
INSERT INTO pedidos (id, tenant_id, cliente_id, cupon_id, fecha_pedido, estado) VALUES
  (1, 1, 1, 1, '2025-04-01 10:00', 'procesando'),
  (2, 1, 1, NULL, '2025-04-05 15:30', 'completado'),
  (3, 1, 2, 2, '2025-03-20 09:15', 'completado'),
  (4, 1, 2, NULL, '2025-03-22 11:45', 'cancelado'),
  (5, 1, 3, 1, '2025-04-10 14:00', 'procesando'),
  (6, 1, 3, NULL, '2025-04-12 16:20', 'completado'),
  (7, 2, 4, 3, '2025-04-02 08:30', 'procesando'),
  (8, 2, 4, NULL,'2025-04-07 12:00', 'completado'),
  (9, 2, 5, 4, '2025-03-28 17:45', 'completado'),
  (10,2, 5, NULL,'2025-03-30 13:10', 'cancelado'),
  (11,2, 6, 3, '2025-04-15 09:00', 'procesando'),
  (12,2, 6, NULL,'2025-04-18 10:50', 'completado');

-- 8. Detalle de pedidos
INSERT INTO detalle_pedidos (id, tenant_id, pedido_id, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1, 1, 499.99),
  (2, 1, 1, 4, 2, 19.99),
  (3, 1, 2, 2, 1, 299.99),
  (4, 1, 3, 5, 1, 49.99),
  (5, 1, 3, 3, 1, 699.99),
  (6, 1, 4, 4, 3, 19.99),
  (7, 1, 5, 1, 1, 499.99),
  (8, 1, 5, 2, 2, 299.99),
  (9, 1, 5, 5, 1, 49.99),
  (10,1, 6, 3, 1, 699.99),
  (11,2, 7, 6, 1, 149.99),
  (12,2, 7, 9, 2, 29.99),
  (13,2, 8, 7, 1, 89.99),
  (14,2, 9, 9, 3, 29.99),
  (15,2, 9,10, 1, 99.99),
  (16,2,11, 8, 1, 399.99),
  (17,2,12, 6, 2, 149.99);

-- 9. Pagos
INSERT INTO pagos (id, tenant_id, pedido_id, monto, fecha_pago, metodo_pago) VALUES
  (1, 1, 1,  539.97, '2025-04-02 09:00', 'tarjeta'),
  (2, 1, 2,  299.99, '2025-04-06 10:00', 'paypal'),
  (3, 1, 3,  719.98, '2025-03-21 08:00', 'tarjeta'),
  (4, 1, 5, 1149.96, '2025-04-11 11:00', 'transferencia'),
  (5, 1, 6,  699.99, '2025-04-13 14:00', 'tarjeta'),
  (6, 2, 7,  309.97, '2025-04-03 10:30', 'paypal'),
  (7, 2, 8,   89.99, '2025-04-08 13:00', 'tarjeta'),
  (8, 2, 9,  189.97, '2025-03-29 18:00', 'transferencia'),
  (9, 2,11,  399.99, '2025-04-16 10:00', 'paypal'),
  (10,2,12,  299.98, '2025-04-19 12:00', 'tarjeta');