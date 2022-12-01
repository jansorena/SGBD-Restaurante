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
        self.tree_ingredientes.bind('<ButtonRelease-1>', self.click_ingredientes)

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

        self.hamburguesa1 = self.load_image("/images/Hamburguesa1.jpeg", 170)
        self.hamburguesa2 = self.load_image("/images/Hamburguesa2.jpeg", 170)
        self.aceite = self.load_image("/images/aceite.jpg", 170)
        self.barrosluco = self.load_image("/images/Barros Luco.png", 170)
        self.carne = self.load_image("/images/carne.jpg", 170)
        self.cebollamorada = self.load_image("/images/cebolla morada.jpg", 170)
        self.chucrut = self.load_image("/images/chucrut.jpg", 170)
        self.cocacola15 = self.load_image("/images/coca-cola 1.5L.jpg", 170)
        #self.cocacolaL = self.load_image("/images/coca-cola litro.webp", 170)
        self.cocacola = self.load_image("/images/coca-cola.png", 170)
        self.completohasqueso = self.load_image("/images/Completo has queso.png", 170)
        self.completohas = self.load_image("/images/completo has.jpg", 170)
        self.completoitaliano = self.load_image("/images/Completo Italiano.png", 170)
        self.fanta15 = self.load_image("/images/fanta 1.5L.png", 170)
        self.fantaL = self.load_image("/images/fanta litro.jpg", 170)
        self.fanta = self.load_image("/images/fanta.jpg", 170)
        self.hamburguesaitaliana = self.load_image("/images/Hamburguesa Italiana.png", 170)
        self.huevo = self.load_image("/images/huevo.jpg", 170)
        self.kem15 = self.load_image("/images/kem 1.5L.jpg", 170)
        self.kemL = self.load_image("/images/kem litro.jpeg", 170)
        self.kem = self.load_image("/images/kem.png", 170)
        self.ketchup = self.load_image("/images/ketchup.jpg", 170)
        self.lechuga = self.load_image("/images/lechuga.jpg", 170)
        self.lomo = self.load_image("/images/lomo.jpg", 170)
        self.mayonesa = self.load_image("/images/mayonesa.jpg", 170)
        self.mostaza = self.load_image("/images/mostaza.png", 170)
        self.palta = self.load_image("/images/palta.jpg", 170)
        self.pancompleto = self.load_image("/images/pan completo.jpg", 170)
        self.pan = self.load_image("/images/Pan.jpeg", 170)
        self.papasfritaschica = self.load_image("/images/Papas fritas chica.png", 170)
        self.papasfritasfamiliar = self.load_image("/images/Papas fritas familiar.png", 170)
        self.papasfritasgrande = self.load_image("/images/Papas fritas grande.jpg", 170)
        self.papasprefritas = self.load_image("/images/papas prefritas.jpg", 170)
        self.pichangacalientefamiliar = self.load_image("/images/Pichanga caliente familiar.png", 170)
        self.pichangacalientemediana = self.load_image("/images/Pichanga caliente mediana.jpg", 170)
        self.pichangacalientepara2 = self.load_image("/images/Pichanga caliente para 2.jpg", 170)
        self.pollo = self.load_image("/images/pollo.jpg", 170)
        self.queso = self.load_image("/images/queso.jpg", 170)
        self.sal = self.load_image("/images/sal.png", 170)
        self.sprite15 = self.load_image("/images/sprite 1.5L.png", 170)
        self.spriteL = self.load_image("/images/sprite litro.jpg", 170)
        self.sprite = self.load_image("/images/sprite.png", 170)
        self.tocino = self.load_image("/images/tocino.jpg", 170)
        self.tomate = self.load_image("/images/tomate.jpg", 170)
        self.vienesa = self.load_image("/images/vianesa.png", 170)
        
        self.dic = {
            '1231' : self.hamburguesa1,
            '1232' : self.hamburguesa2,
            '1233' : self.hamburguesaitaliana,
            '1234' : self.barrosluco,
            '1241' : self.papasfritaschica,
            '1242' : self.papasfritasgrande,
            '1243' : self.papasfritasfamiliar,
            '1251' : self.hamburguesa2,
            '1252' : self.pichangacalientemediana,
            '1253' : self.pichangacalientefamiliar,
            '1261' : self.completoitaliano,
            '1262' : self.completohas,
            '1263' : self.completohasqueso,
            '23411' : self.cocacola,
            #'23412' : self.cocacolaL,
            '23413' : self.cocacola15,
            '23421' : self.sprite,
            '23422' : self.spriteL,
            '23423' : self.sprite15,
            '23431' : self.fanta,
            '23432' : self.fantaL,
            '23433' : self.fanta15,
            '23441' : self.kem,
            '23442' : self.kemL,
            '23443' : self.kem15,
            '12' : self.chucrut,
            #'19' : self.jamon,
            '24' : self.kem,
            '4' : self.tocino,
            '7' : self.cebollamorada,
            '9' : self.lechuga,
            '3' : self.pan,
            '15' : self.ketchup,
            '16' : self.mostaza,
            '18' : self.pollo,
            '5' : self.huevo,
            '17' : self.carne,
            '13' : self.papasprefritas,
            '2' : self.sal,
            '1' : self.aceite,
            '10' : self.vienesa,
            '6' : self.queso,
            '20' : self.lomo,
            '25' : self.pancompleto,
            '14' : self.mayonesa,
            '11' : self.palta,
            '8' : self.tomate,
            '21' : self.cocacola,
            '22' : self.sprite,
            '23' : self.fanta,

        }

        self.img_label = customtkinter.CTkLabel(self, borderwidth=2, relief='solid', text='Imagen Producto',width=170,height=170)
        self.img_label.grid(row=0,column=0,columnspan=2)

        self.img_label2 = customtkinter.CTkLabel(self, borderwidth=2, relief='solid', text='Imagen Ingrediente',width=170,height=170)
        self.img_label2.grid(row=0,column=4,columnspan=2)

    def agregar_productos(self):
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.producto(id_producto,nombre,porcentaje_ganancia,tmp_preparacion) VALUES(%s,%s,%s,%s)"""
        conn = None

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_producto_agregar = self.id_producto.get()
            nombre_agregar = self.nombre.get()
            porcentaje_ganancia_agregar = self.porc_ganancia.get()
            tmp_preparacion_agregar = self.tmp_preparacion.get()

            if(id_producto_agregar != ""):
                cur.execute(sql,(id_producto_agregar,nombre_agregar,porcentaje_ganancia_agregar,tmp_preparacion_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_productos()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
            
    def mostrar_productos(self):
        self.id_producto.delete(0,END)
        self.nombre.delete(0,END)
        self.porc_ganancia.delete(0,END)
        self.tmp_preparacion.delete(0,END)
        
        for item in self.tree.get_children():
            self.tree.delete(item)
        
        self.id_ingrediente.delete(0,END)
        self.cantidad_ingrediente.delete(0,END)

        for item in self.tree_ingredientes.get_children():
            self.tree_ingredientes.delete(item)
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT *
            FROM proyecto.producto as p
            ORDER BY id_producto;
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

            cur.callproc('proyecto.precio_producto',())
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
        sql = """
        UPDATE proyecto.producto as p
        SET nombre = %s, porcentaje_ganancia = %s, tmp_preparacion = %s
        WHERE p.id_producto = %s;
        """
        funcion = """SELECT proyecto.precio_producto();"""
        conn = None
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos

            id_producto_agregar = self.id_producto.get()
            nombre_agregar = self.nombre.get()
            porcentaje_ganancia_agregar = self.porc_ganancia.get()
            tmp_preparacion_agregar = self.tmp_preparacion.get()

            if(id_producto_agregar != ""):
                cur.execute(sql,(nombre_agregar,porcentaje_ganancia_agregar,tmp_preparacion_agregar,id_producto_agregar))
                cur.execute(funcion)
            
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_productos()

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_ingredientes(self,event):
        curItem = self.tree.focus()
        ingred = self.tree.item(curItem,'values')

        self.id_producto.delete(0,END)
        self.nombre.delete(0,END)
        self.porc_ganancia.delete(0,END)
        self.tmp_preparacion.delete(0,END)

        try:
            self.id_producto.insert(0,ingred[0])
            self.nombre.insert(0,ingred[1])
            self.porc_ganancia.insert(0,ingred[3])
            self.tmp_preparacion.insert(0,ingred[4])
        except:
            pass

        self.img_label.configure(image='')
        try:
            imagen = self.dic[ingred[0]]
            self.img_label.configure(image=imagen)
        except:
            pass
        
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
        # Consultar usuarios en la base de datos
        sql = """INSERT INTO proyecto.compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES(%s,%s,%s)"""
        conn = None

        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            id_producto_agregar = self.id_producto.get()
            id_ingrediente_agregar = self.id_ingrediente.get()
            cantidad_ingrediente_agregar = self.cantidad_ingrediente.get()

            if(id_producto_agregar != "" and id_ingrediente_agregar != "" and cantidad_ingrediente_agregar != ""):
                cur.execute(sql,(id_producto_agregar,id_ingrediente_agregar,cantidad_ingrediente_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_ingredientes(self)

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def editar_ingredientes(self):
        sql = """
        UPDATE proyecto.compone as c
        SET cantidad_ingrediente = %s
        WHERE c.id_producto = %s and c.id_ingrediente = %s;
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

            # Ejecutar los comandos
            id_producto_agregar = self.id_producto.get()
            id_ingrediente_agregar = self.id_ingrediente.get()
            cantidad_ingrediente_agregar = self.cantidad_ingrediente.get()

            if(id_producto_agregar != "" and id_ingrediente_agregar != "" and cantidad_ingrediente_agregar != ""):
                cur.execute(sql,(cantidad_ingrediente_agregar,id_producto_agregar,id_ingrediente_agregar))

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_ingredientes(self)

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def click_ingredientes(self,event):
        curItem = self.tree_ingredientes.focus()
        ingred = self.tree_ingredientes.item(curItem,'values')

        self.id_ingrediente.delete(0,END)
        self.cantidad_ingrediente.delete(0,END)

        try:
            self.id_ingrediente.insert(0,ingred[0])
            self.cantidad_ingrediente.insert(0,ingred[2])
        except:
            pass

        self.img_label2.configure(image='')
        try:
            imagen = self.dic[ingred[0]]
            self.img_label2.configure(image=imagen)
        except (Exception) as error:
            print(error)

    def load_image(self, path, image_size):
        """ load rectangular image with path relative to PATH """
        return ImageTk.PhotoImage(Image.open(PATH + path).resize((image_size, image_size)))