# github.com/pahasara

import alsaaudio 

def get_volume(): 
    mixer = alsaaudio.Mixer()
    volume = mixer.getvolume()[0]  # Get the volume of the first channel (usually master)
    return volume

def get_color(value):
    if(value == 0):
       return "#ff3525" 
    elif(value <= 35):
       return "#ffce0d"
    elif value <= 55:
       return "#a7ff16"
    elif value < 85:
       return "#28df28" 
    else: 
        return "#1dc1ee"

def get_icon(value):
    if(value == 0):
       return ""
    elif(value <= 45):
       return ""
    elif value <= 75:
       return ""
    else: 
        return ""

def main():
    volume = get_volume()
    color = get_color(volume)
    icon = get_icon(volume)
    print("<span color='{0}'>{2}    {1}%</span>".format(color, volume, icon))

if __name__ == "__main__":
    main()

