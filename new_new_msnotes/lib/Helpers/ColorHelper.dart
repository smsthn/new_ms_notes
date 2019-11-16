


import 'package:flutter/material.dart';

Color getPrimColor(int colorIndex){
  switch(colorIndex){
    case 1:return Colors.pink;
    case 2:return Colors.red;
    case 3:return Colors.orange;
    case 4:return Colors.yellow;
    case 5:return Colors.lime;
    case 6:return Colors.green;
    case 7:return Colors.teal;
    case 8:return Colors.cyan;
    case 9:return Colors.blue;
    case 10:return Colors.indigo;
    case 11:return Colors.purple;
    case 12:return Colors.deepPurple;
    case 13:return Colors.blueGrey;
    case 14:return Colors.brown;
    case 15:return Colors.grey;
    case 16:return Colors.black;
    default:return Colors.white;
  }
}
Color getTextColor(int colorIndex){
  return (colorIndex < 17 && colorIndex > 9)?Colors.white:Colors.black;
}
Color getColorDegree(int colorIndex,int degree){
  switch(colorIndex){
    case 1:return Colors.pink[degree];
    case 2:return Colors.red[degree];
    case 3:return Colors.orange[degree];
    case 4:return Colors.yellow[degree];
    case 5:return Colors.lime[degree];
    case 6:return Colors.green[degree];
    case 7:return Colors.teal[degree];
    case 8:return Colors.cyan[degree];
    case 9:return Colors.blue[degree];
    case 10:return Colors.indigo[degree];
    case 11:return Colors.purple[degree];
    case 12:return Colors.deepPurple[degree];
    case 13:return Colors.blueGrey[degree];
    case 14:return Colors.brown[degree];
    case 15:return Colors.grey[degree];
    case 16:return Colors.black;
    default:return Colors.white;
  }
}
Color getColorAccent(int colorIndex){
  switch(colorIndex){
    case 1:return Colors.pinkAccent;
    case 2:return Colors.redAccent;
    case 3:return Colors.orangeAccent;
    case 4:return Colors.yellowAccent;
    case 5:return Colors.limeAccent;
    case 6:return Colors.greenAccent;
    case 7:return Colors.tealAccent;
    case 8:return Colors.cyanAccent;
    case 9:return Colors.blueAccent;
    case 10:return Colors.indigoAccent;
    case 11:return Colors.purpleAccent;
    case 12:return Colors.deepPurpleAccent;
    case 13:return Colors.blueGrey;
    case 14:return Colors.brown;
    case 15:return Colors.grey;
    case 16:return Colors.black;
    default:return Colors.white;
  }
}
Color getColorAccentDegree(int colorIndex,int degree){
  switch(colorIndex){
    case 1:return Colors.pinkAccent[degree];
    case 2:return Colors.redAccent[degree];
    case 3:return Colors.orangeAccent[degree];
    case 4:return Colors.yellowAccent[degree];
    case 5:return Colors.limeAccent[degree];
    case 6:return Colors.greenAccent[degree];
    case 7:return Colors.tealAccent[degree];
    case 8:return Colors.cyanAccent[degree];
    case 9:return Colors.blueAccent[degree];
    case 10:return Colors.indigoAccent[degree];
    case 11:return Colors.purpleAccent[degree];
    case 12:return Colors.deepPurpleAccent[degree];
    case 13:return Colors.blueGrey[degree];
    case 14:return Colors.brown[degree];
    case 15:return Colors.grey[degree];
    case 16:return Colors.black;
    default:return Colors.white;
  }
}
Color getLightColor(int colorIndex){
  if(colorIndex < 1 || colorIndex >14 ){
  return Colors.grey[600];
  }
  return getColorDegree(colorIndex, 100);
}
Color getDarkColor(int colorIndex){
  if(colorIndex < 1 || colorIndex >16 ){
    return Colors.grey[600];
  }
  if(colorIndex == 16)
    return Colors.grey[900];
  return getColorDegree(colorIndex, 900);
}
Color getTransparentColor(int colorIndex){
  return getLightColor(colorIndex).withOpacity(0.5);
}