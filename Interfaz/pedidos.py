import customtkinter
import psycopg2
import tkinter as tk
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from PIL import Image, ImageTk
import os
from config import config

class pedidos(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Pedidos")
        #self.geometry("1140x1170")
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
        self.frame1.rowconfigure(17,minsize=20)

        self.rut = customtkinter.CTkEntry(self.frame1, width=300)
        self.rut.grid(row=0,column=1)

        
        self.rut_label = customtkinter.CTkLabel(self.frame1,text="RUT")
        self.rut_label.grid(row=0,column=0)      

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
        self.tree_pedidos.column('ID Pedido',width=150)
        self.tree_pedidos.heading('RUT', text='RUT')
        self.tree_pedidos.column('RUT',width=150)
        self.tree_pedidos.heading('Estado', text='Estado')
        self.tree_pedidos.column('Estado',width=150)
        self.tree_pedidos.heading('Fecha', text='Fecha')
        self.tree_pedidos.column('Fecha',width=150)

        scrollbar_pedidos = ttk.Scrollbar(self.frame1, orient=tk.VERTICAL, command=self.tree_pedidos.yview)
        self.tree_pedidos.configure(yscroll=scrollbar_pedidos.set)
        scrollbar_pedidos.grid(row=7, column=2,ipady=170)

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

        self.editar_productos_btn = customtkinter.CTkButton(self.frame1, text="Editar producto", 
        command=self.editar_producto)
        self.editar_productos_btn.grid(row=14,column=1, ipadx = 25)

        self.quitar_producto_btn = customtkinter.CTkButton(self.frame1, text="Quitar producto", 
        command=self.quitar_producto)
        self.quitar_producto_btn.grid(row=16,column=1, ipadx = 25)

        # Treeview productos en pedido
        columnas = ('ID Producto','Nombre','Cantidad','Valor')
        self.tree = ttk.Treeview(self.frame1,columns=columnas,show='headings')
        self.tree.grid(row=18,column=0,columnspan=2,ipady=30)
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
        scrollbar.grid(row=18, column=2,ipady=150)

        self.tree.bind('<ButtonRelease-1>', self.rellenar_tree)

        # total
        self.total = customtkinter.CTkLabel(self.frame1,text="Total: ")
        self.total.grid(row=19,column=1,sticky="e")
        # pendiente

        #################################### FRAME 2 ########################################

        self.frame2 = Frame(self)
        self.frame2.grid(row=0,column=1,sticky="nsew")
        self.frame2.rowconfigure(3,minsize=20)
        self.frame2.rowconfigure(5,minsize=20)
        self.frame2.rowconfigure(7,minsize=20)
        
        self.frame2.rowconfigure(10,minsize=20)
        self.frame2.rowconfigure(12,minsize=20)
        self.frame2.rowconfigure(14,minsize=20)
        self.frame2.rowconfigure(16,minsize=20)
        self.frame2.rowconfigure(18,minsize=20)

        ### pedidos delivery ###

        self.delivery = customtkinter.CTkLabel(self.frame2,text="Delivery")
        self.delivery.grid(row=0,column=1)

        # Entry
        #self.id_pedido_delivery = customtkinter.CTkEntry(self.frame2, width=300)
        #self.id_pedido_delivery.grid(row=1,column=1)
        self.direccion_delivery = customtkinter.CTkEntry(self.frame2,width=300)
        self.direccion_delivery.grid(row=2,column=1)

        # Etiqueta cuadros de texto
        #self.id_pedido_delivery_label = customtkinter.CTkLabel(self.frame2,text="ID Pedido")
        #self.id_pedido_delivery_label.grid(row=1,column=0)      
        self.direccion_delivery_label = customtkinter.CTkLabel(self.frame2,text="Direccion")
        self.direccion_delivery_label.grid(row=2,column=0)

        # Boton agregar a la base de datos
        self.agregar_pedido_delivery = customtkinter.CTkButton(self.frame2, text="Generar Pedido Delivery", 
        command=self.agregar_pedido_delivery_f)
        self.agregar_pedido_delivery.grid(row=4,column=1, ipadx = 50)

        # En local

        self.enLocal = customtkinter.CTkLabel(self.frame2,text="En Local")
        self.enLocal.grid(row=6,column=1)

        # Entry
        #self.id_pedido_local = customtkinter.CTkEntry(self.frame2, width=300)
        #self.id_pedido_local.grid(row=8,column=1)
        self.mesa_local = customtkinter.CTkEntry(self.frame2,width=300)
        self.mesa_local.grid(row=9,column=1)

        # Etiqueta cuadros de texto
        #self.id_pedido_local_label = customtkinter.CTkLabel(self.frame2,text="ID Pedido")
        #self.id_pedido_local_label.grid(row=8,column=0)      
        self.mesa_local_label = customtkinter.CTkLabel(self.frame2,text="Mesa")
        self.mesa_local_label.grid(row=9,column=0)

        # 2 botones

        self.agregar_pedido_local = customtkinter.CTkButton(self.frame2, text="Generar Pedido Local", 
        command=self.generar_pedido_local_f)
        self.agregar_pedido_local.grid(row=11,column=1, ipadx = 50)

        self.mostrar_mesa_local = customtkinter.CTkButton(self.frame2, text="Mostrar Mesas", 
        command=self.mostrar_mesas_f)
        self.mostrar_mesa_local.grid(row=13,column=1, ipadx = 50)

        columnas = ('Mesa')
        self.tree_mesas = ttk.Treeview(self.frame2,columns=columnas,show='headings')
        self.tree_mesas.grid(row=15,column=1,ipady=15,ipadx=100)

        self.tree_mesas.heading('Mesa', text='Mesa')

        self.tree_mesas.tag_configure('libre', background='green')
        self.tree_mesas.tag_configure('ocupada', background='red')

        # Estado

        self.actualizar_delivery = customtkinter.CTkButton(self.frame2, text="Completar pedido", 
        command=self.completar_pedido, fg_color="red", text_color="white")
        self.actualizar_delivery.grid(row=19,column=1, ipadx = 50, ipady = 50)
    
    def generar_pedido(self):
        # Consultar usuarios en la base de datos
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
            

            if(rut_agregar != ""):
                cur.callproc('proyecto.agregar_pedido',(rut_agregar,))

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
            ORDER BY p.id_pedido DESC;
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
            cur.callproc('proyecto.precio_producto',())
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
            curItem = self.tree_pedidos.focus()
            entrada = self.tree_pedidos.item(curItem,'values')
            
            id_pedido_agregar = entrada[0]
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
                pedido = list(pedido)
                pedido[3] = pedido[2]*pedido[3]
                self.tree.insert('', END, values=pedido)


            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_total_pedido(id_pedido_agregar)

        except (psycopg2.DatabaseError) as error:
            messagebox.showerror(message=error, title="Error")
        except Exception as error:
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
            curItem = self.tree_pedidos.focus()
            entrada = self.tree_pedidos.item(curItem,'values')

            id_pedido_borrar = entrada[0]
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
                pedido = list(pedido)
                pedido[3] = pedido[2]*pedido[3]
                self.tree.insert('', END, values=pedido)
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_total_pedido(id_pedido_borrar)

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def agregar_pedido_delivery_f(self):
        # Consultar usuarios en la base de datos
        sql = """
        INSERT INTO proyecto.fuera_local(id_pedido,direccion) VALUES(%s,%s)
        """

        conn = None
        curItem = self.tree_pedidos.focus()
        entrada = self.tree_pedidos.item(curItem,'values')

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_pedido_agregar = entrada[0]
            direccion_agregar = self.direccion_delivery.get()

            if(id_pedido_agregar != ""):
                cur.execute(sql,(id_pedido_agregar,direccion_agregar))

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
        commands = (
            """
            SELECT *
            FROM proyecto.mesa as m
            ORDER BY m.num_mesa ASC;
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
            
            mesas = cur.fetchall()
            
            try:
                self.tree_mesas.selection_remove(self.tree_mesas.mesas()[0])
            except:
                pass

            for item in self.tree_mesas.get_children():
                self.tree_mesas.delete(item)

            for mesa in mesas:
                tag = mesa[1];
                print(tag)
                self.tree_mesas.insert('', END, values=mesa, tags=(tag,))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def completar_pedido(self):
        # Consultar usuarios en la base de datos
        sql = """
        UPDATE proyecto.pedido
        SET estado_pedido = 'entregado'
        WHERE id_pedido = %s;
        """

        conn = None
        curItem = self.tree_pedidos.focus()
        entrada = self.tree_pedidos.item(curItem,'values')
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_pedido_actualizar = entrada[0]

            if(id_pedido_actualizar != ""):
                cur.execute(sql,(id_pedido_actualizar,))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

        self.mostrar_pedidos_f()
        self.mostrar_mesas_f()
    
    def rellenar_tree_pedidos(self,event):
        curItem = self.tree_pedidos.focus()
        entrada = self.tree_pedidos.item(curItem,'values')

        self.rut.delete(0,END)

        try:
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
                pedido = list(pedido)
                pedido[3] = pedido[2]*pedido[3]
                self.tree.insert('', END, values=pedido)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_total_pedido(entrada[0])
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
    
    def mostrar_total_pedido(self,id_pedido):
        sql = (
        """
        SELECT p.valor_pedido
        FROM proyecto.pedido as p
        WHERE p.id_pedido = %s;
        """
        )
        conn = None
        self.total.destroy()
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            cur.execute(sql,(id_pedido,))
            
            total_num = cur.fetchall()

            x=str(total_num)
            x=x.replace("[","")
            x=x.replace("]","")
            x=x.replace("(","")
            x=x.replace(")","")
            x=x.replace(",","")

            text = 'Total: ' + x
            self.total = customtkinter.CTkLabel(self.frame1,text=text)
            self.total.grid(row=19,column=1,sticky="e")

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def generar_pedido_local_f(self):
         # Consultar usuarios en la base de datos
        sql1 = """
        INSERT INTO proyecto.en_local(id_pedido) VALUES(%s)
        """
        sql2 = """
        INSERT INTO proyecto.ocupa(num_mesa, id_pedido, RUT) VALUES (%s,%s,%s)

        """

        conn = None

        curItem = self.tree_pedidos.focus()
        entrada = self.tree_pedidos.item(curItem,'values')

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_pedido_agregar = entrada[0]
            mesa_agregar = self.mesa_local.get()
            rut_agregar = self.rut.get()

            if(id_pedido_agregar != ""):
                cur.execute(sql1,(id_pedido_agregar,))
                cur.execute(sql2,(mesa_agregar,id_pedido_agregar,rut_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_mesas_f()

        except (psycopg2.DatabaseError) as error:
            messagebox.showerror(message=error, title="Error")
        except Exception as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def editar_producto(self):
         # Consultar usuarios en la base de datos
        sql = """
        UPDATE proyecto.tiene
        SET cantidad_producto = %s
        WHERE id_pedido = %s AND id_producto = %s;
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
            curItem = self.tree_pedidos.focus()
            entrada = self.tree_pedidos.item(curItem,'values')

            id_pedido_editar = entrada[0]
            id_producto_editar = self.id_producto.get()
            cantidad_editar = self.cantidad.get()

            if(id_pedido_editar != "" and id_producto_editar != ""):
                cur.execute(sql,(cantidad_editar,id_pedido_editar,id_producto_editar))

            cur.execute(sql2,(id_pedido_editar,))
            pedidos = cur.fetchall()
            print(pedidos)
            try:
                self.tree.selection_remove(self.tree.selection()[0])
            except:
                pass

            for item in self.tree.get_children():
                self.tree.delete(item)

            for pedido in pedidos:
                pedido = list(pedido)
                pedido[3] = pedido[2]*pedido[3]
                self.tree.insert('', END, values=pedido)
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_total_pedido(id_pedido_editar)

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()