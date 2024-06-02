# github.com/pahasara

import psutil

usage = psutil.virtual_memory().percent

def get_color():
    if(usage >= 90):
       return "#ff5500" 
    elif(usage >= 75):
       return "#ffce0d"
    elif usage >= 50:
       return "#a7ff16"
    elif usage >= 30:
       return "#28df28"
    else:
        return "#1dc1ee"

# For full text uncomment these 2 lines
#message = "<span color='{1}'>{0} {2}</span>"
#print(message.format('',get_color() , str(usage) + "%"))

# For short text ucomment these 2 lines
message = "<span color='{1}'>{0}</span>"
print(message.format('',get_color()))
