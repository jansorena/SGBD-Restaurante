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
        self.frame1.rowconfigure(6,minsize=20)
        self.frame1.rowconfigure(8,minsize=20)
        self.frame1.rowconfigure(11,minsize=20)
        self.frame1.rowconfigure(13,minsize=20)
        self.frame1.rowconfigure(15,minsize=20)

        self.rut = customtkinter.CTkEntry(self.frame1, width=300)
        self.rut.grid(row=0,column=1)
        self.id_pedido = customtkinter.CTkEntry(self.frame1,width=300)
        self.id_pedido.grid(row=1,column=1)
        
        self.rut_label = customtkinter.CTkLabel(self.frame1,text="RUT")
        self.rut_label.grid(row=0,column=0)      
        self.id_pedido_label = customtkinter.CTkLabel(self.frame1,text="ID Pedido")
        self.id_pedido_label.grid(row=1,column=0)

        self.generar_pedido_btn = customtkinter.CTkButton(self.frame1, text="Generar Pedido", 
        command=self.generar_pedido)
        self.generar_pedido_btn.grid(row=3,column=1, ipadx = 50)

        self.mostrar_pedido_btn = customtkinter.CTkButton(self.frame1, text="Mostrar Pedidos", 
        command=self.mostrar_pedidos_f)
        self.mostrar_pedido_btn.grid(row=5,column=1, ipadx=50)

        columnas_pedidos = ('ID Pedido','RUT','Estado','Fecha')
        self.tree_pedidos = ttk.Treeview(self.frame1,columns=columnas_pedidos,show='headings')
        self.tree_pedidos.grid(row=7,column=0,columnspan=2,ipady=50)
        self.tree_pedidos.heading('ID Pedido', text='ID Pedido')
        self.tree_pedidos.column('ID Pedido',width=100)
        self.tree_pedidos.heading('RUT', text='RUT')
        self.tree_pedidos.column('RUT',width=100)
        self.tree_pedidos.heading('Estado', text='Estado')
        self.tree_pedidos.column('Estado',width=150)
        self.tree_pedidos.heading('Fecha', text='Fecha')
        self.tree_pedidos.column('Fecha',width=150)

        scrollbar_pedidos = ttk.Scrollbar(self.frame1, orient=tk.VERTICAL, command=self.tree_pedidos.yview)
        self.tree_pedidos.configure(yscroll=scrollbar_pedidos.set)
        scrollbar_pedidos.grid(row=7, column=2,ipady=100)

        self.tree_pedidos.bind('<ButtonRelease-1>', self.rellenar_tree_pedidos)

        ###############################
        self.id_producto = customtkinter.CTkEntry(self.frame1, width=300)
        self.id_producto.grid(row=9,column=1)
        self.cantidad = customtkinter.CTkEntry(self.frame1,width=300)
        self.cantidad.grid(row=10,column=1)

        self.id_producto_label = customtkinter.CTkLabel(self.frame1,text="ID Producto")
        self.id_producto_label.grid(row=9,column=0)      
        self.cantidad_label = customtkinter.CTkLabel(self.frame1,text="Cantidad")
        self.cantidad_label.grid(row=10,column=0)


        self.agregar_productos_btn = customtkinter.CTkButton(self.frame1, text="Agregar producto", 
        command=self.agregar_producto)
        self.agregar_productos_btn.grid(row=12,column=1, ipadx = 25)

        self.quitar_producto_btn = customtkinter.CTkButton(self.frame1, text="Quitar producto", 
        command=self.quitar_producto)
        self.quitar_producto_btn.grid(row=14,column=1, ipadx = 25)

        # Treeview productos en pedido
        columnas = ('ID Producto','Nombre','Cantidad','Valor')
        self.tree = ttk.Treeview(self.frame1,columns=columnas,show='headings')
        self.tree.grid(row=16,column=0,columnspan=2,ipady=100)
        self.tree.heading('ID Producto', text='ID Producto')
        self.tree.column('ID Producto',width=150)
        self.tree.heading('Nombre', text='Nombre')
        self.tree.column('Nombre',width=150)
        self.tree.heading('Cantidad', text='Cantidad')
        self.tree.column('Cantidad',width=150)
        self.tree.heading('Valor', text='Valor') 
        self.tree.column('Valor',width=150)

        scrollbar = ttk.Scrollbar(self.frame1, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=16, column=2,ipady=191)

        self.tree.bind('<ButtonRelease-1>', self.rellenar_tree)

        # total
        self.total = customtkinter.CTkLabel(self.frame1,text="Total: ")
        self.total.grid(row=17,column=1,sticky="e")
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
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.pedido(id_pedido,RUT) VALUES(%s,%s)"""
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
            id_pedido_agregar = self.id_pedido.get()

            if(rut_agregar != "" and id_pedido_agregar != ""):
                cur.execute(sql,(id_pedido_agregar,rut_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_pedidos_f()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
    
    def mostrar_pedidos_f(self):
        commands = (
            """
            SELECT p.id_pedido, p.RUT, p.estado_pedido, p.fecha_pedido
            FROM proyecto.pedido as p
            ORDER BY p.fecha_pedido DESC;
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
            pedidos = cur.fetchall()
            
            try:
                self.tree_pedidos.selection_remove(self.tree_pedidos.selection()[0])
            except:
                pass

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
    
    def agregar_producto(self):
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.tiene(id_pedido,id_producto,cantidad_producto) VALUES(%s,%s,%s)"""
        sql2 = (
            """
            SELECT t.id_producto, pr.nombre, t.cantidad_producto, pr.valor_producto
            FROM proyecto.pedido as p, proyecto.tiene as t, proyecto.producto as pr
            WHERE p.id_pedido = %s AND p.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto;
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
            id_pedido_agregar = self.id_pedido.get()
            id_producto_agregar = self.id_producto.get()
            cantidad_agregar = self.cantidad.get()

            if(id_producto_agregar != "" and id_pedido_agregar != ""):
                cur.execute(sql,(id_pedido_agregar,id_producto_agregar,cantidad_agregar))

            cur.execute(sql2,(id_pedido_agregar,))
            pedidos = cur.fetchall()
            print(pedidos)
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for pedido in pedidos:
                self.tree.insert('', END, values=pedido)


            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
    
    def quitar_producto(self):
        # Consultar usuarios en la base de datos
        sql = """
        DELETE FROM proyecto.tiene as t
        WHERE t.id_pedido = %s AND t.id_producto = %s;
        """

        sql2 = (
            """
            SELECT t.id_producto, pr.nombre, t.cantidad_producto, pr.valor_producto
            FROM proyecto.pedido as p, proyecto.tiene as t, proyecto.producto as pr
            WHERE p.id_pedido = %s AND p.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto;
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
            id_pedido_borrar = self.id_pedido.get()
            id_producto_borrar = self.id_producto.get()

            if(id_pedido_borrar != ""):
                cur.execute(sql,(id_pedido_borrar,id_producto_borrar))

            cur.execute(sql2,(id_pedido_borrar,))
            pedidos = cur.fetchall()
            print(pedidos)
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for pedido in pedidos:
                self.tree.insert('', END, values=pedido)
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def agregar_pedido_delivery_f(self):
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.fuera_local(id_pedido) VALUES(%s,%s)"""

        conn = None

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_pedido_agregar = self.id_pedido.get()

            if(id_pedido_agregar != ""):
                cur.execute(sql,(id_pedido_agregar,))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_mesas_f(self):
        pass

    def actualizar_delivery_f(self):
        pass
    
    def rellenar_tree_pedidos(self,event):
        curItem = self.tree_pedidos.focus()
        entrada = self.tree_pedidos.item(curItem,'values')

        self.rut.delete(0,END)
        self.id_pedido.delete(0,END)

        try:
            self.id_pedido.insert(0,entrada[0]) 
            self.rut.insert(0,entrada[1])
        except:
            pass

        commands = (
            """
            SELECT t.id_producto, pr.nombre, t.cantidad_producto, pr.valor_producto
            FROM proyecto.pedido as p, proyecto.tiene as t, proyecto.producto as pr
            WHERE p.id_pedido = %s AND p.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto;
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
            cur.execute(commands,(entrada[0],))
            pedidos = cur.fetchall()
            print(pedidos)
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for pedido in pedidos:
                self.tree.insert('', END, values=pedido)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def rellenar_tree(self,event):
        curItem = self.tree.focus()
        entrada = self.tree.item(curItem,'values')

        self.id_producto.delete(0,END)
        self.cantidad.delete(0,END)

        try:
            self.id_producto.insert(0,entrada[0]) 
            self.cantidad.insert(0,entrada[2])
        except:
            pass
    
    def mostrar_productos_2(self):
        pass