part of 'lifecycle.dart';

abstract class LiveData<T> with Diagnosticable {
  LiveData(this.value);

  ///
  /// Valor do LiveData
  ///
  @protected
  T value;

  ///
  /// Lista de Observer
  ///
  final List<Observer> _observers = [];

  ///
  /// Adiciona o Observer na lista
  ///
  void addObserver(Observer observer) {
    if (_observers.contains(observer)) {
      return;
    }
    _observers.add(observer);
    if (_observers.isNotEmpty) {
      active();
    }
  }

  ///
  /// Remove o Observar da lista
  ///
  void removeObserver(Observer observer) {
    _observers.remove(observer);
    if (_observers.isEmpty) {
      inactive();
    }
  }

  ///
  /// Verifica se há algum Observer na lista
  ///
  bool hasObserver() => _observers.isNotEmpty;

  ///
  /// Esse método é chamado quando tiver algum Observer na lista
  ///
  @protected
  void active() {}

  ///
  /// Esse método é chamado quando não tiver nenhum Observer na lista
  @protected
  void inactive() {}

  ///
  /// Define o valor do LiveData
  ///
  @protected
  void setValue(T newValue) {
    if (value != newValue) {
      value = newValue;
      _setReporter.report(this);
      notifyObservers(newValue);
    }
  }

  ///
  /// Retorna o valor do LiveData
  ///
  @protected
  T getValue() {
    _getReporter.report(this);
    return value;
  }

  ///
  /// Notifica todos Observer a mudança de valor
  ///
  @protected
  void notifyObservers(T? value) {
    for (var observer in _observers) {
      observer.onChange();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('value', value.toString()));
  }
}
