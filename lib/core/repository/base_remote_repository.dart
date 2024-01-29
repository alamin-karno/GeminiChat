abstract class BaseRemoteRepository {
  // Future<dynamic> get(String url);

  Future<dynamic> post(String url, String jsonData);
}
