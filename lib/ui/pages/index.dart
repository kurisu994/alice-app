import 'package:alice/models/account.dart';
import 'package:alice/net/api/api.dart';
import 'package:alice/net/net/dio_util.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: '我的账号密码',
        home: AccountList()
    );
  }
}

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  List<AccountModel> items = new List();
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  final _dio = DioUtil.getInstance();

  @override
  void initState() {
    super.initState();
    _refresh();
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        _getMoreData();
//      }
//    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      BaseResp<List<AccountModel>> res = await _httpRequest();
      List<AccountModel> accountList = res.data;
      if (accountList.isEmpty) {
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          _scrollController.animateTo(
              _scrollController.offset - (edge - offsetFromBottom),
              duration: new Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
      }
      setState(() {
        items.addAll(accountList);
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('我的账号密码'),
      ),
      body: new SafeArea(
        child: new Container(
          padding: EdgeInsets.all(2.0),
          child: new RefreshIndicator(
            onRefresh: _refresh,
            backgroundColor: Colors.blue,
            child: new ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return _buildProgressIndicator();
                } else {
                  return ListTile(
                    title: new Text(
                        "${items[index].account}(${items[index].remark})"),
                    subtitle: new Text("${items[index].cipherCode}"),
                  );
                }
              },
              controller: _scrollController,
              separatorBuilder: (context, idx) {
                return Divider();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseResp<List<AccountModel>>> _httpRequest() async {
    Future<BaseResp<List<AccountModel>>> res =
    _dio.getRequest(ApiUtil.getPath(ApiUtil.QUERY_ACCOUNT));
    return res;
  }

  Future<Null> _refresh() async {
    items.clear();
    _dio.getRequest(ApiUtil.getPath(ApiUtil.QUERY_ACCOUNT))
        .then((BaseResp<dynamic> res) {
      List<dynamic> data = res.data;
      List<AccountModel> accountList = new List();
      if (data != null) {
        data.forEach((item) {
          AccountModel accountModel = AccountModel.fromJson(item);
          accountList.add(accountModel);
        });
      }
      setState(() {
        items.addAll(accountList);
        isPerformingRequest = false;
      });
    }).catchError((error) {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new SingleChildScrollView(
              child: AlertDialog(
                title: Text('错误'),
                content: Text(error.message),
                actions: <Widget>[
                  FlatButton(
                    child: Text('关闭'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          });
    });
    return;
  }
}
