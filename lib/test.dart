import 'package:flutter/cupertino.dart';

var info = [1, 2, 3, 4, 5, 5];


void main(){
  info.add(7);
  print('$info');
  info = [9, 10];

  info.add(8);
  print('$info');

}

