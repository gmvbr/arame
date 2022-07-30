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
  void inactive() => controller.clear();

  @override
  void onChange() => super.setValue(controller.get(super.value));

  ///
  /// Retorna o valor do LiveData
  ///
  @override
  T get value => super.getValue();
}
