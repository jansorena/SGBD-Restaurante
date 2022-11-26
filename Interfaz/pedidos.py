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

        #################################### FRAME 1 ########################################
        self.frame1 = Frame(self)
        self.frame1.grid(row=0,column=0,sticky="nsew")
        self.frame1.rowconfigure(2,minsize=20)
        self.frame1.rowconfigure(4,minsize=20)
        self.frame1.rowconfigure(7,minsize=20)
        self.frame1.rowconfigure(9,minsize=20)
        self.frame1.rowconfigure(11,minsize=20)
        self.frame1.rowconfigure(13,minsize=20)

        # Entry
        self.rut = customtkinter.CTkEntry(self.frame1, width=300)
        self.rut.grid(row=0,column=1)
        self.id_pedido = customtkinter.CTkEntry(self.frame1,width=300)
        self.id_pedido.grid(row=1,column=1)
        self.id_producto = customtkinter.CTkEntry(self.frame1, width=300)
        self.id_producto.grid(row=5,column=1)
        self.cantidad = customtkinter.CTkEntry(self.frame1,width=300)
        self.cantidad.grid(row=6,column=1)

        # Etiqueta cuadros de texto
        self.rut_label = customtkinter.CTkLabel(self.frame1,text="RUT")
        self.rut_label.grid(row=0,column=0)      
        self.id_pedido_label = customtkinter.CTkLabel(self.frame1,text="ID Pedido")
        self.id_pedido_label.grid(row=1,column=0)
        self.id_producto_label = customtkinter.CTkLabel(self.frame1,text="ID Producto")
        self.id_producto_label.grid(row=5,column=0)      
        self.cantidad_label = customtkinter.CTkLabel(self.frame1,text="Cantidad")
        self.cantidad_label.grid(row=6,column=0)

        # Botones
        self.generar_pedido_btn = customtkinter.CTkButton(self.frame1, text="Generar Pedido", 
        command=self.generar_pedido)
        self.generar_pedido_btn.grid(row=3,column=1, ipadx = 50)

        self.agregar_productos_btn = customtkinter.CTkButton(self.frame1, text="Agregar producto", 
        command=self.agregar_producto)
        self.agregar_productos_btn.grid(row=8,column=1, ipadx = 25)

        self.quitar_producto_btn = customtkinter.CTkButton(self.frame1, text="Quitar producto", 
        command=self.quitar_producto)
        self.quitar_producto_btn.grid(row=10,column=1, ipadx = 25)

        # Treeview productos en pedido
        columnas = ('ID Producto','Nombre','Cantidad','Valor')
        self.tree = ttk.Treeview(self.frame1,columns=columnas,show='headings')
        self.tree.grid(row=12,column=0,columnspan=2,ipady=100)
        self.tree.heading('ID Producto', text='ID Producto')
        self.tree.column('ID Producto',width=100)
        self.tree.heading('Nombre', text='Nombre')
        self.tree.column('Nombre',width=100)
        self.tree.heading('Cantidad', text='Cantidad')
        self.tree.column('Cantidad',width=150)
        self.tree.heading('Valor', text='Valor') 
        self.tree.column('Valor',width=150)

        scrollbar = ttk.Scrollbar(self.frame1, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=12, column=2,ipady=191)

        # total
        self.total = customtkinter.CTkLabel(self.frame1,text="Total: ")
        self.total.grid(row=14,column=1,sticky="e")
        # pendiente

        #################################### FRAME 2 ########################################

        self.frame2 = Frame(self)
        self.frame2.grid(row=0,column=1,sticky="nsew")
        self.frame2.rowconfigure(3,minsize=20)
        self.frame2.rowconfigure(5,minsize=20)
        self.frame2.rowconfigure(7,minsize=20)
        self.frame2.rowconfigure(9,minsize=20)
        self.frame2.rowconfigure(11,minsize=20)
        self.frame2.rowconfigure(14,minsize=20)
        self.frame2.rowconfigure(16,minsize=20)
        self.frame2.rowconfigure(18,minsize=20)

        ### pedidos delivery ###

        self.delivery = customtkinter.CTkLabel(self.frame2,text="Delivery")
        self.delivery.grid(row=0,column=1)

        # Entry
        self.id_pedido_delivery = customtkinter.CTkEntry(self.frame2, width=300)
        self.id_pedido_delivery.grid(row=1,column=1)
        self.direccion_delivery = customtkinter.CTkEntry(self.frame2,width=300)
        self.direccion_delivery.grid(row=2,column=1)

        # Etiqueta cuadros de texto
        self.id_pedido_delivery_label = customtkinter.CTkLabel(self.frame2,text="ID Pedido")
        self.id_pedido_delivery_label.grid(row=1,column=0)      
        self.direccion_delivery_label = customtkinter.CTkLabel(self.frame2,text="Direccion")
        self.direccion_delivery_label.grid(row=2,column=0)

        # Boton agregar a la base de datos
        self.agregar_pedido_delivery = customtkinter.CTkButton(self.frame2, text="Generar Pedido Delivery", 
        command=self.agregar_pedido_delivery_f)
        self.agregar_pedido_delivery.grid(row=4,column=1, ipadx = 50)

        # Estado
        self.estado_delivery = customtkinter.CTkEntry(self.frame2, width=300)
        self.estado_delivery.grid(row=6,column=1)

        self.estado_delivery_label = customtkinter.CTkLabel(self.frame2,text="Estado")
        self.estado_delivery_label.grid(row=6,column=0)

        self.actualizar_delivery = customtkinter.CTkButton(self.frame2, text="Actualizar estado", 
        command=self.actualizar_delivery_f)
        self.actualizar_delivery.grid(row=8,column=1, ipadx = 50)

        # En local

        self.enLocal = customtkinter.CTkLabel(self.frame2,text="En Local")
        self.enLocal.grid(row=10,column=1)

        # Entry
        self.id_pedido_local = customtkinter.CTkEntry(self.frame2, width=300)
        self.id_pedido_local.grid(row=12,column=1)
        self.mesa_local = customtkinter.CTkEntry(self.frame2,width=300)
        self.mesa_local.grid(row=13,column=1)

        # Etiqueta cuadros de texto
        self.id_pedido_local_label = customtkinter.CTkLabel(self.frame2,text="ID Pedido")
        self.id_pedido_local_label.grid(row=12,column=0)      
        self.mesa_local_label = customtkinter.CTkLabel(self.frame2,text="Mesa")
        self.mesa_local_label.grid(row=13,column=0)

        # 2 botones

        self.agregar_pedido_local = customtkinter.CTkButton(self.frame2, text="Generar Pedido Local", 
        command=self.agregar_pedido_delivery_f)
        self.agregar_pedido_local.grid(row=15,column=1, ipadx = 50)

        self.mostrar_mesa_local = customtkinter.CTkButton(self.frame2, text="Mostrar Mesas", 
        command=self.agregar_pedido_delivery_f)
        self.mostrar_mesa_local.grid(row=17,column=1, ipadx = 50)

        columnas = ('Mesa')
        self.tree_mesas = ttk.Treeview(self.frame2,columns=columnas,show='headings')
        self.tree_mesas.grid(row=19,column=1,ipady=15,ipadx=100)

        self.tree_mesas.heading('Mesa', text='Mesa')


    def generar_pedido(self):
        pass

    def agregar_producto(self):
        pass

    def quitar_producto(self):
        pass

    def agregar_pedido_delivery_f(self):
        pass

    def mostrar_mesas_f(self):
        pass

    def actualizar_delivery_f(self):
        pass