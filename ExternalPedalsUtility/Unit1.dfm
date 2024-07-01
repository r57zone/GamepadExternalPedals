object Main: TMain
  Left = 192
  Top = 125
  AlphaBlend = True
  AlphaBlendValue = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'External Pedals Utility'
  ClientHeight = 145
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TimerIntervalLbl: TLabel
    Left = 169
    Top = 117
    Width = 75
    Height = 13
    Caption = 'TimerIntervalLbl'
    Visible = False
  end
  object StatusLbl: TLabel
    Left = 8
    Top = 8
    Width = 148
    Height = 13
    Caption = 'External Pedals: not connected'
  end
  object PedalsPressedLbl: TLabel
    Left = 8
    Top = 32
    Width = 81
    Height = 13
    Caption = 'Pedals pressed: -'
  end
  object LeftPedalKeyLbl: TLabel
    Left = 8
    Top = 56
    Width = 70
    Height = 13
    Caption = 'Left pedal key:'
  end
  object RightPedalKeyLbl: TLabel
    Left = 168
    Top = 56
    Width = 77
    Height = 13
    Caption = 'Right pedal key:'
  end
  object LeftPedalKeyCB: TComboBox
    Left = 8
    Top = 80
    Width = 153
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'NONE'
    OnChange = LeftPedalKeyCBChange
    Items.Strings = (
      'NONE'
      'MOUSE-LEFT-CLICK'
      'MOUSE-RIGHT-CLICK'
      'MOUSE-MIDDLE-CLICK'
      'MOUSE-WHEEL-UP'
      'MOUSE-WHEEL-DOWN'
      'ESCAPE'
      'F1'
      'F2'
      'F3'
      'F4'
      'F5'
      'F6'
      'F7'
      'F8'
      'F9'
      'F10'
      'F11'
      'F12'
      '~'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '0'
      '-'
      '='
      'TAB'
      'CAPS-LOCK'
      'SHIFT'
      'CTRL'
      'WIN'
      'ALT'
      'SPACE'
      'ENTER'
      'BACKSPACE'
      'Q'
      'W'
      'E'
      'R'
      'T'
      'Y'
      'U'
      'I'
      'O'
      'P'
      '['
      ']'
      'A'
      'S'
      'D'
      'F'
      'G'
      'H'
      'J'
      'K'
      'L'
      ':'
      'APOSTROPHE'
      '\'
      'Z'
      'X'
      'C'
      'V'
      'B'
      'N'
      'M'
      '<'
      '>'
      '?'
      'PRINTSCREEN'
      'SCROLL-LOCK'
      'PAUSE'
      'INSERT'
      'HOME'
      'PAGE-UP'
      'DELETE'
      'END'
      'PAGE-DOWN'
      'UP'
      'DOWN'
      'LEFT'
      'RIGHT'
      'NUM-LOCK'
      'NUMPAD0'
      'NUMPAD1'
      'NUMPAD2'
      'NUMPAD3'
      'NUMPAD4'
      'NUMPAD5'
      'NUMPAD6'
      'NUMPAD7'
      'NUMPAD8'
      'NUMPAD9'
      'NUMPAD-DIVIDE'
      'NUMPAD-MULTIPLY'
      'NUMPAD-MINUS'
      'NUMPAD-PLUS'
      'NUMPAD-DEL'
      'VOLUME-UP'
      'VOLUME-DOWN'
      'VOLUME-MUTE'
      'HIDE-APPS'
      'SWITCH-APP'
      'DISPLAY-KEYBOARD'
      'GAMEBAR'
      'GAMEBAR-SCREENSHOT'
      'FULLSCREEN'
      'FULLSCREEN-PLUS'
      'CHANGE-LANGUAGE'
      'CUT'
      'COPY'
      'PASTE')
  end
  object RightPedalKeyCB: TComboBox
    Left = 169
    Top = 80
    Width = 153
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'NONE'
    OnChange = RightPedalKeyCBChange
    Items.Strings = (
      'NONE'
      'MOUSE-LEFT-CLICK'
      'MOUSE-RIGHT-CLICK'
      'MOUSE-MIDDLE-CLICK'
      'MOUSE-WHEEL-UP'
      'MOUSE-WHEEL-DOWN'
      'ESCAPE'
      'F1'
      'F2'
      'F3'
      'F4'
      'F5'
      'F6'
      'F7'
      'F8'
      'F9'
      'F10'
      'F11'
      'F12'
      '~'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '0'
      '-'
      '='
      'TAB'
      'CAPS-LOCK'
      'SHIFT'
      'CTRL'
      'WIN'
      'ALT'
      'SPACE'
      'ENTER'
      'BACKSPACE'
      'Q'
      'W'
      'E'
      'R'
      'T'
      'Y'
      'U'
      'I'
      'O'
      'P'
      '['
      ']'
      'A'
      'S'
      'D'
      'F'
      'G'
      'H'
      'J'
      'K'
      'L'
      ':'
      'APOSTROPHE'
      '\'
      'Z'
      'X'
      'C'
      'V'
      'B'
      'N'
      'M'
      '<'
      '>'
      '?'
      'PRINTSCREEN'
      'SCROLL-LOCK'
      'PAUSE'
      'INSERT'
      'HOME'
      'PAGE-UP'
      'DELETE'
      'END'
      'PAGE-DOWN'
      'UP'
      'DOWN'
      'LEFT'
      'RIGHT'
      'NUM-LOCK'
      'NUMPAD0'
      'NUMPAD1'
      'NUMPAD2'
      'NUMPAD3'
      'NUMPAD4'
      'NUMPAD5'
      'NUMPAD6'
      'NUMPAD7'
      'NUMPAD8'
      'NUMPAD9'
      'NUMPAD-DIVIDE'
      'NUMPAD-MULTIPLY'
      'NUMPAD-MINUS'
      'NUMPAD-PLUS'
      'NUMPAD-DEL'
      'VOLUME-UP'
      'VOLUME-DOWN'
      'VOLUME-MUTE'
      'HIDE-APPS'
      'SWITCH-APP'
      'DISPLAY-KEYBOARD'
      'GAMEBAR'
      'GAMEBAR-SCREENSHOT'
      'FULLSCREEN'
      'FULLSCREEN-PLUS'
      'CHANGE-LANGUAGE'
      'CUT'
      'COPY'
      'PASTE')
  end
  object CloseBtn2: TButton
    Left = 7
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = CloseBtn2Click
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 256
    Top = 8
  end
  object XPManifest1: TXPManifest
    Left = 224
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Left = 288
    Top = 8
    object ShownBtn: TMenuItem
      Caption = 'Show'
      OnClick = ShownBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AboutBtn: TMenuItem
      Caption = 'About...'
      OnClick = AboutBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CloseBtn: TMenuItem
      Caption = 'Close'
      OnClick = CloseBtnClick
    end
  end
end
