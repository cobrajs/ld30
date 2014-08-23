package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Player extends WorldDweller {
  public static inline var MOVE_ACCELERATION_GROUND:Float = 0.5;
  public static inline var MOVE_ACCELERATION_AIR:Float = 0.05;

  public function new(x:Float, y:Float) {
    super(x, y);

    width = 32;
    height = 64;

    grounded = false;

    type = "player";
  }

  public override function update() {
    super.update();

    if (_world.receiveEvents) {
      if (Input.check("left") || Input.check("right")) {
        if (Input.check("left")) {
          acceleration.x += -(grounded ? MOVE_ACCELERATION_GROUND : MOVE_ACCELERATION_AIR);
        } else {
          acceleration.x += (grounded ? MOVE_ACCELERATION_GROUND : MOVE_ACCELERATION_AIR);
        }
      } else {
        applyDrag();
      }
      if (Input.pressed("jump") && grounded) {
        acceleration.y = -8;
        grounded = false;
      }
    } else {
      applyDrag();
    }
  }

  public override function assignWorld(_world:World) {
    super.assignWorld(_world);
  }
}

