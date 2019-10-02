import 'designcoursetheme.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'database/database.dart';
import 'database/course.dart';

class PopularCourseListView extends StatefulWidget {
  // final Function callBack;

  const PopularCourseListView({Key key}) : super(key: key);
  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  Future<List<Course>> getData() async {
    List<Course> data = await DBProvider.db.getAllCourses();
    List<Course> listnew = new List<Course>();
    if(data.length==0){
      return listnew;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          } else {
            List<Course> courses = snapshot.data;
            return GridView(
              padding: EdgeInsets.all(8),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List.generate(
                courses.length,
                (index) {
                  var count = courses.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController.forward();
                  return CourseView(
                    // callback: () {
                    //   widget.callBack();
                    // },
                    course: courses[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
}
