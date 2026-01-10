#!/usr/bin/bash

# Get Day, Month (as number), and Weekday
read -r day month weekday <<< "$(date '+%d %m %a')"

# Convert month to Roman numeral
# Bash arrays are 0-indexed, so we use month as index
romans=("" "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" "XI" "XII")
roman_month=${romans[$((10#$month))]} # 10# force base-10 to avoid octal errors

echo "$day $weekday $roman_month"
