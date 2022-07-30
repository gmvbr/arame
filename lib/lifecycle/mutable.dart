part of 'lifecycle.dart';

///
/// Implementação do LiveData
///
class MutableLiveData<T> extends LiveData<T> {
  MutableLiveData(super.value);

  ///
  /// Define o valor do LiveData
  ///
  @override
  set value(T value) => super.setValue(value);

  ///
  /// Retorna o valor do LiveData
  ///
  @override
  T get value => super.getValue();
}
