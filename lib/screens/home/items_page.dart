import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';
import 'package:flutter_study_1/repository/user_service.dart';
import 'package:flutter_study_1/utils/logger.dart';
import 'package:shimmer/shimmer.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        final imgSize = size.width / 4;

        return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 1500)),
            builder: (context, snapshot) {
                return (snapshot.connectionState != ConnectionState.done ? shimmerListView(imgSize) : AnimatedSwitcher(duration: Duration(milliseconds: 1000), child: getListView(imgSize)));
            });
      },
    );
  }

  Widget getListView(double imgSize) {
    return ListView.separated(
        padding: EdgeInsets.all(COMMON_PADDING),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              UserService().testReadFireStore();
            },
            child: SizedBox(
              height: imgSize,
              child: Row(
                children: [
                  SizedBox(
                      width: imgSize,
                      height: imgSize,
                      child: ExtendedImage.network('https://picsum.photos/100',
                          borderRadius: BorderRadius.circular(12),
                          shape: BoxShape.rectangle // boxShape를 줘야만 radius가 적용됨!
                          )),
                  SizedBox(width: COMMON_SMALL_PADDING),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('work',
                            style: Theme.of(context).textTheme.subtitle1),
                        Text('53일 전',
                            style: Theme.of(context).textTheme.subtitle2),
                        Text('5000원'),
                        Expanded(child: Container()),
                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          SizedBox(
                            height: 16,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.chat_bubble_2),
                                  Text('22'),
                                  Icon(CupertinoIcons.suit_heart),
                                  Text('30')
                                ],
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
              height: COMMON_SMALL_PADDING * 2 + 1,
              thickness: 1,
              color: Colors.grey[200]);
        },
        itemCount: 10);
  }

  Widget shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
          padding: EdgeInsets.all(COMMON_PADDING),
          itemBuilder: (context, index) {
            return SizedBox(
              height: imgSize,
              child: Row(
                children: [
                  Container(
                      width: imgSize,
                      height: imgSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          color: Colors.white)),
                  SizedBox(width: COMMON_SMALL_PADDING),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                shape: BoxShape.rectangle,
                                color: Colors.white)),
                        SizedBox(
                          height: COMMON_SMALL_PADDING / 2,
                        ),
                        Container(
                            width: 40,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                shape: BoxShape.rectangle,
                                color: Colors.white)),
                        SizedBox(
                          height: COMMON_SMALL_PADDING / 2,
                        ),
                        Container(
                            width: 55,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                shape: BoxShape.rectangle,
                                color: Colors.white)),
                        Expanded(child: Container()),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: 70,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      shape: BoxShape.rectangle,
                                      color: Colors.white))
                            ])
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
                height: COMMON_SMALL_PADDING * 2 + 1,
                thickness: 1,
                color: Colors.grey[200]);
          },
          itemCount: 10),
    );
  }
}
