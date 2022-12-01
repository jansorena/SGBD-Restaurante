import customtkinter
import psycopg2
import tkinter as tk
from config import config
from tkinter import *
from tkinter import ttk

class clientes(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Clientes")
        #self.geometry("700x500")
        self.rowconfigure(3,minsize=20)
        self.rowconfigure(5,minsize=20)
        self.rowconfigure(7,minsize=20)
        self.rowconfigure(9,minsize=20)
        self.columnconfigure(3,minsize=10)

        # Cuadros de texto
        self.rut = customtkinter.CTkEntry(self, width=300)
        self.rut.grid(row=0,column=1)
        self.nombre = customtkinter.CTkEntry(self,width=300)
        self.nombre.grid(row=1,column=1)
        self.apellido = customtkinter.CTkEntry(self,width=300)
        self.apellido.grid(row=2,column=1)

        # Etiqueta cuadros de texto
        self.rut_label = customtkinter.CTkLabel(self,text="RUT")
        self.rut_label.grid(row=0,column=0)      
        self.nombre_label = customtkinter.CTkLabel(self,text="Nombre")
        self.nombre_label.grid(row=1,column=0)
        self.apellido_label = customtkinter.CTkLabel(self,text="Apellido")
        self.apellido_label.grid(row=2,column=0)

        # Boton agregar a la base de datos
        self.agregar_clientes_btn = customtkinter.CTkButton(self, text="Agregar a la Base de Datos", command=self.agregar_clientes)
        self.agregar_clientes_btn.grid(row=4,column=0,columnspan=2, ipadx = 50)
        self.mostrar_clientes_btn = customtkinter.CTkButton(self, text="Mostrar clientes", command=self.mostrar_clientes)
        self.mostrar_clientes_btn.grid(row=6,column=0,columnspan=2, ipadx = 72)
        self.editar_clientes_btn = customtkinter.CTkButton(self,text="Editar cliente", command=self.editar_clientes)
        self.editar_clientes_btn.grid(row=8,column=0,columnspan=2, ipadx = 72)
        

        
        # Treeview clientes
        columnas = ('RUT','Nombre','Apellido')
        self.tree = ttk.Treeview(self,columns=columnas,show='headings')
        self.tree.grid(row=10,column=0,columnspan=2,ipady=130)

        self.tree.heading('RUT', text='RUT')
        self.tree.heading('Nombre', text='Nombre')
        self.tree.heading('Apellido', text='Apellido') 

        # add a scrollbar
        scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=10, column=2,ipady=220)

        # Treeview pedidos
        columnas_pedidos = ('id_pedido','valor_pedido','estado_pedido','fecha_pedido')

        self.tree_pedidos = ttk.Treeview(self,columns=columnas_pedidos,show='headings')
        self.tree_pedidos.grid(row=1,column=4,rowspan=10, ipady=250, ipadx=10)
        self.tree_pedidos.column('id_pedido',width=150)
        self.tree_pedidos.heading('id_pedido', text='ID')
        self.tree_pedidos.column('valor_pedido',width=150)
        self.tree_pedidos.heading('valor_pedido', text='Valor')
        self.tree_pedidos.column('estado_pedido',width=150)
        self.tree_pedidos.heading('estado_pedido', text='Estado')
        self.tree_pedidos.column('fecha_pedido',width=150)
        self.tree_pedidos.heading('fecha_pedido', text='Fecha')
    
        self.pedido_label = customtkinter.CTkLabel(self,text="Pedidos")
        self.pedido_label.grid(row=0,column=4)     

        # add a scrollbar
        scrollbar_pedidos = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree_pedidos.yview)
        self.tree_pedidos.configure(yscroll=scrollbar.set)
        scrollbar_pedidos.grid(row=1, column=5,ipady=220,rowspan=10)

        #mostrar_pedidos
        self.tree.bind('<ButtonRelease-1>', self.mostrar_pedidos)
   
    def editar_clientes(self):
        sql_nombre = """
        UPDATE proyecto.persona as pe
        SET nombre = %s
        FROM proyecto.cliente as cl
        WHERE cl.rut = %s AND pe.rut = cl.rut;
        """

        sql_apellido ="""
        UPDATE proyecto.persona as pe
        SET apellido = %s
        FROM proyecto.cliente as cl
        WHERE cl.rut = %s AND pe.rut = cl.rut;
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

            if rut_agregar != "" and nombre_agregar != "":
                cur.execute(sql_nombre,(nombre_agregar,rut_agregar))

            if rut_agregar != "" and apellido_agregar != "":
                cur.execute(sql_apellido,(apellido_agregar,rut_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def agregar_clientes(self):
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.persona(rut,nombre,apellido) VALUES(%s,%s,%s)"""
        sql2 = """INSERT INTO proyecto.cliente(rut) VALUES(%s)"""
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

            if(rut_agregar != ""):
                cur.execute(sql,(rut_agregar,nombre_agregar,apellido_agregar))
                cur.execute(sql2,(rut_agregar,))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_clientes(self):

        self.rut.delete(0,END)
        self.nombre.delete(0,END)
        self.apellido.delete(0,END)
        
        for item in self.tree_pedidos.get_children():
                self.tree_pedidos.delete(item)
        
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT *
            FROM proyecto.cliente as c
            ORDER BY c.rut;
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
            
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for usuario in usuarios:
                self.tree.insert('', END, values=usuario)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_pedidos(self,event):
        curItem = self.tree.focus()
        rut = self.tree.item(curItem,'values')
        
        self.rut.delete(0,END)
        self.nombre.delete(0,END)
        self.apellido.delete(0,END)

        try:
            self.rut.insert(0,rut[0])
            self.nombre.insert(0,rut[1]) 
            self.apellido.insert(0,rut[2])
        except:
            pass

        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT pe.id_pedido, pe.valor_pedido, pe.estado_pedido, pe.fecha_pedido
            FROM proyecto.pedido as pe, proyecto.cliente as c
            WHERE c.rut = %s and c.rut = pe.rut
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
            cur.execute(commands,(rut[0],))
            pedidos = cur.fetchall()

            for item in self.tree_pedidos.get_children():
                self.tree_pedidos.delete(item)

            for pedido in pedidos:
                self.tree_pedidos.insert('', END, values=pedido)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()