enum Environment { dev, stage, prod }

const String _baseUrl = "baseUrl";

late final Map<String, dynamic> _config;

const String _refreshToken = "refreshTokn";
const String _accessToken = "accessToken";
const String _clientKey = "clientKey";
const String _clientSecret = "clientSecret";

const String clientKey =
    "ck_2_u1avd9o5Ch2gj6zB51T5TM0VNqEs8nlMUewNACsaMED1E4P3TDMDQuwQ397IJj6u";
const String clientSecret =
    "cs_2_fjyupTB0lvAwHuCBl5bgDUwTujC4UJ7KsM28w41qnlhNyJBdfDOO0MPh3ejTSbGD";

void setEnv({Environment? env}) {
  switch (env) {
    case Environment.prod:
      _config = {
        _baseUrl: "https://api.sadadpay.net/api",
        _clientKey: clientKey,
        _clientSecret: clientSecret
      };
      break;
    case Environment.stage:
      _config = {
        _baseUrl: "https://apisandbox.sadadpay.net/api",
        _clientKey: clientKey,
        _clientSecret: clientSecret
      };
      break;
    default:
      _config = {
        _baseUrl: "https://apisandbox.sadadpay.net/api",
        _clientKey: clientKey,
        _clientSecret: clientSecret
      };
  }
}

void setAccessToken({required final String accessToken}) {
  _config[_accessToken] = accessToken;
}

void setRefreshToken({required final String refreshToken}) {
  _config[_refreshToken] = refreshToken;
}

dynamic get apiBaseUrl {
  return _config[_baseUrl];
}

dynamic get apiClientKey {
  return _config[_clientKey];
}

dynamic get apiClientSecret {
  return _config[_clientSecret];
}

dynamic get apiRefreshToken {
  return _config[_refreshToken];
}

dynamic get apiAcessToken {
  return _config[_accessToken];
}
