import 'package:flutter_tdd_clean_architecture/data/models/remote_account_model.dart';

import '../../domain/entities/entities.dart';
import '../http/http_client.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../../domain/helpers/domain_error.dart';
import '../models/models.dart';

import 'package:meta/meta.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final httpResponse = await httpClient.request(
          url: url,
          method: "post",
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
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
