import Debug "mo:base/Debug";
import M "mo:matchers/Matchers";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";
import WriterImports "../src/Writer";
import TextStyle "../src/TextStyle";

let {run;test;suite} = S;
let { Writer } = WriterImports;
let { backgroundColor; textColor } = TextStyle;

Debug.print("Running Writer features tests...");
run(suite("Writer features",
  [
    test(
      "after initialization, read() defaults the empty string with white textColor",
      Writer().read(),
      M.equals(T.text("\1b[" # textColor.white # "m\1b[0m"))
    ),
    test(
      "initialization provides an escape sequence with transparent color",
      Writer().readDebug(),
      M.equals(T.text("\\1b[37m\\1b[0m"))
    ),
    test(
      "text can be set",
      Writer()
        .text("Hello, world!")
        .read(),
      M.equals(T.text("\1b[37mHello, world!\1b[0m"))
    ),
    test(
      "textColor can be set",
      Writer()
        .text("red text")
        .textColor(textColor.red)
        .read(),
      M.equals(T.text("\1b[31mred text\1b[0m"))
    ),
    test(
      "textColor can be set with rgb",
      Writer()
        .text("rgb text")
        .textColorRGB(20, 40, 60)
        .read(),
      M.equals(T.text("\1b[38;2;20;40;60mrgb text\1b[0m"))
    ),
    test(
      "backgroundColor can be set",
      Writer()
        .text("blue bg")
        .backgroundColor(backgroundColor.blue)
        .read(),
      M.equals(T.text("\1b[37;44mblue bg\1b[0m"))
    ),
    test(
      "backgroundColor can be set with rgb",
      Writer()
        .text("rgb bg")
        .backgroundColorRGB(20, 40, 60)
        .read(),
      M.equals(T.text("\1b[37;48;2;20;40;60mrgb bg\1b[0m"))
    ),
    test(
      "can set bold text",
      Writer()
        .text("bold me")
        .bold(true)
        .read(),
      M.equals(T.text("\1b[37;1mbold me\1b[0m"))
    ),
    test(
      "can set italicized text",
      Writer()
        .text("italicize me")
        .italicize(true)
        .read(),
      M.equals(T.text("\1b[37;3mitalicize me\1b[0m"))
    ),
    test(
      "can set underlined text",
      Writer()
        .text("underline me")
        .underline(true)
        .read(),
      M.equals(T.text("\1b[37;4munderline me\1b[0m"))
    )
  ]
));

func testImmutability(t: Text): Text {
  let w1 = Writer()
    .text(t)
    .textColor(textColor.red);
  let w2 = w1.textColor(textColor.purple);
  return w1.read();
};

Debug.print("Running Writer composition tests...");
run(suite("Writer composition",
  [
    test(
      "by generating a new text style functor each time, can generate different text style " #
      "settings without overwriting previous ones",
      testImmutability("I'm a functor!"),
      M.equals(T.text("\1b[31mI'm a functor!\1b[0m"))
    ),
    test(
      "last applied style wins",      
      Writer()
        .text("last style wins")
        .textColor(textColor.red)
        .bold(true)
        .bold(false)
        .textColor(textColor.yellow)
        .read(),
      M.equals(T.text("\1b[33mlast style wins\1b[0m"))
    ),
    test(
      "all non rgb styles applied together work as expected",      
      Writer()
        .text("every non-rgb feature!")
        .textColor(textColor.red)
        .backgroundColor(backgroundColor.white)
        .bold(true)
        .italicize(true)
        .underline(true)
        .read(),
      M.equals(T.text("\1b[31;47;1;3;4mevery non-rgb feature!\1b[0m"))
    ),
    test(
      "all rgb styles applied together work as expected",      
      Writer()
        .text("every rgb feature!")
        .textColorRGB(20,40,60)
        .backgroundColorRGB(180,200,220)
        .bold(true)
        .italicize(true)
        .underline(true)
        .read(),
      M.equals(T.text("\1b[38;2;20;40;60;48;2;180;200;220;1;3;4mevery rgb feature!\1b[0m"))
    )
  ]
));