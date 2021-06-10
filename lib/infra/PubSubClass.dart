import 'package:local_pubsub/local_pubsub.dart';

class PubSubClass {
  static final shared = PubSubClass._();
  late PubSub _pubSub;
  PubSubClass._() {
    print("PubSub ");
  }

  Subscription? subscribe(String s) {
    return _pubSub.subscribe(s);
  }

  void publish(String s, dynamic message) {
    _pubSub.publish(s, message);
  }
}