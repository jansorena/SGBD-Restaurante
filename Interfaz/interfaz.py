import psycopg2
import tkinter.font
from tkinter import *
from config import config

# Agregar usuarios a la base de datos
def agregar_usuarios():
    # Consultar usuarios en la base de datos
    sql = """INSERT INTO proyecto.persona(rut,nombre,apellido) VALUES(%s,%s,%s)"""
    conn = None

    try:
        # Leer los parametros de configuracion
        params = config()

        # Conectar a las base de datos
        conn = psycopg2.connect(**params)

        # Crear cursor
        cur = conn.cursor()

        # Ejecutar los comandos
        cur.execute(sql,(rut.get(),nombre.get(),apellido.get()))
        
        # Cerrar la comunicacion con la base de datos
        cur.close()

        # Commit los cambios
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def mostrar_usuarios():
    # Consultar usuarios en la base de datos
    commands = (
        """
        SELECT *
        FROM proyecto.persona;
        """
    )
    conn = None
    try:
        # Leer los parametros de configuracion
        params = config()

        # Conectar a las base de datos
        conn = psycopg2.connect(**params)

        # Crear cursor
        cur = conn.cursor()

        # Ejecutar los comandos
        cur.execute(commands)
        usuarios = cur.fetchall()
        imprimir_usuarios = ""
        usuarios_texto.configure(state="normal")
        usuarios_texto.delete(1.0,END)

        string_rut = "RUT"
        string_nombre = "Nombre"
        string_apellido = "Apellido"

        usuarios_texto.insert(
            END,
            string_rut.ljust(15," ") + " " +
            string_nombre.ljust(15," ") + " " +
            string_apellido.ljust(15," ") + " " +
            "\n"
        )

        for usuario in usuarios:
            string1 = str(usuario[0])
            string2 = str(usuario[1])
            string3 = str(usuario[2])

            imprimir_usuarios = string1.ljust(15," ") + " " + string2.ljust(15," ") + " " + string3.ljust(15, " ")
            usuarios_texto.insert(END, imprimir_usuarios + "\n")
        
        usuarios_texto.configure(state="disabled")

        # Cerrar la comunicacion con la base de datos
        cur.close()

        # Commit los cambios
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

# Aplicacion principal
root  = Tk()

# Cuadros de texto
rut = Entry(root, width=30)
rut.grid(row=0, column=1,padx=50)
nombre = Entry(root,width=30)
nombre.grid(row=1,column=1)
apellido = Entry(root,width=30)
apellido.grid(row=2,column=1)

# Etiqueta cuadros de texto
rut_label = Label(root,text="RUT")
rut_label.grid(row=0,column=0)
nombre_label = Label(root,text="Nombre")
nombre_label.grid(row=1,column=0)
apellido_label = Label(root,text="Apellido")
apellido_label.grid(row=2,column=0)

# Boton agregar a la base de datos
agregar_usuarios_btn = Button(root, text="Agregar a la Base de Datos", command=agregar_usuarios)
agregar_usuarios_btn.grid(row=3,column=0,columnspan=2,pady=2,padx=10,ipadx=100)
mostrar_usuarios_btn = Button(root, text="Mostrar usuarios", command=mostrar_usuarios)
mostrar_usuarios_btn.grid(row=4,column=0,columnspan=2,pady=2,padx=10,ipadx=131)

# Cuadro para la consulta
usuarios_texto = Text(root, height=30, width=100, state="disabled", font=('Consolas', 15))
usuarios_texto.grid(row=5,column=0,columnspan=2)

#fuente
my_font = tkinter.font.Font(
    family = "Courier New", 
    size = 15, 
    weight = "bold"
)
usuarios_texto.configure(font = my_font)

# loop
root.mainloop()
 