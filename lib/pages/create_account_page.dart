import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import 'package:user/backend_processes/connector.dart';
import 'package:user/modules/app_theme.dart';
import 'package:user/modules/dialog_presenter.dart';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPage();
}

class _CreateAccountPage extends State<CreateAccountPage> {

  final _informationFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _validateFormKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  String _userName = "";
  String _email = "";
  String _password = "";
  String _code = "";

  int _currentScreen = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final _screenTitles = <String> [
    "輸入基本資訊",
    "設定密碼",
    "傳送申請",
    "驗證信箱",
    "成功 !",
  ];


  Future<void> _create() async {
    DialogPresenter.showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.createAccount(userName: _userName, email: _email, password: _password);

    if(context.mounted) {
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        DialogPresenter.showInformDialog(context, "傳送成功");
        setState(() {
          _currentScreen = 3;
        });
        _animateSwitchScreen();
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.parameterInUsedError:
            errorDescription = "使用者名稱或信箱已被使用";
            break;
          case StatusType.namePasswordInvalidError:
            errorDescription = "使用者名稱或密碼不符標準";
            break;
          case StatusType.programExceptionError:
            errorDescription = response.data["reason"];
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        DialogPresenter.showInformDialog(context, "傳送失敗", description: errorDescription);
      }
    }
  }

  Future<void> _validate() async {
    DialogPresenter.showProcessingDialog(context, "傳送中");

    ConnectResponse response = await connector.validate(code: _code);

    if(context.mounted){
      DialogPresenter.closeDialog(context);
      if(response.isOk()){
        setState(() {
          _currentScreen = 4;
        });
        _animateSwitchScreen();
      }
      else{
        String errorDescription;
        switch(response.type){
          case StatusType.invalidCredentialCodeError:
            errorDescription = "驗證碼錯誤";
            break;
          case StatusType.programExceptionError:
            errorDescription = response.data["reason"];
            break;
          case StatusType.connectionError:
            errorDescription = "無法連線";
            break;
          case StatusType.unknownError:
            errorDescription = response.data["reason"];
            break;
          default:
            errorDescription = "";
        }
        DialogPresenter.showInformDialog(context, "失敗", description: errorDescription);
      }
    }
  }

  void _animateSwitchScreen() {
    _pageController.animateToPage(
      _currentScreen,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _topSwitchScreenBar() {
    return Column(
      children: [
        if(_currentScreen != 4) ...[
          Row(
            children: <Expanded> [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if(_currentScreen == 3){
                        _currentScreen = 0;
                      }
                      else{
                        _currentScreen--;
                      }
                    });
                    _animateSwitchScreen();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if([1, 2, 3].contains(_currentScreen)) ...[
                        const Icon(Icons.arrow_back_ios, color: Colors.orange),
                        Text(
                          _currentScreen == 3 ? "返回" : "上一步",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageViewDotIndicator(
                  currentItem: _currentScreen,
                  count: 4,
                  duration: const Duration(milliseconds: 300),
                  unselectedColor: Colors.grey,
                  selectedColor: Colors.orange,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    switch(_currentScreen){
                      case 0:
                        if(_informationFormKey.currentState!.validate()) {
                          setState(() {
                            _currentScreen = 1;
                          });
                          _animateSwitchScreen();
                        }
                        break;
                      case 1:
                        if(_passwordFormKey.currentState!.validate()) {
                          setState(() {
                            _currentScreen = 2;
                          });
                          _animateSwitchScreen();
                        }
                        break;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(_currentScreen == 0 || _currentScreen == 1) ...[
                        const Text(
                          "下一步",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            _screenTitles[_currentScreen],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputInformationScreen() {
    return Form(
      key: _informationFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: TextFormField(
              initialValue: _userName,
              keyboardType: TextInputType.text,
              decoration: AppTheme.getEllipseInputDecoration(
                labelText: "使用者名稱",
                prefixIcon: const Icon(Icons.person),
              ),
              onChanged: (text) {
                setState(() {
                  _userName = text;
                });
              },
              validator: (text) {
                return (text == null || text.isEmpty) ? "請輸入使用者名稱" : null;
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: TextFormField(
              initialValue: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: AppTheme.getEllipseInputDecoration(
                labelText: "信箱",
                prefixIcon: const Icon(Icons.email),
              ),
              onChanged: (text) {
                setState(() {
                  _email = text;
                });
              },
              validator: (text) {
                return (text == null || text.isEmpty) ? "請輸入信箱" : null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputPasswordScreen() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: TextFormField(
              initialValue: _password,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_passwordVisible,
              decoration: AppTheme.getEllipseInputDecoration(
                labelText: "密碼",
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: _passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _password = text;
                });
              },
              validator: (text) {
                return (text == null || text.isEmpty) ? "請輸入密碼" : null;
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: TextFormField(
              initialValue: "",
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_passwordVisible,
              decoration: AppTheme.getEllipseInputDecoration(
                labelText: "確認密碼",
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: _passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              validator: (text) {
                if(text == null || text.isEmpty) {
                  return "請再次輸入密碼";
                }
                if(text != _password){
                  return "密碼不一致";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendScreen() {
    return Column(
      children: [
        Lottie.asset(
          "assets/lotties/sending.json",
          width: 250,
          height: 250,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            fixedSize: const Size(100, 40),
          ),
          onPressed: () {
            _create();
          },
          child: const Text("傳送"),
        ),
      ],
    );
  }

  Widget _validateScreen() {
    return Form(
      key: _validateFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Lottie.asset(
              "assets/lotties/verify_code.json",
              width: 150,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: AppTheme.getRoundedRectangleInputDecoration(
                prefixIcon: const Icon(Icons.code),
                labelText: "驗證碼",
              ),
              onChanged: (text) {
                setState(() {
                  _code = text;
                });
              },
              validator: (text) {
                return (text == null || text.isEmpty) ? "請輸入驗證碼" : null;
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              fixedSize: const Size(100, 40),
            ),
            onPressed: () {
              if(_validateFormKey.currentState!.validate()) {
                _validate();
              }
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }

  Widget _successScreen() {
    return Lottie.asset(
      "assets/lotties/success.json",
      width: 100,
      height: 100,
      repeat: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("註冊帳號"),
        backgroundColor: AppTheme.veryLightOrange,
        actions: [
          TextButton(
            child: const Text(
              "輸入驗證碼",
              style: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
            onPressed: () {
              setState(() {
                _currentScreen = 3;
              });
              _animateSwitchScreen();
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.veryLightOrange,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: null,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: _topSwitchScreenBar(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ExpandablePageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _inputInformationScreen(),
                    _inputPasswordScreen(),
                    _sendScreen(),
                    _validateScreen(),
                    _successScreen(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}