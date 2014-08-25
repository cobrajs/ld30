package entities;

import utils.MessageBus;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;

import flash.geom.Rectangle;

class NonMoveBlock extends NonMoveable {
  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);
    width = 64;
    height = 64;
  }

  // This doesn't move
  public override function doPhysics() { }
  public override function applyGravity() { }

  public override function setupGraphics(color:Int, inverseColor:Int) {
    var graphicName = "graphics/boxes.png";
    if (color == World.LIGHT) {
      graphic = new Image(graphicName, new Rectangle(0, 0, 64, 64));
    } else {
      graphic = new Image(graphicName, new Rectangle(0, 64, 64, 64));
    }
  }
}



