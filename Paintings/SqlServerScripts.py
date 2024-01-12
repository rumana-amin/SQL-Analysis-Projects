import pandas as pd
import sqlalchemy
import pyodbc
import socket

# Get the hostname
hostname = socket.gethostname()

# Check available ODBC drivers
odbc_drivers = pyodbc.drivers()

# Create a SQL Server connection string
conn_str = f"mssql+pyodbc://{hostname}/Painting?trusted_connection=yes&driver=ODBC Driver 17 for SQL Server"
conn = sqlalchemy.create_engine(conn_str)

# List of the CSV files
files = ['artist', 'canvas_size', 'image_link', 'museum', 'museum_hours', 'product_size', 'subject', 'work']

# Create a dictionary to store DataFrames
dfs = {}

# Loop through each file, read its DataFrame, and write it to a separate table in SQL Server
for file in files:
    file_path = fr'D:\SQL\techTFQ\Painting\Datasets\{file}.csv'
    dfs[file] = pd.read_csv(file_path)
    
    # Use the file name as the table name
    table_name = file
    dfs[file].to_sql(table_name, con=conn, if_exists='replace', index=False)

# Close the database connection when done
conn.dispose()
