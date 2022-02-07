

import Writer "mo:color/Writer";
import TextStyle "mo:color/TextStyle";
import Debug "mo:base/Debug";

let { backgroundColor; textColor } = TextStyle;

let writer = Writer.Writer().text("Hello world!");

writer
  .textColor(textColor.black)
  .backgroundColor(backgroundColor.white)
  .bold(true)
  .print();
writer
  .textColor(textColor.red)
  .backgroundColor(backgroundColor.white)
  .bold(true)
  .print();
writer
  .textColor(textColor.lightblue)
  .backgroundColor(backgroundColor.green)
  .italicize(true)
  .print();
writer
  .textColor(textColor.yellow)
  .backgroundColor(backgroundColor.purple)
  .bold(true)
  .print();
writer
  .textColor(textColor.blue)
  .backgroundColor(backgroundColor.white)
  .bold(true)
  .underline(true)
  .print();
writer
  .textColor(textColor.yellow)
  .backgroundColor(backgroundColor.red)
  .bold(true)
  .underline(true)
  .italicize(true)
  .print();

Debug.print(
  writer
    .text("✓")
    .textColor(textColor.green)
    .bold(true)
    .read()
  # " " #
  writer
    .text("All systems go!")
    .bold(true)
    .read()
);