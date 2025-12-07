# ProyectoRuby

- **Nombres:** (Leonardo Dolande, Cristina Gómez)
- **Carnets:** (19-10181, 19-10266)

Aplicacion de escritorio en Ruby + Shoes que ejecuta partidas de Piedra, Papel, Tijera, Lagarto, Spock con estrategias configurables y control de puntaje.

## Contenidos
- Arquitectura
- Estrategias disponibles
- Flujo de la UI
- Dependencias
- Ejecucion
- Notas tecnicas

## Arquitectura
- `main.rb`: construye la interfaz con Shoes, captura nombres, modo (`Rondas`/`Alcanzar`), objetivo `N`, estrategia de cada jugador y (si aplica) los pesos de la estrategia sesgada. Instancia `Partida` y coordina la vista de rondas, marcadores y jugadas manuales.
- `RPTLS.rb`: logica de dominio.
	- `Jugada` y subclases `Piedra`, `Papel`, `Tijera`, `Lagarto`, `Spock`: cada una define `vence_a`; `Jugada#puntos` retorna `[pts_propios, pts_oponente]` segun el cruce.
	- `Partida`: lleva estado de ronda, puntajes y criterio de termino. Modo `Rondas` juega un numero fijo de rondas; modo `Alcanzar` finaliza cuando algun jugador alcanza `N` puntos.
	- Estrategias (implementan `Estrategia#prox(jugada_oponente)`):
		- `Manual`: espera la seleccion de la UI.
		- `Uniforme`: elige jugada uniforme al azar entre las cinco opciones.
		- `Sesgada`: elige al azar ponderado con los pesos proporcionados.
		- `Copiar`: repite la ultima jugada del oponente (primera ronda usa aleatorio).
		- `Pensar`: cuenta frecuencias del oponente y elige una jugada que derrote a la mas frecuente (sin historial usa aleatorio).

## Flujo de la UI
1) Shoes abre ventana 840x640 con fondo oscuro y entradas de configuracion.
2) El usuario define nombres, modo, objetivo `N` y estrategias (con pesos si aplica).
3) Al presionar "Iniciar juego" se crea `Partida` y se renderizan controles de ronda y botones/imagenes para jugadas manuales.
4) En cada clic de "Siguiente ronda":
	 - Para estrategias manuales se toma la jugada elegida; para las demas se llama `prox` (pasando la jugada rival cuando corresponde).
	 - `Partida#jugar_ronda_con` calcula puntaje y avanza la ronda.
	 - Se actualizan labels de ronda, jugadas y marcadores; si `terminado?` es verdadero, se deshabilita el boton y se muestra alerta con ganador o empate.

## Dependencias
- Ruby con Shoes (ruby-shoes) instalado y disponible como comando `shoes`.

## Ejecucion
En la raiz del proyecto:

```powershell
shoes main.rb
```

Alternativa con JRuby (requiere Shoes compatible):

```powershell
jruby main.rb
```

## Notas tecnicas
- Aleatoriedad: estrategias no deterministas usan `Random` con semilla fija `@@semillaPadre = 42` para reproducibilidad.
- Estrategia sesgada: si la suma de pesos es 0, se reemplaza por valores por defecto `{Piedra=>5, Papel=>1, Tijera=>1, Lagarto=>1, Spock=>1}`.
- Validaciones manuales: avanzar ronda sin seleccionar jugada manual deja `nil`; seleccionar antes de presionar "Siguiente ronda" evita puntaje inconsistente.
