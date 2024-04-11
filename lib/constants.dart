import 'package:flutter/material.dart';

const Color children_light = Color.fromRGBO(234, 210, 129, 1);
const Color children = Color.fromRGBO(226, 201, 102, 1);
const Color children_dark = Color.fromRGBO(199, 171, 93, 1);
const Color sky_light = Color.fromRGBO(179, 229, 254, 1);
const Color sky_deep = Color.fromRGBO(132, 208, 255, 1);
const Color mountain = Color.fromRGBO(142, 185, 29, 1);

const kSmallText = TextStyle(
  color: Colors.white,
  fontFamily: "Dongle",
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);
const kTitleDecoration = TextStyle(
  color: children_light,
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);
const kLogoDecoration = TextStyle(
  color: children_light,
  fontWeight: FontWeight.bold,
  fontSize: 60.0,
);

const kTextFieldDecoration = InputDecoration(
  hintText: '이메일을 입력하세요',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: children, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: children, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

const kPostTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: children, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: children, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);
