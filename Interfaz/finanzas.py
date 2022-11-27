import customtkinter
import psycopg2
import tkinter as tk
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from PIL import Image, ImageTk
import os
from config import config

class finanzas(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        self.title("Finanzas")