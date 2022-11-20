import customtkinter
from PIL import Image, ImageTk
import os
import tkinter
import clientes, ingredientes, trabajadores, productos

PATH = os.path.dirname(os.path.realpath(__file__))
customtkinter.set_appearance_mode("light")
customtkinter.set_default_color_theme("blue")

class MainMenu(customtkinter.CTk):
    def __init__(self):
        super().__init__()
        self.title("Proyecto Base de Datos")
        self.geometry("700x700")
        self.columnconfigure(0,minsize=50)
        self.rowconfigure(0,minsize=50)

        self.columnconfigure(2,minsize=50)
        self.rowconfigure(2,minsize=50)

        self.columnconfigure(4,minsize=50)
        self.rowconfigure(4,minsize=50)

        self.pedidos_image = self.load_image("/images/1.png", 100)
        self.finanzas_image = self.load_image("/images/2.png", 100)
        self.clientes_image = self.load_image("/images/3.png", 100)
        self.trabajadores_image = self.load_image("/images/4.png", 100)
        self.ingredientes_image = self.load_image("/images/5.png", 100)
        self.productos_image = self.load_image("/images/6.png", 100)
        
        self.button_clientes = customtkinter.CTkButton(self, text="  Clientes  ", image=self.clientes_image,
        command=self.window_clientes)
        self.button_clientes.grid(row=1,column=1,ipadx=30,ipady=30)

        self.button_trabajadores = customtkinter.CTkButton(self, text="Trabajadores", image=self.trabajadores_image,
        command=self.window_trabajadores)
        self.button_trabajadores.grid(row=1,column=3,ipadx=30,ipady=30)

        self.button_pedidos = customtkinter.CTkButton(self, text="  Pedidos  ",image=self.pedidos_image)
        self.button_pedidos.grid(row=3,column=1,ipadx=30,ipady=30)

        self.button_finanzas = customtkinter.CTkButton(self, text="  Finanzas  ", image=self.finanzas_image)
        self.button_finanzas.grid(row=3,column=3,ipadx=30,ipady=30)

        self.button_ingredientes = customtkinter.CTkButton(self, text="Ingredientes", image=self.ingredientes_image,
        command=self.window_ingredientes)
        self.button_ingredientes.grid(row=5,column=1,ipadx=30,ipady=30)

        self.button_productos = customtkinter.CTkButton(self, text="Productos", image=self.productos_image,
        command=self.window_productos)
        self.button_productos.grid(row=5,column=3,ipadx=30,ipady=30)        

    def load_image(self, path, image_size):
        """ load rectangular image with path relative to PATH """
        return ImageTk.PhotoImage(Image.open(PATH + path).resize((image_size, image_size)))

    def window_clientes(self):
        new_window_clientes = clientes.clientes(self)
    
    def window_ingredientes(self):
        new_window_ingredientes = ingredientes.ingredientes(self)

    def window_trabajadores(self):
        new_window_trabajadores = trabajadores.trabajadores(self)

    def window_productos(self):
        new_window_productos = productos.productos(self)

if __name__ == "__main__":
    app = MainMenu()
    app.mainloop()