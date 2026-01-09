import 'package:dio/dio.dart';

/// Servicio centralizado para la configuración de Dio
///
/// - Define opciones base comunes para todas las peticiones HTTP
/// - Centraliza timeouts, headers y baseUrl
/// - Facilita reutilización y testing
class CardDioService {
  /// Crea y configura una instancia de Dio
  ///
  /// - Usa `BaseOptions` para evitar repetir configuración
  /// - Define timeouts razonables para red inestable
  /// - Agrega interceptores útiles para debugging
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.myl.cl',

        /// Tiempo máximo para establecer conexión
        connectTimeout: const Duration(seconds: 10),

        /// Tiempo máximo para recibir respuesta
        receiveTimeout: const Duration(seconds: 10),

        /// Header por defecto esperado por la API
        headers: {'Accept': 'application/json'},
      ),
    );

    /// Interceptor para logging
    ///
    /// - Imprime request y response completos
    /// - Útil en desarrollo y debugging
    /// - Se recomienda desactivar en producción
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
