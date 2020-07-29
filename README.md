# Compilador de lenguaje de programación propio

Este repositorio contiene el código de un simulador de un compilador. 
Es un proyecto para la asignatura de Procesadores de Lenguaje del grado de Ingeniería Informática de la UPNA.

### Input del compilador
Toma como entrada un archivo de codigo en formato .alg, un lenguaje de programación creado unicamente para este proposito.

### Output del compilador:
Este no es un compilador en sí. Realiza una simulación de compilación y no genera un archivo ejecutable. Genera tres archivos de texto para visualizar 
Se generan tres arhivos de salida:
```
out.ShiftsAndReduces
out.TablaSimbolos
out.TablaCuadruplas
```
- *out.ShiftsAndReduces* Informa del proceso de Shifts y Reduces que ha realizado el compilador. \n
- *out.TablaSimbolos* Contiene información sobre la tabla de símbolos generada por el compilador.
- *out.TablaCuadruplas* Contiene información de la tabla de instrucciones generada por el compilador.
