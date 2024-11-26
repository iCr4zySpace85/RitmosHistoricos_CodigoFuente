package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
    public static var psychEngineVersion:String = '0.6.3'; // Versión actual
    public static var curSelected:Int = 0;
    var playerHitboxVisual:FlxSprite;
    var descriptionText:FlxText; // Texto para las descripciones

    var menuItems:FlxTypedGroup<FlxSprite>;
    private var camGame:FlxCamera;
    private var camAchievement:FlxCamera;
	// Obtener el ancho y alto de la ventana
	var screenWidth = FlxG.width;
	var screenHeight = FlxG.height;
    // Margen desde la esquina
    var margin = 10;


    var optionShit:Array<String> = [
        'story_mode',
        'freeplay',
        // 'credits',
        'options'
    ];

    var magenta:FlxSprite;
    var camFollow:FlxObject;
    var camFollowPos:FlxObject;
    var bg:FlxSprite;
    var debugKeys:Array<FlxKey>;
    var player:Player; // Aquí se declara el jugador que añadimos
    var moveText:FlxText;
    var interactText:FlxText;
    var interactText2:FlxText;
    var moveIcon:FlxSprite;
    var interactIcon1:FlxSprite;
    var interactIcon2:FlxSprite;

    override function create()
    {

        
        FlxG.debugger.visible = true;
        // Creación de cámaras y otras configuraciones
        camGame = new FlxCamera();
        camAchievement = new FlxCamera();
        camAchievement.bgColor.alpha = 0;

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camAchievement, false);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);
        // camGame.zoom = 8; // Aleja la cámara; valores menores a 1 alejan la vista.


        // Cargar la música, el fondo y la configuración del menú
        bg = new FlxSprite(-80).loadGraphic(Paths.image('floor'));
        // bg.scrollFactor.set(0.3, 0.3); // El fondo no se moverá al cambiar la posición de la cámara

        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        

        // Cargar la imagen de la pared
        var wall:FlxSprite = new FlxSprite(-245, -260).loadGraphic(Paths.image('wall')); // Ajusta la posición inicial (100, 50) según lo necesites
        // wall.scrollFactor.set(0.3, 0.3); // Ajusta esto si quieres que la pared se mueva con la cámara o no
        wall.setGraphicSize(Std.int(wall.width * 1.176)); // Escala de la pared, ajusta el factor de escala si es necesario
        wall.updateHitbox();
        add(wall);

        // Crear al jugador
        // player = new Player(FlxG.width / 2 - 100, FlxG.height - 200); // Posición inicial del jugador
        // player.setGraphicSize(Std.int(player.width * 0.8));
        // add(player);

        // Inicializar los ítems del menú
        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        // for (i in 0...optionShit.length)
        // {
        //     var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
        //     var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
        //     menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
        //     menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
        //     menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
        //     menuItem.animation.play('idle');
        //     menuItem.ID = i;
        //     menuItem.screenCenter(X);
        //     menuItems.add(menuItem);
        // }

		for (i in 0...optionShit.length) {
            var menuItem:FlxSprite = new FlxSprite(0, 0);
            menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
            menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
            menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
            menuItem.animation.play('idle');
            menuItem.ID = i;
        
            // Ajustar posición y hitbox
            switch (optionShit[i]) {
                case 'story_mode':
                    menuItem.x = 500;
                    menuItem.y = -200;
                    menuItem.width = 150;
                    menuItem.height = 50;
                    menuItem.offset.set(500, -200);
        
                case 'freeplay':
                    menuItem.x = 50;
                    menuItem.y = -80;
                    menuItem.width = 140;
                    menuItem.height = 60;
                    menuItem.offset.set(150, 0);
                    menuItem.setGraphicSize(Std.int(menuItem.width * 2));
        
                case 'credits':
                    menuItem.x = 500;
                    menuItem.y = 1000;
                    menuItem.width = 130;
                    menuItem.height = 70;
                    menuItem.offset.set(5, 30);
        
                case 'options':
                    menuItem.x = 1000;
                    menuItem.y = -100;
                    menuItem.width = 160;
                    menuItem.height = 40;
                    menuItem.offset.set(1000, -100);
            }

            // var hitboxVisual:FlxSprite = new FlxSprite(menuItem.x , menuItem.y );
            // hitboxVisual.makeGraphic(Std.int(menuItem.width), Std.int(menuItem.height), FlxColor.RED, true); // Color rojo semitransparente
            // hitboxVisual.alpha = 0.3; // Opacidad baja para que no bloquee la vista
            // // hitboxVisual.scrollFactor.set(0.3, 0.3);
            // add(hitboxVisual);
            

            // Llama a updateHitbox() aquí, después de todos los ajustes
            menuItem.updateHitbox();
            // menuItem.scrollFactor.set(0.3, 0.3);
        
            menuItems.add(menuItem);


			
        }
        
        
        
            

        
        // Crear al jugador
        player = new Player(FlxG.width / 2 - 100, FlxG.height - 220); // Posición inicial del jugador
        player.setGraphicSize(Std.int(player.width * 0.5));
        
        // player.offset.set(400, 0); // Ajusta el desplazamiento si la hitbox no está alineada con la imagen del jugador
        player.updateHitbox(); // Actualiza la hitbox después del ajuste
        add(player);
        // FlxG.camera.follow(player, null, 1); // La cámara sigue al jugador

		var zoomFactor:Float = Math.min(FlxG.width / bg.width, FlxG.height / bg.height);

		// Establecer el zoom
		FlxG.camera.zoom = zoomFactor;

		// Centrar la cámara en el fondo manualmente
		FlxG.camera.scroll.set(bg.x + 250, bg.y + 200);


        // //  Crear la visualización de la hitbox del jugador
        //  playerHitboxVisual = new FlxSprite(player.x, player.y);
        //  playerHitboxVisual.makeGraphic(Std.int(player.width), Std.int(player.height), FlxColor.BLUE, true);
        //  playerHitboxVisual.alpha = 0.3;
        //  add(playerHitboxVisual);


		// Crear el texto y los íconos para "Moverte"
		moveIcon = new FlxSprite(0, 0).loadGraphic(Paths.image('teclado'));
		moveIcon.setGraphicSize(Std.int(moveIcon.width * 0.2));
        moveIcon.alpha = 0.8; // Opacidad al 80%
		moveIcon.updateHitbox();
		
		

		moveText = new FlxText(moveIcon.x + 260, moveIcon.y + 20, 200, "PARA MOVERTE");
		moveText.setFormat(Paths.font("Starborn.ttf"), 25, FlxColor.BLACK, "left");
        moveText.alpha = 0.8; // Opacidad al 80%
		
        

		// Crear el texto y los íconos para "Interactuar"
		interactIcon1 = new FlxSprite(0, 0).loadGraphic(Paths.image('enter'));
		interactIcon1.setGraphicSize(Std.int(interactIcon1.width * 0.3));
        interactIcon1.alpha = 0.8; // Opacidad al 80%
		interactIcon1.updateHitbox();
		
        interactText2 = new FlxText(interactIcon1.x, interactIcon1.y, 200, "O");
		interactText2.setFormat(Paths.font("Starborn.ttf"), 25, FlxColor.BLACK, "left");
        interactText2.alpha = 0.8; // Opacidad al 80%
		
		interactIcon2 = new FlxSprite(interactText2.x + 100, interactText2.y).loadGraphic(Paths.image('espacio'));
		interactIcon2.setGraphicSize(Std.int(interactIcon2.width * 0.3));
        interactIcon2.alpha = 0.8; // Opacidad al 80%
		interactIcon2.updateHitbox();
		

		interactText = new FlxText(interactIcon2.x + 100, interactIcon2.y, 210, "PARA INTERACTUAR");
		interactText.setFormat(Paths.font("Starborn.ttf"), 25, FlxColor.BLACK, "left");
        interactText.alpha = 0.8; // Opacidad al 80%

        moveIcon.x = player.x - 767;
		moveIcon.y = player.y + 240;
		moveText.x = moveIcon.x + moveIcon.width + 10;
		moveText.y = moveIcon.y + 50;

		interactIcon1.x = player.x - 800;
		interactIcon1.y = player.y + 100;
        interactText2.x = interactIcon1.x + interactIcon1.width - 30;
		interactText2.y = interactIcon1.y + 10;
		interactIcon2.x = interactIcon1.x + interactIcon1.width + 10;
		interactIcon2.y = interactIcon1.y;
		interactText.x = interactIcon2.x + interactIcon2.width + 10;
		interactText.y = interactIcon1.y - 5;
        add(moveIcon);
		add(moveText);
		add(interactIcon1);
		add(interactText2);
		add(interactIcon2);
		add(interactText);

        // Crear el texto de descripción en la esquina inferior derecha
        descriptionText = new FlxText(FlxG.width - 300, FlxG.height - 40, 500, "");
        descriptionText.setFormat(Paths.font("Starborn.ttf"), 60, FlxColor.BLACK, "center");
        // Cambiar la opacidad del texto
        descriptionText.alpha = 0.8; // Opacidad al 80%
        add(descriptionText);
        super.create();
    }

    function clamp(value:Float, min:Float, max:Float):Float {
        return if (value < min) min else if (value > max) max else value;
    }
	override function update(elapsed:Float)
	{
		var margen:Float = 100; // Ajusta este valor según el tamaño adicional o reducido que quieras

		// Define los límites según la posición y el tamaño del fondo, con el margen ajustado
		var leftLimit:Float = bg.x;
		var rightLimit:Float = bg.x + bg.width - player.width;
		var topLimit:Float = bg.y + margen;
		var bottomLimit:Float = bg.y + bg.height - player.height;

		// Limitar la posición del jugador usando la función clamp personalizada
		player.x = clamp(player.x, leftLimit, rightLimit);
		player.y = clamp(player.y, topLimit, bottomLimit);
        

		// Función para verificar colisión AABB (bounding box)
		function checkCollision(obj1:FlxSprite, obj2:FlxSprite):Bool
		{
			return obj1.x < obj2.x + obj2.width && obj1.x + obj1.width > obj2.x && obj1.y < obj2.y + obj2.height && obj1.y + obj1.height > obj2.y;
		}

		function resolveCollision(player:FlxSprite, obstacle:FlxSprite, collisionMargin:Float = -1):Void
            {
                // Calcular solapamiento con margen adicional
                var overlapX:Float = Math.min(
                    player.x + player.width + collisionMargin - obstacle.x,
                    obstacle.x + obstacle.width + collisionMargin - player.x
                );
            
                var overlapY:Float = Math.min(
                    player.y + player.height + collisionMargin - obstacle.y,
                    obstacle.y + obstacle.height + collisionMargin - player.y
                );
            
                if (overlapX < overlapY)
                {
                    // Resolver en X
                    if (player.x < obstacle.x)
                    {
                        player.x -= overlapX; // Empujar hacia la izquierda
                    }
                    else
                    {
                        player.x += overlapX; // Empujar hacia la derecha
                    }
                }
                else
                {
                    // Resolver en Y
                    if (player.y < obstacle.y)
                    {
                        player.y -= overlapY; // Empujar hacia arriba
                    }
                    else
                    {
                        player.y += overlapY; // Empujar hacia abajo
                    }
                }
            }
            
		// Comprobar colisiones con objetos
		for (menuItem in menuItems)
		{
			if (checkCollision(player, menuItem))
			{
				// Resolver la colisión
				resolveCollision(player, menuItem);
			}
		}

		

		


        //  // Actualizar la posición de playerHitboxVisual para que siga al jugador
		// playerHitboxVisual.x = player.x - player.offset.x;
		// playerHitboxVisual.y = player.y - player.offset.y;

		// Actualizar la hitbox del jugador
		player.updateHitbox();

		// Actualizar las posiciones y hitboxes de cada menuItem
		for (menuItem in menuItems)
		{
			menuItem.updateHitbox(); // Asegura que la hitbox esté actualizada para cada item
			if (player.overlaps(menuItem))
			{
				selectMenuItem(menuItem);
				if (controls.ACCEPT)
				{ // Si el jugador presiona la tecla de acción
					executeMenuOption(menuItem);
				}
			}
		}

		// // Alinear los textos y las imágenes a la posición del jugador
		// moveIcon.x = player.x - 567;
		// moveIcon.y = player.y + 250;
		// moveText.x = moveIcon.x + moveIcon.width + 10;
		// moveText.y = moveIcon.y + 25;

		// interactIcon1.x = player.x - 600;
		// interactIcon1.y = player.y + 330;
        // interactText2.x = interactIcon1.x + interactIcon1.width - 10;
		// interactText2.y = interactIcon1.y + 5;
		// interactIcon2.x = interactIcon1.x + interactIcon1.width + 10;
		// interactIcon2.y = interactIcon1.y;
		// interactText.x = interactIcon2.x + interactIcon2.width + 10;
		// interactText.y = interactIcon1.y + 5;


        // Comprobar si el jugador está cerca de algún objeto y actualizar el texto
        var isNear:Bool = false; // Bandera para saber si hay algo cerca
        for (menuItem in menuItems) {
            if (player.overlaps(menuItem)) { // Si el jugador está cerca del objeto
                switch (menuItem.ID) {
                    case 0: descriptionText.text = "Modo Historia"; // 'story_mode'
                    case 1: descriptionText.text = "Juego Libre";   // 'freeplay'
                    case 2: descriptionText.text = "Opciones";      // 'credits'
                    case 3: descriptionText.text = "Creditos";      // 'options'
                }
                isNear = true;
                break; // Solo necesitamos mostrar la descripción de un objeto
            }
        }

        // Si no hay objetos cercanos, limpiar el texto
        if (!isNear) {
            descriptionText.text = "";
        }

		super.update(elapsed);
	}

	function selectMenuItem(menuItem:FlxSprite)
	{
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

        menuItem.animation.play('selected');
    }

    function executeMenuOption(menuItem:FlxSprite)
    {
        var daChoice:String = optionShit[menuItem.ID];
        switch (daChoice)
        {
            case 'story_mode':
                MusicBeatState.switchState(new StoryMenuState());
            case 'freeplay':
                MusicBeatState.switchState(new FreeplayState());
            #if MODS_ALLOWED
            case 'mods':
                MusicBeatState.switchState(new ModsMenuState());
            #end
            case 'awards':
                MusicBeatState.switchState(new AchievementsMenuState());
            case 'credits':
                MusicBeatState.switchState(new CreditsState());
            case 'options':
                LoadingState.loadAndSwitchState(new options.OptionsState());
        }
    }
}
