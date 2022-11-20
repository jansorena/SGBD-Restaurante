import customtkinter
import psycopg2
import tkinter as tk
from config import config
from tkinter import *
from tkinter import ttk

class ingredientes(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Ingredientes")

        self.rowconfigure(4,minsize=20)
        self.rowconfigure(6,minsize=20)
        self.rowconfigure(8,minsize=20)
        self.rowconfigure(10,minsize=20)

        self.id_ingrediente = customtkinter.CTkEntry(self, width=300)
        self.id_ingrediente.grid(row=0,column=1)
        self.nombre_ingrediente = customtkinter.CTkEntry(self,width=300)
        self.nombre_ingrediente.grid(row=1,column=1)
        self.unidad_medida = customtkinter.CTkEntry(self,width=300)
        self.unidad_medida.grid(row=2,column=1)
        self.valor_unitario = customtkinter.CTkEntry(self,width=300)
        self.valor_unitario.grid(row=3,column=1)

        # Etiqueta cuadros de texto
        self.id_ingrediente_label = customtkinter.CTkLabel(self,text="ID")
        self.id_ingrediente_label.grid(row=0,column=0)      
        self.nombre_ingrediente_label = customtkinter.CTkLabel(self,text="Nombre")
        self.nombre_ingrediente_label.grid(row=1,column=0)
        self.unidad_medida_label = customtkinter.CTkLabel(self,text="Unidad de medida")
        self.unidad_medida_label.grid(row=2,column=0)
        self.valor_unitario_label = customtkinter.CTkLabel(self,text="Valor Unitario")
        self.valor_unitario_label.grid(row=3,column=0)

        self.agregar_ingredientes_btn = customtkinter.CTkButton(self, text="Agregar a la Base de Datos", command=self.agregar_ingredientes)
        self.agregar_ingredientes_btn.grid(row=5,column=0,columnspan=2, ipadx = 50)
        self.mostrar_ingredientes_btn = customtkinter.CTkButton(self, text="Mostrar ingredientes", command=self.mostrar_ingredientes)
        self.mostrar_ingredientes_btn.grid(row=7,column=0,columnspan=2, ipadx = 72)
        self.editar_ingredientes_btn = customtkinter.CTkButton(self,text="Editar ingredientes", command=self.editar_ingredientes)
        self.editar_ingredientes_btn.grid(row=9,column=0,columnspan=2, ipadx = 72)

        # Treeview ingredientes
        columnas = ('ID','Nombre','Stock','Unidad de Medida','Fecha EXP','Valor Unitario')
        self.tree = ttk.Treeview(self,columns=columnas,show='headings')
        self.tree.grid(row=11,column=0,columnspan=2,ipady=100)

        self.tree.column('ID', width=120)
        self.tree.heading('ID', text='ID')
        
        self.tree.column('Nombre', width=120)
        self.tree.heading('Nombre', text='Nombre')

        self.tree.column('Stock', width=120)
        self.tree.heading('Stock', text='Stock') 

        self.tree.column('Unidad de Medida', width=120)
        self.tree.heading('Unidad de Medida', text='Unidad de Medida') 

        self.tree.column('Fecha EXP', width=120)
        self.tree.heading('Fecha EXP', text='Fecha EXP') 

        self.tree.column('Valor Unitario', width=120)
        self.tree.heading('Valor Unitario', text='Valor Unitario') 

        # agregar scrollbar
        scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=11, column=2,ipady=191)

        self.tree.bind('<ButtonRelease-1>', self.rellenar_entrada)

    def agregar_ingredientes(self):
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.ingrediente(id_ingrediente,nombre,u_m,valor_unitario) VALUES(%s,%s,%s,%s)"""
        conn = None

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_agregar = self.id_ingrediente.get()
            nombre_agregar = self.nombre_ingrediente.get()
            u_m_agregar = self.unidad_medida.get()
            valor_unitario_agregar = self.valor_unitario.get()

            if(id_agregar != ""):
                cur.execute(sql,(id_agregar,nombre_agregar,u_m_agregar,valor_unitario_agregar))

            self.id_ingrediente.delete(0,END)
            self.nombre_ingrediente.delete(0,END)
            self.unidad_medida.delete(0,END)
            self.valor_unitario.delete(0,END)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_ingredientes(self):
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT *
            FROM proyecto.ingrediente as i
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
            ingredientes = cur.fetchall()
            
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for ingrediente in ingredientes:
                self.tree.insert('', END, values=ingrediente)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def editar_ingredientes(self):

        sql_ingrediente = """
        UPDATE proyecto.ingrediente as i
        SET nombre = %s, u_m = %s, valor_unitario = %s
        WHERE i.id_ingrediente = %s;
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
            id_agregar = self.id_ingrediente.get()
            nombre_agregar = self.nombre_ingrediente.get()
            u_m_agregar = self.unidad_medida.get()
            valor_unitario_agregar = self.valor_unitario.get()

            if id_agregar != "":
                cur.execute(sql_ingrediente,(nombre_agregar,u_m_agregar,valor_unitario_agregar,id_agregar))


            self.id_ingrediente.delete(0,END)
            self.nombre_ingrediente.delete(0,END)
            self.unidad_medida.delete(0,END)
            self.valor_unitario.delete(0,END)

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

        self.id_ingrediente.delete(0,END)
        self.nombre_ingrediente.delete(0,END)
        self.unidad_medida.delete(0,END)
        self.valor_unitario.delete(0,END)

        try:
            self.id_ingrediente.insert(0,entrada[0])
            self.nombre_ingrediente.insert(0,entrada[1])
            self.unidad_medida.insert(0,entrada[3])
            self.valor_unitario.insert(0,entrada[5])
        except:
            pass    