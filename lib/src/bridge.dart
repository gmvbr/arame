import 'package:flutter/material.dart';

class Bridge<N> extends StatefulWidget {
  final Widget child;
  const Bridge({Key? key, required this.child}) : super(key: key);

  static BridgeContext<N>? of<N>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BridgeInherited<N>>()
        ?.bridgeContext;
  }

  @override
  State<Bridge> createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  final BridgeContext _bridgeContext = BridgeContext();

  @override
  Widget build(BuildContext context) {
    return BridgeInherited(
      bridgeContext: _bridgeContext,
      child: widget.child,
    );
  }
}

class BridgeInherited<N> extends InheritedWidget {
  const BridgeInherited({
    super.key,
    required super.child,
    required this.bridgeContext,
  });

  final BridgeContext<N> bridgeContext;

  @override
  bool updateShouldNotify(covariant BridgeInherited oldWidget) {
    return bridgeContext != oldWidget.bridgeContext;
  }
}

abstract class BridgeObserver<T> {
  void message(T topic, dynamic args);
}

class BridgeContext<N> {
  final Map<N, List<BridgeObserver>> _map = {};

  void dispose() => _map.clear();

  void registerObserver(N topic, BridgeObserver<N> observer) {
    if (_map.containsKey(topic)) {
      if (_map[topic]!.contains(observer)) {
        return;
      }
      _map[topic]!.add(observer);
    } else {
      _map[topic] = [observer];
    }
  }

  void unregisterObserver(N topic, BridgeObserver<N> observer) {
    if (_map.containsKey(topic)) {
      _map[topic]!.remove(observer);
      if (_map[topic]!.isEmpty) {
        _map.remove(topic);
      }
    }
  }

  int send(N topic, dynamic args) {
    int count = 0;
    if (_map.containsKey(topic)) {
      for (var item in _map[topic]!) {
        item.message(topic, args);
        count++;
      }
    }
    return count;
  }
}

abstract class BridgeState<T extends StatefulWidget, N> extends State<T>
    implements BridgeObserver<N> {
  List<N> get binds;

  late final BridgeContext bridge = Bridge.of<N>(context)!;

  @override
  void initState() {
    for (var element in binds) {
      bridge.registerObserver(element, this);
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var element in binds) {
      bridge.unregisterObserver(element, this);
    }
    super.dispose();
  }
}