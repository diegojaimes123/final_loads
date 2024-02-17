import tkinter as tk

def add():
   num1 = float(entry_num1.get())
   num2 = float(entry_num2.get())
   result = num1 + num2
   label_result.config(text=str(result))

def subtract():
   num1 = float(entry_num1.get())
   num2 = float(entry_num2.get())
   result = num1 - num2
   label_result.config(text=str(result))

def multiply():
   num1 = float(entry_num1.get())
   num2 = float(entry_num2.get())
   result = num1 * num2
   label_result.config(text=str(result))

def divide():
   num1 = float(entry_num1.get())
   num2 = float(entry_num2.get())
   if num2 == 0:
       raise ValueError("Cannot divide by zero")
   result = num1 / num2
   label_result.config(text=str(result))

root = tk.Tk()
root.title("Calculator")

label_num1 = tk.Label(root, text="Number 1:")
label_num1.grid(row=0, column=0)
entry_num1 = tk.Entry(root)
entry_num1.grid(row=0, column=1)

label_num2 = tk.Label(root, text="Number 2:")
label_num2.grid(row=1, column=0)
entry_num2 = tk.Entry(root)
entry_num2.grid(row=1, column=1)

button_add = tk.Button(root, text="+", command=add)
button_add.grid(row=2, column=0)
button_subtract = tk.Button(root, text="-", command=subtract)
button_subtract.grid(row=2, column=1)
button_multiply = tk.Button(root, text="*", command=multiply)
button_multiply.grid(row=3, column=0)
button_divide = tk.Button(root, text="/", command=divide)
button_divide.grid(row=3, column=1)

label_result = tk.Label(root, text="")
label_result.grid(row=4, columnspan=2)

root.mainloop()