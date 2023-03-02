# T2: Programación de E/S en lenguaje arm
    Profesor: Dr. Adán Geovanni Medrano Chávez
    UEA: Microcontroladores

## Integrantes del equipo
    Erick David Ruiz Coronel    2143067521
    

## Proceso de instalación del compilador cruzado para arm

Bajo una distribución basada en Ubuntu, basta con utilizar el comando
siguiente para instalar el compilador cruzado de arm y un emulador que
permitirá ejecutar aplicaciones arm desde el pc.

````
sudo apt install gcc- arm -linux -gnueabi qemu-user-static
````

The above formatting is used to create a box which can display code or command in a well formatted manner.


## Usage

Below is another example of displaying
````python
import csv

with open("sample.csv","r") as csvinput: # read input csv file
    reader = csv.reader(csvinput) # create a reader
    for row in reader:
        print(row[0])
````

