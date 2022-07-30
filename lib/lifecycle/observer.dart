part of 'lifecycle.dart';

///
/// Interface para definir a classe que responderá os eventos de observação 
///
abstract class Observer {
  
  ///
  /// Método será invocado quando tiver alguma mudança
  ///
  void onChange();
}
