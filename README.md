# Database Restaurant Management System

A desktop application for managing a restaurant's operations using Python, PostgreSQL and CustomTkinter.

## Features

- **Customer Management**: Track customer information and orders
- **Employee Management**: Manage employee data and roles 
- **Product Management**: Handle menu items and ingredients
- **Order Management**: Process and track customer orders
- **Financial Management**: Track revenue, expenses and generate reports
- **Inventory Management**: Monitor and manage ingredient stock levels

## Technology Stack

- **Frontend**: CustomTkinter, Tkinter
- **Backend**: Python, psycopg2
- **Database**: PostgreSQL
- **Visualization**: Matplotlib

## Project Structure

```
.
├── .gitignore                  # Git ignore file
├── README.md                   # Project documentation
├── Interfaz/                   # Frontend GUI modules
│   ├── clientes.py             # Customer management module
│   ├── config.py               # Database configuration
│   ├── finanzas.py             # Financial management module
│   ├── images/                 # UI images
│   ├── ingredientes.py         # Ingredient management module
│   ├── main.py                 # Main application entry point
│   ├── pedidos.py              # Order management module  
│   ├── productos.py            # Product management module
│   └── trabajadores.py         # Employee management module
└── SQL/                        # Database scripts
    ├── consultas_proyecto.sql  # Database queries
    ├── datos_proyecto.sql      # Sample data
    └── proyecto.sql            # Database schema
```

## Requirements

- Python 3.x
- PostgreSQL
- Python packages:
  - customtkinter
  - psycopg2
  - Pillow
  - matplotlib
  - tkcalendar

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Install required Python packages:

```bash
pip install customtkinter psycopg2-binary Pillow matplotlib tkcalendar
```

3. Set up PostgreSQL database:
- Create a database
- Run the SQL scripts in the following order:
    1. proyecto.sql
    2. datos_proyecto.sql
    3. consultas_proyecto.sql

4. Configure database connection:

- Create a database.ini file in the root directory with your PostgreSQL credentials:

```yaml
[postgresql]
host=localhost
database=your_database_name
user=your_username
password=your_password
```

## Usage
Run the main application:

```bash
python Interfaz/main.py
```

