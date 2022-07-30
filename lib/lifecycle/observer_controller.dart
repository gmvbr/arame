part of 'lifecycle.dart';

class ObserverController<T, A> with Diagnosticable {
  ObserverController(this._builder, [this._observer]);

  ///
  /// Observer que é invocado ao detectar mudança nos LiveData
  ///
  Observer? _observer;

  ///
  /// Função que busca os LiveData e retorna o valor
  ///
  final T Function(A args) _builder;

  ///
  /// Lista com os LiveData
  ///
  final List<LiveData> _list = [];

  ///
  /// Determina se deve buscar os LiveData
  ///
  bool _initialized = false;

  ///
  /// Altera o Observer que recebe as mudanças
  ///
  void update(Observer observer) {
    unregistry();
    _observer = observer;
    registry();
  }

  ///
  /// Registra o Observer que recebe as mudanças em todos LiveData
  ///
  void registry() {
    if (!_initialized || _observer == null) {
      return;
    }
    for (var observabe in _list) {
      observabe.addObserver(_observer!);
    }
  }

  ///
  /// Remove o Observer que recebe as mudanças em todos LiveData
  ///
  void unregistry() {
    if (!_initialized || _observer == null) {
      return;
    }
    for (var observabe in _list) {
      observabe.removeObserver(_observer!);
    }
  }

  ///
  /// Remove os Observer
  ///
  void clear() {
    unregistry();
    _list.clear();
    _initialized = false;
  }

  //
  /// Retorna o valor de builder, e registra os LiveData
  ///
  T get(A args) {
    T value;
    if (!_initialized) {
      _initialized = true;
      value = _getReporter.monitor<T, A>(_list, args, _builder);
      registry();
    } else {
      value = _builder(args);
    }
    return value;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('observerList', _list));
  }
}
