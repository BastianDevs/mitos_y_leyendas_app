import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Servicio centralizado para la creación y configuración de Dio.
///
/// Responsabilidades:
/// - Define la URL base y headers comunes para todas las peticiones a api.myl.cl
/// - Establece timeouts para manejar conexiones lentas o inestables
/// - Registra interceptores en orden: primero caché, luego logging
///
/// El orden de los interceptores es importante:
/// DioCacheInterceptor debe ir antes que LogInterceptor para que
/// el log refleje correctamente si la respuesta vino de la red o del caché.
class CardDioService {
  /// Configuración global del caché HTTP para todas las peticiones.
  ///
  /// Se declara como [static] para que pueda ser accedida desde otros
  /// lugares de la app si se necesita invalidar el caché manualmente,
  /// por ejemplo al implementar pull-to-refresh.
  ///
  /// Detalles de configuración:
  /// - [MemCacheStore]: almacena las respuestas en memoria RAM.
  ///   El caché se pierde al cerrar la app, lo que garantiza que
  ///   el usuario siempre ve datos frescos al iniciar una nueva sesión.
  ///
  /// - [maxStale] de 30 minutos: una respuesta cacheada se considera
  ///   válida durante ese tiempo. Pasado ese límite, se realiza un
  ///   nuevo request a la API para obtener datos actualizados.
  ///
  /// - [CachePolicy.forceCache]: ignora los headers de caché que
  ///   envíe el servidor y aplica siempre la política definida aquí.
  ///   Necesario porque api.myl.cl no incluye headers de caché
  ///   estándar (Cache-Control, ETag, etc.) en sus respuestas.
  static final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    maxStale: const Duration(minutes: 30),
    policy: CachePolicy.forceCache,
  );

  /// Crea y retorna una instancia de [Dio] lista para usar.
  ///
  /// Configuración base:
  /// - [baseUrl]: apunta a la API oficial de Mitos y Leyendas.
  ///   Todas las peticiones usan esta URL como prefijo, por lo que
  ///   los datasources solo necesitan especificar el path relativo.
  ///
  /// - [connectTimeout]: tiempo máximo para establecer la conexión
  ///   con el servidor. Si se supera, Dio lanza un [DioException].
  ///
  /// - [receiveTimeout]: tiempo máximo para recibir la respuesta
  ///   completa del servidor una vez establecida la conexión.
  ///
  /// - [headers]: la API de MyL requiere el header Accept: application/json
  ///   para retornar datos en formato JSON en lugar de HTML.
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

    /// Interceptor de caché HTTP.
    ///
    /// Intercepta cada request antes de enviarlo a la red:
    /// - Si existe una respuesta cacheada y vigente (< 30 min),
    ///   la retorna directamente sin realizar ninguna llamada HTTP.
    /// - Si no existe o expiró, deja pasar el request y guarda
    ///   la nueva respuesta en caché para futuros usos.
    ///
    /// En consola, el header [X-Cache] indica el resultado:
    /// - X-Cache: HIT  → respuesta servida desde caché
    /// - X-Cache: MISS → respuesta obtenida desde la red
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    /// Interceptor de logging.
    ///
    /// Registra en consola el detalle completo de cada petición:
    /// - Request: método, URL, headers y body enviado
    /// - Response: status code, headers y body recibido
    ///
    /// Combinado con DioCacheInterceptor, permite verificar
    /// fácilmente si una respuesta proviene de caché (X-Cache: HIT)
    /// o fue una llamada real a la API (X-Cache: MISS).
    ///
    /// Recomendación: desactivar en producción para evitar
    /// exponer información sensible en los logs del dispositivo.
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }
}
