abstract class BackupService {
  Future<String> exportarJson();
  Future<void> importarJson(String json);
}