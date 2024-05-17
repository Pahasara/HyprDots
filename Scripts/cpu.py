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

# For full text uncomment these 2 lines
#message = "<span color='{0}'>   {1}%</span>"
#print(message.format(color, usage))

# For short text ucomment these 2 lines
message = "<big><span color='{0}'> </span></big>"
print(message.format(color))
