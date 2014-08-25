package scenes;

import utils.MessageBus;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.Tween.TweenType;

class WinScene extends Scene {

  private var messageBus:MessageBus;

  /* ---------- HaxePunk Overrides ---------- */


  public function new(messageBus:MessageBus) {
    super();

    Input.define("proceed", [Key.UP, Key.RIGHT, Key.ENTER, Key.SPACE, Key.ESCAPE]);

    this.messageBus = messageBus;
  }

	public override function begin() {
    addGraphic(new Image("graphics/win.png"));
	}

  public override function end() {
  }

  public override function update() {
    if (Input.pressed("proceed") || Input.mouseDown) {
#if !flash
      flash.Lib.exit();
#end
    }
    super.update();
  }
}

