import 'dart:convert';

import 'package:countrydetail/models/country_detail_model.dart';
import 'package:countrydetail/utils/const.dart' as constant;
import 'package:http/http.dart' as http;

class APIController {
  // api call to get the country detail

  static Future<CountryDetailModel>? getCountryDetail() async {
    final Map<String, String> header = {"Content-Type": "application/json"};
    CountryDetailModel apiResponse;

    http.Response response;

    // sets URL

    Uri url = Uri.parse(constant.baseUrl);

    try {
      response = await http.get(url, headers: header);
    } catch (_) {
      return CountryDetailModel.withError(constant.serverError);
    }
    int statusCode = response.statusCode;

    if (statusCode == constant.http200ok) {
      apiResponse = CountryDetailModel.fromJson(json.decode(response.body));
      return apiResponse;
    } else {
      String errorMessage = json.decode(response.body);
      apiResponse = CountryDetailModel.withError(errorMessage);
      return apiResponse;
    }
  }
}
