import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({Key? key}) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, snapshot) {

        Size size = MediaQuery.of(context).size;
        var imageSize = (size.width / 3) - COMMON_PADDING * 2;
        var borderRadius = 16.0;

        return SizedBox(
          width: size.width,
          height: size.width / 3,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: EdgeInsets.all(COMMON_PADDING),
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey, width: 2)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded, color: Colors.grey),
                      Text('0/10', style: Theme.of(context).textTheme.subtitle2)
                    ],
                  ),
                ),
              ),
              ...List.generate(20,
                      (index) => Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: COMMON_PADDING, bottom: COMMON_PADDING, top: COMMON_PADDING),
                              child: Column(
                                children: [
                                  ExtendedImage.network('https://picsum.photos/100',
                                                        width: imageSize,
                                                        height: imageSize,
                                                        borderRadius: BorderRadius.circular(borderRadius),
                                                        shape: BoxShape.rectangle,
                                         ),
                                ],
                              )
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                  padding: EdgeInsets.all(8),
                                  onPressed: () {},
                                  icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.black54
                                  )
                              ),
                            ),
                          )
                        ],
                      ))
            ],
          ),
        );
      }
    );
  }
}
