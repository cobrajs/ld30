package entities;

import utils.MessageBus;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

class EndState extends NonMoveable {
  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);

    type = "endstate";
  }
}
