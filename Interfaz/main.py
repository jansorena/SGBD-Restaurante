import customtkinter
from PIL import Image, ImageTk
import os
import tkinter
import clientes

PATH = os.path.dirname(os.path.realpath(__file__))
customtkinter.set_appearance_mode("light")
customtkinter.set_default_color_theme("blue")

class MainMenu(customtkinter.CTk):
    def __init__(self):
        super().__init__()
        self.title("Proyecto Base de Datos")
        self.geometry("800x600")
        self.columnconfigure(0,minsize=100)
        self.rowconfigure(0,minsize=100)

        self.columnconfigure(2,minsize=100)
        self.rowconfigure(2,minsize=100)

        self.pedidos_image = self.load_image("/images/1.png", 60)
        self.finanzas_image = self.load_image("/images/2.png", 60)
        self.clientes_image = self.load_image("/images/3.png", 60)
        self.trabajadores_image = self.load_image("/images/4.png", 60)

        self.button_clientes = customtkinter.CTkButton(self, text="Clientes", image=self.clientes_image,
        command=self.window_clientes)
        self.button_clientes.grid(row=1,column=1,ipadx=50,ipady=50)

        self.button_trabajadores = customtkinter.CTkButton(self, text="Trabajadores", image=self.trabajadores_image)
        self.button_trabajadores.grid(row=1,column=3,ipadx=50,ipady=50)

        self.button_pedidos = customtkinter.CTkButton(self, text="Pedidos",image=self.pedidos_image)
        self.button_pedidos.grid(row=3,column=1,ipadx=50,ipady=50)

        self.button_finanzas = customtkinter.CTkButton(self, text="Finanzas", image=self.finanzas_image)
        self.button_finanzas.grid(row=3,column=3,ipadx=50,ipady=50)

    def load_image(self, path, image_size):
        """ load rectangular image with path relative to PATH """
        return ImageTk.PhotoImage(Image.open(PATH + path).resize((image_size, image_size)))

    def window_clientes(self):
        new_window = clientes.clientes(self)

if __name__ == "__main__":
    app = MainMenu()
    app.mainloop()