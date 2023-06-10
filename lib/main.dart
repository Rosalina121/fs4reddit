import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'OMG Blahaj',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>{};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    // Widget page;
    // switch (selectedIndex) {
    //   case 0:
    //     page = GeneratorPage();
    //     break;
    //   case 1:
    //     page = FavoritesPage();
    //     break;
    //   case 2:
    //     page = AllPage();
    //     break;
    //   default:
    //     throw UnimplementedError('No widget for $selectedIndex');
    // }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text('r/all'),
        ),
        body: AllPage(),
        // body: Row(
        //   children: [
        //     SafeArea(
        //       child: NavigationRail(
        //         extended: constraints.maxWidth >= 600,
        //         destinations: [
        //           NavigationRailDestination(
        //             icon: Icon(Icons.home),
        //             label: Text('Home'),
        //           ),
        //           NavigationRailDestination(
        //             icon: Icon(Icons.favorite),
        //             label: Text('Favorites'),
        //           ),
        //           NavigationRailDestination(
        //             icon: Icon(Icons.all_inclusive),
        //             label: Text('All'),
        //           ),
        //         ],
        //         selectedIndex: selectedIndex,
        //         onDestinationSelected: (value) {
        //           setState(() {
        //             selectedIndex = value;
        //           });
        //         },
        //       ),
        //     ),
        //     Expanded(
        //       child: Container(
        //         color: Color.fromARGB(255, 255, 167, 179),
        //         child: page,
        //       ),
        //     ),
        //   ],
        // ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet :(.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('You have ${favorites.length} favorites:'),
        ),
        for (var fav in favorites)
          ListTile(leading: Icon(Icons.favorite), title: Text(fav.asCamelCase)),
      ],
    );
  }
}

class AllPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return PostCard(theme: theme, index: index);
      },
    );
  }
}

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.theme,
    required this.index,
  });

  final ThemeData theme;
  final int index;

  @override
  State<PostCard> createState() => _PostCardState();
}

enum VoteState { upvoted, downvoted, none }

class _PostCardState extends State<PostCard> {
  VoteState voteState = VoteState.none;

  void _onDismissed() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        key: ValueKey(widget.index),
        startActionPane: ActionPane(
            motion: const StretchMotion(),
            // extentRatio: 1 / 5,
            children: [
              SlidableAction(
                backgroundColor: Color(0xFFff6c00),
                autoClose: true,
                icon: Icons.arrow_upward,
                onPressed: (context) => {
                  if (voteState != VoteState.upvoted) {
                    setState(() {
                      voteState = VoteState.upvoted;
                    })
                  } else {
                    setState(() {
                      voteState = VoteState.none;
                    })
                  }

                },
              ),
              SlidableAction(
                backgroundColor: Color(0xFF5560e2),
                autoClose: true,
                icon: Icons.arrow_downward,
                onPressed: (context) => {
                  if (voteState != VoteState.downvoted) {
                    setState(() {
                      voteState = VoteState.downvoted;
                    })
                  } else {
                    setState(() {
                      voteState = VoteState.none;
                    })
                  }
                },
              )
            ]),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.blue,
              autoClose: true,
              icon: Icons.ios_share,
              onPressed: (context) => _onDismissed(),
            ),
            SlidableAction(
              backgroundColor: Colors.green,
              autoClose: true,
              icon: Icons.bookmark,
              onPressed: (context) => _onDismissed(),
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: widget.theme.colorScheme.primaryContainer,
              border: switch (voteState) {
                VoteState.upvoted =>
                  Border(left: BorderSide(width: 5, color: Color(0xFFff6c00))),
                VoteState.downvoted =>
                  Border(left: BorderSide(width: 5, color: Color(0xFF5560e2))),
                _ => null
              }),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Post Title',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('r/subreddit'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.network(
                            fit: BoxFit.fitHeight,
                            width: 350,
                            'https://media.tenor.com/ql5zFjnFEmMAAAAd/celeste-badeline.gif'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('u/user'),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            TextButton(
                              child: Icon(Icons.more_horiz),
                              onPressed: () {
                                print('More');
                              },
                            ),
                            SizedBox(width: 5),
                            TextButton(
                              child: Icon(Icons.chat),
                              onPressed: () {
                                print('Comments');
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Fav'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(pair.asCamelCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}
