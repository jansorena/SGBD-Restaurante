import customtkinter
import psycopg2
import tkinter as tk
from config import config
from tkinter import *
from tkinter import ttk

class trabajadores(customtkinter.CTkToplevel):
    def __init__(self,master):
        super().__init__()
        