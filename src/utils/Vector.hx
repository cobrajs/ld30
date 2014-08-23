package utils;

import com.haxepunk.HXP;

class Vector {
  public var x:Float;
  public var y:Float;

  public function new(x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }

  public function add(newVector:Vector) {
    this.x += newVector.x;
    this.y += newVector.y;
  }
}
