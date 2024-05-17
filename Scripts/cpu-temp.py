# github.com/pahasara

import os

def get_cpu_temperature():
    # The CPU temperature is typically available in the /sys/class/thermal/thermal_zone0/temp file
    # The temperature is in millidegrees Celsius, so divide by 1000 to get degrees Celsius
    try:
        with open('/sys/class/thermal/thermal_zone0/temp', 'r') as file:
            temp_str = file.read().strip()
            temp_celsius = int(temp_str) / 1000
            return temp_celsius
    except FileNotFoundError:
        return None

def get_color(value):
    if(value >= 80):
       return "#ff3525" 
    elif(value >= 70):
       return "#ffce0d"
    elif value >= 60:
       return "#a7ff16"
    elif value > 45:
       return "#28df28"
    elif value >= 20:
        return "#1dc1ee"
    else:
       return "#ff3525" 

def get_icon(value):
    if value >= 85:
        return ""
    elif value >= 80:
        return " "
    elif value >= 70:
        return " "
    elif value >= 60:
        return " "
    elif value > 40:
        return " "
    elif value >= 20:
        return " "
    else:
        return " "

def main():
    cpu_temp = get_cpu_temperature()
    if cpu_temp is not None:
        icon = get_icon(cpu_temp)
        color = get_color(cpu_temp)
        temp = str(cpu_temp) + "°C"
        
        # For full text uncomment these 2 lines
        #message = "<span color='{0}'>{1} {2}</span>"
        #print(message.format(color, icon,  temp))

        # For short text ucomment these 2 lines
        message = "<span color='{0}'>{1}</span>"
        print(message.format(color, icon))
    else:
        print("Failed to read CPU temperature.")

if __name__ == "__main__":
    main()

