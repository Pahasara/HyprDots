#!/usr/bin python3
import psutil

usage = psutil.cpu_percent(interval=1)

def get_color(usage):
    if(usage >= 90):
       return "#ff5500" 
    elif(usage >= 75):
       return "#ffce0d"
    elif usage >= 50:
       return "#a7ef16"
    elif usage >= 30:
       return "#28cf28"
    else:
        return "#1dc1ee"

color = get_color(usage)
message = "<span color='{0}'>  {1}%</span>"
print(message.format(color, usage))
