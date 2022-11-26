import customtkinter
import psycopg2
import tkinter as tk
from config import config
from tkinter import *
from tkinter import ttk

class trabajadores(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Trabajadores")
        self.rowconfigure(5,minsize=20)
        self.rowconfigure(7,minsize=20)
        self.rowconfigure(9,minsize=20)
        self.rowconfigure(11,minsize=20)
        # Cuadros de texto
        self.rut = customtkinter.CTkEntry(self, width=300)
        self.rut.grid(row=0,column=1)
        self.nombre = customtkinter.CTkEntry(self,width=300)
        self.nombre.grid(row=1,column=1)
        self.apellido = customtkinter.CTkEntry(self,width=300)
        self.apellido.grid(row=2,column=1)
        self.cargo = customtkinter.CTkEntry(self,width=300)
        self.cargo.grid(row=3,column=1)
        self.sueldo = customtkinter.CTkEntry(self,width=300)
        self.sueldo.grid(row=4,column=1)

        # Etiqueta cuadros de texto
        self.rut_label = customtkinter.CTkLabel(self,text="RUT")
        self.rut_label.grid(row=0,column=0)      
        self.nombre_label = customtkinter.CTkLabel(self,text="Nombre")
        self.nombre_label.grid(row=1,column=0)
        self.apellido_label = customtkinter.CTkLabel(self,text="Apellido")
        self.apellido_label.grid(row=2,column=0)
        self.cargo_label = customtkinter.CTkLabel(self,text="Cargo")
        self.cargo_label.grid(row=3,column=0)
        self.sueldo_label = customtkinter.CTkLabel(self,text="Sueldo")
        self.sueldo_label.grid(row=4,column=0)

        # Boton agregar a la base de datos
        self.agregar_trabajadores_btn = customtkinter.CTkButton(self, text="Agregar a la Base de Datos", command=self.agregar_trabajadores)
        self.agregar_trabajadores_btn.grid(row=6,column=0,columnspan=2, ipadx = 50)
        self.mostrar_trabajadores_btn = customtkinter.CTkButton(self, text="Mostrar trabajadores", command=self.mostrar_trabajadores)
        self.mostrar_trabajadores_btn.grid(row=8,column=0,columnspan=2, ipadx = 72)
        self.editar_trabajadores_btn = customtkinter.CTkButton(self,text="Editar trabajadores", command=self.editar_trabajadores)
        self.editar_trabajadores_btn.grid(row=10,column=0,columnspan=2, ipadx = 72)

        # Treeview clientes
        columnas = ('RUT','Nombre','Apellido','Cargo','Sueldo')
        self.tree = ttk.Treeview(self,columns=columnas,show='headings')
        self.tree.grid(row=12,column=0,columnspan=2,ipady=100)

        self.tree.heading('RUT', text='RUT')
        self.tree.heading('Nombre', text='Nombre')
        self.tree.heading('Apellido', text='Apellido')
        self.tree.heading('Cargo', text='Cargo') 
        self.tree.heading('Sueldo', text='Sueldo') 

        # add a scrollbar
        scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=12, column=2,ipady=191)

        self.tree.bind('<ButtonRelease-1>', self.rellenar_entrada)

    def agregar_trabajadores(self):
        # Consultar usuarios en la base de datos
        sql2 = """INSERT INTO proyecto.trabajador(rut,cargo,sueldo) VALUES(%s,%s,%s)"""
        conn = None

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            rut_agregar = self.rut.get()
            nombre_agregar = self.nombre.get()
            apellido_agregar = self.apellido.get()
            cargo_agregar = self.cargo.get()
            sueldo_agregar = self.sueldo.get()

            if(rut_agregar != ""):
                cur.execute(sql2,(rut_agregar,cargo_agregar,sueldo_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_trabajadores()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def editar_trabajadores(self):
        sql_trabajador ="""
        UPDATE proyecto.trabajador as t
        SET nombre = %s, apellido =%s, cargo = %s, sueldo = %s
        WHERE t.RUT = %s;
        """
        conn = None
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            rut_agregar = self.rut.get()
            nombre_agregar = self.nombre.get()
            apellido_agregar = self.apellido.get()
            cargo_agregar = self.cargo.get()
            sueldo_agregar = self.sueldo.get()

            if rut_agregar != "":
                cur.execute(sql_trabajador,(nombre_agregar,apellido_agregar,
                cargo_agregar,sueldo_agregar,rut_agregar))

            self.rut.delete(0,END)
            self.nombre.delete(0,END)
            self.apellido.delete(0,END)
            self.cargo.delete(0,END)
            self.sueldo.delete(0,END)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_trabajadores()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_trabajadores(self):
        self.rut.delete(0,END)
        self.nombre.delete(0,END)
        self.apellido.delete(0,END)
        self.cargo.delete(0,END)
        self.sueldo.delete(0,END)

         # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT *
            FROM proyecto.trabajador as t
            ORDER BY RUT;
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
            trabajadores = cur.fetchall()
            
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for trabajador in trabajadores:
                self.tree.insert('', END, values=trabajador)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def rellenar_entrada(self,event):
        curItem = self.tree.focus()
        entrada = self.tree.item(curItem,'values')

        self.rut.delete(0,END)
        self.nombre.delete(0,END)
        self.apellido.delete(0,END)
        self.cargo.delete(0,END)
        self.sueldo.delete(0,END)

        try:
            self.rut.insert(0,entrada[0])
            self.nombre.insert(0,entrada[1]) 
            self.apellido.insert(0,entrada[2])
            self.cargo.insert(0,entrada[3])
            self.sueldo.insert(0,entrada[4])
        except:
            pass