import os
from pynput.keyboard import Key
from pynput.keyboard import Listener as KeyboardListener
from pynput.mouse import Controller
from pynput.mouse import Listener as MouseListener

#start by moving the mouse to a specific position
#this makes it clear to see when the program is running
#and also allows us to easily detect if it has been moved

mouse = Controller()
mouse.position = (200,200)

#define functions to listen for the mouse being moved or being clicked
#execute systemctl poweroff if either is detected
#the mouse is allowed to move within a very small square around (200,00)
#this is to prevent systemctl poweroff from being executed from a small bump

def is_moved(x,y):
    if x > 250 or y > 250 or x < 150 or y < 150:
        os.system('systemctl poweroff')
       
def is_clicked(x, y, button, pressed):
    if pressed:
        os.system('systemctl poweroff')

#activate mouse listener wrt to the above funcitons

mouse_listener = MouseListener(on_move=is_moved, on_click=is_clicked)
mouse_listener.start()

#define function to listen for keypresses
#if any key besides esc or f8 is pressed, systemctl poweroff will be executed
#esc is the secret key to stop the program
#f8 is also excluded from the first case because I was using autokey
#with f8 as the hotkey to initiate the program and I did not want
#double keypresses to execute systemctl poweroff

def on_press(key):
    if key != Key.esc and key != Key.f8:
        os.system('systemctl poweroff')
    elif key == Key.esc:
        mouse_listener.stop()
        return False

#activate keyboard listener wrt the above functions

with KeyboardListener(on_press=on_press) as keyboard_listener:
    keyboard_listener.join()


