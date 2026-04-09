CREATE DATABASE SGFoodDW;
GO

USE SGFoodDW;
GO

CREATE TABLE StageVentas (
    fecha DATE,
    cliente_id NVARCHAR(50),
    cliente_nombre NVARCHAR(255),
    segmento_cliente NVARCHAR(100),
    producto_nombre NVARCHAR(255),
    marca NVARCHAR(100),
    categoria NVARCHAR(100),
    subcategoria NVARCHAR(100),
    fabricante NVARCHAR(100),
    departamento NVARCHAR(100),
    municipio NVARCHAR(100),
    canal_venta NVARCHAR(100),
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    costo_unitario DECIMAL(10,2),
    descuento DECIMAL(10,2)
);

CREATE TABLE DimCliente (
    cliente_key INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id NVARCHAR(50),
    cliente_nombre NVARCHAR(255),
    segmento_cliente NVARCHAR(100)
);

CREATE TABLE DimFecha (
    fecha_key INT PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    nombre_mes NVARCHAR(20),
    dia INT,
    dia_semana NVARCHAR(20)
);

CREATE TABLE DimUbicacion (
    ubicacion_key INT IDENTITY(1,1) PRIMARY KEY,
    departamento NVARCHAR(100),
    municipio NVARCHAR(100)
);

CREATE TABLE DimCanal (
    canal_key INT IDENTITY(1,1) PRIMARY KEY,
    canal_venta NVARCHAR(100)
);

CREATE TABLE DimProducto (
    producto_key INT IDENTITY(1,1) PRIMARY KEY,
    producto_nombre NVARCHAR(255),
    marca NVARCHAR(100),
    categoria NVARCHAR(100),
    subcategoria NVARCHAR(100),
    fabricante NVARCHAR(100)
);

CREATE TABLE FactVentas (
    venta_key INT IDENTITY(1,1) PRIMARY KEY,
    fecha_key INT,
    cliente_key INT,
    producto_key INT,
    ubicacion_key INT,
    canal_key INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    costo_unitario DECIMAL(10,2),
    descuento DECIMAL(10,2),
    total_venta DECIMAL(12,2),

    FOREIGN KEY (fecha_key) REFERENCES DimFecha(fecha_key),
    FOREIGN KEY (cliente_key) REFERENCES DimCliente(cliente_key),
    FOREIGN KEY (producto_key) REFERENCES DimProducto(producto_key),
    FOREIGN KEY (ubicacion_key) REFERENCES DimUbicacion(ubicacion_key),
    FOREIGN KEY (canal_key) REFERENCES DimCanal(canal_key)
);
