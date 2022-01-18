
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

Color backgroundColor = Color.fromRGBO(0, 78, 0, 800);
Color colorAbove = Colors.yellow;
Color colorTooHigh = Color(0xFF65000b);


int limit = 35;

int speed = 0;

int count = 0;

final player = AudioCache();


void changeColor(speedValue){
  if(speedValue <= limit){
    backgroundColor = Color.fromRGBO(0, 78, 0, 800);

  }
  else if (speedValue > limit && speedValue < limit+10){
    backgroundColor = Colors.yellow;
    // player.loop('note1.wav',);
    // player.loop('assets_note5.wav');
  }
  else{
    backgroundColor = Color(0xFF65000b);
    // player.clearAll();
    // player.loop('note1.wav',
    // volume: 3);
    // player.loop('assets_note5.wav',
    // volume: 3);
  }
}