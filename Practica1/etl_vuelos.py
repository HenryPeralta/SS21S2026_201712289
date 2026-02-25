from __future__ import annotations

import pandas as pd
from pathlib import Path
import urllib
from sqlalchemy import create_engine, text

SERVER = "localhost"
DATABASE = "DW_Vuelos"

ROOT = Path(__file__).resolve().parent
csv_path = ROOT / "dataset_vuelos_crudo.csv"

def make_engine(database: str):
    params = urllib.parse.quote_plus(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={SERVER};"
        f"DATABASE={database};"
        "Trusted_Connection=yes;"
    )
    return create_engine(f"mssql+pyodbc:///?odbc_connect={params}", future=True)

engine = make_engine(DATABASE)

df = pd.read_csv(csv_path)
df.columns = df.columns.str.strip().str.lower()

text_cols = [
    "airline_code", "airline_name",
    "origin_airport", "destination_airport",
    "passenger_id", "passenger_gender",
    "passenger_nationality",
    "sales_channel", "payment_method",
    "currency", "cabin_class",
    "aircraft_type", "status"
]

for c in text_cols:
    if c in df.columns:
        df[c] = df[c].astype(str).str.strip()
        df[c] = df[c].replace(["", "nan", "None"], pd.NA)

# Normalización estructural
df["airline_code"] = df["airline_code"].str.upper()
df["airline_name"] = df["airline_name"].str.title()
df["origin_airport"] = df["origin_airport"].str.upper()
df["destination_airport"] = df["destination_airport"].str.upper()
df["currency"] = df["currency"].str.upper()
df["status"] = df["status"].str.title()

# Manejo NULL en Dim_Venta
cols_venta = ["sales_channel", "payment_method", "currency", "cabin_class"]

for c in cols_venta:
    df[c] = df[c].fillna("DESCONOCIDO")

# Fechas
df["departure_datetime"] = pd.to_datetime(
    df["departure_datetime"], format="%d/%m/%Y %H:%M", errors="coerce"
)
df["arrival_datetime"] = pd.to_datetime(
    df["arrival_datetime"], format="%d/%m/%Y %H:%M", errors="coerce"
)
df["booking_datetime"] = pd.to_datetime(
    df["booking_datetime"], format="%d/%m/%Y %H:%M", errors="coerce"
)

df = df[
    df["departure_datetime"].notna() &
    df["arrival_datetime"].notna() &
    df["booking_datetime"].notna()
].copy()

df["departure_date"] = df["departure_datetime"].dt.date
df["arrival_date"] = df["arrival_datetime"].dt.date
df["booking_date"] = df["booking_datetime"].dt.date

print("Registros válidos:", len(df))

with engine.begin() as conn:

    # Dim_Aerolinea
    dim = df[["airline_code", "airline_name"]].drop_duplicates()

    exist = pd.read_sql("SELECT airline_code FROM Dim_Aerolinea", conn)
    exist["airline_code"] = exist["airline_code"].str.upper().str.strip()

    dim_new = dim[~dim["airline_code"].isin(exist["airline_code"])]

    if not dim_new.empty:
        dim_new.to_sql("Dim_Aerolinea", conn, if_exists="append", index=False)

    # Dim_Aeropuerto
    aeropuertos = pd.concat([
        df[["origin_airport"]].rename(columns={"origin_airport": "airport_code"}),
        df[["destination_airport"]].rename(columns={"destination_airport": "airport_code"})
    ])

    aeropuertos["airport_code"] = aeropuertos["airport_code"].str.upper().str.strip()
    aeropuertos = aeropuertos.drop_duplicates()

    exist = pd.read_sql("SELECT airport_code FROM Dim_Aeropuerto", conn)
    exist["airport_code"] = exist["airport_code"].str.upper().str.strip()

    aero_new = aeropuertos[
        ~aeropuertos["airport_code"].isin(exist["airport_code"])
    ]

    if not aero_new.empty:
        aero_new.to_sql("Dim_Aeropuerto", conn, if_exists="append", index=False)

    # Dim_Pasajero
    dim_pas = df[[
        "passenger_id", "passenger_gender",
        "passenger_age", "passenger_nationality"
    ]].drop_duplicates()

    exist = pd.read_sql("SELECT passenger_id FROM Dim_Pasajero", conn)
    pas_new = dim_pas[~dim_pas["passenger_id"].isin(exist["passenger_id"])]

    if not pas_new.empty:
        pas_new.to_sql("Dim_Pasajero", conn, if_exists="append", index=False)

    # Dim_Venta
    dim_venta = df[[
        "sales_channel", "payment_method",
        "currency", "cabin_class"
    ]].drop_duplicates()

    exist = pd.read_sql("""
        SELECT sales_channel, payment_method, currency, cabin_class
        FROM Dim_Venta
    """, conn)

    dim_venta_new = dim_venta.merge(
        exist,
        on=["sales_channel", "payment_method", "currency", "cabin_class"],
        how="left",
        indicator=True
    )

    dim_venta_new = dim_venta_new[dim_venta_new["_merge"] == "left_only"]
    dim_venta_new = dim_venta_new.drop(columns=["_merge"])

    if not dim_venta_new.empty:
        dim_venta_new.to_sql("Dim_Venta", conn, if_exists="append", index=False)

    # Dim_Aeronave
    dim_av = df[["aircraft_type"]].drop_duplicates()
    exist = pd.read_sql("SELECT aircraft_type FROM Dim_Aeronave", conn)
    av_new = dim_av[~dim_av["aircraft_type"].isin(exist["aircraft_type"])]

    if not av_new.empty:
        av_new.to_sql("Dim_Aeronave", conn, if_exists="append", index=False)

    # Dim_EstadoVuelo
    dim_estado = df[["status"]].drop_duplicates()
    exist = pd.read_sql("SELECT status FROM Dim_EstadoVuelo", conn)
    estado_new = dim_estado[~dim_estado["status"].isin(exist["status"])]

    if not estado_new.empty:
        estado_new.to_sql("Dim_EstadoVuelo", conn, if_exists="append", index=False)

    # Dim_Fecha
    fechas = pd.concat([
        df["departure_date"],
        df["arrival_date"],
        df["booking_date"]
    ]).drop_duplicates()

    cal = pd.DataFrame({"fecha": fechas})
    cal["anio"] = pd.to_datetime(cal["fecha"]).dt.year
    cal["mes"] = pd.to_datetime(cal["fecha"]).dt.month
    cal["dia"] = pd.to_datetime(cal["fecha"]).dt.day
    cal["trimestre"] = pd.to_datetime(cal["fecha"]).dt.quarter
    cal["nombre_mes"] = pd.to_datetime(cal["fecha"]).dt.month_name()
    cal["dia_semana"] = pd.to_datetime(cal["fecha"]).dt.day_name()

    exist = pd.read_sql("SELECT fecha FROM Dim_Fecha", conn)
    cal_new = cal[~cal["fecha"].isin(exist["fecha"])]

    if not cal_new.empty:
        cal_new.to_sql("Dim_Fecha", conn, if_exists="append", index=False)

