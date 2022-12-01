import customtkinter
import psycopg2
import tkinter as tk
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from PIL import Image, ImageTk
import os
from config import config
import matplotlib.pyplot as plt
from tkcalendar import Calendar
from datetime import datetime

class finanzas(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Finanzas")
        self.geometry("700x700")
        self.columnconfigure(0,minsize=50)
        self.rowconfigure(0,minsize=50)

        self.columnconfigure(2,minsize=50)
        self.rowconfigure(2,minsize=50)

        self.columnconfigure(4,minsize=50)
        self.rowconfigure(4,minsize=50)

        self.rowconfigure(6,minsize=50)

        self.button_boletas = customtkinter.CTkButton(self, text="Boletas",
        command=self.window_boletas)
        self.button_boletas.grid(row=1,column=1,ipadx=30,ipady=30)

        self.button_compras = customtkinter.CTkButton(self, text="Compras Ingredientes",
        command=self.window_compras)
        self.button_compras.grid(row=1,column=3,ipadx=30,ipady=30)

        self.button_pago_trabajadores = customtkinter.CTkButton(self, text="Pago Trabajadores",
        command=self.window_pago_trabajadores)
        self.button_pago_trabajadores.grid(row=3,column=1,ipadx=30,ipady=30)

        self.button_otros_egresos = customtkinter.CTkButton(self, text="Otros Egresos",
        command=self.window_otros_egresos)
        self.button_otros_egresos.grid(row=3,column=3,ipadx=30,ipady=30)

        self.button_ganancias = customtkinter.CTkButton(self, text="Ganacias",
        command=self.window_ganancias)
        self.button_ganancias.grid(row=5,column=1,ipadx=30,ipady=30)

        self.button_productos_mas_vendidos = customtkinter.CTkButton(self, text="Productos mas vendidos",
        command=self.window_productos_mas_vendidos)
        self.button_productos_mas_vendidos.grid(row=5,column=3,ipadx=30,ipady=30)

        self.button_ingresos_diarios = customtkinter.CTkButton(self, text="Ingresos Diarios",
        command=self.window_ingresos_diarios)
        self.button_ingresos_diarios.grid(row=7,column=1,ipadx=30,ipady=30)
    
    def window_ingresos_diarios(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Ingresos Diarios")
        window.rowconfigure(1,minsize=20)
        window.rowconfigure(3,minsize=20)

        window.cal = Calendar(window, selectmode = 'day',
               year = 2022, month = 12,
               day = 1,
               date_pattern='yyyy-MM-dd')
        window.cal.grid(row=0,column=0, ipady = 200, ipadx = 200)



        window.ganancias_label = customtkinter.CTkLabel(window,text="Ingresos Diarios: $ ",text_font=('Helvatical bold',20))
        window.ganancias_label.grid(row=4,column=0, sticky="w")

        window.button_mostrar_ingresos = customtkinter.CTkButton(window, text="Mostrar Ingresos",
        command=lambda: self.ingresos_diarios_f(window.cal,window.ganancias_label))
        window.button_mostrar_ingresos.grid(row=2,column=0,columnspan=2, ipadx = 50)
        
    def ingresos_diarios_f(self,cal,ganancias_label):
        dt=cal.get_date()
        conn = None
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            cur.callproc('proyecto.ingresos_diarios',(dt,))
            ingresos = cur.fetchall()
        
            x=str(ingresos)
            x=x.replace("[","")
            x=x.replace("]","")
            x=x.replace("(","")
            x=x.replace(")","")
            x=x.replace(",","")
            text = 'Ingresos Diarios: $ ' + x

                     

            ganancias_label.configure(text = text)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()


    #ganancias
    def window_ganancias(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Ganancias")
        window.rowconfigure(2,minsize=20)
        window.rowconfigure(4,minsize=20)
        window.rowconfigure(6,minsize=20)
        window.rowconfigure(8,minsize=20)

        window.mes_label = customtkinter.CTkLabel(window,text="Mes")
        window.mes_label.grid(row=0,column=0)

        window.anio_label = customtkinter.CTkLabel(window,text="Año")
        window.anio_label.grid(row=1,column=0)

        window.combo = ttk.Combobox(
            window,
            state="readonly",
            values=["1", "2", "3", "4","5","6","7","8","9","10","11","12"]
        )
        window.combo.grid(row=0,column=1,ipadx=15)

        window.combo2 = ttk.Combobox(
            window,
            state="readonly",
            values=["2021", "2022", "2023"]
        )
        window.combo2.grid(row=1,column=1,ipadx=15)

        window.ganancias_label = customtkinter.CTkLabel(window,text="Ganancias: ",
        text_font=('Helvatical bold',20))
        window.ganancias_label.grid(row=9,column=0,sticky = "w")

        window.ingresos_label = customtkinter.CTkLabel(window,text="Ingresos: ",
        text_font=('Helvatical bold',20))
        window.ingresos_label.grid(row=5,column=0,sticky = "w")

        window.egresos_label = customtkinter.CTkLabel(window,text="Egresos: ",
        text_font=('Helvatical bold',20))
        window.egresos_label.grid(row=7,column=0,sticky = "w")

        window.button_mostrar_ganancias = customtkinter.CTkButton(window, text="Mostrar ganancias",
        command=lambda: self.mostrar_ganancias_f(window.combo.get(),window.combo2.get(),
        window.ganancias_label,window,window.ingresos_label,window.egresos_label))
        window.button_mostrar_ganancias.grid(row=3,column=0,columnspan=2, ipadx = 70)

    def mostrar_ganancias_f(self,mes,anio,ganancia_label,window,ingresos_label,egresos_label):
        conn = None
        try:
            # Leer los parametros de configuracion
            params = config()

            # Conectar a las base de datos
            conn = psycopg2.connect(**params)

            # Crear cursor
            cur = conn.cursor()

            # Ejecutar los comandos
            cur.callproc('proyecto.ganancia_mensual',(int(mes),int(anio)))
            ganancia = cur.fetchall()
            cur.callproc('proyecto.ingreso_mensual',(int(mes),int(anio)))
            ingresos = cur.fetchall()
            cur.callproc('proyecto.egreso_mensual',(int(mes),int(anio)))
            egresos = cur.fetchall()
        
            x=str(ganancia)
            x=x.replace("[","")
            x=x.replace("]","")
            x=x.replace("(","")
            x=x.replace(")","")
            x=x.replace(",","")
            text = 'Ganancia: $ ' + x

            y=str(ingresos)
            y=y.replace("[","")
            y=y.replace("]","")
            y=y.replace("(","")
            y=y.replace(")","")
            y=y.replace(",","")
            text1 = 'Ingresos: $ ' + y

            z=str(egresos)
            z=z.replace("[","")
            z=z.replace("]","")
            z=z.replace("(","")
            z=z.replace(")","")
            z=z.replace(",","")
            text2 = 'Egresos: $ ' + z            

            ganancia_label.configure(text = text)
            ingresos_label.configure(text = text1)
            egresos_label.configure(text = text2)


            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
    
    #productos mas vendidos
    def window_productos_mas_vendidos(self):
        labels = ()
        sizes = []

        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT * FROM proyecto.productos_vendidos;
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
                labels = labels + (producto[0],)
                sizes.append(producto[1])

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        
        # Pie chart, where the slices will be ordered and plotted counter-clockwise:
        #labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
        #sizes = [15, 30, 45, 10]
        #explode = (0, 0.1, 0, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')
        try:
            #fig = plt.figure()
            fig1, ax1 = plt.subplots(figsize=(10, 10))
            ax1.pie(sizes, labels=labels, autopct=lambda p:f'{p:.1f}% ({p*sum(sizes)/100 :.0f})',
            shadow=True, startangle=90)
            ax1.set_title('Productos mas vendidos')
            ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
            plt.show()
            
        except:
            pass

        ### segundo grafico

        labels = ()
        sizes = []

        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT * FROM proyecto.productos_mayor_ingresos;
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
                labels = labels + (producto[0],)
                sizes.append(producto[1])

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
        
        # Pie chart, where the slices will be ordered and plotted counter-clockwise:
        #labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
        #sizes = [15, 30, 45, 10]
        #explode = (0, 0.1, 0, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')
        try:
            fig2 = plt.figure(figsize = (10, 5))
            # creating the bar plot
            plt.bar(labels, sizes, color ='maroon',
                    width = 0.4)
            
            for a,b in zip(labels, sizes): 
                plt.text(a, b, str(b))

            plt.xlabel("Producto")
            plt.ylabel("Ingresos")
            plt.xticks(rotation=45)
            plt.title("Productos de mayor ingresos")
            plt.show()
        except:
            pass

    def make_autopct(values):
        def my_autopct(pct):
            total = sum(values)
            val = int(round(pct*total/100.0))
            return '{p:.2f}%  ({v:d})'.format(p=pct,v=val)
        return my_autopct

    #otros egresos
    def window_otros_egresos(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Otros Egresos")
        window.rowconfigure(2,minsize=20)
        window.rowconfigure(4,minsize=20)
        window.rowconfigure(6,minsize=20)

        columnas_pedidos = ('id_egreso','fecha_egreso','descripcion','total')

        window.tree = ttk.Treeview(window,columns=columnas_pedidos,show='headings')
        window.tree.grid(row=7,column=0, columnspan=2, ipady=250, ipadx=100)
        window.tree.column('id_egreso',width=100)
        window.tree.heading('id_egreso', text='ID Egreso')
        window.tree.column('fecha_egreso',width=100)
        window.tree.heading('fecha_egreso', text='Fecha Egreso')       
        window.tree.column('descripcion',width=100)
        window.tree.heading('descripcion', text='Descripcion') 
        window.tree.column('total',width=100)
        window.tree.heading('total', text='Total')

        # add a scrollbar
        scrollbar = ttk.Scrollbar(window, orient=tk.VERTICAL, command=window.tree.yview)
        window.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=7, column=2, ipady=340)

        window.descripcion = customtkinter.CTkEntry(window, width=300)
        window.descripcion.grid(row=0,column=1)
        window.descripcion_label = customtkinter.CTkLabel(window,text="Descripcion")
        window.descripcion_label.grid(row=0,column=0)

        window.total = customtkinter.CTkEntry(window, width=300)
        window.total.grid(row=1,column=1)
        window.total_label = customtkinter.CTkLabel(window,text="Total")
        window.total_label.grid(row=1,column=0)


        window.button_mostrar_otros_egresos = customtkinter.CTkButton(window, text="Mostrar otros egresos",
        command=lambda: self.mostrar_otros_egresos(window.tree))
        window.button_mostrar_otros_egresos.grid(row=3,column=0,columnspan=2, ipadx = 50)

        window.button_agregar_otros_egresos = customtkinter.CTkButton(window, text="Agregar otros egresos",
        command=lambda: self.agregar_otros_egresos(window.tree,window.descripcion,window.total))
        window.button_agregar_otros_egresos.grid(row=5,column=0,columnspan=2, ipadx = 50)

    def agregar_otros_egresos(self,tree,descripcion,total):
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
            cur.callproc('proyecto.pago_otros_pagos',(descripcion.get(),total.get()))
            
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_otros_egresos(tree)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_otros_egresos(self,tree):
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT e.id_egreso,e.fecha_egreso,e.descripcion, e.total
            FROM proyecto.egreso as e, proyecto.otro_egreso as oe
            WHERE e.id_egreso = oe.id_egreso;
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
            actualizas = cur.fetchall()
            
            try:
                tree.selection_remove(tree.selection()[0])
            except:
                pass

            for item in tree.get_children():
                tree.delete(item)

            for actualiza in actualizas:
                tree.insert('', END, values=actualiza)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    #pagos trabajadores
    def window_pago_trabajadores(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Pago Trabajadores")
        window.rowconfigure(1,minsize=20)
        window.rowconfigure(3,minsize=20)
        window.rowconfigure(5,minsize=20)

        columnas_pedidos = ('id_egreso','fecha_egreso','descripcion','total')

        window.tree = ttk.Treeview(window,columns=columnas_pedidos,show='headings')
        window.tree.grid(row=6,column=0, columnspan=2, ipady=250, ipadx=100)
        window.tree.column('id_egreso',width=100)
        window.tree.heading('id_egreso', text='ID Egreso')
        window.tree.column('fecha_egreso',width=100)
        window.tree.heading('fecha_egreso', text='Fecha Egreso')       
        window.tree.column('descripcion',width=100)
        window.tree.heading('descripcion', text='Descripcion') 
        window.tree.column('total',width=100)
        window.tree.heading('total', text='Total')

        # add a scrollbar
        scrollbar = ttk.Scrollbar(window, orient=tk.VERTICAL, command=window.tree.yview)
        window.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=6, column=2, ipady=340)

        window.rut = customtkinter.CTkEntry(window, width=300)
        window.rut.grid(row=0,column=1)
        window.rut_label = customtkinter.CTkLabel(window,text="RUT")
        window.rut_label.grid(row=0,column=0)   

        window.button_mostrar_pago_trabajador = customtkinter.CTkButton(window, text="Mostrar pagos trabajador",
        command=lambda: self.mostrar_pagos_trabajador(window.tree))
        window.button_mostrar_pago_trabajador.grid(row=4,column=0,columnspan=2, ipadx = 50)

        window.button_pago_trabajador = customtkinter.CTkButton(window, text="Pagar trabajador",
        command=lambda: self.agregar_pago_trabajador_f(window.tree,window.rut))
        window.button_pago_trabajador.grid(row=2,column=0,columnspan=2, ipadx = 50)

    def mostrar_pagos_trabajador(self,tree):
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT e.id_egreso,e.fecha_egreso,e.descripcion, e.total
            FROM proyecto.egreso as e, proyecto.pago_trabajador as pt
            WHERE e.id_egreso = pt.id_egreso;
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
            actualizas = cur.fetchall()
            
            try:
                tree.selection_remove(tree.selection()[0])
            except:
                pass

            for item in tree.get_children():
                tree.delete(item)

            for actualiza in actualizas:
                tree.insert('', END, values=actualiza)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def agregar_pago_trabajador_f(self,tree,rut):
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
            cur.callproc('proyecto.pago_trabajador',(rut.get(),))
            
            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_pagos_trabajador(tree)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
    
    #compras
    def window_compras(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Compras Ingredientes")
        window.rowconfigure(2,minsize=20)
        window.rowconfigure(4,minsize=20)
        window.rowconfigure(6,minsize=20)

        columnas_pedidos = ('id_ingrediente','id_egreso','fecha_actualiza','estado_actualiza')

        window.tree = ttk.Treeview(window,columns=columnas_pedidos,show='headings')
        window.tree.grid(row=7,column=0, columnspan=2, ipady=250, ipadx=100)
        window.tree.column('id_ingrediente',width=100)
        window.tree.heading('id_ingrediente', text='ID Ingrediente')
        window.tree.column('id_egreso',width=100)
        window.tree.heading('id_egreso', text='ID Egreso')       
        window.tree.column('fecha_actualiza',width=100)
        window.tree.heading('fecha_actualiza', text='Fecha Compra') 
        window.tree.column('estado_actualiza',width=100)
        window.tree.heading('estado_actualiza', text='Estado Compra')

        window.cantidad_actualiza = customtkinter.CTkEntry(window,width=300)
        window.cantidad_actualiza.grid(row=0,column=1)
        window.cantidad_actualiza_label = customtkinter.CTkLabel(window,text="Cantidad")
        window.cantidad_actualiza_label.grid(row=0,column=0)
        
        window.fecha_exp = customtkinter.CTkEntry(window,width=300)
        window.fecha_exp.grid(row=1,column=1)
        window.fecha_exp_label = customtkinter.CTkLabel(window,text="Fecha Expiracion")
        window.fecha_exp_label.grid(row=1,column=0)

        window.button_actualiza = customtkinter.CTkButton(window, text="Actualizar Stock Ingredientes",
        command=lambda: self.actualizar(window.tree,window.cantidad_actualiza,window.fecha_exp))
        window.button_actualiza.grid(row=3,column=0,columnspan=2, ipadx = 50)

        window.button_mostrar_actualiza = customtkinter.CTkButton(window, text="Mostrar compras ingredientes",
        command=lambda: self.mostrar_actualiza(window.tree))
        window.button_mostrar_actualiza.grid(row=5,column=0,columnspan=2, ipadx = 50)

    def actualizar(self,tree,cantidad_actualiza,fecha_exp):
        try:
            curItem = tree.focus()
            entrada = tree.item(curItem,'values')
            id_ingrediente_actualizar = entrada[0]
            id_egreso_actualizar = entrada[1]
            cantidad_a_actualiza = cantidad_actualiza.get()
            fecha_exp_actualizar = fecha_exp.get()
        except:
            pass

        # Consultar usuarios en la base de datos
        commands = (
            """
            UPDATE proyecto.actualiza
            SET cantidad_actualiza = %s, fecha_exp = %s, estado_actualiza = 'actualizado'
            WHERE id_ingrediente = %s and id_egreso = %s;
            """
        )
        commands2 = (
            """
            UPDATE proyecto.actualiza
            SET cantidad_actualiza = %s, estado_actualiza = 'actualizado'
            WHERE id_ingrediente = %s and id_egreso = %s;
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
            if(id_ingrediente_actualizar != '' and id_egreso_actualizar != ''):
                if(fecha_exp_actualizar != ''):
                    cur.execute(commands,(int(cantidad_a_actualiza),fecha_exp_actualizar,id_ingrediente_actualizar,id_egreso_actualizar))
                else:
                    cur.execute(commands2,(int(cantidad_a_actualiza),id_ingrediente_actualizar,id_egreso_actualizar))
            

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()

            self.mostrar_actualiza(tree)

        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    def mostrar_actualiza(self,tree):
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT a.id_ingrediente,a.id_egreso,a.fecha_actualiza,a.estado_actualiza
            FROM proyecto.actualiza as a
            ORDER BY a.fecha_actualiza DESC;
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
            actualizas = cur.fetchall()
            
            try:
                tree.selection_remove(tree.selection()[0])
            except:
                pass

            for item in tree.get_children():
                tree.delete(item)

            for actualiza in actualizas:
                tree.insert('', END, values=actualiza)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

    #boletas
    def window_boletas(self):
        window = customtkinter.CTkToplevel(self)
        window.title("Boletas")

        window.rowconfigure(1,minsize=20)

        # Treeview pedidos
        columnas_pedidos = ('id_boleta','id_pedido','rut','total','valor_neto','iva','fecha_venta')

        window.tree = ttk.Treeview(window,columns=columnas_pedidos,show='headings')
        window.tree.grid(row=3,column=0, ipady=250, ipadx=100)
        window.tree.column('id_boleta',width=100)
        window.tree.heading('id_boleta', text='ID Boleta')
        window.tree.column('id_pedido',width=100)
        window.tree.heading('id_pedido', text='ID Pedido')       
        window.tree.column('rut',width=100)
        window.tree.heading('rut', text='RUT') 
        window.tree.column('total',width=100)
        window.tree.heading('total', text='Total') 
        window.tree.column('valor_neto',width=100)
        window.tree.heading('valor_neto', text='Valor Neto')
        window.tree.column('iva',width=100)
        window.tree.heading('iva', text='IVA')
        window.tree.column('fecha_venta',width=100)
        window.tree.heading('fecha_venta', text='Fecha Venta')

        window.mostrar_boletas_btn = customtkinter.CTkButton(window, text="Mostrar Boletas", command=self.mostrar_boletas_f(window.tree))
        window.mostrar_boletas_btn.grid(row=0,column=0,columnspan=2, ipadx = 50)
        
        # add a scrollbar
        scrollbar = ttk.Scrollbar(window, orient=tk.VERTICAL, command=window.tree.yview)
        window.tree.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=3, column=1, ipady=340)

    def mostrar_boletas_f(self,tree):
        # Consultar usuarios en la base de datos
        commands = (
            """
            SELECT b.id_boleta, b.id_pedido, p.rut, b.total, b.valor_neto, b.iva, b.fecha_venta
            FROM proyecto.boleta as b, proyecto.pedido as p
            WHERE b.id_pedido = p.id_pedido;
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
            boletas = cur.fetchall()
            
            try:
                tree.selection_remove(tree.selection()[0])
            except:
                pass

            for item in tree.get_children():
                tree.delete(item)

            for boleta in boletas:
                tree.insert('', END, values=boleta)

            # Cerrar la comunicacion con la base de datos
            cur.close()

            # Commit los cambios
            conn.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()

