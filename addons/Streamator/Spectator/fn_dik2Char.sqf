#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:


    Parameter(s):
    None

    Returns:
    None
*/
params ["_dik", "_shift"];

private _char = toLower call compile keyName _dik;
DUMP("Pressed Char: " + _char + " " + str toArray _char + " " + str (count (toArray _char)));
if ((count (toArray _char)) != 1) then {
    _char = "";
};
/*
private _char = switch (_dik) do {
    case DIK_A: {"a"};
    case DIK_B: {"b"};
    case DIK_C: {"c"};
    case DIK_D: {"d"};
    case DIK_E: {"e"};
    case DIK_F: {"f"};
    case DIK_G: {"g"};
    case DIK_H: {"h"};
    case DIK_I: {"i"};
    case DIK_J: {"j"};
    case DIK_K: {"k"};
    case DIK_L: {"l"};
    case DIK_M: {"m"};
    case DIK_N: {"n"};
    case DIK_O: {"o"};
    case DIK_P: {"p"};
    case DIK_Q: {"q"};
    case DIK_R: {"r"};
    case DIK_S: {"s"};
    case DIK_T: {"t"};
    case DIK_U: {"u"};
    case DIK_V: {"v"};
    case DIK_W: {"w"};
    case DIK_X: {"x"};
    case DIK_Y: {"y"};
    case DIK_Z: {"z"};
    case DIK_SPACE: {" "};
    case DIK_NUMPAD0;
    case DIK_0: {"0"};
    case DIK_NUMPAD1;
    case DIK_1: {"1"};
    case DIK_NUMPAD2;
    case DIK_2: {"2"};
    case DIK_NUMPAD3;
    case DIK_3: {"3"};
    case DIK_NUMPAD4;
    case DIK_4: {"4"};
    case DIK_NUMPAD5;
    case DIK_5: {"5"};
    case DIK_NUMPAD6;
    case DIK_6: {"6"};
    case DIK_NUMPAD7;
    case DIK_7: {"7"};
    case DIK_NUMPAD8;
    case DIK_8: {"8"};
    case DIK_NUMPAD9;
    case DIK_9: {"9"};
    case DIK_UNDERLINE: {"_"};
    case DIK_SLASH: {"/"};
    case DIK_BACKSLASH: {"\"};
    case DIK_COMMA: {","};
    case DIK_SEMICOLON: {";"};
    case DIK_MINUS: {"-"};
    default {""};
};
*/
[_char, toUpper _char] select _shift;
