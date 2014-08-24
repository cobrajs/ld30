package scenes;

import entities.Player;
import entities.NonMoveable;

import utils.WorldLoader;
import utils.MessageBus;

import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import flash.geom.Rectangle;

class GameScene extends Scene {
  private static inline var GAMESCENE_DEATH:String = "gamescene_death";

  private var lightWorld:World;
  private var darkWorld:World;

  private var lightArrow:Image;
  private var darkArrow:Image;

  private var messageBus:MessageBus;

  private var currentLevel:String;


  /* ---------- HaxePunk Overrides ---------- */


  public function new(levelName:String, messageBus:MessageBus) {
    super();

    this.messageBus = messageBus;

    currentLevel = levelName;

    Input.define("up", [Key.UP, Key.W]);
    Input.define("down", [Key.DOWN, Key.S]);
    Input.define("left", [Key.LEFT, Key.A]);
    Input.define("right", [Key.RIGHT, Key.D]);
    Input.define("jump", [Key.X, Key.K]);
    Input.define("action", [Key.Z, Key.J]);

    Input.define("switch", [Key.C, Key.L]);
  }

	public override function begin() {
    lightWorld = new World(0, 0, Std.int(HXP.width), Std.int(HXP.halfHeight), messageBus);
    lightWorld.color = World.LIGHT;
    add(lightWorld);

    darkWorld = new World(0, HXP.halfHeight, Std.int(HXP.width), Std.int(HXP.halfHeight), messageBus);
    darkWorld.color = World.DARK;
    add(darkWorld);

    lightArrow = new Image("graphics/arrow.png", new Rectangle(0, 0, 48, 64));
    addGraphic(lightArrow, 0, 0, HXP.halfHeight - lightArrow.height);
    darkArrow = new Image("graphics/arrow.png", new Rectangle(48, 0, 48, 64));
    addGraphic(darkArrow, 0, 0, HXP.halfHeight);

    switchControl(true);

    WorldLoader.loadWorld(currentLevel, this, lightWorld, darkWorld, messageBus);

    messageBus.subscribe(MessageBus.DEATH, GAMESCENE_DEATH, deathMessage);
	}

  public override function end() {
    messageBus.unsubscribe(MessageBus.DEATH, GAMESCENE_DEATH, deathMessage);
  }

  public override function update() {
    if (Input.pressed("switch")) {
      switchControl();
    }
    super.update();
  }


  /* ---------- Game Related Functions ---------- */


  public function switchControl(?light:Bool, ?dark:Bool) {
    if (light != null && dark == null) {
      dark = false;
    } else if (light == null && dark != null) {
      light = false;
    } else if (light == null && dark == null) {
      light = !lightWorld.receiveEvents;
      dark = !darkWorld.receiveEvents;
    }

    lightWorld.receiveEvents = light;
    lightArrow.visible = light;
    darkWorld.receiveEvents = dark;
    darkArrow.visible = dark;
  }


  /* ---------- Callback Functions ---------- */


  private function deathMessage(message:Int):Bool {
    messageBus.addMessage(MessageBus.SCENE_SWITCH, "gameover");
    return true;
  }

}

