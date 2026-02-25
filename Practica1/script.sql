USE master;
GO

IF DB_ID('DW_Vuelos') IS NOT NULL
BEGIN
    ALTER DATABASE DW_Vuelos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DW_Vuelos;
END;
GO

CREATE DATABASE DW_Vuelos;
GO

USE DW_Vuelos;
GO

CREATE TABLE Dim_Fecha (
    id_fecha INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL,
    anio SMALLINT NOT NULL,
    mes TINYINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    nombre_mes VARCHAR(20) NOT NULL,
    dia TINYINT NOT NULL CHECK (dia BETWEEN 1 AND 31),
    trimestre TINYINT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    dia_semana VARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Dim_Fecha UNIQUE (fecha)
);

CREATE TABLE Dim_Aerolinea (
    id_aerolinea INT IDENTITY(1,1) PRIMARY KEY,
    airline_code VARCHAR(10) NOT NULL,
    airline_name VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Dim_Aerolinea UNIQUE (airline_code)
);

CREATE TABLE Dim_Aeropuerto (
    id_aeropuerto INT IDENTITY(1,1) PRIMARY KEY,
    airport_code VARCHAR(10) NOT NULL,
    CONSTRAINT UQ_Dim_Aeropuerto UNIQUE (airport_code)
);

CREATE TABLE Dim_Pasajero (
    id_pasajero INT IDENTITY(1,1) PRIMARY KEY,
    passenger_id VARCHAR(50) NOT NULL,
    passenger_gender VARCHAR(10),
    passenger_age INT CHECK (passenger_age >= 0),
    passenger_nationality VARCHAR(50),
    CONSTRAINT UQ_Dim_Pasajero UNIQUE (passenger_id)
);

CREATE TABLE Dim_Venta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    sales_channel VARCHAR(50) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    cabin_class VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Dim_Venta UNIQUE (sales_channel, payment_method, currency, cabin_class)
);

CREATE TABLE Dim_Aeronave (
    id_aeronave INT IDENTITY(1,1) PRIMARY KEY,
    aircraft_type VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Dim_Aeronave UNIQUE (aircraft_type)
);

CREATE TABLE Dim_EstadoVuelo (
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    status VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Dim_Estado UNIQUE (status)
);

CREATE TABLE Fact_Vuelos (
    id_fact BIGINT IDENTITY(1,1) PRIMARY KEY,

    id_fecha_salida INT NOT NULL,
    id_fecha_llegada INT NOT NULL,
    id_fecha_reserva INT NOT NULL,

    id_aerolinea INT NOT NULL,
    id_origen INT NOT NULL,
    id_destino INT NOT NULL,
    id_pasajero INT NOT NULL,
    id_venta INT NOT NULL,
    id_aeronave INT NOT NULL,
    id_estado INT NOT NULL,

    duration_min INT CHECK (duration_min >= 0),
    delay_min INT,
    ticket_price_usd_est DECIMAL(12,2) CHECK (ticket_price_usd_est >= 0),
    bags_total INT CHECK (bags_total >= 0),
    bags_checked INT CHECK (bags_checked >= 0),

    CONSTRAINT FK_Fact_FechaSalida FOREIGN KEY (id_fecha_salida) REFERENCES Dim_Fecha(id_fecha),
    CONSTRAINT FK_Fact_FechaLlegada FOREIGN KEY (id_fecha_llegada) REFERENCES Dim_Fecha(id_fecha),
    CONSTRAINT FK_Fact_FechaReserva FOREIGN KEY (id_fecha_reserva) REFERENCES Dim_Fecha(id_fecha),

    CONSTRAINT FK_Fact_Aerolinea FOREIGN KEY (id_aerolinea) REFERENCES Dim_Aerolinea(id_aerolinea),
    CONSTRAINT FK_Fact_Origen FOREIGN KEY (id_origen) REFERENCES Dim_Aeropuerto(id_aeropuerto),
    CONSTRAINT FK_Fact_Destino FOREIGN KEY (id_destino) REFERENCES Dim_Aeropuerto(id_aeropuerto),
    CONSTRAINT FK_Fact_Pasajero FOREIGN KEY (id_pasajero) REFERENCES Dim_Pasajero(id_pasajero),
    CONSTRAINT FK_Fact_Venta FOREIGN KEY (id_venta) REFERENCES Dim_Venta(id_venta),
    CONSTRAINT FK_Fact_Aeronave FOREIGN KEY (id_aeronave) REFERENCES Dim_Aeronave(id_aeronave),
    CONSTRAINT FK_Fact_Estado FOREIGN KEY (id_estado) REFERENCES Dim_EstadoVuelo(id_estado),

    CONSTRAINT UQ_Fact_Vuelo UNIQUE (
        id_fecha_salida,
        id_pasajero,
        id_aerolinea,
        id_origen,
        id_destino
    )
);

CREATE NONCLUSTERED INDEX IX_Fact_FechaSalida ON Fact_Vuelos(id_fecha_salida);
CREATE NONCLUSTERED INDEX IX_Fact_Aerolinea ON Fact_Vuelos(id_aerolinea);
CREATE NONCLUSTERED INDEX IX_Fact_Destino ON Fact_Vuelos(id_destino);
CREATE NONCLUSTERED INDEX IX_Fact_Pasajero ON Fact_Vuelos(id_pasajero);
CREATE NONCLUSTERED INDEX IX_Fact_Estado ON Fact_Vuelos(id_estado);

IF OBJECT_ID('v_CuboVuelos', 'V') IS NOT NULL
    DROP VIEW v_CuboVuelos;
GO

CREATE VIEW v_CuboVuelos AS
SELECT
    F.id_fact,
    FS.fecha AS FechaSalida,
    FL.fecha AS FechaLlegada,
    FR.fecha AS FechaReserva,

    A.airline_name,
    O.airport_code AS Origen,
    D.airport_code AS Destino,
    P.passenger_gender,
    P.passenger_nationality,
    V.sales_channel,
    V.cabin_class,
    AV.aircraft_type,
    E.status,

    F.duration_min,
    F.delay_min,
    F.ticket_price_usd_est,
    F.bags_total,
    F.bags_checked

FROM Fact_Vuelos F
INNER JOIN Dim_Fecha FS ON F.id_fecha_salida = FS.id_fecha
INNER JOIN Dim_Fecha FL ON F.id_fecha_llegada = FL.id_fecha
INNER JOIN Dim_Fecha FR ON F.id_fecha_reserva = FR.id_fecha
INNER JOIN Dim_Aerolinea A ON F.id_aerolinea = A.id_aerolinea
INNER JOIN Dim_Aeropuerto O ON F.id_origen = O.id_aeropuerto
INNER JOIN Dim_Aeropuerto D ON F.id_destino = D.id_aeropuerto
INNER JOIN Dim_Pasajero P ON F.id_pasajero = P.id_pasajero
INNER JOIN Dim_Venta V ON F.id_venta = V.id_venta
INNER JOIN Dim_Aeronave AV ON F.id_aeronave = AV.id_aeronave
INNER JOIN Dim_EstadoVuelo E ON F.id_estado = E.id_estado;
GO
