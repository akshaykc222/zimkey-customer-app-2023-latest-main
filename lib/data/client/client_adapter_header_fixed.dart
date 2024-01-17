import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef OnHttpClientCreate = HttpClient? Function(HttpClient client);
/**
 * Copied verbatim from dio's io_adapter.dart and
 * fixed the case-insensitive header names bug. (marked with ***changed***)
 */

/// The default HttpClientAdapter for Dio.
class HeaderFixedHttpClientAdapter implements HttpClientAdapter {
  /// [Dio] will create HttpClient when it is needed.
  /// If [onHttpClientCreate] is provided, [Dio] will call
  /// it when a HttpClient created.
  OnHttpClientCreate? onHttpClientCreate;
  HttpClient? _defaultHttpClient;
  bool _closed = false;

// ***changed***: added a convenience constructor
  HeaderFixedHttpClientAdapter({this.onHttpClientCreate});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    if (_closed) {
      throw Exception(
          "Can't establish connection after [HttpClientAdapter] closed!");
    }
    var httpClient = _configHttpClient(cancelFuture, options.connectTimeout!.inMilliseconds);
    var reqFuture = httpClient.openUrl(options.method, options.uri);
    void throwConnectingTimeout() {
      throw DioError(
        requestOptions: options,
        error: 'Connecting timed out [${options.connectTimeout}ms]',
        type: DioErrorType.connectionTimeout,
      );
    }

    late HttpClientRequest request;
    int timePassed = 0;
    try {
      if (options.connectTimeout!.inMilliseconds > 0) {
        var start = DateTime.now().millisecond;
        request = await reqFuture
            .timeout(Duration(milliseconds: options.connectTimeout!.inMilliseconds));
        timePassed = DateTime.now().millisecond - start;
      } else {
        request = await reqFuture;
      }
//Set Headers
// ***changed***: fixed the case-sensitive header names bug
      options.headers.forEach((k, v) {
// if header value is null, build BytesBuilder will crash,set preserveHeaderCase true to keep case
        request.headers.set(k, v ?? "null", preserveHeaderCase: true);
      });
    } on SocketException catch (e) {
      if (e.message.contains('timed out')) {
        throwConnectingTimeout();
      }
      rethrow;
    } on TimeoutException {
      throwConnectingTimeout();
    }
    request.followRedirects = options.followRedirects;
    request.maxRedirects = options.maxRedirects;
    if (requestStream != null) {
// Transform the request data
      await request.addStream(requestStream);
    }
// [receiveTimeout] represents a timeout during data transfer! That is to say the
// client has connected to the server, and the server starts to send data to the client.
// So, we should use connectTimeout.
    int responseTimeout = options.connectTimeout!.inMilliseconds - timePassed;
    var future = request.close();
    if (responseTimeout > 0) {
      future = future.timeout(Duration(milliseconds: responseTimeout));
    }
    late HttpClientResponse responseStream;
    try {
      responseStream = await future;
    } on TimeoutException {
      throwConnectingTimeout();
    }
    var stream =
        responseStream.transform<Uint8List>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(Uint8List.fromList(data));
      },
    ));
    var headers = <String, List<String>>{};
    responseStream.headers.forEach((key, values) {
      headers[key] = values;
    });
    return ResponseBody(
      stream,
      responseStream.statusCode,
      headers: headers,
      isRedirect:
          responseStream.isRedirect || responseStream.redirects.isNotEmpty,
      redirects: responseStream.redirects
          .map((e) => RedirectRecord(e.statusCode, e.method, e.location))
          .toList(),
      statusMessage: responseStream.reasonPhrase,
    );
  }

  HttpClient _configHttpClient(Future? cancelFuture, int connectionTimeout) {
    var connectTimeout = connectionTimeout > 0
        ? Duration(milliseconds: connectionTimeout)
        : null;
    if (cancelFuture != null) {
      var client = HttpClient();
      client.userAgent = null;
      if (onHttpClientCreate != null) {
//user can return a HttpClient instance
        client = onHttpClientCreate!(client) ?? client;
      }

      client.idleTimeout = const Duration(seconds: 0);
      cancelFuture.whenComplete(() {
        Future.delayed(const Duration(seconds: 0)).then((e) {
          try {
            client.close(force: true);
          } catch (e) {
//...
          }
        });
      });
      return client..connectionTimeout = connectTimeout;
    }
    if (_defaultHttpClient == null) {
      _defaultHttpClient = HttpClient();
      _defaultHttpClient!.idleTimeout = const Duration(seconds: 3);
      if (onHttpClientCreate != null) {
//user can return a HttpClient instance
        _defaultHttpClient =
            onHttpClientCreate!(_defaultHttpClient!) ?? _defaultHttpClient;
      }
      _defaultHttpClient!.connectionTimeout = connectTimeout;
    }
    return _defaultHttpClient!;
  }

  @override
  void close({bool force = false}) {
    _closed = _closed;
    _defaultHttpClient?.close(force: force);
  }
}
