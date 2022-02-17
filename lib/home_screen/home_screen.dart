import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jakes_git_app/datamodel/jake_model.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'home_screen_bloc.dart';
import 'home_screen_events.dart';
import 'home_screen_states.dart';

class Jake extends StatelessWidget {
  const Jake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JakeBloc(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ItemScrollController scrollController;
  late List<JakeData> list = [];

  late ItemPositionsListener itemListener;
  bool firstLoad = true;

  @override
  void initState() {
    if (firstLoad) {
      BlocProvider.of<JakeBloc>(context).add(GetDataEvent());
      this.firstLoad = false;
    }
    scrollController = ItemScrollController();
    itemListener = ItemPositionsListener.create();
    var dataLength = 15;
    itemListener.itemPositions.addListener(() {
      final indices =
          itemListener.itemPositions.value.map((item) => item.index).toList();
      var indicesLength = indices.length;
      if (indices[indicesLength - 1] == (dataLength - 3)) {
        BlocProvider.of<JakeBloc>(context).add(GetDataEvent());
        dataLength = dataLength + 15;
        print('call the api for more data');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jakes Github Data'),
      ),
      body: BlocConsumer<JakeBloc, JakeState>(
        builder: (context, state) {
          this.list = BlocProvider.of<JakeBloc>(context).jakeList;
          return Column(
            children: [
              Expanded(
                child: ScrollablePositionedList.separated(
                  itemScrollController: scrollController,
                  itemPositionsListener: itemListener,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.file_copy),
                          subtitle: Text(list[index].description),
                          title: Text(list[index].name),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            Text(
                              '<> ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(list[index].language),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Icon(Icons.bug_report),
                            Text(list[index].openIssues.toString()),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Icon(Icons.person),
                            Text(list[index].watchers.toString()),
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: list.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.orange,
                    );
                  },
                ),
              ),
              state is OnLoading ? CircularProgressIndicator() : Container()
            ],
          );
        },
        listener: (context, state) {
          if (state is OnError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
      ),
    );
  }
}
