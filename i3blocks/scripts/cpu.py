#!/usr/bin python3
import psutil

def get_cpu_usage():
    return psutil.cpu_percent(interval=1)

def format_output(cpu_usage):
    return f': {cpu_usage}%'

cpu_usage = get_cpu_usage()
output = format_output(cpu_usage)

print(f'{output}')
