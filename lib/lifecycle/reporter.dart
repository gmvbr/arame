part of 'lifecycle.dart';

///
/// Instância para reportar as leituras
///
final _getReporter = _Reporter();

///
/// Instância para reportar as escritas
///
final _setReporter = _Reporter();

///
/// Função usada no monitor para capturar os LiveData
///
typedef ReporterFn<T, A> = T Function(A args);

class _Reporter {
  ///
  /// Camada de monitoramento
  ///
  int _index = -1;

  ///
  /// Mapa do monitoramento
  ///
  final Map<int, List<LiveData>> _reports = {};

  ///
  /// Reporta o LiveData
  ///
  void report(LiveData data) {
    if (_reports.isEmpty) {
      return;
    }
    if (_reports[_index]!.contains(data)) {
      return;
    }
    _reports[_index]!.add(data);
  }

  ///
  /// Inicia a captura dos LiveData e retorna a camada da busca
  ///
  int beginCapture() {
    _index++;
    _reports[_index] = [];
    return _index;
  }

  ///
  /// Finaliza a captura dos LiveData e adiciona o resultado na lista
  ///
  void endCapture(int level, List<LiveData> list) {
    list.addAll(_reports[level]!);
    _reports.remove(level);
    _index--;
  }

  ///
  /// Captura os LiveData e adiciona na lista
  ///
  T monitor<T, A>(List<LiveData> list, A args, ReporterFn<T, A> function) {
    int index = beginCapture();
    T value = function(args);
    endCapture(index, list);
    return value;
  }
}
