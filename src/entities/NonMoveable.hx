package entities;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import utils.Vector;

class NonMoveable extends WorldDweller {
  public function new(x:Float, y:Float) {
    super(x, y);

    type = "solid";
  }

  public override function update() {
    super.update();
  }

  // This doesn't move
  public override function doPhysics() { }
  public override function applyGravity(v:Vector) { }
}


