import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'package:gardien_tech/domain/services/backup_service.dart';

class BackupViewmodel extends ChangeNotifier {
  final BackupService _backupService;

  BackupViewmodel(this._backupService);

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> exportarBackup() async {
    isLoading = true;
    notifyListeners();

    try {
      final json = await _backupService.exportarJson();

      // Gerar nome do arquivo
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final fileName = 'gardien_tech_backup_$timestamp.json';

      // Permitir usuário escolher o local para salvar
      final String? directoryPath = await getDirectoryPath();

      if (directoryPath == null) {
        errorMessage = 'Salvamento cancelado';
        notifyListeners();
        isLoading = false;
        notifyListeners();
        return;
      }

      final filePath = '$directoryPath/$fileName';
      final file = File(filePath);
      await file.writeAsString(json, encoding: utf8);

      successMessage = 'Backup exportado com sucesso!\nCaminho: $filePath';
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro ao exportar: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restaurarBackup() async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      const XTypeGroup jsonTypeGroup = XTypeGroup(
        label: 'JSON',
        extensions: <String>['json'],
      );

      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[jsonTypeGroup],
      );

      if (file == null) {
        errorMessage = 'Nenhum arquivo selecionado';
        notifyListeners();
        return;
      }

      final bytes = await file.readAsBytes();
      final jsonContent = utf8.decode(bytes, allowMalformed: false); // Evita problemas na decodificação de caracteres especiais como ^

      await _backupService.importarJson(jsonContent);
      
      successMessage = 'Backup restaurado com sucesso.';
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro ao restaurar. Verifique o arquivo de backup e tente novamente.';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
