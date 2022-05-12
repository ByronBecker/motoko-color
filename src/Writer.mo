/// The Writer module
///
/// This module contains the Writer function, which allows for the
/// customization of text styling in the terminal.
///
/// ```motoko
/// import Writer "mo:color/Writer";
/// import TextStyle "mo:color/TextStyle";
///
/// let { backgroundColor; textColor } = TextStyle;
///
/// let writer = Writer.Writer();
///
/// writer
/// .text("hello world")
/// .textColor(textColor.black)
/// .backgroundColor(backgroundColor.white)
/// .bold(true)
/// .print();
/// ```
import Text "mo:base/Text";
import TextStyle "./TextStyle";
import Debug "mo:base/Debug";
import Nat8 "mo:base/Nat8";
import Bool "mo:base/Bool";
import Result "mo:base/Result";

import Hex "mo:encoding/Hex";

module {
  /// All of the text styles that can be manipulated
  public type TextSettings = {
    text: Text;
    textColor: Text;
    backgroundColor: Text;
    bold: Text;
    italicize: Text;
    underline: Text;
  };

  /// Object type that the Writer() function produces, contains all
  /// setter and read/print methods, and holds the internal settings
  /// state. 
  ///
  /// This state is currently not directly readable, but can
  /// be manipulated via setter methods like `text()`, `textColor()`,
  /// `italicize()`, etc.
  ///
  /// Note: Nested function signatures are currently not picked up by mo-doc, so the below is
  /// a more spaced out, readable version of the API
  ///
  /// Setter methods:
  /// 
  /// `textColor: (color: Text) -> TextStyleFunctor;`  
  /// 
  /// `textColorRGB: (r: Nat8, g: Nat8, b: Nat8) -> TextStyleFunctor;`  
  /// 
  /// `textColorHex: (hex: Text) -> TextStyleFunctor;`  
  /// 
  /// `backgroundColor: (color: Text) -> TextStyleFunctor;`  
  /// 
  /// `backgroundColorRGB: (r: Nat8, g: Nat8, b: Nat8) -> TextStyleFunctor;`  
  /// 
  /// `backgroundColorHex: (hex: Text) -> TextStyleFunctor;`  
  /// 
  /// `text: (t: Text) -> TextStyleFunctor;`  
  /// 
  /// `bold: (isBold: Bool) -> TextStyleFunctor;`  
  /// 
  /// `italicize: (isItalicize: Bool) -> TextStyleFunctor;`  
  /// 
  /// `underline: (isUnderline: Bool) -> TextStyleFunctor;`  
  /// 
  ///
  /// 
  /// Accessor methods:
  /// 
  /// `read: () -> Text; // returns the formatted and styled text`  
  ///
  /// `readDebug: () -> Text; // returns the internal representation of that text: escape code + SGR styling codes + text + reset & suffix escape code`  
  ///
  /// `print: () -> () // prints the result of read() to the console` 
  /// 
  public type TextStyleFunctor = {
    textColor: (color: Text) -> TextStyleFunctor;
    textColorRGB: (r: Nat8, g: Nat8, b: Nat8) -> TextStyleFunctor;
    textColorHex: (hex: Text) -> TextStyleFunctor;
    backgroundColor: (color: Text) -> TextStyleFunctor;
    backgroundColorRGB: (r: Nat8, g: Nat8, b: Nat8) -> TextStyleFunctor;
    backgroundColorHex: (hex: Text) -> TextStyleFunctor;
    text: (t: Text) -> TextStyleFunctor;
    bold: (isBold: Bool) -> TextStyleFunctor;
    italicize: (isItalicize: Bool) -> TextStyleFunctor;
    underline: (isUnderline: Bool) -> TextStyleFunctor;
    read: () -> Text;
    readDebug: () -> Text;
    print: () -> ();
  };

  let defaultSettings = {
    text = "";
    textColor = TextStyle.textColor.white;
    backgroundColor = TextStyle.backgroundColor.transparent;
    bold = "";
    italicize = "";
    underline = "";
  };

  public func Writer(): TextStyleFunctor {
    return functor(defaultSettings);
  };

  public func functor(newSettings: TextSettings): TextStyleFunctor {
    func toRGBText(r: Nat8, g: Nat8, b: Nat8): Text {
      ";" # Nat8.toText(r) 
      # ";" # Nat8.toText(g)
      # ";" # Nat8.toText(b); 
    };

    func hexToRGB(hex: Text): ?(Nat8, Nat8, Nat8) {
      let h = Text.trimStart(hex, #char '#');

      switch (Hex.decode(h)){
        case (#ok(bytes)){ 
          if (bytes.size() == 3){
            ?(bytes[0], bytes[1], bytes[2]) 
          }else{
            null
          };
        };
        case (_){ null };
      }
    };

    object {
      let settings = newSettings;

      public func textColor(color: Text): TextStyleFunctor { 
        return functor({
          textColor = color;
          backgroundColor = settings.backgroundColor;
          text = settings.text;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      public func textColorRGB(r: Nat8, g: Nat8, b: Nat8): TextStyleFunctor { 
        return functor({
          textColor = TextStyle.foregroundRGBPrefix # toRGBText(r,g,b);
          backgroundColor = settings.backgroundColor;
          text = settings.text;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      public func textColorHex(hex: Text): TextStyleFunctor { 
        switch (hexToRGB(hex)){
          case (?(r,g,b)){ textColorRGB(r, g, b) };
          case (_){ functor(settings) }; // ignores method if hex is invalid
        };
      };

      public func backgroundColor(color: Text): TextStyleFunctor { 
        return functor({
          textColor = settings.textColor;
          backgroundColor = 
            if (color == TextStyle.backgroundColor.transparent) { color }
            else { ";" # color };
          text = settings.text;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      public func backgroundColorRGB(r: Nat8, g: Nat8, b: Nat8): TextStyleFunctor { 
        return functor({
          textColor = settings.textColor;
          backgroundColor = TextStyle.backgroundRGBPrefix # toRGBText(r,g,b);
          text = settings.text;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      public func backgroundColorHex(hex: Text): TextStyleFunctor { 
        switch (hexToRGB(hex)){
          case (?(r,g,b)){ backgroundColorRGB(r, g, b) };
          case (_){ functor(settings) }; 
        };
      };

      public func bold(isBold: Bool): TextStyleFunctor {
        return functor({
          textColor = settings.textColor;
          backgroundColor = settings.backgroundColor;
          text = settings.text;
          bold = if (isBold) TextStyle.bold else "";
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      public func italicize(isItalicize: Bool): TextStyleFunctor {
        return functor({
          textColor = settings.textColor;
          backgroundColor = settings.backgroundColor;
          text = settings.text;
          bold = settings.bold;
          italicize = if (isItalicize) TextStyle.italicize else "";
          underline = settings.underline;
        })
      };

      public func underline(isUnderline: Bool): TextStyleFunctor {
        return functor({
          textColor = settings.textColor;
          backgroundColor = settings.backgroundColor;
          text = settings.text;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = if (isUnderline) TextStyle.underline else "";
        })
      };

      public func text(t: Text): TextStyleFunctor {
        return functor({
          textColor = settings.textColor;
          backgroundColor = settings.backgroundColor;
          text = t;
          bold = settings.bold;
          italicize = settings.italicize;
          underline = settings.underline;
        })
      };

      func readTextSettings(): Text {
        return settings.textColor   // text color 8 or rgb 
        # settings.backgroundColor  // background text color 7 or rgb
        # settings.bold             // SGR bold
        # settings.italicize        // SGR italics
        # settings.underline        // SGR underline
        # "m"                       // Final byte, signals end of SGR sequence
        # settings.text;            // text
      };

      public func read(): Text {
        return "\1b["               // escape code
        # readTextSettings()
        # "\1b[0m";                 // resets SGR settings
      };

      public func readDebug(): Text {
        return "\\1b["
        # readTextSettings()
        # "\\1b[0m";
      };

      public func print(): () {
        Debug.print(read());
      };
    }
  }
}