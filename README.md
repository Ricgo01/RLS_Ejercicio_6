# Ejercicio de Row Level Security en PostgreSQL

## 📋 Descripción del Proyecto

Este proyecto implementa un sistema de base de datos para una aplicación de e-commerce **multi-tenant**, donde varias empresas (tenants) pueden utilizar la misma base de datos mientras sus datos permanecen completamente aislados entre sí mediante mecanismos de seguridad avanzados a nivel de fila (Row Level Security) en PostgreSQL.

## 🏗️ Estructura de la Base de Datos

El diseño comprende un conjunto completo de tablas relacionadas para gestionar operaciones de e-commerce:

1. **`tenants`** - Almacena información de las empresas que utilizan la plataforma
2. **`clientes`** - Registra los clientes de cada tenant
3. **`categorias`** - Categorías de productos por tenant 
4. **`productos`** - Catálogo de productos disponibles
5. **`cupones`** - Promociones y descuentos configurables
6. **`direcciones_envio`** - Direcciones de envío de los clientes
7. **`pedidos`** - Órdenes de compra
8. **`detalle_pedidos`** - Elementos individuales en cada pedido
9. **`pagos`** - Registros de transacciones de pago

## 🔐 Roles y Permisos

El sistema implementa un modelo de seguridad basado en cinco roles específicos:

| Rol | Descripción | Permisos |
|-----|-------------|----------|
| **`super_admin`** | Administración completa del sistema | Acceso total a todas las tablas y operaciones |
| **`gestor_tenant`** | Gestión de datos del tenant asignado | CRUD en todas las tablas dentro del tenant específico |
| **`lector_general`** | Visualización de datos sin edición | SELECT en todas las tablas dentro del tenant específico |
| **`gestor_pagos`** | Gestión financiera | CRUD exclusivamente en la tabla pagos |
| **`catalog_manager`** | Gestión de catálogo de productos | CRUD en las tablas productos y categorias |

## 🔒 Implementación de Row Level Security

La seguridad a nivel de fila se implementa mediante políticas que filtran automáticamente los datos basándose en el tenant actual:

```sql
CREATE POLICY clientes_select ON clientes 
FOR SELECT USING (tenant_id = current_setting('app.current_tenant')::int);

CREATE POLICY clientes_insert ON clientes 
FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant')::int);
```

Cada operación (SELECT, INSERT, UPDATE, DELETE) tiene políticas específicas que garantizan que los usuarios solo pueden acceder a los datos de su propio tenant.

## 🧪 Pruebas y Validación

Los siguientes scripts validan que las políticas de seguridad funcionan correctamente:

- **`catalog_manager.sql`**: Prueba las operaciones CRUD en las tablas de categorías y productos
- **`gestor_pagos.sql`**: Verifica las operaciones en la tabla de pagos
- **`lector_general.sql`**: Confirma que este rol solo tiene permisos de lectura
- **`gestor_tenant.sql`**: Prueba la gestión completa de datos para un tenant específico
- **`super_admin.sql`**: Verifica el acceso administrativo completo sin restricciones

Cada script configura:
1. El rol activo con `SET ROLE`
2. El tenant actual con `SET app.current_tenant`
3. Ejecuta operaciones SELECT, INSERT, UPDATE y DELETE

## 💡 Aspectos Destacados

- **Aislamiento de datos**: Las políticas RLS garantizan que cada tenant solo puede acceder a sus propios datos
- **Modelo de seguridad flexible**: Los roles permiten diferentes niveles de acceso según las responsabilidades
- **Configuración dinámica**: El sistema utiliza variables de sesión para controlar el contexto del tenant

## 🚀 Ejecución de los Scripts

Para probar la implementación:

1. Ejecutar [`ddl.sql`](ddl.sql ) para crear el esquema, roles y políticas
2. Ejecutar [`data.sql`](data.sql ) para insertar datos de prueba
3. Ejecutar los scripts de prueba por rol para validar la seguridad:
   ```bash
   psql -f super_admin.sql
   psql -f gestor_tenant.sql
   psql -f lector_general.sql
   psql -f gestor_pagos.sql
   psql -f catalog_manager.sql
   ```

## 📊 Conclusiones

Este proyecto demuestra cómo implementar de manera efectiva un sistema multi-tenant seguro utilizando PostgreSQL. El uso de Row Level Security proporciona un mecanismo robusto para aislar datos sin necesidad de crear bases de datos o esquemas separados para cada cliente, optimizando así el uso de recursos mientras se mantiene un estricto control de acceso.

---

*Proyecto desarrollado para el curso de Base de Datos 1 - UVG 2025*