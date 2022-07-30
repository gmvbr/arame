import 'dart:async';
import 'dart:io';

import 'package:arame/arame.dart';

class DirectoryWatch extends LiveData<Directory?> {
  DirectoryWatch(super.value);

  Stream<FileSystemEvent>? stream;
  StreamSubscription<FileSystemEvent>? subscription;

  final int events =
      FileSystemEvent.create | FileSystemEvent.move | FileSystemEvent.delete;

  ///
  /// Define o diretório atual
  ///
  @override
  set value(Directory? directory) => _createWatch(directory);

  ///
  /// Retorna o diretório atual
  ///
  @override
  Directory? get value => getValue();

  void _createWatch(Directory? directory) {
    if (value == directory && subscription != null) {
      return;
    }
    _cancelWatch();
    if (directory != null && hasObserver() && directory.existsSync()) {
      subscription =
          directory.watch(events: events).listen(_update, onDone: () {
        if (super.value == directory) {
          _cancelWatch();
        }
      });
    }
    setValue(value);
  }

  ///
  /// Notifica o evento
  ///
  void _update(FileSystemEvent event) {
    notifyObservers(value);
  }

  ///
  /// Cancela o Watch atual
  ///
  void _cancelWatch() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void active() => _createWatch(value);

  @override
  void inactive() => _cancelWatch();
}
