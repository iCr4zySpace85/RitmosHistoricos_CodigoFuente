package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.animation.FlxAnimationController;

class Player extends FlxSprite {
    public var speed:Float = 500;
    public var controls:Controls;

    
    public function new(x:Float, y:Float) {
        super(x, y);

        // Cargar el atlas de texturas
        frames = Paths.getSparrowAtlas('boyfriendrpg');

        // Definir las animaciones usando el prefijo adecuado
        animation.addByIndices('down', 'boyfriend_down', [0, 1, 2, 3], "", 10, true);
        animation.addByIndices('left', 'boyfriend_left', [0, 1, 2, 3], "", 10, true);
        animation.addByIndices('right', 'boyfriend_right', [0, 1, 2, 3], "", 10, true);
        animation.addByIndices('up', 'boyfriend_up', [0, 1, 2, 3], "", 10, true);

        // Iniciar con la animación "down"
        animation.play("down");

        // Crear una instancia de Controls (asegúrate de que los controles estén configurados correctamente)
        controls = new Controls("PlayerControls");
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Resetear la velocidad
        velocity.x = 0;
        velocity.y = 0;

        // Movimiento basado en controles
        var moving:Bool = false;

        if (FlxG.keys.pressed.LEFT) {
            velocity.x = -speed;
            animation.play("left");
            moving = true;
        } else if (FlxG.keys.pressed.RIGHT) {
            velocity.x = speed;
            animation.play("right");
            moving = true;
        }

        if (FlxG.keys.pressed.UP) {
            velocity.y = -speed;
            animation.play("up");
            moving = true;
        } else if (FlxG.keys.pressed.DOWN) {
            velocity.y = speed;
            animation.play("down");
            moving = true;
        }

        // Si no hay movimiento, puedes establecer una animación de reposo, si la tienes
        if (!moving) {
            animation.stop();
        }
    }
}
