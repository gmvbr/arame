import 'package:flutter/material.dart';

class Bridge<N> extends StatefulWidget {
  final Widget child;
  final List<BridgeService<N>>? services;

  const Bridge({
    Key? key,
    required this.child,
    this.services,
  }) : super(key: key);

  static BridgeContext<N>? of<N>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BridgeInherited<N>>()
        ?.bridgeContext;
  }

  @override
  State<Bridge<N>> createState() => _BridgeState<N>();
}

class _BridgeState<N> extends State<Bridge<N>> {
  final BridgeContext<N> _bridgeContext = BridgeContext<N>();

  final List<BridgeService<N>> _services = [];

  void registerService(BridgeService<N> service) {
    if (_services.contains(service)) {
      return;
    }
    service._register(_bridgeContext);
    _services.add(service);
  }

  void unregisterService(BridgeService<N> service) {
    if (_services.contains(service)) {
      return;
    }
    service._unregister(_bridgeContext);
    _services.remove(service);
  }

  @override
  void initState() {
    super.initState();
    if (widget.services != null) {
      for (BridgeService<N> service in widget.services!) {
        registerService(service);
      }
    }
  }

  @override
  void didUpdateWidget(covariant Bridge<N> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.services != widget.services) {
      if (oldWidget.services != null) {
        for (BridgeService<N> service in oldWidget.services!) {
          unregisterService(service);
        }
      }
      if (widget.services != null) {
        for (BridgeService<N> service in widget.services!) {
          registerService(service);
        }
      }
    }
  }

  @override
  void dispose() {
    if (widget.services != null) {
      for (BridgeService<N> service in widget.services!) {
        registerService(service);
      }
    }
    _bridgeContext.dispose();
    super.dispose();
  }

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

class BridgeService<N> implements BridgeObserver<N> {
  List<N> get binds => [];

  @override
  void message(N topic, args) {}

  void _register(BridgeContext<N> bridge) {
    for (var element in binds) {
      bridge._registerObserver(element, this);
    }
  }

  void _unregister(BridgeContext<N> bridge) {
    for (var element in binds) {
      bridge._unregisterObserver(element, this);
    }
  }
}

class BridgeContext<N> {
  final Map<N, List<BridgeObserver>> _map = {};

  void _registerObserver(N topic, BridgeObserver<N> observer) {
    if (_map.containsKey(topic)) {
      if (_map[topic]!.contains(observer)) {
        return;
      }
      _map[topic]!.add(observer);
    } else {
      _map[topic] = [observer];
    }
  }

  void _unregisterObserver(N topic, BridgeObserver<N> observer) {
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

  void dispose() {
    _map.clear();
  }
}

abstract class BridgeState<T extends StatefulWidget, N> extends State<T>
    implements BridgeObserver<N> {
  List<N> get binds => [];

  late final BridgeContext bridge;

  @override
  void message(N topic, args) {}

  @override
  void initState() {
    super.initState();
    bridge = Bridge.of<N>(context)!;

    for (var element in binds) {
      bridge._registerObserver(element, this);
    }
  }

  @override
  void dispose() {
    for (var element in binds) {
      bridge._unregisterObserver(element, this);
    }
    super.dispose();
  }
}
