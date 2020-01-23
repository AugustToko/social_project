import 'dart:async';
import 'package:http_client_helper/http_client_helper.dart';

import 'package:rxdart/rxdart.dart';

import '../di/app_module.dart';

//Future _get(String url, {Map<String, dynamic> params}) async {
//  var response = await dio.get(url, queryParameters: params);
//  return response.data;
//}

Observable post(String url, Map<String, dynamic> params) =>
    Observable.fromFuture(_post(url, params)).asBroadcastStream();

//Observable get(String url, {Map<String, dynamic> params}) =>
//    Observable.fromFuture(_get(url, params: params)).asBroadcastStream();

Future _post(String url, Map<String, dynamic> params) async {
//  var response = await Dio().post(url, data: params);
  var result = await HttpClientHelper.post(url, body: params);
  return result.body;
}
