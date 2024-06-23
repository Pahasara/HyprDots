#github.com/pahasara

import psutil

battery = psutil.sensors_battery()

power  = battery.power_plugged
percent = battery.percent

def get_color(value):
    if(value < 25):
       return "#ff5500" 
    elif(value < 50):
       return "#ffce0d"
    elif value < 75:
       return "#a7ff16"
    elif value < 100:
       return "#28df28"
    else:
        return "#1dc1ee"

def get_icon(value):
    if power:
        return ""
    elif value == 100.0:
        return " "
    elif value >= 75.0:
        return " "
    elif value >= 50.0:
        return " "
    elif value >= 25.0:
        return " "
    else:
        return " "

icon = get_icon(percent)
color = get_color(percent)

message = "<span color='{0}'>{1}</span>"
print(message.format(color, icon))
