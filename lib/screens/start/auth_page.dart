import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(title: Text('전화번호 로그인')),
          body: Padding(
            padding: EdgeInsets.all(COMMON_PADDING),
            child: Column(
              children: [
                Row(
                  children: [
                    ExtendedImage.asset('assets/imgs/padlock.png', width: size.width * 0.15, height: size.width * 0.15),
                    SizedBox(width: COMMON_SMALL_PADDING),
                    Text('토마토마켓은 휴대폰 번호로 가입해요.\n번호는 안전하게 보관 되며\n어디에도 공개되지 않아요.')
                  ],
                ),
                SizedBox(height: COMMON_SMALL_PADDING),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    )
                  )
                )
              ],
            )
          ),
        );
      }
    );
  }
}
