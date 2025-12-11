# ProyectoRuby

- **Nombres:** (Leonardo Dolande, Cristina Gómez)
- **Carnets:** (19-10181, 19-10266)

## Descripción

Este proyecto es una implementación del juego extendido "Piedra, Papel, Tijera, Lagarto, Spock", el cual fue desarrollado en Ruby utilizando la biblioteca gráfica Shoes (ejecutado sobre JRuby). El juego permite simulaciones de partidas entre jugadores o si lo desea, existen distintas estrategias para poder jugar contra la máquina (CPU).

## Dependencias
Este proyecto requiere **JRuby** debido a la compatibilidad con la gema gráfica shoes **shoes4**.

## Instalación y Ejecucion
1) **Instalación de Java:** Instalar el JDK (Java Development Kit) versión 8 o superior. A través de la página oficial.
2) **Instalación de JRuby:** Descarga e instala JRuby 9.4.X desde su sitio oficial ```https://www.jruby.org/download```
3) **Instalación de Dependecias:** Desde la terminal (PowerShell o CMD) se debe ejecutar el siguiente comando para instalar Shoes en su versión pre-release:
```
gem install shoes --pre
```
4) **Ejecución del Proyecto:** En la raiz del proyecto debe ejecutar el siguiente comando

```
shoes main.rb
```

### Reglas del Juego
* **Tijera** corta a Papel y decapita a Lagarto.
* **Papel** tapa a Piedra y desautoriza a Spock.
* **Piedra** aplasta a Lagarto y aplasta a Tijera.
* **Lagarto** envenena a Spock y devora a Papel.
* **Spock** rompe a Tijera y vaporiza a Piedra.

## Arquitectura
- `main.rb`: Este archivo construye la interfaz con Shoes, captura los datos que necesita el programa como nombres de los jugadores, el modo a jugar (`Rondas`/`Alcanzar`), objetivo `N` (Numero de Rondas o Puntos), estrategia de cada jugador y (si aplica) los pesos de la estrategia sesgada. Instancia `Partida` y coordina la vista de rondas, marcadores y jugadas manuales.
- `RPTLS.rb`: Contiene la logica del juegp.
	- Clase `Jugada` y subclases `Piedra`, `Papel`, `Tijera`, `Lagarto`, `Spock`: cada una define a quien vence; retorna los puntos propios o del contrincante segun el cruce, cada una de las subclases definen las reglas de victoria.
	- Clase `Partida`: Lleva el estado de la ronda, los puntajes y el criterio de termino. Existen 2 modos de juego, está el Modo `Rondas` juega un numero fijo de rondas y modo `Alcanzar` finaliza cuando algun jugador alcanza `N` puntos.
	- Clase `Estrategias` contiene subclases que definen las estategias de cada jugador dentro del juego:
		- `Manual`: espera la seleccion de la UI.
		- `Uniforme`: elige jugada uniforme al azar entre las cinco opciones.
		- `Sesgada`: elige al azar ponderado con los pesos proporcionados.
		- `Copiar`: repite la ultima jugada del oponente (primera ronda usa aleatorio).
		- `Pensar`: cuenta frecuencias del oponente y elige una jugada que derrote a la mas frecuente (sin historial usa aleatorio).

## Flujo de la UI
1) Shoes ejecuta una ventana de dimensiones (900x750 píxeles), utilizando una paleta de colores oscuros.
2) Al iniciar, el usuario accede a un panel de configuración de la partida donde puede asignar nombres a los jugadores, definir el criterio de victoria, es decir,  jugar un número fijo de rondas o alcanzar un puntaje específico, también puede seleccionar la estrategia para cada participante (Manual, Uniforme, Sesgada, Copiar o Pensar), en caso de no escoger ninguna el juego envía una alerta y saca al jugador, pero en cambio, al elegir estrategias complejas como **Uniforme** o **Sesgada**, se despliegan automáticamente controles adicionales para configurar las opciones permitidas o los pesos probabilísticos de cada jugada.
3) Al presionar "Iniciar Juego", la pantalla se limpia y se muestra el "area de Juego", el cual impreme un marcador visual que destaca los puntajes en tiempo real de cada jugador. En esta vista, el usuario puede interactuar seleccionando su movimiento mediante íconos (si juega en modo Manual) o puede visualizar el estado de las estrategias automáticas de la CPU.
4) En cada clic de "Siguiente ronda":
	 - Para estrategias manuales se toma la jugada elegida; para las demas se llama `prox` (pasando la jugada rival cuando corresponde).
	 - Luego se calcula el puntaje y avanza la ronda.
	 - Se actualizan labels de ronda, jugadas y marcadores; si `terminado?` es verdadero, se deshabilita el boton y se muestra alerta con el resultado ya sea que haya un ganador o termine en empate.

## Notas tecnicas
- **Aleatoriedad:** estrategias no deterministas usan `Random` con semilla fija `@@semillaPadre = 42` para reproducibilidad.
- **Estrategia sesgada:** si la suma de pesos es 0, se reemplaza por valores por defecto `{Piedra=>5, Papel=>1, Tijera=>1, Lagarto=>1, Spock=>1}`.
- **Validaciones manuales:** avanzar ronda sin seleccionar jugada manual deja `nil`; seleccionar antes de presionar "Siguiente ronda" el cual evita puntaje inconsistente.
