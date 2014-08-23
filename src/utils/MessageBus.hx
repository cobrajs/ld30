package utils;

class MessageBus {
  public var messages:Array<Message>;

  public function new() {
    messages = new Array<Message>();
  }
}

class Message {
  public var type:String;
  public var message:String;
}
