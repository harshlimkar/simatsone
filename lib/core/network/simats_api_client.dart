// SIMATS ONE – Dio HTTP Client with Interceptors
// Handles: auth headers, token refresh, retry, logging, error mapping

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../storage/secure_storage_service.dart';
import '../errors/app_failure.dart';
import '../../app/config/app_config.dart';

class SimatsApiClient {
  SimatsApiClient._(this._secureStorage) {
    _dio = _buildDio();
    _setupInterceptors();
  }

  final SecureStorageService _secureStorage;
  late final Dio _dio;
  final _logger = Logger();

  static SimatsApiClient? _instance;
  factory SimatsApiClient({required SecureStorageService secureStorage}) {
    _instance ??= SimatsApiClient._(secureStorage);
    return _instance!;
  }

  Dio get dio => _dio;

  Dio _buildDio() => Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Client': 'simats-one-android',
        'X-Client-Version': AppConstants.appVersion,
      },
    ),
  );

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _AuthInterceptor(_secureStorage, _dio, _logger),
      _LoggingInterceptor(_logger),
      _ErrorInterceptor(),
    ]);
  }
}

// ── Auth Interceptor (auto token injection + refresh) ─────────────────────────

class _AuthInterceptor extends QueuedInterceptor {
  _AuthInterceptor(this._storage, this._dio, this._logger);

  final SecureStorageService _storage;
  final Dio _dio;
  final Logger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry original request with new token
          final token = await _storage.getAccessToken();
          final opts = err.requestOptions
            ..headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(opts);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        _logger.e('${AppConstants.tagAuth} Token refresh failed', error: e);
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );
      final data = response.data as Map<String, dynamic>;
      await _storage.saveAccessToken(data['access_token'] as String);
      if (data['refresh_token'] != null) {
        await _storage.saveRefreshToken(data['refresh_token'] as String);
      }
      return true;
    } catch (_) {
      await _storage.clearAll();
      return false;
    }
  }
}

// ── Logging Interceptor ───────────────────────────────────────────────────────

class _LoggingInterceptor extends Interceptor {
  _LoggingInterceptor(this._logger);
  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '${AppConstants.tagNetwork} → ${options.method} ${options.path}',
      // NEVER log Authorization header
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '${AppConstants.tagNetwork} ← ${response.statusCode} ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.w(
      '${AppConstants.tagNetwork} ✗ ${err.response?.statusCode} ${err.requestOptions.path}: ${err.type}',
    );
    handler.next(err);
  }
}

// ── Error Interceptor (DioException → AppFailure) ─────────────────────────────

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: failure,
        response: err.response,
        type: err.type,
      ),
    );
  }

  AppFailure _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      default:
        final statusCode = err.response?.statusCode;
        return switch (statusCode) {
          401 => const UnauthorizedFailure(),
          403 => const ForbiddenFailure(),
          503 => const ServiceUnavailableFailure(),
          int code when code >= 500 => const ServerFailure(),
          _ => const UnknownFailure(),
        };
    }
  }
}
