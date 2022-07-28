import 'package:meta/meta.dart';

import '../http/http_client.dart';
import '../../domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: "post", body: params.toJason());
  }
}
