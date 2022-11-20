import customtkinter
import psycopg2
import tkinter as tk
from tkinter import *
from tkinter import ttk
from PIL import Image, ImageTk
import os
from config import config


PATH = os.path.dirname(os.path.realpath(__file__))

class productos(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Productos")
        self.rowconfigure(1,minsize=20)
        self.rowconfigure(6,minsize=20)
        self.rowconfigure(8,minsize=20)
        self.rowconfigure(10,minsize=20)
        self.rowconfigure(12,minsize=20)
        self.columnconfigure(3,minsize=10)

         # Cuadros de texto
        self.id_producto = customtkinter.CTkEntry(self, width=300)
        self.id_producto.grid(row=2,column=1)
        self.nombre = customtkinter.CTkEntry(self,width=300)
        self.nombre.grid(row=3,column=1)
        self.porc_ganancia = customtkinter.CTkEntry(self,width=300)
        self.porc_ganancia.grid(row=4,column=1)
        self.tmp_preparacion = customtkinter.CTkEntry(self,width=300)
        self.tmp_preparacion.grid(row=5,column=1)

        # Etiqueta cuadros de texto
        self.id_producto_label = customtkinter.CTkLabel(self,text="ID")
        self.id_producto_label.grid(row=2,column=0)      
        self.nombre_label = customtkinter.CTkLabel(self,text="Nombre")
        self.nombre_label.grid(row=3,column=0)
        self.porc_ganancia_label = customtkinter.CTkLabel(self,text="Porcentaje Ganancia")
        self.porc_ganancia_label.grid(row=4,column=0)
        self.tmp_preparacion_label = customtkinter.CTkLabel(self,text="Tiempo Preparacion")
        self.tmp_preparacion_label.grid(row=5,column=0)

         # Boton agregar a la base de datos
        self.agregar_productos_btn = customtkinter.CTkButton(self, text="Agregar a la Base de Datos", command=self.agregar_productos)
        self.agregar_productos_btn.grid(row=7,column=1, ipadx = 50)
        self.mostrar_productos_btn = customtkinter.CTkButton(self, text="Mostrar productos", command=self.mostrar_productos)
        self.mostrar_productos_btn.grid(row=9,column=1, ipadx = 72)
        self.editar_productos_btn = customtkinter.CTkButton(self,text="Editar productos", command=self.editar_productos)
        self.editar_productos_btn.grid(row=11,column=1, ipadx = 72)

        # Treeview clientes
        columnas = ('ID','Nombre','Valor','Porcentaje Ganancia','Tiempo Preparacion')
        self.tree = ttk.Treeview(self,columns=columnas,show='headings')
        self.tree.grid(row=13,column=0,columnspan=2,ipady=100)

        self.tree.heading('ID', text='ID')
        self.tree.column('ID',width=100)
        self.tree.heading('Nombre', text='Nombre')
        self.tree.column('Nombre',width=100)
        self.tree.heading('Valor', text='Valor')
        self.tree.column('Valor',width=150)
        self.tree.heading('Porcentaje Ganancia', text='Porcentaje Ganancia') 
        self.tree.column('Porcentaje Ganancia',width=150)
        self.tree.heading('Tiempo Preparacion', text='Tiempo Preparacion') 
        self.tree.column('Tiempo Preparacion',width=150)

        # add a scrollbar
        scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=13, column=2,ipady=191)

        # Treeview ingredientes
        columnas_ingredientes = ('id_ingrediente','nombre_ingrediente','cantidad_ingrediente')

        self.tree_ingredientes = ttk.Treeview(self,columns=columnas_ingredientes,show='headings')
        self.tree_ingredientes.grid(row=13,column=4,columnspan=2, ipady=100)
        self.tree_ingredientes.column('id_ingrediente',width=150)
        self.tree_ingredientes.heading('id_ingrediente', text='ID')
        self.tree_ingredientes.column('nombre_ingrediente',width=150)
        self.tree_ingredientes.heading('nombre_ingrediente', text='Nombre')
        self.tree_ingredientes.column('cantidad_ingrediente',width=150)
        self.tree_ingredientes.heading('cantidad_ingrediente', text='Cantidad')
    
        #self.pedido_label = customtkinter.CTkLabel(self,text="Ingredientes")
        #self.pedido_label.grid(row=0,column=4)     

        # add a scrollbar
        scrollbar_ingredientes = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree_ingredientes.yview)
        self.tree_ingredientes.configure(yscroll=scrollbar.set)
        scrollbar_ingredientes.grid(row=13, column=6,ipady=191)

        self.tree.bind('<ButtonRelease-1>', self.mostrar_ingredientes)

        # ingredientes
        self.id_ingrediente = customtkinter.CTkEntry(self, width=300)
        self.id_ingrediente.grid(row=2,column=5)
        self.cantidad_ingrediente = customtkinter.CTkEntry(self,width=300)
        self.cantidad_ingrediente.grid(row=3,column=5)

        self.id_ingrediente_label = customtkinter.CTkLabel(self,text="ID Ingrediente")
        self.id_ingrediente_label.grid(row=2,column=4)      
        self.cantidad_ingrediente_label = customtkinter.CTkLabel(self,text="Cantidad")
        self.cantidad_ingrediente_label.grid(row=3,column=4)

        # Boton agregar a la base de datos
        self.agregar_ingredientes_btn = customtkinter.CTkButton(self, text="Agregar Ingredientes", command=self.agregar_ingredientes)
        self.agregar_ingredientes_btn.grid(row=7,column=4,columnspan=2, ipadx = 50)
        self.editar_ingredientes_btn = customtkinter.CTkButton(self, text="Editar Ingredientes", command=self.editar_ingredientes)
        self.editar_ingredientes_btn.grid(row=9,column=4,columnspan=2, ipadx = 72)

        self.img = self.load_image("/images/hamburguer.jpeg", 170)
        self.img_label = customtkinter.CTkLabel(self,image=self.img, borderwidth=2, relief='solid')
        self.img_label.grid(row=0,column=0,columnspan=2)

    def agregar_productos(self):
        pass

    def mostrar_productos(self):
        self.id_producto.delete(0,END)
        self.nombre.delete(0,END)
        self.porc_ganancia.delete(0,END)
        self.tmp_preparacion.delete(0,END)
        
        for item in self.tree.get_children():
            self.tree.delete(item)
        
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT *
            FROM proyecto.producto as p
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
            productos = cur.fetchall()

            for producto in productos:
                self.tree.insert('', END, values=producto)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def editar_productos(self):
        pass

    def mostrar_ingredientes(self,event):

        curItem = self.tree.focus()
        ingred = self.tree.item(curItem,'values')
       
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT c.id_ingrediente, i.nombre, c.cantidad_ingrediente
            FROM proyecto.producto as pr, proyecto.ingrediente as i, proyecto.compone as c
            WHERE pr.id_producto = %s and pr.id_producto = c.id_producto and c.id_ingrediente = i.id_ingrediente
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
            cur.execute(commands,(ingred[0],))
            ingred_productos = cur.fetchall()

            for item in self.tree_ingredientes.get_children():
                self.tree_ingredientes.delete(item)

            for ingred_producto in ingred_productos:
                self.tree_ingredientes.insert('', END, values=ingred_producto)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def agregar_ingredientes(self):
        pass

    def editar_ingredientes(self):
        pass

    def load_image(self, path, image_size):
        """ load rectangular image with path relative to PATH """
        return ImageTk.PhotoImage(Image.open(PATH + path).resize((image_size, image_size)))