import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/app-shared.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/comments.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/data-service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PostView extends StatefulWidget {

  final num id;

  const PostView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {

  Post? post;
  List<Comments> list = [];
  List<Comments> _list = [];
  String keyword = '';
  bool isLoading = false;
  final searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getPost(widget.id);
      var lx = await getCommentsFromPost(widget.id);
      setState(() {
        post = o;
        list = lx;
        _list = lx;
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

  void filterComments(String s) {
    if (s.isEmpty) {
      setState(() {
        list = _list;
      });
    }

    else {
      String r = s.toLowerCase();
      var q = _list.where((x) {
        String? name = x.name;
        String? email = x.email;
        String? body = x.body;
        bool bname = name?.toLowerCase().contains(r) ?? false;
        bool bemail = email?.toLowerCase().contains(r) ?? false;
        bool bbody = body?.toLowerCase().contains(r) ?? false;
        return bname || bemail || bbody;
      });
      setState(() {
        list = q.toList();
      });
    }
  }

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextField(
        controller: searchController,
        autofocus: false,
        cursorColor: Colors.black,
        style: const TextStyle(
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search By name, email, body",
          hintStyle: const TextStyle(
            color: Color(0xFFB1B1B1),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 25.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        onChanged: (String s) {
          filterComments(s);
        },
      ),
    );
  }

  List<Widget> buildContents() {
    if (post == null) {
      return [
        buildSearch(),
      ];
    }

    List<Widget> lx = [
      buildSearch(),
      Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(229, 229, 229, 0.7),
              blurRadius: 7.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post!.title ?? '',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              post!.body ?? '',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    ];

    for (int i = 0; i < list.length; i++) {
      Comments o = list[i];
      final w = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments by: ${o.name}\n(${o.email})',
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            o.body ?? '',
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      );
      final c = Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: w,
      );
      lx.add(c);
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFFF8F8F8),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Post',
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
              child: ListView(
                shrinkWrap: true,
                children: buildContents(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}