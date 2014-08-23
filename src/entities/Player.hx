package entities;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Player extends WorldDweller {
  public function new(x:Float, y:Float) {
    super(x, y);

    width = 32;
    height = 64;

    type = "player";
  }

  public override function update() {
    super.update();

    if (_world.receiveEvents) {
      if (Input.check("left") || Input.check("right")) {
        if (Input.check("left")) {
          acceleration.x = -1;
        } else {
          acceleration.x = 1;
        }
      } else {
        applyDrag();
      }
    } else {
      applyDrag();
    }
  }

  public override function assignWorld(_world:World) {
    super.assignWorld(_world);
  }
}

