package entities;

import utils.MessageBus;

class NonMoveable extends WorldDweller {
  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);

    baseTypename = "solid";
    type = getTypename();
  }

  // This doesn't move
  public override function doPhysics() { }
  public override function applyGravity() { }
}


