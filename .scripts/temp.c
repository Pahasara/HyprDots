#include <stdio.h>
#include <stdlib.h>

#define TEMP_PATH "/sys/class/thermal/thermal_zone0/temp"

char* get_color(double value) {
    if (value >= 85) {
        return "#ff5500";
    } else if (value >= 75) {
        return "#ffce0d";
    } else if (value >= 60) {
        return "#a7ff16";
    } else if (value >= 45) {
        return "#28df28";
    } else {
        return "#1dc1ee";
    }
}

char* get_icon(double value) {
    if (value >= 85) {
        return "";
    } else if (value >= 75) {
        return "";
    } else if (value >= 60) {
        return "";
    } else if (value >= 45) {
        return "";
    } else {
        return "";
    }
}

int main() {
    FILE *temp_file;
    double temp_celsius;
    char *color, *icon;
    char output[100];

    temp_file = fopen(TEMP_PATH, "r");
    if (temp_file == NULL) {
        printf("Error: Unable to open temperature file.\n");
        return 1;
    }

    fscanf(temp_file, "%lf", &temp_celsius);
    fclose(temp_file);

    // Convert millidegrees Celsius to degrees Celsius
    temp_celsius /= 1000.0;

    icon = get_icon(temp_celsius);
    color = get_color(temp_celsius);

    snprintf(output, sizeof(output), "<span color='%s'>  %.1f °C</span>", color, icon, temp_celsius);


    printf("%s\n", output);


    return 0;
}
