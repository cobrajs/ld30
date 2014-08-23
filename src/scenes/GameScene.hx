package scenes;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import entities.Player;
import entities.NonMoveable;

import utils.WorldLoader;

class GameScene extends Scene {

  private var lightWorld:World;
  private var darkWorld:World;

  public function new() {
    super();

    Input.define("up", [Key.UP, Key.W]);
    Input.define("down", [Key.DOWN, Key.S]);
    Input.define("left", [Key.LEFT, Key.A]);
    Input.define("right", [Key.RIGHT, Key.D]);
    Input.define("jump", [Key.X, Key.K]);
    Input.define("action", [Key.Z, Key.J]);

    Input.define("switch", [Key.C, Key.L]);
  }

	public override function begin() {
    lightWorld = new World(0, 0, Std.int(HXP.width), Std.int(HXP.halfHeight));
    lightWorld.color = World.LIGHT;
    lightWorld.receiveEvents = true;
    add(lightWorld);

    darkWorld = new World(0, HXP.halfHeight, Std.int(HXP.width), Std.int(HXP.halfHeight));
    darkWorld.color = World.DARK;
    add(darkWorld);

    WorldLoader.loadWorld("world1", this, lightWorld, darkWorld);
	}

  public override function update() {
    if (Input.pressed("switch")) {
      if (lightWorld.receiveEvents && !darkWorld.receiveEvents) {
        lightWorld.receiveEvents = false;
        darkWorld.receiveEvents = true;
      } else {
        lightWorld.receiveEvents = true;
        darkWorld.receiveEvents = false;
      }
    }
    lightWorld.update();
    darkWorld.update();
  }
}

