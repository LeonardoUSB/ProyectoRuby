require 'shoes'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto, Spock", width: 840, height: 420, resizable: false) do
    background "#1e1e1e"

    def heading(txt)
        para strong(txt), stroke: white, size: 22, align: "center"
    end

    def label_text(txt)
        para txt, stroke: white, size: 12
    end

    stack(margin: 50) do
        heading "Piedra, Papel, Tijera, Lagarto, Spock"

        stack(margin_top: 30) do
            label_text "Nombre del Jugador 1:"
            @name1 = edit_line("Jugador1", width: 200)
            label_text "Nombre del Jugador 2:"
            @name2 = edit_line("Jugador2", width: 200)
        end

        stack(margin_top: 10) do
            label_text "Modo de juego:"
            flow(margin_top: 5) do
                @rb_rondas = radio :modo
                para "Rondas", stroke: white, margin_right: 40
                @rb_alcanzar = radio :modo
                para "Alcanzar", stroke: white
            end
            @rb_rondas.checked
        end

        stack(margin_top: 20, align: "center") do
            button "Iniciar juego" do
                nombre1 = @name1.text.strip.empty? ? "Jugador1" : @name1.text.strip
                nombre2 = @name2.text.strip.empty? ? "Jugador2" : @name2.text.strip
                modo = @rb_alcanzar.checked? ? "Alcanzar" : "Rondas"
                alert "Iniciando juego...\n#{nombre1} vs #{nombre2}\nModo: #{modo}"
            end
        end
    end
end
