package utils;

import com.haxepunk.HXP;

typedef Callback = Dynamic->Bool;
typedef CallbackMap = Map<String, Callback>;

class MessageBus {
  public static var DEATH:String = "death";
  public static var SCENE_SWITCH:String = "scene_switch";
  public static var WIN_STATE:String = "win_state";
  public static var NON_WIN_STATE:String = "non_win_state";

  public var messages:Array<Message>;
  public var subscriptions:Map<String, CallbackMap>;

  public function new() {
    messages = new Array<Message>();

    subscriptions = new Map<String, CallbackMap>();
  }

  public function subscribe(type:String, messageId:String, func:Callback) {
    var temp:CallbackMap;
    if (subscriptions.exists(type)) {
      temp = subscriptions.get(type);
    } else {
      temp = new CallbackMap();
    }
    temp.set(messageId, func);
    subscriptions.set(type, temp);
  }

  public function unsubscribe(type:String, messageId:String, func:Callback) {
    if (subscriptions.exists(type)) {
      var temp = subscriptions.get(type);
      if (temp.exists(messageId)) {
        temp.remove(messageId);
      }
      subscriptions.set(type, temp);
    }
  }

  public function addMessage(type:String, message:Dynamic) {
    var handled = false;
    if (subscriptions.exists(type)) {
      var callbacks:CallbackMap = subscriptions.get(type);
      for (callback in callbacks.iterator()) {
        handled = callback(message) || handled;
      }
    }
    if (!handled) {
      //messages.push(message);
    }
  }
}

class Message {
  public var type:String;
  public var message:Dynamic;

  public function new(type:String, message:Dynamic) {
    this.type = type;
    this.message = message;
  }
}

