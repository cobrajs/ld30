package entities;

import utils.MessageBus;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import flash.geom.Point;

class NonMoveable extends WorldDweller {
  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);

    type = "solid";
  }

  public override function update() {
    super.update();
  }

  // This doesn't move
  public override function doPhysics() { }
  public override function applyGravity() { }
}


