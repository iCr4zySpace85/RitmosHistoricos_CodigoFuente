package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import Player; // Importa Player directamente ya que está en la misma carpeta
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import Controls; // Importa Controls directamente desde la misma carpeta

class MiniGameState extends FlxState {
    public var controls:Controls; // Variable pública para los controles personalizados

    private var player:Player;
    private var goal:FlxSprite;
    private var txtInstruction:FlxText;
    private var bg:FlxSprite;
    private var soundPlayed:Bool = false; // Para controlar si ya se reprodujo el sonido
    private var dialogBox:FlxText; // Cuadro de diálogo
    private var dialogImage:FlxSprite;  // Imagen del cuadro de diálogo
    private var dialogShown:Bool = false; // Controla si el cuadro de diálogo está visible
    private var dialogFinished:Bool = false; // Controla si el diálogo terminó

    override public function create():Void {
        super.create();

        // Instanciar la clase Controls con el nombre del esquema (opcional)
        controls = new Controls("PlayerControls");

        // Cargar el fondo del minijuego
        bg = new FlxSprite(0, 0);
        bg.loadGraphic("crono_test"); // Como todos los archivos están en la misma carpeta
        add(bg);
        
        // Crear el objetivo (puedes reemplazarlo con un sprite más adecuado)
        goal = new FlxSprite(FlxG.width - 50, FlxG.height / 2 - 16);
        goal.makeGraphic(32, 32, FlxColor.GREEN);
        add(goal);

        // Crear el jugador
        player = new Player(50, FlxG.height / 2 - 16);
        add(player);

        
        // Crear la imagen del cuadro de diálogo (inicialmente invisible)
        dialogImage = new FlxSprite(0, 0);
        dialogImage.loadGraphic("box");  // Cargar el asset desde la misma carpeta
        dialogImage.alpha = 0;  // Comienza invisible
        add(dialogImage);

        // Crear el cuadro de diálogo (visible inicialmente pero fuera de la pantalla)
        dialogBox = new FlxText(0, 0, FlxG.width, "Entonces yo seré tu oponente.", 16);
        dialogBox.setFormat(null, 16, FlxColor.WHITE, "center");
        dialogBox.alpha = 0; // Inicia invisible
        add(dialogBox);

        // Hacer que la cámara siga al jugador
        FlxG.camera.follow(player);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    
        // Verificar si el jugador ha alcanzado el objetivo y presionó la tecla ACCEPT
        if (player.overlaps(goal) && controls.ACCEPT) {
            showDialogBox();
        }
    
        // Actualizar la posición de la imagen y el cuadro de diálogo
        dialogImage.x = FlxG.camera.scroll.x + (FlxG.width - dialogImage.width) / 2; // Centrar la imagen
        dialogImage.y = FlxG.camera.scroll.y + FlxG.height - dialogImage.height - 20; // Cerca del borde inferior
    
        dialogBox.x = dialogImage.x - 440;  // Texto alineado dentro de la imagen
        dialogBox.y = dialogImage.y + ((dialogImage.height - dialogBox.height) / 2) - 35;  // Centrar verticalmente el texto
    
        // Restringir el movimiento del jugador dentro de los límites de la imagen de fondo
        if (player.x < 0) {
            player.x = 0;
        } else if (player.x + player.width > bg.width) {
            player.x = bg.width - player.width;
        }
    
        if (player.y < 0) {
            player.y = 0;
        } else if (player.y + player.height > bg.height) {
            player.y = bg.height - player.height;
        }
    }
    
    private function showDialogBox():Void {
        // Verificar si los objetos están correctamente inicializados
        if (dialogImage != null && dialogBox != null) {
            // Mostrar la imagen y el cuadro de diálogo con una transición suave
            FlxTween.tween(dialogImage, { alpha: 1 }, 0.5, { onComplete: function(twn:FlxTween):Void {
                FlxTween.tween(dialogBox, { alpha: 1 }, 0.5, { onComplete: function(twn:FlxTween):Void {
                    // Después de mostrar, puedes poner otra transición para desvanecer
                    FlxTween.tween(dialogImage, { alpha: 0 }, 1.5, { onComplete: function(twn:FlxTween):Void {
                        // Cambiar al estado de juego principal (o pasar al siguiente nivel)
                        FlxG.switchState(new PlayState());
                    }});
                    FlxTween.tween(dialogBox, { alpha: 0 }, 1.5);
                }});
            }});
        }
    }
}
