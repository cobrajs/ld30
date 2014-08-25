package scenes;

import entities.Player;
import entities.NonMoveable;

import utils.WorldLoader;
import utils.WorldLoader.LevelData;
import utils.MessageBus;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.tweens.misc.VarTween;

import flash.geom.Rectangle;

class GameScene extends Scene {
  private static inline var GAMESCENE_DEATH:String = "gamescene_death";
  private static inline var GAMESCENE_WIN_STATE:String = "gamescene_win_state";
  private static inline var GAMESCENE_NON_WIN_STATE:String = "gamescene_non_win_state";

  private var lightWorld:World;
  private var darkWorld:World;

  private var lightArrow:Image;
  private var darkArrow:Image;

  private var darkSweep:Entity;
  private var lightSweep:Entity;

  private var messageBus:MessageBus;

  private var currentLevel:String;

  private var initSweepLight:Bool;

  private var lightWinState:Bool;
  private var darkWinState:Bool;

  private var levelData:LevelData;

  private var pause:Bool;


  /* ---------- HaxePunk Overrides ---------- */


  public function new(levelName:String, messageBus:MessageBus, ?light:Bool = true) {
    super();

    pause = false;

    this.messageBus = messageBus;

    currentLevel = levelName;

    Input.define("up", [Key.UP, Key.W]);
    Input.define("down", [Key.DOWN, Key.S]);
    Input.define("left", [Key.LEFT, Key.A]);
    Input.define("right", [Key.RIGHT, Key.D]);
    Input.define("jump", [Key.X, Key.K]);
    Input.define("action", [Key.Z, Key.J]);

    Input.define("switch", [Key.C, Key.L]);

    Input.define("pause", [Key.P, Key.SPACE]);

    initSweepLight = light;

    lightWinState = false;
    darkWinState = false;
  }

	public override function begin() {
    lightWorld = new World(0, 0, Std.int(HXP.width), Std.int(HXP.halfHeight), messageBus);
    lightWorld.color = World.LIGHT;
    add(lightWorld);

    darkWorld = new World(0, HXP.halfHeight, Std.int(HXP.width), Std.int(HXP.halfHeight), messageBus);
    darkWorld.color = World.DARK;
    add(darkWorld);

    lightArrow = new Image("graphics/arrow.png", new Rectangle(0, 0, 48, 64));
    addGraphic(lightArrow, 0, 0, HXP.halfHeight - lightArrow.height - 1);
    darkArrow = new Image("graphics/arrow.png", new Rectangle(48, 0, 48, 64));
    addGraphic(darkArrow, 0, 0, HXP.halfHeight);

    levelData = WorldLoader.loadWorld(currentLevel, this, lightWorld, darkWorld, messageBus);

    if (levelData.control == WorldLoader.SEPARATE) {
      switchControl(true, false);
    } else if (levelData.control == WorldLoader.MIRRORED) {
      switchControl(true, true);
    }

    lightSweep = new Entity(0, -HXP.height);
    lightSweep.graphic = Image.createRect(HXP.width, HXP.height, World.LIGHT);
    lightSweep.layer = 0;
    add(lightSweep);
    darkSweep = new Entity(0, HXP.height);
    darkSweep.graphic = Image.createRect(HXP.width, HXP.height, World.DARK);
    darkSweep.layer = 0;
    add(darkSweep);

    var tween = new VarTween(function(nothing:Int) {
      clearTweens();
    });
    if (initSweepLight) {
      lightSweep.y = 0;
      tween.tween(lightSweep, "y", -HXP.height, 0.5);
    } else {
      darkSweep.y = 0;
      tween.tween(darkSweep, "y", HXP.height, 0.5);
    }
    addTween(tween, true);

    messageBus.subscribe(MessageBus.DEATH, GAMESCENE_DEATH, deathMessage);
    messageBus.subscribe(MessageBus.WIN_STATE, GAMESCENE_WIN_STATE, winState);
    messageBus.subscribe(MessageBus.NON_WIN_STATE, GAMESCENE_NON_WIN_STATE, nonWinState);
	}

  public override function end() {
    messageBus.unsubscribe(MessageBus.DEATH, GAMESCENE_DEATH, deathMessage);
    messageBus.unsubscribe(MessageBus.WIN_STATE, GAMESCENE_WIN_STATE, winState);
    messageBus.unsubscribe(MessageBus.NON_WIN_STATE, GAMESCENE_NON_WIN_STATE, nonWinState);
  }

  public override function update() {
    if (Input.pressed("switch") && levelData.control == WorldLoader.SEPARATE) {
      switchControl();
    }
    if (Input.pressed("pause")) {
      pause = !pause;
    }
    if (!pause) {
      if (!hasTween) {
        super.update();
      } else {
        updateTweens();
      }
    }
  }


  /* ---------- Game Related Functions ---------- */


  public function sweep(light:Bool, death:Bool, win:Bool) {
    var tween = new VarTween(function(empty:Int) {
      if (death && !win) {
        messageBus.addMessage(MessageBus.SCENE_SWITCH, "gameover" + (light ? "Light" : "Dark"));
      } else if (win && !death) {
        messageBus.addMessage(MessageBus.SCENE_SWITCH, "win");
      }
    });
    tween.tween(light ? lightSweep : darkSweep, "y", 0, 0.4);
    addTween(tween, true);
  }

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

  public function win() {
    sweep(true, false, true);
  }


  /* ---------- Callback Functions ---------- */


  private function deathMessage(light:Bool):Bool {
    sweep(light, true, false);
    return true;
  }

  private function winState(light:Bool):Bool {
    if (light) {
      lightWinState = true;
    } else {
      darkWinState = true;
    }
    if (lightWinState && darkWinState) {
      win();
    }
    return true;
  }

  private function nonWinState(light:Bool):Bool {
    if (light) {
      lightWinState = false;
    } else {
      darkWinState = false;
    }
    return true;
  }
}

