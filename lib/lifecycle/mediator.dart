part of 'lifecycle.dart';

class MediatorLiveData<T> extends LiveData<T> implements Observer {
  final ObserverController<T, T?> controller;

  ///
  /// Inicializa o Controller para observar essa classe
  ///
  MediatorLiveData._(this.controller, super.value) {
    controller.update(this);
  }

  ///
  /// Cria a instância do MediatorLiveData
  ///
  factory MediatorLiveData.of(T Function(T? args) builder) {
    var controller = ObserverController<T, T?>(builder);
    var value = controller.get(null);

    return MediatorLiveData._(controller, value);
  }

  @override
  void _inactive() => controller.clear();

  @override
  void onChange() => super._setValue(controller.get(_value));

  ///
  /// Retorna o valor do LiveData
  ///
  T? get value => super._getValue();
}
