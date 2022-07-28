import 'package:meta/meta.dart';

import '../http/http_client.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../../domain/helpers/domain_error.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    try {
      await httpClient.request(
          url: url,
          method: "post",
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({@required this.email, @required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {'email': email, 'password': password};
}
