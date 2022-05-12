/// Static text stylings
///
/// This module contains static text style constants which can be passed to 
/// methods of Writer to customize text styling
import Bool "mo:base/Bool";
import HashMap "mo:base/HashMap";

module TextStyle {
  /// Record of color name to ANSI SGR background color code
  ///
  /// Available Colors:
  /// - black
  /// - red
  /// - green
  /// - yellow
  /// - blue
  /// - purple
  /// - lightblue
  /// - white
  /// - transparent
  public let backgroundColor = {
    black       = "40";
    red         = "41";
    green       = "42";
    yellow      = "43";
    blue        = "44";
    purple      = "45";
    lightblue   = "46";
    white       = "47";
    transparent = "";
  };

  /// Record of color name to ANSI SGR foreground color code
  ///
  /// Available Colors:
  /// - black
  /// - red
  /// - green
  /// - yellow
  /// - blue
  /// - purple
  /// - lightblue
  /// - white
  /// - grey 
  public let textColor = {
    black       = "30";
    red         = "31";
    green       = "32";
    yellow      = "33";
    blue        = "34";
    purple      = "35";
    lightblue   = "36";
    white       = "37";
    grey        = "38";
  };

  public let foregroundRGBPrefix  = "38;2";
  public let backgroundRGBPrefix  = ";48;2";
  public let bold                 = ";1";
  public let italicize            = ";3";
  public let underline            = ";4";
}
