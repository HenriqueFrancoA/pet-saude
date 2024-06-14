import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Logger {
  late File _logFile;

  Logger() {
    _initLogFile();
  }

  void _initLogFile() async {
    // Obtenha o diretório de documentos do aplicativo
    final appDocDir = await getExternalStorageDirectory();
    final logFilePath = '${appDocDir!.path}/app_log.txt';

    // Abra ou crie o arquivo de log
    _logFile = File(logFilePath);
    if (!_logFile.existsSync()) {
      _logFile.createSync(
        recursive: true,
      );
    }
  }

  void log(String message) {
    final timeStamp = DateTime.now().toIso8601String();
    final logMessage = '[$timeStamp]: $message\n';

    // Escreva a mensagem de log no arquivo
    _logFile.writeAsString(
      logMessage,
      mode: FileMode.append,
    );
  }
}
