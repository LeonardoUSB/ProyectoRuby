# main.rb

require 'shoes'
require_relative 'RPTLS'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto, Spock", width: 900, height: 700, resizable: false) do
  background "#1e1e1e"
  ##Definir formato para el heading y labels
  def heading(txt)
    # Helper para títulos consistentes.
    para strong(txt), stroke: white, size: 22, align: "center"
  end

  def label_text(txt)
    # Helper para etiquetas pequeñas en blanco.
    para txt, stroke: white, size: 12
  end
  # Pantalla inicial de configuración
  stack(margin: 50) do
    heading "Piedra, Papel, Tijera, Lagarto, Spock"

    # Nombres
    stack(margin_top: 30) do
      label_text "Nombre del Jugador 1:"
      @name1 = edit_line("Jugador1", width: 200)
      label_text "Nombre del Jugador 2:"
      @name2 = edit_line("Jugador2", width: 200)
    end

    # Modo de juego
    stack(margin_top: 10) do
      label_text "Modo de juego:"
      flow(margin_top: 5) do
        @rb_rondas   = radio :modo; para "Rondas", stroke: white, margin_right: 40
        @rb_alcanzar = radio :modo; para "Alcanzar", stroke: white
      end
      @rb_rondas.checked
    end

    # Objetivo (N)
    stack(margin_top: 10) do
      label_text "Cantidad de rondas/puntos (N):"
      @objetivo = edit_line("5", width: 60)
    end

    # Estrategia Jugador 1
    stack(margin_top: 10) do
      label_text "Estrategia del Jugador 1:"
      flow(margin_top: 5) do
        @rb_manual   = radio :estrategia1; para "Manual", stroke: white, margin_right: 40
        @rb_uniforme = radio :estrategia1; para "Uniforme", stroke: white, margin_right: 40
        @rb_sesgada  = radio :estrategia1; para "Sesgada", stroke: white, margin_right: 40
        @rb_copiar   = radio :estrategia1; para "Copiar", stroke: white, margin_right: 40
        @rb_pensar   = radio :estrategia1; para "Pensar", stroke: white
      end
      @rb_manual.checked

      # Bloque de pesos si se escoge Sesgada
      @sesgada_pesos1 = stack(margin_top: 25) do
        label_text "Pesos (Jugador 1):"
        flow do
          para "Piedra", stroke: white;  @peso_piedra1  = edit_line("5", width: 40)
          para "Papel", stroke: white;   @peso_papel1   = edit_line("1", width: 40)
          para "Tijera", stroke: white;  @peso_tijera1  = edit_line("1", width: 40)
          para "Lagarto", stroke: white; @peso_lagarto1 = edit_line("1", width: 40)
          para "Spock", stroke: white;   @peso_spock1   = edit_line("1", width: 40)
        end
      end
      @sesgada_pesos1.hide

      # Bloque de opciones si se escoge Uniforme
      @uniforme_opciones1 = stack(margin_top: 10) do
        label_text "Opciones para Uniforme (Jugador 1):"
        flow do
          @chk_piedra1  = check; para "Piedra", stroke: white, margin_right: 20
          @chk_papel1   = check; para "Papel", stroke: white, margin_right: 20
          @chk_tijera1  = check; para "Tijera", stroke: white, margin_right: 20
          @chk_lagarto1 = check; para "Lagarto", stroke: white, margin_right: 20
          @chk_spock1   = check; para "Spock", stroke: white
        end
      end
      @uniforme_opciones1.hide

      # Lógica de mostrar/ocultar
      @rb_manual.click do
        @sesgada_pesos1.hide
        @uniforme_opciones1.hide
      end

      @rb_uniforme.click do
        @sesgada_pesos1.hide
        @uniforme_opciones1.show
      end

      @rb_sesgada.click do
        @uniforme_opciones1.hide
        @sesgada_pesos1.show
      end

      [@rb_copiar, @rb_pensar].each do |rb|
        rb.click do
          @sesgada_pesos1.hide
          @uniforme_opciones1.hide
        end
      end
    end

    # Estrategia Jugador 2
    stack(margin_top: 60) do
      label_text "Estrategia del Jugador 2:"
      flow(margin_top: 5) do
        @rb2_manual   = radio :estrategia2; para "Manual", stroke: white, margin_right: 40
        @rb2_uniforme = radio :estrategia2; para "Uniforme", stroke: white, margin_right: 40
        @rb2_sesgada  = radio :estrategia2; para "Sesgada", stroke: white, margin_right: 40
        @rb2_copiar   = radio :estrategia2; para "Copiar", stroke: white, margin_right: 40
        @rb2_pensar   = radio :estrategia2; para "Pensar", stroke: white
      end
      @rb2_manual.checked

      # Bloque de pesos si se escoge Sesgada
      @sesgada_pesos2 = stack(margin_top: 25) do
        label_text "Pesos (Jugador 2):"
        flow do
          para "Piedra", stroke: white;  @peso_piedra2  = edit_line("5", width: 40)
          para "Papel", stroke: white;   @peso_papel2   = edit_line("1", width: 40)
          para "Tijera", stroke: white;  @peso_tijera2  = edit_line("1", width: 40)
          para "Lagarto", stroke: white; @peso_lagarto2 = edit_line("1", width: 40)
          para "Spock", stroke: white;   @peso_spock2   = edit_line("1", width: 40)
        end
      end
      @sesgada_pesos2.hide

      # Bloque de opciones si se escoge Uniforme
      @uniforme_opciones2 = stack(margin_top: 10) do
        label_text "Opciones para Uniforme (Jugador 2):"
        flow do
          @chk_piedra2  = check; para "Piedra", stroke: white, margin_right: 20
          @chk_papel2   = check; para "Papel", stroke: white, margin_right: 20
          @chk_tijera2  = check; para "Tijera", stroke: white, margin_right: 20
          @chk_lagarto2 = check; para "Lagarto", stroke: white, margin_right: 20
          @chk_spock2   = check; para "Spock", stroke: white
        end
      end
      @uniforme_opciones2.hide

      # Lógica de mostrar/ocultar
      @rb2_manual.click do
        @sesgada_pesos2.hide
        @uniforme_opciones2.hide
      end

      @rb2_uniforme.click do
        @sesgada_pesos2.hide
        @uniforme_opciones2.show
      end

      @rb2_sesgada.click do
        @uniforme_opciones2.hide
        @sesgada_pesos2.show
      end

      [@rb2_copiar, @rb2_pensar].each do |rb|
        rb.click do
          @sesgada_pesos2.hide
          @uniforme_opciones2.hide
        end
      end
    end


    # Botón iniciar
    stack(margin_top: 40, align: "center") do
      button "Iniciar juego" do
        # Lee configuracion inicial y normaliza valores vacios o invalidos.
        nombre1 = @name1.text.strip
        nombre1 = "Jugador1" if nombre1.empty?
        nombre2 = @name2.text.strip
        nombre2 = "Jugador2" if nombre2.empty?
        modo = @rb_alcanzar.checked? ? "Alcanzar" : "Rondas"
        objetivo = @objetivo.text.to_i
        objetivo = 1 if objetivo <= 0

        # Estrategia Jugador 1
        estrategia1 =
          #Si escoge Manual
          if @rb_manual.checked?   then Manual.new
          #Si escoge Uniforme crea lista con las opciones seleccionadas
          elsif @rb_uniforme.checked?
            lista = []
            lista << Piedra  if @chk_piedra1.checked?
            lista << Papel   if @chk_papel1.checked?
            lista << Tijera  if @chk_tijera1.checked?
            lista << Lagarto if @chk_lagarto1.checked?
            lista << Spock   if @chk_spock1.checked?

            if lista.empty?
              alert "Debes seleccionar al menos una opción para Uniforme. Se usarán todas por defecto."
              lista = [Piedra, Papel, Tijera, Lagarto, Spock]
            end

            Uniforme.new(lista)
          #Si escoge Sesgada se crea un hash con los pesos
          elsif @rb_sesgada.checked?
            pesos = {
              Piedra  => (@peso_piedra1.text.to_i rescue 0),
              Papel   => (@peso_papel1.text.to_i rescue 0),
              Tijera  => (@peso_tijera1.text.to_i rescue 0),
              Lagarto => (@peso_lagarto1.text.to_i rescue 0),
              Spock   => (@peso_spock1.text.to_i rescue 0)
            }
            if pesos.values.sum == 0
              alert "Los pesos no pueden ser todos cero. Se usarán valores por defecto."
              pesos = { Piedra=>5, Papel=>1, Tijera=>1, Lagarto=>1, Spock=>1 }
            end
            Sesgada.new(pesos)
          #Si escoge Copiar
          elsif @rb_copiar.checked?   then Copiar.new
          #Si escoge Pensar
          elsif @rb_pensar.checked?   then Pensar.new
          end

        # Estrategia Jugador 2
        estrategia2 =
          #Si escoge Manual
          if @rb2_manual.checked?   then Manual.new
          #Si escoge Uniforme crea lista con las opciones seleccionadas
          elsif @rb2_uniforme.checked? 
            lista = []
            lista << Piedra  if @chk_piedra2.checked?
            lista << Papel   if @chk_papel2.checked?
            lista << Tijera  if @chk_tijera2.checked?
            lista << Lagarto if @chk_lagarto2.checked?
            lista << Spock   if @chk_spock2.checked?

            if lista.empty?
              alert "Debes seleccionar al menos una opción para Uniforme. Se usarán todas por defecto."
              lista = [Piedra, Papel, Tijera, Lagarto, Spock]
            end

            Uniforme.new(lista)

          elsif @rb2_sesgada.checked?
            #Si escoge Sesgada se crea un hash con los pesos
            pesos = {
              Piedra  => (@peso_piedra2.text.to_i rescue 0),
              Papel   => (@peso_papel2.text.to_i rescue 0),
              Tijera  => (@peso_tijera2.text.to_i rescue 0),
              Lagarto => (@peso_lagarto2.text.to_i rescue 0),
              Spock   => (@peso_spock2.text.to_i rescue 0)
            }
            if pesos.values.sum == 0
              alert "Los pesos no pueden ser todos cero. Se usarán valores por defecto."
              pesos = { Piedra=>5, Papel=>1, Tijera=>1, Lagarto=>1, Spock=>1 }
            end
            Sesgada.new(pesos)
          #Si escoge Copiar
          elsif @rb2_copiar.checked?   then Copiar.new
          #Si escoge Pensar
          elsif @rb2_pensar.checked?   then Pensar.new
          end

        # Instanciar Partida y montar pantalla de juego
        partida = Partida.new(nombre1, estrategia1, nombre2, estrategia2, modo, objetivo)

        # Limpiar pantalla y montar UI de juego
        clear do
          background "#222"

          # Header
          stack do
            para "Bienvenido #{nombre1} vs #{nombre2}", stroke: white, size: 20
            para "Modo: #{modo} (N = #{objetivo})", stroke: white, size: 16
          end

          # Marcadores
          @score_flow = flow(margin_top: 10) do
            @score1 = para "#{nombre1}: 0", stroke: white, size: 14, margin_right: 40
            @score2 = para "#{nombre2}: 0", stroke: white, size: 14
          end
          
          # Columnas de botones para jugadas manuales
          # Solo se usan cuando la estrategia es Manual; las otras ignoran estos botones.
          @manual_buttons = flow(margin_top: 20) do

            # Columna Jugador 1
          stack(width: 0.5) do
            para "#{nombre1} (elige jugada):", stroke: white
            # Mostrar botones solo si es Manual
            if estrategia1.is_a?(Manual)
              @jugada_label1 = para "Sin elección", stroke: white, margin_top: 5

              @btn_piedra1  = image("fotos/roca.png", width: 80, height: 80).click do
                @jugada_manual1 = Piedra.new
                @jugada_label1.text = "Eligió: Roca"
              end
              @btn_papel1   = image("fotos/papel.png",  width: 80, height: 80).click do
                @jugada_manual1 = Papel.new
                @jugada_label1.text = "Eligió: Papel"
              end
              @btn_tijera1  = image("fotos/tijera.png", width: 80, height: 80).click do
                @jugada_manual1 = Tijera.new
                @jugada_label1.text = "Eligió: Tijera"
              end
              @btn_lagarto1 = image("fotos/lagarto.png",width: 80, height: 80).click do
                @jugada_manual1 = Lagarto.new
                @jugada_label1.text = "Eligió: Lagarto"
              end
              @btn_spock1   = image("fotos/spock.png",  width: 80, height: 80).click do
                @jugada_manual1 = Spock.new
                @jugada_label1.text = "Eligió: Spock"
              end
            else
              # Estrategia automática: no se muestran botones, solo el label
              @jugada_label1 = para "Automático", stroke: white, margin_top: 5
            end
          end

            # Columna Jugador 2
          stack(width: 0.5) do
            para "#{nombre2} (elige jugada):", stroke: white
            # Mostrar botones solo si es Manual
            if estrategia2.is_a?(Manual)
              @jugada_label2 = para "Sin elección", stroke: white, margin_top: 5

              @btn_piedra2  = image("fotos/roca.png", width: 80, height: 80).click do
                @jugada_manual2 = Piedra.new
                @jugada_label2.text = "Eligió: Roca"
              end
              @btn_papel2   = image("fotos/papel.png",  width: 80, height: 80).click do
                @jugada_manual2 = Papel.new
                @jugada_label2.text = "Eligió: Papel"
              end
              @btn_tijera2  = image("fotos/tijera.png", width: 80, height: 80).click do
                @jugada_manual2 = Tijera.new
                @jugada_label2.text = "Eligió: Tijera"
              end
              @btn_lagarto2 = image("fotos/lagarto.png", width: 80, height: 80).click do
                @jugada_manual2 = Lagarto.new
                @jugada_label2.text = "Eligió: Lagarto"
              end
              @btn_spock2   = image("fotos/spock.png",  width: 80, height: 80).click do
                @jugada_manual2 = Spock.new
                @jugada_label2.text = "Eligió: Spock"
              end
            else
              @jugada_label2 = para "Automático", stroke: white, margin_top: 5
            end
          end

          end
          # Visual de la ronda y jugadas
          @ronda_info = stack(margin_top: 10) do
            @ronda_label = para "Ronda: 0", stroke: white, size: 14
            @jugadas_label = para "Esperando jugadas...", stroke: white, size: 14
          end

          # Botón avanzar
          @btn_next = button "Siguiente ronda"

          # Lógica del botón avanzar (soporta Manual y automáticas)
          @btn_next.click do
            # Construir jugadas según estrategia
            jugada1 =
              if estrategia1.is_a?(Manual)
                # Puede quedar nil si el jugador no seleccionó; se valida implícitamente al puntuar.
                @jugada_manual1
              else
                estrategia1.prox
              end

            jugada2 =
              if estrategia2.is_a?(Manual)
                # Si el oponente usa Manual, igual le mostramos diálogo
                @jugada_manual2
              else
                estrategia2.prox(jugada1)
              end

            j1, j2, puntos = partida.jugar_ronda_con(jugada1, jugada2)

            # Actualizar UI
            @ronda_label.text = "Ronda: #{partida.ronda_actual}"
            @jugadas_label.text = "#{nombre1} juega #{j1} | #{nombre2} juega #{j2}"
            @score1.text = "#{nombre1}: #{partida.jugador1[:score]}"
            @score2.text = "#{nombre2}: #{partida.jugador2[:score]}"

            # Fin de partida
            if partida.terminado?
              ganador = partida.ganador
              @btn_next.state = "disabled"
              if ganador == "Empate"
                alert "Juego terminado. Empate."
              else
                alert "Juego terminado. Ganador: #{ganador}"
              end
            end
          end
        end
      end
    end
  end
end
