package entities;

import utils.MessageBus;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import flash.geom.Rectangle;

class MoveBlock extends WorldDweller {
  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);
    width = 64;
    height = 64;

    baseTypename = "moveblock";
    type = getTypename();
  }

  public override function setupGraphics(color:Int, inverseColor:Int) {
    var graphicName = "graphics/boxes.png";
    if (color == World.LIGHT) {
      graphic = new Image(graphicName, new Rectangle(64, 0, 64, 64));
    } else {
      graphic = new Image(graphicName, new Rectangle(64, 64, 64, 64));
    }
  }
}




