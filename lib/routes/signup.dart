import 'package:fl_fan/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'Feed.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  AuthService ath = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String name = "";
  String surname = "";
  String _message = "";

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      if (event == null) {
        print('User is signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  bool x = true;
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double screenWidth;
    double screenHeight;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _auth.authStateChanges().listen((event) {
      if (event == null) {
        setState(() {
          x = true;
        });
      } else {
        setState(() {
          x = false;
        });
      }
    });
    if (x) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/football.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight / 24,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth / 4, right: screenWidth / 4),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight / 12,
                          ),
                          const Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              if (value != null) {
                                name = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              prefixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your name: ',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Surname',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            onSaved: (value) {
                              if (value != null) {
                                surname = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 10.0),
                              prefixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your surname: ',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Email field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Please enter email!';
                                }
                                if (!EmailValidator.validate(trimmedValue)) {
                                  return 'Please enter a valid email!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                email = value;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 10.0),
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your email: ',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Password field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Password field can not be empty!';
                                }
                                if (trimmedValue.length < 8) {
                                  return 'Password must be longer than 8 characters!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                password = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    30.0,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 10,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your password: ',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Password Again',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null) {
                                return 'Password field can not be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty) {
                                  return 'Password field can not be empty!';
                                }
                                if (trimmedValue.length < 8) {
                                  return 'Password must be longer than 8 characters!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                password = value;
                              }
                            },
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white70),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    30.0,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 10,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your password again: ',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight / 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: screenWidth / 5,
                                height: screenHeight / 24,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      ath.signUpUser(name, email, password);
                                    }
                                  },
                                  child: Text('Done'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    fixedSize: Size(
                                        screenWidth / 4, screenHeight / 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth / 5,
                                height: screenHeight / 24,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'welcome');
                                  },
                                  child: Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    fixedSize: Size(
                                        screenWidth / 4, screenHeight / 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Feed(analytics: widget.analytics, observer: widget.observer);
    }
  }
}



/*
Column(
                          children: [
                            SizedBox(
                              height: screenHeight / 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight / 10,
                            ),
                            SizedBox(
                              height: screenHeight / 8,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Name',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(
                                    height: screenHeight / 8,
                                  ),
                                  TextFormField(
                                    onSaved: (value) {
                                      if (value != null) {
                                        name = value;
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(top: 10.0),
                                      prefixIcon: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.white70,
                                      ),
                                      hintText: 'Enter your name: ',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    'Surname',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    onSaved: (value) {
                                      if (value != null) {
                                        surname = value;
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(top: 10.0),
                                      prefixIcon: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.white70,
                                      ),
                                      hintText: 'Enter your surname: ',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Email field can not be empty!';
                                      } else {
                                        String trimmedValue = value.trim();
                                        if (trimmedValue.isEmpty) {
                                          return 'Please enter email!';
                                        }
                                        if (!EmailValidator.validate(
                                            trimmedValue)) {
                                          return 'Please enter a valid email!';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value != null) {
                                        email = value;
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(top: 10.0),
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Colors.white70,
                                      ),
                                      hintText: 'Enter your email: ',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Text(
                                    'Password',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Password field can not be empty!';
                                      } else {
                                        String trimmedValue = value.trim();
                                        if (trimmedValue.isEmpty) {
                                          return 'Password field can not be empty!';
                                        }
                                        if (trimmedValue.length < 8) {
                                          return 'Password must be longer than 8 characters!';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value != null) {
                                        password = value;
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            30.0,
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white70,
                                      ),
                                      hintText: 'Enter your password: ',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Password Again',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white70),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.only(top: 10),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white70,
                                      ),
                                      hintText: 'Enter your password again: ',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20.0,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            color: Color(0xFF527DAA),
                                            letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white70),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                          }
                                          signUpUser();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text('- OR -',
                                            style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 5.0),
                                        Text(
                                          'Sing Up with',
                                          //style: kLabelLightTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () =>
                                            print('Sing Up with Facebook'),
                                        child: Container(
                                          height: 40.0,
                                          width: 60.0,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                // BoxShadow(
                                                //   color: AppColors.shadow,
                                                //   offset: Offset(
                                                //       0, Dimensions.offset),
                                                //   blurRadius: 6.0,
                                                // ),
                                              ],
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/fb.jpeg'))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            print('Sing Up with Google'),
                                        child: Container(
                                          height: 40.0,
                                          width: 60.0,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                // BoxShadow(
                                                //   color: AppColors.shadow,
                                                //   offset: Offset(
                                                //       0, Dimensions.offset),
                                                //   blurRadius: 6.0,
                                                // ),
                                              ],
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/ggl.jpeg'))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            color: Color(0xFF527DAA),
                                            letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white12),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/WelcomePage.dart');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
*/