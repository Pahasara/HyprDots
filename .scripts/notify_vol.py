import alsaaudio 
import dbus

def get_volume():
    mixer = alsaaudio.Mixer()
    volume = mixer.getvolume()[0]  # Get the volume of the first channel (usually master)
    return volume

def get_icon(value):
    if(value == 0):
       return ""
    elif(value <= 30):
       return ""
    elif value <= 65:
       return ""
    else: 
        return " "

obj = dbus.SessionBus().get_object("org.freedesktop.Notifications", "/org/freedesktop/Notifications")
obj = dbus.Interface(obj, "org.freedesktop.Notifications")
message = get_icon(get_volume()) + " Volume: " + str(get_volume()) + "%"
obj.Notify("", 2200, "", message, "", [], {"urgency": 1}, 1500)
