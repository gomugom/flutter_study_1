import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_study_1/constraints/common_constraints.dart';
import 'package:flutter_study_1/constraints/shared_pref_keys.dart';
import 'package:flutter_study_1/state/user_provider.dart';
import 'package:flutter_study_1/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? _verificationId;
  int? _resendingToken;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying ? true : false,
          child: Form(
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
                        TextButton(onPressed: () async {

                          // codeSending 중일 땐 클릭 못하도록
                          if(_verificationStatus == VerificationStatus.codeSending) {
                            return;
                          }

                          // getAddress();
                          if(_globalKey.currentState != null) {
                            bool flag = _globalKey.currentState!.validate();
                            logger.d('flag value : ${flag}');

                            if(flag) { // validation passed
                              // setState(() {
                              //   _verificationStatus = VerificationStatus.sending;
                              // });

                              setState(() {
                                _verificationStatus = VerificationStatus.codeSending;
                              });

                              String phoneNum = txtEditController.text;
                              phoneNum = phoneNum.replaceAll(' ', '');
                              phoneNum = phoneNum.replaceFirst('0', '');

                              FirebaseAuth auth = FirebaseAuth.instance;

                              await auth.verifyPhoneNumber(
                                phoneNumber: '+82$phoneNum',
                                forceResendingToken: _resendingToken,
                                verificationCompleted: (PhoneAuthCredential credential) async {
                                  await auth.signInWithCredential(credential);
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  if (e.code == 'invalid-phone-number') {
                                    print('The provided phone number is not valid.');
                                  }

                                  setState(() { // 실패시 인증문자 재발송할 수 있게끔
                                    _verificationStatus = VerificationStatus.none;
                                  });
                                },
                                codeSent: (String verificationId, int? resendToken) async {

                                  setState(() {
                                    _verificationStatus = VerificationStatus.codeSent;
                                  });

                                  _verificationId = verificationId;
                                  _resendingToken = resendToken!;

                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                            }
                          }
                        }, child: _verificationStatus == VerificationStatus.codeSending ? SizedBox(width:26,height: 26,child: CircularProgressIndicator(color: Colors.white)) : Text('인증문자 발송')),
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
                              this.attemptVerify(context);
                            }, child: _verificationStatus == VerificationStatus.verifying ? SizedBox(width:26,height: 26,child: CircularProgressIndicator(color:Colors.white)) : Text('인증')),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ),
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
      case VerificationStatus.verifying:
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifyDone:
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
        return 0.0;
      case VerificationStatus.sending:
      case VerificationStatus.verifying:
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifyDone:
          return 1.0;
    }
  }

  void attemptVerify(BuildContext context) async {

    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    // await Future.delayed(Duration(seconds: 1));

    try {
      // Update the UI - wait for the user to enter the SMS code
      String smsCode = authEditController.text; // 사용자가 입력한 인증번호

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _verificationStatus = VerificationStatus.verifyDone;
      });

    } catch(err) {

      logger.e('err occur!! auth fail : ${err}');

      // 하단 메시지 경고창 출력
      SnackBar snackBar = SnackBar(content: Text('인증번호를 잘못 입력하셨어요!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

  }

  Future<String?> getAddress() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String address = prefs.getString(SHARED_ADDRESS) ?? "";
    double lat = prefs.getDouble(SHARED_LAT) ?? 0;
    double lon = prefs.getDouble(SHARED_LON) ?? 0;

    logger.d('saved address from pref : ${address}');
    return address;
  }

}

enum VerificationStatus {
  none, sending, verifying, codeSending, codeSent, verifyDone
}