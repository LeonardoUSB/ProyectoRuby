# main.rb

begin
  class Java::OrgEclipseSwtWidgets::Button
    def enable_widget(val)
      self.enabled = val
    end
  end
rescue
end
$VERBOSE = nil

require 'shoes'
require_relative 'RPTLS'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto, Spock", width: 900, height: 750, resizable: false) do
  # Paleta de colores
  @color_fondo = "#1e293b"
  @color_secundario = "#1e293b"
  @color_acento = "#3b82f6"
  @color_acento2 = "#8b5cf6"
  @color_texto = "#f1f5f9"
  @color_texto_sec = "#94a3b8"
  @color_exito = "#10b981"
  @color_peligro = "#ef4444"
  
  background @color_fondo
  
  #Definir formato para el heading y labels
  def heading(txt)
    para strong(txt), stroke: @color_texto, size: 28, align: "center", margin_bottom: 10
  end

  def subheading(txt)
    para strong(txt), stroke: @color_acento, size: 18, align: "left", margin_bottom: 5
  end

  def label_text(txt)
    para txt, stroke: @color_texto, size: 13, margin_bottom: 5
  end
  
  def label_text_sec(txt)
    para txt, stroke: @color_texto_sec, size: 11, margin_bottom: 3
  end
  
  # Pantalla inicial de configuración
  stack(margin: 0.01) do
    @time_display = para ""

  every(1) do # Ejecuta el bloque cada segundo
    @time_display.text = ""
  end
    # Título principal centrado
    stack(margin_bottom: 5) do
      heading "Piedra, Papel, Tijera, Lagarto, Spock"
      para "Configura tu partida", stroke: @color_texto_sec, size: 14, align: "center"
    end

    #contenedor centrado para el formulario
    stack(width: 800, margin: "0 auto") do
      stack(margin_top: 5, margin_right:20, margin_left:20, margin_bottom: 15) do
        subheading "Jugadores"
        flow(margin_top: 10) do
          stack(width: 0.48) do
            label_text "Jugador 1:"
            @name1 = edit_line("Jugador1", width: 350)
          end
          stack(width: 0.04) {}
          stack(width: 0.48) do
            label_text "Jugador 2:"
            @name2 = edit_line("Jugador2", width: 350)
          end
        end
      end
      stack(margin_top: 15, margin_right:20, margin_left:20, margin_bottom: 15) do
        subheading "Configuración del Juego"
        
        flow(margin_top: 10) do
          stack(width: 0.48) do
            label_text "Modo de juego:"
            flow(margin_top: 5) do
              @rb_rondas   = radio :modo; para "Rondas", stroke: @color_texto, margin_right: 30
              @rb_alcanzar = radio :modo; para "Alcanzar", stroke: @color_texto
            end
            @rb_rondas.checked = true
          end
          
          stack(width: 0.04) {}
          
          stack(width: 0.48) do
            label_text "Cantidad de rondas/puntos (N):"
            @objetivo = edit_line("5", width: 100)
          end
        end
      end
      stack(margin_top: 15, margin_right:20, margin_left:20, margin_bottom: 15) do
        subheading "Estrategia del Jugador 1"
        
        flow(margin_top: 10) do
          @rb_manual   = radio :estrategia; para "Manual", stroke: @color_texto, margin_right: 20
          @rb_uniforme = radio :estrategia; para "Uniforme", stroke: @color_texto, margin_right: 20
          @rb_sesgada  = radio :estrategia; para "Sesgada", stroke: @color_texto, margin_right: 20
          @rb_copiar   = radio :estrategia; para "Copiar", stroke: @color_texto, margin_right: 20
          @rb_pensar   = radio :estrategia; para "Pensar", stroke: @color_texto
        end
        @rb_manual.checked = true
        
        #si se escoge Sesgada
        @sesgada_pesos1 = stack(margin_top: 15) do
          background @color_fondo, curve: 8
          stack(margin: 15) do
            label_text_sec "Ajusta los pesos para cada opción:"
            flow(margin_top: 8) do
              stack(width: 0.19) do
                para "Piedra", stroke: @color_texto_sec, size: 11
                @peso_piedra1 = edit_line("5", width: 60)
              end
              stack(width: 0.19) do
                para "Papel", stroke: @color_texto_sec, size: 11
                @peso_papel1 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Tijera", stroke: @color_texto_sec, size: 11
                @peso_tijera1 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Lagarto", stroke: @color_texto_sec, size: 11
                @peso_lagarto1 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Spock", stroke: @color_texto_sec, size: 11
                @peso_spock1 = edit_line("1", width: 60)
              end
            end
          end
        end
        @sesgada_pesos1.hide

        #si se escoge Uniforme
        @uniforme_opciones1 = stack(margin_top: 15) do
          stack(margin: 15) do
            label_text_sec "Selecciona las opciones disponibles:"
            flow(margin_top: 8) do
              @chk_piedra1  = check; para "Piedra", stroke: @color_texto_sec, margin_right: 15
              @chk_papel1   = check; para "Papel", stroke: @color_texto_sec, margin_right: 15
              @chk_tijera1  = check; para "Tijera", stroke: @color_texto_sec, margin_right: 15
              @chk_lagarto1 = check; para "Lagarto", stroke: @color_texto_sec, margin_right: 15
              @chk_spock1   = check; para "Spock", stroke: @color_texto_sec
            end
          end
        end
        @uniforme_opciones1.hide

        @rb_manual.click do
          @sesgada_pesos1.hide
          @uniforme_opciones1.hide
          @rb_uniforme.checked = false 
          @rb_sesgada.checked  = false
          @rb_copiar.checked   = false
          @rb_pensar.checked   = false
        end

        @rb_uniforme.click do
          @sesgada_pesos1.hide
          @uniforme_opciones1.show
          @rb_manual.checked = false 
          @rb_sesgada.checked  = false
          @rb_copiar.checked   = false
          @rb_pensar.checked   = false
        end

        @rb_sesgada.click do
          @uniforme_opciones1.hide
          @sesgada_pesos1.show
          @rb_manual.checked = false 
          @rb_uniforme.checked = false
          @rb_copiar.checked   = false
          @rb_pensar.checked   = false
        end

        @rb_copiar.click do
          @sesgada_pesos1.hide
          @uniforme_opciones1.hide
          @rb_manual.checked = false 
          @rb_uniforme.checked = false
          @rb_sesgada.checked  = false
          @rb_pensar.checked   = false
        end
        
        @rb_pensar.click do
          @sesgada_pesos1.hide
          @uniforme_opciones1.hide
          @rb_manual.checked = false 
          @rb_uniforme.checked = false
          @rb_sesgada.checked  = false
          @rb_copiar.checked   = false
        end
      end
      stack(margin_top: 15, margin_right:20, margin_left:20, margin_bottom: 15) do
        subheading "Estrategia del Jugador 2"
        
        flow(margin_top: 10) do
          @rb2_manual   = radio :estrategia2; para "Manual", stroke: @color_texto, margin_right: 20
          @rb2_uniforme = radio :estrategia2; para "Uniforme", stroke: @color_texto, margin_right: 20
          @rb2_sesgada  = radio :estrategia2; para "Sesgada", stroke: @color_texto, margin_right: 20
          @rb2_copiar   = radio :estrategia2; para "Copiar", stroke: @color_texto, margin_right: 20
          @rb2_pensar   = radio :estrategia2; para "Pensar", stroke: @color_texto
        end
        @rb2_manual.checked = true

        #si se escoge Sesgada
        @sesgada_pesos2 = stack(margin_top: 15) do
          stack(margin: 15) do
            label_text_sec "Ajusta los pesos para cada opción:"
            flow(margin_top: 8) do
              stack(width: 0.19) do
                para "Piedra", stroke: @color_texto_sec, size: 11
                @peso_piedra2 = edit_line("5", width: 60)
              end
              stack(width: 0.19) do
                para "Papel", stroke: @color_texto_sec, size: 11
                @peso_papel2 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Tijera", stroke: @color_texto_sec, size: 11
                @peso_tijera2 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Lagarto", stroke: @color_texto_sec, size: 11
                @peso_lagarto2 = edit_line("1", width: 60)
              end
              stack(width: 0.19) do
                para "Spock", stroke: @color_texto_sec, size: 11
                @peso_spock2 = edit_line("1", width: 60)
              end
            end
          end
        end
        @sesgada_pesos2.hide

        #si se escoge Uniforme
        @uniforme_opciones2 = stack(margin_top: 15) do
          stack(margin: 15) do
            label_text_sec "Selecciona las opciones disponibles:"
            flow(margin_top: 8) do
              @chk_piedra2  = check; para "Piedra", stroke: @color_texto_sec, margin_right: 15
              @chk_papel2   = check; para "Papel", stroke: @color_texto_sec, margin_right: 15
              @chk_tijera2  = check; para "Tijera", stroke: @color_texto_sec, margin_right: 15
              @chk_lagarto2 = check; para "Lagarto", stroke: @color_texto_sec, margin_right: 15
              @chk_spock2   = check; para "Spock", stroke: @color_texto_sec
            end
          end
        end
        @uniforme_opciones2.hide

        #logica de mostrar/ocultar
        @rb2_manual.click do
          @sesgada_pesos2.hide
          @uniforme_opciones2.hide
          @rb2_uniforme.checked = false 
          @rb2_sesgada.checked  = false
          @rb2_copiar.checked   = false
          @rb2_pensar.checked   = false

        end

        @rb2_uniforme.click do
          @sesgada_pesos2.hide
          @uniforme_opciones2.show
          @rb2_manual.checked = false 
          @rb2_sesgada.checked  = false
          @rb2_copiar.checked   = false
          @rb2_pensar.checked   = false
        end

        @rb2_sesgada.click do
          @uniforme_opciones2.hide
          @sesgada_pesos2.show
          @rb2_manual.checked = false 
          @rb2_uniforme.checked = false
          @rb2_copiar.checked   = false
          @rb2_pensar.checked   = false
        end
        @rb2_copiar.click do
          @sesgada_pesos2.hide
          @uniforme_opciones2.hide
          @rb2_manual.checked = false 
          @rb2_uniforme.checked = false
          @rb2_sesgada.checked  = false
          @rb2_pensar.checked   = false
        end
        @rb2_pensar.click do
          @sesgada_pesos2.hide
          @uniforme_opciones2.hide
          @rb2_manual.checked = false 
          @rb2_uniforme.checked = false
          @rb2_sesgada.checked  = false
          @rb2_copiar.checked   = false
        end
      end
    end

    #boton iniciar
    stack(margin_top: 30, align: "center") do
      button "Iniciar Juego", width: 200, height: 50 do
        #lee configuracion inicial y corrige valores vacios o invalidos
        nombre1 = @name1.text.strip
        nombre1 = "Jugador1" if nombre1.empty?
        nombre2 = @name2.text.strip
        nombre2 = "Jugador2" if nombre2.empty?
        modo = @rb_alcanzar.checked? ? "Alcanzar" : "Rondas"
        objetivo = @objetivo.text.to_i
        objetivo = 1 if objetivo <= 0

        #estrategia Jugador 1
        estrategia1 =
          if @rb_manual.checked?   then Manual.new
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
          elsif @rb_copiar.checked?   then Copiar.new
          elsif @rb_pensar.checked?   then Pensar.new
          else
            alert "Debes seleccionar al menos una opción para la estrategia del Jugador 1." 
            return
          end

        # Estrategia Jugador 2
        estrategia2 =
          if @rb2_manual.checked?   then Manual.new
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
          elsif @rb2_copiar.checked?   then Copiar.new
          elsif @rb2_pensar.checked?   then Pensar.new
          else 
            alert "Debes seleccionar al menos una opción para la estrategia del Jugador 2."
            return
          end

        #inicio de Partida y montar pantalla de juego
        partida = Partida.new(nombre1, estrategia1, nombre2, estrategia2, modo, objetivo)

        #limpiar pantalla y montar UI de juego
        clear do
          background @color_fondo

          stack(margin: 30) do
            stack(margin_bottom: 20) do
              background @color_secundario, curve: 10
              stack(margin: 20) do
                para "#{nombre1} vs #{nombre2}", stroke: @color_texto, size: 24, align: "center"
                para "Modo: #{modo} | Objetivo: #{objetivo}", stroke: @color_texto_sec, size: 14, align: "center"
              end
            end
            #marcador de puntos
            @score_flow = stack(margin_bottom: 20) do
              background @color_secundario, curve: 10
              flow(margin: 20) do
                stack(width: 0.46) do
                  background @color_acento, curve: 8
                  stack(margin: 15) do
                    @score1 = para "#{nombre1}\n0 puntos", stroke: white, size: 16, align: "center"
                  end
                end
                
                stack(width: 0.08) do
                  para "VS", stroke: @color_texto_sec, size: 18, align: "center", margin_top: 15
                end
                
                stack(width: 0.46) do
                  background @color_acento2, curve: 8
                  stack(margin: 15) do
                    @score2 = para "#{nombre2}\n0 puntos", stroke: white, size: 16, align: "center"
                  end
                end
              end
            end
            
            #columnas de botones para jugadas manuales
            @manual_buttons = stack(margin_bottom: 20) do
              background @color_secundario, curve: 10
              stack(margin: 20) do
                flow do
                  #columna Jugador 1
                  stack(width: 0.48) do
                    para "#{nombre1}", stroke: @color_acento, size: 16, align: "center"
                    
                    if estrategia1.is_a?(Manual)
                      @jugada_label1 = para "Selecciona tu jugada", stroke: @color_texto_sec, margin_top: 10, align: "center"

                      flow(margin_top: 10) do
                        @btn_piedra1  = image("fotos/roca.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual1 = Piedra.new
                          @jugada_label1.text = "Roca"
                        end
                        @btn_papel1   = image("fotos/papel.png",  width: 70, height: 70, margin: 5).click do
                          @jugada_manual1 = Papel.new
                          @jugada_label1.text = "Papel"
                        end
                        @btn_tijera1  = image("fotos/tijera.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual1 = Tijera.new
                          @jugada_label1.text = "Tijera"
                        end
                        @btn_lagarto1 = image("fotos/lagarto.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual1 = Lagarto.new
                          @jugada_label1.text = "Lagarto"
                        end
                        @btn_spock1   = image("fotos/spock.png",  width: 70, height: 70, margin: 5).click do
                          @jugada_manual1 = Spock.new
                          @jugada_label1.text = "Spock"
                        end
                      end
                    else
                      @jugada_label1 = para "Automático", stroke: @color_exito, margin_top: 10, align: "center", size: 14
                    end
                  end

                  stack(width: 0.04) {}

                  #columna Jugador 2
                  stack(width: 0.48) do
                    para "#{nombre2}", stroke: @color_acento2, size: 16, align: "center"
                    
                    if estrategia2.is_a?(Manual)
                      @jugada_label2 = para "Selecciona tu jugada", stroke: @color_texto_sec, margin_top: 10, align: "center"

                      flow(margin_top: 10) do
                        @btn_piedra2  = image("fotos/roca.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual2 = Piedra.new
                          @jugada_label2.text = "Roca"
                        end
                        @btn_papel2   = image("fotos/papel.png",  width: 70, height: 70, margin: 5).click do
                          @jugada_manual2 = Papel.new
                          @jugada_label2.text = "Papel"
                        end
                        @btn_tijera2  = image("fotos/tijera.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual2 = Tijera.new
                          @jugada_label2.text = "Tijera"
                        end
                        @btn_lagarto2 = image("fotos/lagarto.png", width: 70, height: 70, margin: 5).click do
                          @jugada_manual2 = Lagarto.new
                          @jugada_label2.text = "Lagarto"
                        end
                        @btn_spock2   = image("fotos/spock.png",  width: 70, height: 70, margin: 5).click do
                          @jugada_manual2 = Spock.new
                          @jugada_label2.text = "Spock"
                        end
                      end
                    else
                      @jugada_label2 = para "Automático", stroke: @color_exito, margin_top: 10, align: "center", size: 14
                    end
                  end
                end
              end
            end
            
            #vista de la ronda y jugadas
            @ronda_info = stack(margin_bottom: 20) do
              background @color_secundario, curve: 10
              stack(margin: 20) do
                @ronda_label = para "Ronda: 0", stroke: @color_texto, size: 16, align: "center"
                @jugadas_label = para "Esperando jugadas...", stroke: @color_texto_sec, size: 14, align: "center", margin_top: 5
              end
            end

            #boton avanzar centrado
            stack(align: "center") do
              @btn_next = button "Siguiente Ronda", width: 250, height: 50
            end

            @btn_next.click do
              #construir jugadas y jugar ronda
              jugada1 =
                if estrategia1.is_a?(Manual)
                  @jugada_manual1
                else
                  estrategia1.prox
                end

              jugada2 =
                if estrategia2.is_a?(Manual)
                  @jugada_manual2
                else
                  estrategia2.prox(jugada1)
                end

              j1, j2, puntos = partida.jugar_ronda_con(jugada1, jugada2)

              #actualizar UI
              @ronda_label.text = "Ronda: #{partida.ronda_actual}"
              @jugadas_label.text = "#{nombre1} juega #{j1} | #{nombre2} juega #{j2}"
              @score1.text = "#{nombre1}\n#{partida.jugador1[:score]} puntos"
              @score2.text = "#{nombre2}\n#{partida.jugador2[:score]} puntos"

              # Fin de partida
              if partida.terminado?
                ganador = partida.ganador
                @btn_next.state = "disabled"
                if ganador == "Empate"
                  alert "Juego terminado. ¡Empate!"
                  return
                else
                  alert "Juego terminado. ¡Ganador: #{ganador}!"
                  return
                end
              end
            end
          end
        end
      end
    end
  end
end