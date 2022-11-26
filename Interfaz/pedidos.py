import customtkinter
import psycopg2
import tkinter as tk
from tkinter import *
from tkinter import ttk
from PIL import Image, ImageTk
import os
from config import config

class pedidos(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Pedidos")
        self.rowconfigure(2,minsize=20)
        self.rowconfigure(4,minsize=20)
        self.rowconfigure(7,minsize=20)
        self.rowconfigure(9,minsize=20)
        self.rowconfigure(11,minsize=20)
        self.columnconfigure(3,minsize=20)

        # Entry
        self.rut = customtkinter.CTkEntry(self, width=300)
        self.rut.grid(row=0,column=1)
        self.id_pedido = customtkinter.CTkEntry(self,width=300)
        self.id_pedido.grid(row=1,column=1)

        # Etiqueta cuadros de texto
        self.rut_label = customtkinter.CTkLabel(self,text="RUT")
        self.rut_label.grid(row=0,column=0)      
        self.id_pedido_label = customtkinter.CTkLabel(self,text="ID Pedido")
        self.id_pedido_label.grid(row=1,column=0)

        # Boton agregar a la base de datos
        self.agregar_pedidos_btn = customtkinter.CTkButton(self, text="Generar Pedido", command=self.generar_pedido)
        self.agregar_pedidos_btn.grid(row=3,column=1, ipadx = 50)


        ##### Agregar productos al pedido #####

        self.id_producto = customtkinter.CTkEntry(self, width=300)
        self.id_producto.grid(row=5,column=1)
        self.cantidad = customtkinter.CTkEntry(self,width=300)
        self.cantidad.grid(row=6,column=1)

        # Etiqueta cuadros de texto
        self.id_producto_label = customtkinter.CTkLabel(self,text="ID Producto")
        self.id_producto_label.grid(row=5,column=0)      
        self.cantidad_label = customtkinter.CTkLabel(self,text="Cantidad")
        self.cantidad_label.grid(row=6,column=0)

        # Boton agregar a la base de datos
        self.agregar_pedidos_btn = customtkinter.CTkButton(self, text="Agregar producto", 
        command=self.agregar_producto)
        self.agregar_pedidos_btn.grid(row=8,column=1, ipadx = 25)

        self.agregar_pedidos_btn = customtkinter.CTkButton(self, text="Quitar producto", 
        command=self.quitar_producto)
        self.agregar_pedidos_btn.grid(row=10,column=1, ipadx = 25)

        # Treeview productos en pedido
        
        columnas = ('ID Producto','Nombre','Cantidad','Valor')
        self.tree = ttk.Treeview(self,columns=columnas,show='headings')
        self.tree.grid(row=12,column=0,columnspan=2,ipady=100)

        self.tree.heading('ID Producto', text='ID Producto')
        self.tree.column('ID Producto',width=100)
        self.tree.heading('Nombre', text='Nombre')
        self.tree.column('Nombre',width=100)
        self.tree.heading('Cantidad', text='Cantidad')
        self.tree.column('Cantidad',width=150)
        self.tree.heading('Valor', text='Valor') 
        self.tree.column('Valor',width=150)

        # add a scrollbar
        scrollbar = ttk.Scrollbar(self, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=12, column=2,ipady=191)

        # total

        # pendiente

        ### pedidos en local ###

        self.enLocal = customtkinter.CTkLabel(self,text="Pedido en Local")
        self.enLocal.grid(row=0,column=5)

        # Entry
        self.id_pedido_local = customtkinter.CTkEntry(self, width=300)
        self.id_pedido_local.grid(row=1,column=5)
        self.mesa_local = customtkinter.CTkEntry(self,width=300)
        self.mesa_local.grid(row=2,column=5)

        # Etiqueta cuadros de texto
        self.id_pedido_local_label = customtkinter.CTkLabel(self,text="RUT")
        self.id_pedido_local_label.grid(row=1,column=4)      
        self.mesa_local_label = customtkinter.CTkLabel(self,text="ID Pedido")
        self.mesa_local_label.grid(row=2,column=4)

        # Boton agregar a la base de datos
        self.agregar_pedido_local = customtkinter.CTkButton(self, text="Generar Pedido Local", 
        command=self.agregar_pedido_f)
        self.agregar_pedido_local.grid(row=4,column=5, ipadx = 50)

        self.mostrar_mesas_local = customtkinter.CTkButton(self, text="Mostrar Mesa",
        command=self.mostrar_mesas_f)
        self.mostrar_mesas_local.grid(row=6,column=5,ipadx=50)

        # Treeview mesas
        self.tree_mesas = ttk.Treeview(self)
        self.tree_mesas.grid(row=7,column=4,columnspan=2, rowspan= 4,ipady=50, ipadx=100)

    def generar_pedido(self):
        pass

    def agregar_producto(self):
        pass

    def quitar_producto(self):
        pass

    def agregar_pedido_f(self):
        pass

    def mostrar_mesas_f(self):
        pass