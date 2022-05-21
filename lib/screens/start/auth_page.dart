import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';
import 'package:flutter_study_1/utils/logger.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  TextEditingController txtEditController = TextEditingController(text: '010');
  TextEditingController authEditController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        return Form(
          key: _globalKey,
          child: Scaffold(
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
                    controller: txtEditController,
                    inputFormatters: [
                      MaskedInputFormatter('010 0000 0000')
                    ],
                    validator: (inputTxt) {
                      if(inputTxt != null && inputTxt.length == 13) {
                        return null;
                      } else {
                        return '전화번호를 올바르게 입력하세요.';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      )
                    )
                  ),
                  SizedBox(height: COMMON_SMALL_PADDING),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(onPressed: () {
                        if(_globalKey.currentState != null) {
                          bool flag = _globalKey.currentState!.validate();
                          logger.d('flag value : ${flag}');

                          if(flag) { // validation passed
                            setState(() {
                              _verificationStatus = VerificationStatus.sending;
                            });
                          }
                        }
                      }, child: Text('인증문자 발송')),
                    ],
                  ),
                  SizedBox(height: COMMON_SMALL_PADDING),
                  AnimatedOpacity(
                    opacity: this.getOpacityValue(_verificationStatus),
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 300),
                    child: AnimatedContainer(
                      height: this.getHeight('txtFormField', _verificationStatus),
                      duration: Duration(milliseconds: 300),
                      child: TextFormField(
                          controller: authEditController,
                          inputFormatters: [
                            MaskedInputFormatter('000000')
                          ],
                          validator: (inputAuthTxt) {

                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                              )
                          )
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    opacity: this.getOpacityValue(_verificationStatus),
                    child: AnimatedContainer(
                      height: this.getHeight('btn', _verificationStatus),
                      duration: Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(onPressed: () {

                          }, child: Text('인증')),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        );
      }
    );
  }

  double getHeight(String type, VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.sending:
      case VerificationStatus.sendAndDone:
        if(type == 'btn') {
          return 40 + COMMON_SMALL_PADDING;
        } else {
          return 60 + COMMON_SMALL_PADDING;
        }
    }
  }

  double getOpacityValue(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.sending:
      case VerificationStatus.sendAndDone:
          return 1;
    }
  }

}

enum VerificationStatus {
  none, sending, sendAndDone
}