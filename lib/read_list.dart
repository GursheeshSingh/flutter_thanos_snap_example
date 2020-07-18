import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:snappable/snappable.dart';

const kPurple = Color(0xFF2F2B42);
const kLightPurple = Color(0xFF393351);
const kDarkPink = Color(0xFFB182EA);
const kLightPink = Color(0xFFFF67A5);

const Duration snapDuration = const Duration(seconds: 2);

class ReadListScreen extends StatefulWidget {
  @override
  _ReadListScreenState createState() => _ReadListScreenState();
}

const int itemsLength = 5;

class _ReadListScreenState extends State<ReadListScreen> {
  //TODO: Generate only for required ones
  final List<GlobalKey<SnappableState>> keys =
      List.generate(itemsLength, (index) => GlobalKey<SnappableState>());

  final List<bool> canRead = [false, true, false, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPurple,
      body: ListView(
        children: List.generate(5, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            ///If user can read message, only then we will add slidable
            child: canRead[index] == false
                ? _buildItem(index, false)
                : Slidable(
                    actionPane: SlidableScrollActionPane(),
                    actionExtentRatio: 0.25,
                    child: _buildItem(index, true),
                    actions: <Widget>[
                      ReadAction(keys[index], () => _onSnapCompleted(index)),
                    ],
                  ),
          );
        }),
      ),
    );
  }

  _onSnapCompleted(int index) {
    setState(() {
      canRead[index] = false;
    });
  }

  _buildItem(int index, bool canRead) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kLightPurple,
            ),
          ),
        ),

        ///If user can read message, then show gradient
        canRead
            ? Positioned.fill(
                child: Snappable(
                  key: keys[index],
                  duration: snapDuration,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [kDarkPink, kLightPink]),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text('$index'),
            foregroundColor: Colors.white,
          ),
          title: Text(
            'theboringdeveloper',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Good luck',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ReadAction extends StatelessWidget {
  final GlobalKey<SnappableState> snapKey;
  final Function onSnappedCompleted;

  const ReadAction(this.snapKey, this.onSnappedCompleted);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //Do the snap when 'Read' is clicked and close the slidable
        await snapKey.currentState.snap();
        Slidable.of(context).close();
        print(snapKey.currentState.isGone);
        //Wait for the duration of snap
        await Future.delayed(snapDuration);
        print(snapKey.currentState.isGone);
        //Call after snap is completed
        onSnappedCompleted?.call();
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.indigo),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          "Read",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
