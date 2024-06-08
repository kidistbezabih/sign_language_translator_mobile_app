import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './searchController.dart' as sc;
import 'description.dart';

class TabsView extends StatefulWidget {
  const TabsView({super.key});

  static const routeName = '/tabs';

  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  TextEditingController searchKeyEditingController = TextEditingController();

  final searchController = sc.SearchController('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Alphabets',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 6.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFF4053B5),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_half,
              color: Color(0xFF4053B5),
            ),
            label: 'Favorites',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: searchController,
        builder: (BuildContext context, Widget? child) {
          return SafeArea(
            top: false,
            child: Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4053B5),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      // Search bar
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const BackButton(
                            color: Colors.white,
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const Text(
                            'Alphabets',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: BackButton(
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: searchKeyEditingController,
                          onChanged: (change) {
                            searchController.setSearchKey(change);
                          },
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                                strokeAlign: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1,
                                strokeAlign: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                      const Tabs(),
                      const SizedBox(
                        height: 0,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Alphabets(
                              searchController: searchController,
                            ),
                            Words(
                              searchController: searchController,
                            ),
                            Numbers(
                              searchController: searchController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Numbers extends StatefulWidget {
  const Numbers({
    super.key,
    required this.searchController,
  });

  final sc.SearchController searchController;

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> numbers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      numbers = await getCollectionData('numbers');
      setState(() {});
      // debugPrint('${numbers[0]}');
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Search Key: ${numbers.length}');

    return ListenableBuilder(
      listenable: widget.searchController,
      builder: (BuildContext context, Widget? child) {
        debugPrint('Search Key: ${widget.searchController.searchKey}');
        List newNumbers = [];
        if (widget.searchController.searchKey.isNotEmpty) {
          newNumbers = numbers
              .where((element) =>
                  element.get('name') == widget.searchController.searchKey)
              .toList();
        } else {
          newNumbers = numbers;
        }
        return numbers.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : ListView.builder(
                itemCount: newNumbers.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 26,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 0.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Description.routeName,
                              arguments: DescriptionScreenArguments(
                                file: newNumbers[index].get('sign'),
                                name: newNumbers[index].get('name'),
                                type: Signs.number,
                              ),
                            );
                          },
                          title: Text(
                            "${newNumbers[index].get('name')}",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 2,
                        right: 35,
                        child: Icon(
                          Icons.bookmark_sharp,
                          color: Color(0xFF4053B5),
                          size: 32,
                        ),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}

class Words extends StatefulWidget {
  const Words({
    super.key,
    required this.searchController,
  });

  final sc.SearchController searchController;

  @override
  State<Words> createState() => _WordsState();
}

class _WordsState extends State<Words> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> words = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      words = await getCollectionData('words');
      setState(() {});
      // debugPrint('${words[0].get('word')}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.searchController,
      builder: (BuildContext context, Widget? child) {
        debugPrint('Words Search Key: ${widget.searchController.searchKey}');

        List newWords = [];

        if (widget.searchController.searchKey.isNotEmpty) {
          newWords = words.where((element) {
            if (element
                    .get('word')
                    .toString()
                    .contains(widget.searchController.searchKey) ||
                element.get('description').toString().contains(
                      widget.searchController.searchKey,
                    )) {
              return true;
            }
            return false;
          }).toList();
        } else {
          newWords = words;
        }

        return words.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : ListView.builder(
                itemCount: newWords.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 26,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 0.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Description.routeName,
                              arguments: DescriptionScreenArguments(
                                  file: newWords[index].get('sign'),
                                  name: newWords[index].get('word'),
                                  type: Signs.word,
                                  description:
                                      newWords[index].get('description')),
                            );
                          },
                          dense: true,
                          isThreeLine: false,
                          title: Text(
                            newWords[index].get('word'),
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 2,
                        right: 35,
                        child: Icon(
                          Icons.bookmark_sharp,
                          color: Color(0xFF4053B5),
                          size: 32,
                        ),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getCollectionData(
    String collectionName) async {
  final collectionRef = FirebaseFirestore.instance.collection(collectionName);
  final querySnapshot = await collectionRef.get();
  final allData = querySnapshot.docs.map((doc) => doc).toList();
  return allData;
}

class Alphabets extends StatefulWidget {
  const Alphabets({
    super.key,
    required this.searchController,
  });

  final sc.SearchController searchController;
  

  @override
  State<Alphabets> createState() => _AlphabetsState();
}

class _AlphabetsState extends State<Alphabets> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> alphabets = [];
  late List<String> favorites;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      alphabets = await getCollectionData('letters');
      prefs = await SharedPreferences.getInstance();
      favorites =  prefs.getStringList("favorites_alphabets") ?? [];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.searchController,
      builder: (BuildContext context, Widget? child) {
        List newAlphabets = [];

        if (widget.searchController.searchKey.isNotEmpty) {
          newAlphabets = alphabets.where((element) {
            for (var alphabet in alphabets) {
              debugPrint('${alphabet.get('label') ?? ''}');

              var letters = alphabet.get('label');

              if (letters[0].contains(widget.searchController.searchKey) ||
                  letters[1].contains(widget.searchController.searchKey) ||
                  letters[2].contains(widget.searchController.searchKey) ||
                  letters[3].contains(widget.searchController.searchKey) ||
                  letters[4].contains(widget.searchController.searchKey) ||
                  letters[5].contains(widget.searchController.searchKey) ||
                  letters[6].contains(widget.searchController.searchKey)) {
                debugPrint(
                    '${letters} vs ${widget.searchController.searchKey}');
                return true;
              }
            }

            return false;
          }).toList();
        } else {
          newAlphabets = alphabets;
        }

        return alphabets.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : ListView.builder(
                itemCount: newAlphabets.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.only(
                          bottom: 26,
                          left: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 0.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      // height: 600,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Center(
                                              child: Text(
                                                '${newAlphabets[index].get('label')[0]} - Family',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                            for (int i = 0;
                                                i <
                                                    newAlphabets[index]
                                                        .get('label')
                                                        .length;
                                                i++)
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushNamed(
                                                    context,
                                                    Description.routeName,
                                                    arguments:
                                                        DescriptionScreenArguments(
                                                      name: newAlphabets[index]
                                                          .get('label')[i],
                                                      file: newAlphabets[index]
                                                          .get('link')[i],
                                                      type: Signs.letter,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 6,
                                                    vertical: 4,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 6,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xFF4053B5),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    newAlphabets[index]
                                                        .get('label')[i],
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 120,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF4053B5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Close',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            // Navigator.pushNamed(
                            //   context,
                            //   Description.routeName,
                            //   arguments: DescriptionScreenArguments(
                            //     name: alphabets[index].get('label')[0].toString(),
                            //     file: alphabets[index].get('link')[0],
                            //   ),
                            // );
                          },
                          dense: true,
                          isThreeLine: false,
                          title: newAlphabets[index].get('label')[0] != null
                              ? Text(
                                  newAlphabets[index].get('label')[0] +
                                      ' - ' +
                                      newAlphabets[index].get('label')[6],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                        ),
                      ),
                       Positioned(
                        top: 18,
                        right: 35,
                        child: GestureDetector(
                          onTap: () async {
                            final List<String> favs = [...favorites];
                            var item = newAlphabets[index].reference.id;

                            if (favorites.contains(item)) {
                              favs.remove(item);
                            }else {
                              favs.add(item);
                            }
                            // debugPrint(item);
                            // debugPrint(favs.toString());
                            setState(() {
                              favorites = favs;
                            });
                            await prefs.setStringList('favorites_alphabets', favs);
                          },
                          child: Icon( !favorites.contains(newAlphabets[index].reference.id) ? 
                            Icons.star_border : Icons.star,
                            color: Color(0xFF4053B5),
                            size: 32,
                          ),
                        ),
                      ),
                      // const Positioned(
                      //   top: 18,
                      //   right: 35,
                      //   child: Icon(
                      //     Icons.star,
                      //     color: Color(0xFF4053B5),
                      //     size: 32,
                      //   ),
                      // ),
                    ],
                  );
                },
              );
      },
    );
  }
}

class Tabs extends StatelessWidget {
  const Tabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonsTabBar(
      backgroundColor: const Color(0xFFC8D1F2),
      unselectedBackgroundColor: Colors.white,
      borderColor: Theme.of(context).colorScheme.onBackground,
      unselectedLabelStyle: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.bold,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        decorationColor: Colors.black,
        color: Colors.black,
      ),
      onTap: (index) {
        // ref.read(serviceTypeProvider.notifier).update((state) {
        //   return index + 1;
        // });
      },
      borderWidth: 1,
      buttonMargin: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      physics: const ScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      tabs: const [
        Tab(
          text: "Alphabets",
        ),
        Tab(
          text: "Words",
        ),
        Tab(
          text: "Numbers",
        ),
      ],
    );
  }
}
