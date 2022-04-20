import 'dart:convert';

import 'package:countrydetail/models/country_detail.dart';
import 'package:countrydetail/utils/const.dart' as constant;
import 'package:http/http.dart' as http;

class APIController {
  // api call to get the country detail

  static Future<CountryDetail>? getCountryDetail() async {
    final Map<String, String> header = {"Content-Type": "application/json"};
    CountryDetail apiResponse;

    http.Response response;

    Uri url = Uri.https(constant.baseUrl, constant.basePath);

    try {
      response = await http.get(url, headers: header);
    } catch (_) {
      return CountryDetail.withError(constant.serverError);
    }
    int statusCode = response.statusCode;

    if (statusCode == constant.HTTP_200_OK) {
      apiResponse = CountryDetail.fromJson(json.decode(response.body));
      return apiResponse;
    } else {
      String errorMessage = json.decode(response.body);
      apiResponse = CountryDetail.withError(errorMessage);
      return apiResponse;
    }
  }
}
