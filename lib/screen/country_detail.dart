import 'package:countrydetail/controller/api_controller.dart';
import 'package:countrydetail/models/country_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CountryDetail extends StatefulWidget {
  const CountryDetail({Key? key}) : super(key: key);

  @override
  State<CountryDetail> createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  Future<CountryDetailModel>? countryDetailResponse;
  CountryDetailModel countryDetail = CountryDetailModel();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    countryDetailResponse = APIController.getCountryDetail();
    super.initState();
  }

  void _onRefresh() async {
    countryDetailResponse = APIController.getCountryDetail();
    countryDetailResponse?.then((response) {
      if (response.error == null) {
        countryDetail = response;
      }
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<CountryDetailModel>(
            future: countryDetailResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data?.error == null) {
                  countryDetail = snapshot.data!;
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(countryDetail.title ?? ''),
                    ),
                    body: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: _listView(),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(snapshot.data?.error.toString() ?? ''),
                  );
                }
              } else if (snapshot.error != null) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ),
    );
  }

// list view to show data rows
  ListView _listView() {
    return ListView.builder(
        itemCount: countryDetail.rows?.length,
        itemBuilder: (_, index) {
          Rows detail = countryDetail.rows![index];
          return (detail.title != null || detail.imageHref != null || detail.description != null)
              ? Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: (detail.imageHref != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                detail.imageHref!,
                                height: 55,
                                width: 55,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Center(
                                      child: Text(
                                    'Wrong url',
                                    textAlign: TextAlign.center,
                                  ));
                                },
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Text('No url'),
                    ),
                    title: Text(detail.title ?? ''),
                    subtitle: Text(detail.description ?? ''),
                    isThreeLine: true,
                  ),
                )
              : Container();
        });
  }
}
