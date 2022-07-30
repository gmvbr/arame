part of 'lifecycle.dart';

///
/// Implementação do LiveData
///
class MutableLiveData<T> extends LiveData<T> {
  MutableLiveData(super.value);

  ///
  /// Define o valor do LiveData
  ///
  set value(T value) => super._setValue(value);

  ///
  /// Retorna o valor do LiveData
  ///
  T get value => super._getValue();
}
