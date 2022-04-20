class CountryDetail {
  String? title;
  List<Rows>? rows;
  String? error;

  // Default constructor

  CountryDetail({this.title, this.rows, this.error});

  // Named factory constructor to fill the data from json

  factory CountryDetail.fromJson(Map<String, dynamic> json) {
    return CountryDetail(
      title: json['title'],
      rows: getRowsList(json),
    );
  }
  // method to return the List of Rows
  static List<Rows> getRowsList(Map<String, dynamic> json) {
    List<Rows> rows = <Rows>[];
    if (json['rows'] != null) {
      json['rows'].forEach((row) {
        rows.add(Rows.fromJson(row));
      });
    }
    return rows;
  }

  // Named constuructor to get capture the error (if any)

  factory CountryDetail.withError(String? errorMessage) {
    return CountryDetail(error: errorMessage);
  }
}

class Rows {
  String? title;
  String? description;
  String? imageHref;

  // Default constructor

  Rows({this.title, this.description, this.imageHref});

// Named factory constructor to parse the data of Row

  factory Rows.fromJson(Map<String, dynamic> json) {
    return Rows(
      title: json['title'],
      description: json['description'],
      imageHref: json['imageHref'],
    );
  }
}
