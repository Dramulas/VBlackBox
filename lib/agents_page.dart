import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:VBlackBox/agent_detail_page.dart';

class AgentsPage extends StatefulWidget {
  @override
  createState() => new AgentsPageState();
}

class AgentsPageState extends State<AgentsPage> {
  List _agentList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AGENTS'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor,
          leading: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: _agentList.length == 0
            ? Container()
            : new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  Map agent = _agentList[index];
                  return Card(
                    margin: EdgeInsets.only(
                        top: 64, bottom: 110, left: 8, right: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      AgentDetailPage(agent: agent)));
                        },
                        child: Ink(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(agent['img']),
                                    fit: BoxFit.fitHeight)),
                            padding: EdgeInsets.all(12),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(agent['type'],
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 18)),
                                  Text(agent['name'].toString().toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700)),
                                ]))),
                    color: Color(0xFF0F1923),
                  );
                },
                itemCount: _agentList.length,
                viewportFraction: 0.7,
                scale: 0.9,
                index: 0));
  }

  Future<void> _fetchData() async {
    String body = await rootBundle.loadString('assets/agents.json');

    setState(() {
      _agentList = json.decode(body);
    });
  }
}
