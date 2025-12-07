# partida
# Maneja el estado y la puntuacion de una partida entre dos estrategias.
class Partida
  attr_reader :jugador1, :jugador2, :modo, :objetivo, :ronda_actual

  def initialize(nombre1, estrategia1, nombre2, estrategia2, modo, objetivo)
    @jugador1 = { nombre: nombre1, estrategia: estrategia1, score: 0 }
    @jugador2 = { nombre: nombre2, estrategia: estrategia2, score: 0 }
    @modo = modo          # "Rondas" o "Alcanzar"
    @objetivo = objetivo  # N rondas o N puntos
    @ronda_actual = 0
  end

  def jugar_ronda_con(jugada1, jugada2)
    # Calcula puntos para ambas jugadas y actualiza marcadores.
    puntos = jugada1.puntos(jugada2)
    @jugador1[:score] += puntos[0]
    @jugador2[:score] += puntos[1]
    @ronda_actual += 1
    [jugada1, jugada2, puntos]
  end

  def jugar_ronda_auto
    # Ejecuta una ronda usando ambas estrategias en modo auto.
    j1 = @jugador1[:estrategia].prox
    j2 = @jugador2[:estrategia].prox(j1)
    jugar_ronda_con(j1, j2)
  end

  def terminado?
    # Corta por rondas fijas o por alcanzar N puntos, segun @modo.
    if @modo == "Rondas"
      @ronda_actual >= @objetivo
    else
      @jugador1[:score] >= @objetivo || @jugador2[:score] >= @objetivo
    end
  end

  def ganador
    # Devuelve nombre del ganador o "Empate" si hay igualdad.
    if @jugador1[:score] > @jugador2[:score]
      @jugador1[:nombre]
    elsif @jugador2[:score] > @jugador1[:score]
      @jugador2[:nombre]
    else
      "Empate"
    end
  end
end

# jugada
# Representa una jugada concreta y su relacion de victoria.

class Jugada
  # Cada subclase debe devolver su nombre (String) y lista de clases a las que vence.
  def nombre
    raise NotImplementedError, "Subclase debe implementar #nombre"
  end

  def vence_a
    raise NotImplementedError, "Subclase debe implementar #vence_a (Array de clases)"
  end

  # Representación en texto
  def to_s
    nombre
  end

  # Lógica de puntaje contra otra jugada
  # Retorna [ptos_propios, ptos_contrincante]
  def puntos(contrincante)
    # Validaciones defensivas
    unless contrincante.is_a?(Jugada)
      raise ArgumentError, "contrincante debe ser una Jugada"
    end

    if contrincante.class == self.class
      return [0, 0] # Empate
    end

    if vence_a.include?(contrincante.class)
      return [1, 0] # Yo gano
    else
      return [0, 1] # Yo pierdo
    end
  end
end

class Piedra < Jugada
  def nombre
    "Piedra"
  end

  def vence_a
    [Tijera, Lagarto]
  end
end

class Papel < Jugada
  def nombre
    "Papel"
  end

  def vence_a
    [Piedra, Spock]
  end
end

class Tijera < Jugada
  def nombre
    "Tijera"
  end

  def vence_a
    [Papel, Lagarto]
  end
end

class Lagarto < Jugada
  def nombre
    "Lagarto"
  end

  def vence_a
    [Papel, Spock]
  end
end

class Spock < Jugada
  def nombre
    "Spock"
  end

  def vence_a
    [Tijera, Piedra]
  end
end

# estrategia
# Estrategias generan la siguiente jugada con (opcional) info de la jugada rival previa.


class Estrategia
  @@semillaPadre = 42   # Semilla fija para reproducibilidad entre estrategias aleatorias.
  @@rng = Random.new(@@semillaPadre)

    def prox(j = nil)
        raise NotImplementedError, "Subclase debe implementar #prox(j)"
    end
end

class Manual < Estrategia
    def prox(j = nil)
        puts "Elige tu jugada: piedra, papel, tijera, lagarto, spock"
        input = gets.strip.downcase.to_sym
        case input
        when :piedra  then Piedra.new
        when :papel   then Papel.new
        when :tijera  then Tijera.new
        when :lagarto then Lagarto.new
        when :spock   then Spock.new
        else
            puts "Entrada inválida. Se usará Piedra por defecto."
            Piedra.new
        end
    end
end

class Uniforme < Estrategia
  def initialize(lista)
    @lista = lista # lista de clases de jugadas (ej: [Papel, Lagarto, Spock])
  end

  def prox(_ = nil)
    @lista.sample(random: @@rng).new
  end
end


class Sesgada < Estrategia
    def initialize(pesos)
    # Expande la lista segun peso para lograr muestreo ponderado.
        @jugadas = []
        pesos.each do |jugada, peso|
            @jugadas += [jugada] * peso.to_i
        end
    end

    def prox(j = nil)
        @jugadas.sample(random: @@rng).new
    end
end

class Copiar < Estrategia
  def initialize
    @ultima_oponente = nil
  end

  def prox(j = nil)
    if @ultima_oponente.nil?
      # Primera ronda: aleatorio
      jugada = [Piedra, Papel, Tijera, Lagarto, Spock].sample(random: @@rng).new
    else
      # Copia la jugada que el oponente hizo en la ronda anterior
      jugada = @ultima_oponente
    end

    # Actualiza para la próxima ronda
    @ultima_oponente = j
    jugada
  end
end

class Pensar < Estrategia
    def initialize
        @historial = Hash.new(0)
    end

    def prox(j = nil)
        @historial[j.class] += 1 if j

        # Si no hay historial, elige aleatorio
        return [Piedra, Papel, Tijera, Lagarto, Spock].sample(random: @@rng).new if @historial.empty?

        # Encuentra la jugada más frecuente del oponente
        mas_frecuente = @historial.max_by { |_, v| v }[0]

        # Busca qué clase la vence
        vencedores = [Piedra, Papel, Tijera, Lagarto, Spock].select do |jugada|
            jugada.new.vence_a.include?(mas_frecuente)
        end

        vencedores.sample(random: @@rng).new
    end
end