with engine.begin() as conn:

    dim_fecha = pd.read_sql("SELECT id_fecha, fecha FROM Dim_Fecha", conn)
    dim_aero = pd.read_sql("SELECT id_aerolinea, airline_code FROM Dim_Aerolinea", conn)
    dim_airp = pd.read_sql("SELECT id_aeropuerto, airport_code FROM Dim_Aeropuerto", conn)
    dim_pas = pd.read_sql("SELECT id_pasajero, passenger_id FROM Dim_Pasajero", conn)
    dim_venta = pd.read_sql("SELECT id_venta, sales_channel, payment_method, currency, cabin_class FROM Dim_Venta", conn)
    dim_av = pd.read_sql("SELECT id_aeronave, aircraft_type FROM Dim_Aeronave", conn)
    dim_estado = pd.read_sql("SELECT id_estado, status FROM Dim_EstadoVuelo", conn)

fact = df.copy()

fact = fact.merge(dim_fecha, left_on="departure_date", right_on="fecha")
fact = fact.rename(columns={"id_fecha": "id_fecha_salida"}).drop(columns=["fecha"])

fact = fact.merge(dim_fecha, left_on="arrival_date", right_on="fecha")
fact = fact.rename(columns={"id_fecha": "id_fecha_llegada"}).drop(columns=["fecha"])

fact = fact.merge(dim_fecha, left_on="booking_date", right_on="fecha")
fact = fact.rename(columns={"id_fecha": "id_fecha_reserva"}).drop(columns=["fecha"])

fact = fact.merge(dim_aero, on="airline_code")

fact = fact.merge(dim_airp, left_on="origin_airport", right_on="airport_code")
fact = fact.rename(columns={"id_aeropuerto": "id_origen"}).drop(columns=["airport_code"])

fact = fact.merge(dim_airp, left_on="destination_airport", right_on="airport_code")
fact = fact.rename(columns={"id_aeropuerto": "id_destino"}).drop(columns=["airport_code"])

fact = fact.merge(dim_pas, on="passenger_id")
fact = fact.merge(dim_venta, on=["sales_channel","payment_method","currency","cabin_class"])
fact = fact.merge(dim_av, on="aircraft_type")
fact = fact.merge(dim_estado, on="status")

required_keys = [
    "id_fecha_salida","id_fecha_llegada","id_fecha_reserva",
    "id_aerolinea","id_origen","id_destino",
    "id_pasajero","id_venta","id_aeronave","id_estado"
]

if fact[required_keys].isna().any().any():
    raise ValueError("Existen llaves faltantes en Fact_Vuelos")

fact_out = fact[[
    "id_fecha_salida","id_fecha_llegada","id_fecha_reserva",
    "id_aerolinea","id_origen","id_destino",
    "id_pasajero","id_venta","id_aeronave","id_estado",
    "duration_min","delay_min",
    "ticket_price_usd_est","bags_total","bags_checked"
]]

with engine.begin() as conn:
    conn.execute(text("DELETE FROM Fact_Vuelos"))
    fact_out.to_sql("Fact_Vuelos", conn, if_exists="append", index=False)

print("Carga completada correctamente.")