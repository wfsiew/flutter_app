// ignore_for_file: use_key_in_widget_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/app-shared.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/data-service.dart';
import 'package:flutter_app/ui/postview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_app/constants.dart';

class Home extends StatefulWidget {
  
  static const String routeName = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Post> list = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var lx = await getAllPost();
      setState(() {
        list = lx;
        isLoading = false;
      });
    }

    on DioError {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8F8F8),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Home',
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(),
        child: SafeArea(
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: onRefresh,
            child: Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, i) {
                  Post o = list[i];
                  return ListTile(
                    onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => PostView(
                            id: o.id!,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      o.title ?? '',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      o.body ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return const Divider(
                    thickness: 1.0,
                    color: Color(0xFFB1B1B1),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}