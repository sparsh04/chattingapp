import 'package:chattingapp/services/databse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "dart:core";

class FeedbackSlider extends StatefulWidget {
  const FeedbackSlider({Key? key}) : super(key: key);

  @override
  _FeedbackSliderState createState() => _FeedbackSliderState();
}

class _FeedbackSliderState extends State<FeedbackSlider> {
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = Colors.red;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  submitFeedbackreport() {
    Map<String, dynamic> feedbackmap = {
      "sendBy": _auth.currentUser!.displayName,
      "feedback": sliderValue
    };

    DatabaseMethods().submittheFeedback(_auth.currentUser!.uid, feedbackmap);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            myFeedbackText,
            style: const TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            myFeedback,
            color: myFeedbackColor,
            size: 100.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slider(
            min: 0.0,
            max: 5.0,
            divisions: 5,
            value: sliderValue,
            activeColor: const Color(0xffff520d),
            inactiveColor: Colors.blueGrey,
            onChanged: (newValue) {
              setState(() {
                sliderValue = newValue;
                if (sliderValue >= 0.0 && sliderValue <= 1.0) {
                  myFeedback = FontAwesomeIcons.sadTear;
                  myFeedbackColor = Colors.red;
                  myFeedbackText = "COULD BE BETTER";
                }
                if (sliderValue >= 1.1 && sliderValue <= 2.0) {
                  myFeedback = FontAwesomeIcons.frown;
                  myFeedbackColor = Colors.yellow;
                  myFeedbackText = "BELOW AVERAGE";
                }
                if (sliderValue >= 2.1 && sliderValue <= 3.0) {
                  myFeedback = FontAwesomeIcons.meh;
                  myFeedbackColor = Colors.amber;
                  myFeedbackText = "NORMAL";
                }
                if (sliderValue >= 3.1 && sliderValue <= 4.0) {
                  myFeedback = FontAwesomeIcons.smile;
                  myFeedbackColor = Colors.green;
                  myFeedbackText = "GOOD";
                }
                if (sliderValue >= 4.1 && sliderValue <= 5.0) {
                  myFeedback = FontAwesomeIcons.laugh;
                  myFeedbackColor = const Color(0xffff520d);
                  myFeedbackText = "EXCELLENT";
                }
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Your Rating: $sliderValue",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xffff520d),
                    ),
                    // "0xffff520d",

                    // color: Color(0xffff520d),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                    onPressed: () {
                      submitFeedbackreport();
                      final snackBar = SnackBar(
                        content: const Text('Feedback Submitted'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
