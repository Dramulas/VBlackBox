// import 'dart:core';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:html/parser.dart';
// import 'package:html/dom.dart' as dom;
// import 'package:package_info/package_info.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'web_page.dart';

// class News {
//   String title;
//   String description;
//   String date;
//   String url;
//   String imgUrl;
// }

// class NewsPage extends StatefulWidget {
//   @override
//   createState() => new NewsPageState();
// }

// class NewsPageState extends State<NewsPage> {
//   List<News> _newsList = [];
//   bool _isLoading = true;
//   BuildContext _scaffoldContext;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       new GlobalKey<RefreshIndicatorState>();

//   PackageInfo _packageInfo;

//   @override
//   void initState() {
//     _refreshList();
//     _initPackageInfo();
//     super.initState();
//   }

//   Future _initPackageInfo() async {
//     _packageInfo = await PackageInfo.fromPlatform();
//   }

//   Future<void> _refreshList() async {
//     _newsList = [];
//     _fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scaffoldContext = context;
//     return _buildHome();
//   }

//   Widget _buildHome() {
//     return NestedScrollView(
//       headerSliverBuilder: (context, innerBoxScrolled) => [
//         SliverAppBar(
//           title: Text('VBlackBox'),
//           centerTitle: true,
//           pinned: true,
//           backgroundColor: Theme.of(context).canvasColor,
//           actions: [
//             PopupMenuButton(
//               onSelected: (result) {
//                 switch (result) {
//                   case 0:
//                     _showAbout();
//                     break;
//                 }
//               },
//               itemBuilder: (context) =>
//                   [PopupMenuItem(child: Text('About'), value: 0)],
//             )
//           ],
//         )
//       ],
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _buildList(),
//     );
//   }

//   Widget _buildList() {
//     return RefreshIndicator(
//       key: _refreshIndicatorKey,
//       onRefresh: _refreshList,
//       child: _newsList.length > 0
//           ? ListView.builder(
//               itemCount: _newsList.length,
//               itemBuilder: (context, index) {
//                 if (index == 0) return _buildFeaturedItem(_newsList[index]);
//                 return _buildItem(_newsList[index]);
//               })
//           : Center(child: Icon(Icons.error_outline, size: 48)),
//     );
//   }

//   Widget _buildItem(News news) {
//     return ListTile(
//         leading: Card(
//             margin: EdgeInsets.all(0),
//             elevation: 4,
//             clipBehavior: Clip.antiAlias,
//             child: Image.network(news.imgUrl)),
//         title: Text(news.title),
//         subtitle: Text(news.date),
//         onTap: () => _launchUrl(news));
//   }

//   Widget _buildFeaturedItem(News news) {
//     return Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 8,
//         margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//             onTap: () => _launchUrl(news),
//             child: Ink(
//                 height: 220,
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: NetworkImage(news.imgUrl), fit: BoxFit.cover)),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Text(news.title,
//                           style: TextStyle(fontSize: 18, color: Colors.white)),
//                       Text(news.date, style: TextStyle(color: Colors.white70))
//                     ]))));
//   }

//   void _showAbout() {
//     showAboutDialog(
//         context: _scaffoldContext,
//         applicationName: 'VBlackBox',
//         applicationIcon:
//             Image.asset('assets/app_logo.png', width: 48, height: 48),
//         applicationVersion: _packageInfo.version,
//         applicationLegalese: 'Copyright 2020 Caleb Yun');
//   }

//   void _launchUrl(News news) async {
//     try {
//       if (news.url.contains('playvalorant.com')) {
//         Navigator.push(context,
//             new CupertinoPageRoute(builder: (context) => WebPage(news: news)));
//       } else
//         await launch(news.url);
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future _fetchData() async {
//     try {
//       String url = 'https://playvalorant.com/en-us/news/';
//       var client = Client();
//       Response response = await client.get(url);

//       var document = parse(response.body);
//       List<dom.Element> newsItems = document.querySelectorAll(
//           'div.NewsArchive-module--content--_kqJU > div.NewsArchive-module--newsCardWrapper--2OQiG');

//       for (var item in newsItems) {
//         String newsUrl = item.querySelector('a').attributes['href'];
//         News news = new News()
//           ..title = item.querySelector('h5').text.replaceAll('â', '\'')
//           ..url = newsUrl.contains('http')
//               ? newsUrl
//               : 'https://playvalorant.com/en-us/news/' + newsUrl
//           ..date =
//               item.querySelector('p.NewsCard-module--published--37jmR').text
//           ..description =
//               item.querySelector('p.NewsCard-module--description--3sFiD').text
//           ..imgUrl = item
//               .querySelector('.NewsCard-module--image--2sGrc')
//               .attributes['style']
//               .replaceAll(
//                   RegExp(r'background-image: url\(|background-image:url\(|\)'),
//                   '');

//         _newsList.add(news);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       Scaffold.of(_scaffoldContext).showBottomSheet(
//         (context) => build(context),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }
// }
