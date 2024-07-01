unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MMSystem, XPMan, ComCtrls, IniFiles, Menus,
  ShellAPI;

type
  TMain = class(TForm)
    Timer: TTimer;
    XPManifest1: TXPManifest;
    TimerIntervalLbl: TLabel;
    StatusLbl: TLabel;
    PedalsPressedLbl: TLabel;
    LeftPedalKeyCB: TComboBox;
    LeftPedalKeyLbl: TLabel;
    RightPedalKeyCB: TComboBox;
    RightPedalKeyLbl: TLabel;
    PopupMenu: TPopupMenu;
    AboutBtn: TMenuItem;
    N2: TMenuItem;
    CloseBtn: TMenuItem;
    CloseBtn2: TButton;
    ShownBtn: TMenuItem;
    N1: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LeftPedalKeyCBChange(Sender: TObject);
    procedure RightPedalKeyCBChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseBtn2Click(Sender: TObject);
    procedure ShownBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure FindJoy;
    procedure DefaultHandler(var Message); override;
  public
    { Public declarations }
    procedure AppShow;
    procedure AppHide;
  protected
    procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    procedure WMActivate(var Msg: TMessage); message WM_ACTIVATE;
  end;

type
  TJoyButton = record
	  PressedOnce: boolean;
	  UnpressedOnce: boolean;
    KeyCode: integer;
  end;

var
  Main: TMain;
  WM_TASKBARCREATED: Cardinal;
  RunOnce: boolean;
  AllowClose: boolean = false;

  MyJoy: TJoyInfo;
  JoyButtons: array[1..2] of TJoyButton;
  JoyIndex: integer;
  PedalsConnected: boolean;
  ExternalPedalsJoyInfo: JOYINFOEX;
	ExternalPedalsJoyCaps: JOYCAPS;
  TimerChanged: boolean = false;

  KeysChanged: boolean = false;

  // Перевод
  IDS_PEDALS_CONNECTED, IDS_NOT_CONNECTED, IDS_PEDALS_PRESSED, IDS_LEFT_PEDAL, IDS_RIGHT_PEDAL: string;
  IDS_ABOUT_TITLE, IDS_LAST_UPDATE: string;

const
  VK_MOUSE_LEFT_CLICK = 501;
  VK_MOUSE_MIDDLE_CLICK = 502;
  VK_MOUSE_RIGHT_CLICK = 503;
  VK_MOUSE_WHEEL_UP = 504;
  VK_MOUSE_WHEEL_DOWN = 505;
  VK_VOLUME_DOWN2 = 174; // VK_VOLUME_DOWN - already exists
  VK_VOLUME_UP2 = 175;
  VK_VOLUME_MUTE2 = 173;
  VK_HIDE_APPS = 506;
  VK_SWITCH_APP = 507;
  VK_DISPLAY_KEYBOARD = 508;
  VK_GAMEBAR = 509;
  VK_GAMEBAR_SCREENSHOT = 510;
  VK_STEAM_SCREENSHOT = 511;
  VK_MULTI_SCREENSHOT = 512;
  VK_FULLSCREEN = 513;
  VK_FULLSCREEN_PLUS = 514;
  VK_CHANGE_LANGUAGE = 515;
  VK_CUT = 516;
  VK_COPY = 517;
  VK_PASTE = 518;

implementation

{$R *.dfm}

function KeyNameToKeyCode(KeyName: string): Integer;
begin
  KeyName := UpperCase(KeyName);

  if KeyName = 'NONE' then Result := 0

  else if KeyName = 'MOUSE-LEFT-CLICK' then Result := VK_MOUSE_LEFT_CLICK
  else if KeyName = 'MOUSE-RIGHT-CLICK' then Result := VK_MOUSE_RIGHT_CLICK
  else if KeyName = 'MOUSE-MIDDLE-CLICK' then Result := VK_MOUSE_MIDDLE_CLICK
  // else if KeyName = 'MOUSE-SIDE1-CLICK' then Result := VK_XBUTTON1
  // else if KeyName = 'MOUSE-SIDE2-CLICK' then Result := VK_XBUTTON2
  else if KeyName = 'MOUSE-WHEEL-UP' then Result := VK_MOUSE_WHEEL_UP
  else if KeyName = 'MOUSE-WHEEL-DOWN' then Result := VK_MOUSE_WHEEL_DOWN

  else if KeyName = 'ESCAPE' then Result := VK_ESCAPE
  else if KeyName = 'F1' then Result := VK_F1
  else if KeyName = 'F2' then Result := VK_F2
  else if KeyName = 'F3' then Result := VK_F3
  else if KeyName = 'F4' then Result := VK_F4
  else if KeyName = 'F5' then Result := VK_F5
  else if KeyName = 'F6' then Result := VK_F6
  else if KeyName = 'F7' then Result := VK_F7
  else if KeyName = 'F8' then Result := VK_F8
  else if KeyName = 'F9' then Result := VK_F9
  else if KeyName = 'F10' then Result := VK_F10
  else if KeyName = 'F11' then Result := VK_F11
  else if KeyName = 'F12' then Result := VK_F12

  else if KeyName = '~' then Result := 192 // VK_OEM_3
  else if KeyName = '1' then Result := Ord('1')
  else if KeyName = '2' then Result := Ord('2')
  else if KeyName = '3' then Result := Ord('3')
  else if KeyName = '4' then Result := Ord('4')
  else if KeyName = '5' then Result := Ord('5')
  else if KeyName = '6' then Result := Ord('6')
  else if KeyName = '7' then Result := Ord('7')
  else if KeyName = '8' then Result := Ord('8')
  else if KeyName = '9' then Result := Ord('9')
  else if KeyName = '0' then Result := Ord('0')
  else if KeyName = '-' then Result := 189
  else if KeyName = '=' then Result := 187

  else if KeyName = 'TAB' then Result := VK_TAB
  else if KeyName = 'CAPS-LOCK' then Result := VK_CAPITAL
  else if KeyName = 'SHIFT' then Result := VK_SHIFT
  else if KeyName = 'CTRL' then Result := VK_CONTROL
  else if KeyName = 'WIN' then Result := VK_LWIN
  else if KeyName = 'ALT' then Result := VK_MENU
  else if KeyName = 'SPACE' then Result := VK_SPACE
  else if KeyName = 'ENTER' then Result := VK_RETURN
  else if KeyName = 'BACKSPACE' then Result := VK_BACK

  else if KeyName = 'Q' then Result := Ord('Q')
  else if KeyName = 'W' then Result := Ord('W')
  else if KeyName = 'E' then Result := Ord('E')
  else if KeyName = 'R' then Result := Ord('R')
  else if KeyName = 'T' then Result := Ord('T')
  else if KeyName = 'Y' then Result := Ord('Y')
  else if KeyName = 'U' then Result := Ord('U')
  else if KeyName = 'I' then Result := Ord('I')
  else if KeyName = 'O' then Result := Ord('O')
  else if KeyName = 'P' then Result := Ord('P')
  else if KeyName = '[' then Result := 219 // VK_OEM_4
  else if KeyName = ']' then Result := 221 // VK_OEM_6
  else if KeyName = 'A' then Result := Ord('A')
  else if KeyName = 'S' then Result := Ord('S')
  else if KeyName = 'D' then Result := Ord('D')
  else if KeyName = 'F' then Result := Ord('F')
  else if KeyName = 'G' then Result := Ord('G')
  else if KeyName = 'H' then Result := Ord('H')
  else if KeyName = 'J' then Result := Ord('J')
  else if KeyName = 'K' then Result := Ord('K')
  else if KeyName = 'L' then Result := Ord('L')
  else if KeyName = ':' then Result := 186
  else if KeyName = 'APOSTROPHE' then Result := 222 // VK_OEM_7
  else if KeyName = '\' then Result := 220 // VK_OEM_6
  else if KeyName = 'Z' then Result := Ord('Z')
  else if KeyName = 'X' then Result := Ord('X')
  else if KeyName = 'C' then Result := Ord('C')
  else if KeyName = 'V' then Result := Ord('V')
  else if KeyName = 'B' then Result := Ord('B')
  else if KeyName = 'N' then Result := Ord('N')
  else if KeyName = 'M' then Result := Ord('M')
  else if KeyName = '<' then Result := 188
  else if KeyName = '>' then Result := 190
  else if KeyName = '?' then Result := 191 // VK_OEM_2

  else if KeyName = 'PRINTSCREEN' then Result := VK_SNAPSHOT
  else if KeyName = 'SCROLL-LOCK' then Result := VK_SCROLL
  else if KeyName = 'PAUSE' then Result := VK_PAUSE
  else if KeyName = 'INSERT' then Result := VK_INSERT
  else if KeyName = 'HOME' then Result := VK_HOME
  else if KeyName = 'PAGE-UP' then Result := VK_NEXT
  else if KeyName = 'DELETE' then Result := VK_DELETE
  else if KeyName = 'END' then Result := VK_END
  else if KeyName = 'PAGE-DOWN' then Result := VK_PRIOR

  else if KeyName = 'UP' then Result := VK_UP
  else if KeyName = 'DOWN' then Result := VK_DOWN
  else if KeyName = 'LEFT' then Result := VK_LEFT
  else if KeyName = 'RIGHT' then Result := VK_RIGHT

  else if KeyName = 'NUM-LOCK' then Result := VK_NUMLOCK
  else if KeyName = 'NUMPAD0' then Result := VK_NUMPAD0
  else if KeyName = 'NUMPAD1' then Result := VK_NUMPAD1
  else if KeyName = 'NUMPAD2' then Result := VK_NUMPAD2
  else if KeyName = 'NUMPAD3' then Result := VK_NUMPAD3
  else if KeyName = 'NUMPAD4' then Result := VK_NUMPAD4
  else if KeyName = 'NUMPAD5' then Result := VK_NUMPAD5
  else if KeyName = 'NUMPAD6' then Result := VK_NUMPAD6
  else if KeyName = 'NUMPAD7' then Result := VK_NUMPAD7
  else if KeyName = 'NUMPAD8' then Result := VK_NUMPAD8
  else if KeyName = 'NUMPAD9' then Result := VK_NUMPAD9

  else if KeyName = 'NUMPAD-DIVIDE' then Result := VK_DIVIDE
  else if KeyName = 'NUMPAD-MULTIPLY' then Result := VK_MULTIPLY
  else if KeyName = 'NUMPAD-MINUS' then Result := VK_SUBTRACT
  else if KeyName = 'NUMPAD-PLUS' then Result := VK_ADD
  else if KeyName = 'NUMPAD-DEL' then Result := VK_DECIMAL

  // Additional
  else if KeyName = 'VOLUME-UP' then Result := VK_VOLUME_UP2
  else if KeyName = 'VOLUME-DOWN' then Result := VK_VOLUME_DOWN2
  else if KeyName = 'VOLUME-MUTE' then Result := VK_VOLUME_MUTE2
  else if KeyName = 'HIDE-APPS' then Result := VK_HIDE_APPS
  else if KeyName = 'SWITCH-APP' then Result := VK_SWITCH_APP
  else if KeyName = 'DISPLAY-KEYBOARD' then Result := VK_DISPLAY_KEYBOARD
  else if KeyName = 'GAMEBAR' then Result := VK_GAMEBAR
  else if KeyName = 'GAMEBAR-SCREENSHOT' then Result := VK_GAMEBAR_SCREENSHOT
  else if KeyName = 'FULLSCREEN' then Result := VK_FULLSCREEN
  else if KeyName = 'FULLSCREEN-PLUS' then Result := VK_FULLSCREEN_PLUS
  else if KeyName = 'CHANGE-LANGUAGE' then Result := VK_CHANGE_LANGUAGE
  else if KeyName = 'CUT' then Result := VK_CUT
  else if KeyName = 'COPY' then Result := VK_COPY
  else if KeyName = 'PASTE' then Result := VK_PASTE

  else Result := 0;
end;

procedure MousePress(MouseBtn: integer; ButtonPressed: boolean; var ButtonState: TJoyButton);
begin
  if ButtonPressed then
  begin
    ButtonState.UnpressedOnce:= True;
    if not ButtonState.PressedOnce then
    begin
      if MouseBtn = VK_MOUSE_LEFT_CLICK then
        mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
      else if MouseBtn = VK_MOUSE_RIGHT_CLICK then
        mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0)
      else if MouseBtn = VK_MOUSE_MIDDLE_CLICK then
        mouse_event(MOUSEEVENTF_MIDDLEDOWN, 0, 0, 0, 0)
      else if MouseBtn = VK_MOUSE_WHEEL_UP then
        mouse_event(MOUSEEVENTF_WHEEL, 0, 0, DWORD(-120), 0)
      else if MouseBtn = VK_MOUSE_WHEEL_DOWN then
        mouse_event(MOUSEEVENTF_WHEEL, 0, 0, DWORD(120), 0);
      ButtonState.PressedOnce := True;
      //writeln('pressed');
    end;
  end
  else if (not ButtonPressed) and ButtonState.UnpressedOnce then
  begin
    //writeln('unpressed');
    if MouseBtn = VK_MOUSE_LEFT_CLICK then
      mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    else if MouseBtn = VK_MOUSE_RIGHT_CLICK then
      mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0)
    else if MouseBtn = VK_MOUSE_MIDDLE_CLICK then
      mouse_event(MOUSEEVENTF_MIDDLEUP, 0, 0, 0, 0);
    ButtonState.UnpressedOnce := False;
    ButtonState.PressedOnce := False;
  end;
end;

procedure MyKeyPress(KeyCode: integer; ButtonPressed: boolean; var ButtonState: TJoyButton);
begin
  if KeyCode = 0 then Exit

	else if (KeyCode = VK_MOUSE_LEFT_CLICK) or (KeyCode = VK_MOUSE_MIDDLE_CLICK) or (KeyCode = VK_MOUSE_RIGHT_CLICK) or
		(KeyCode = VK_MOUSE_WHEEL_UP) or (KeyCode = VK_MOUSE_WHEEL_DOWN) then // Move to mouse press
		  MousePress(KeyCode, ButtonPressed, ButtonState)

  else if ButtonPressed then begin
    ButtonState.UnpressedOnce:=true;
    if not ButtonState.PressedOnce then begin

			if KeyCode < 500 then
				keybd_event(KeyCode, $45, KEYEVENTF_EXTENDEDKEY or 0, 0)
			else if KeyCode = VK_HIDE_APPS then begin
				keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('D'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_SWITCH_APP then begin
				keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_TAB, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_DISPLAY_KEYBOARD then begin
				keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_CONTROL, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('O'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_GAMEBAR then begin
				keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('G'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if (KeyCode = VK_GAMEBAR_SCREENSHOT) or (KeyCode = VK_MULTI_SCREENSHOT) then begin
				keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_MENU, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_SNAPSHOT, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_STEAM_SCREENSHOT then
				keybd_event(VK_F12, $45, KEYEVENTF_EXTENDEDKEY or 0, 0)

			else if (KeyCode = VK_FULLSCREEN) or (KeyCode = VK_FULLSCREEN_PLUS) then begin
				keybd_event(VK_MENU, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_RETURN, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_CHANGE_LANGUAGE then begin
				keybd_event(VK_LMENU, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(VK_SHIFT, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_CUT then begin
				keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('X'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

			end else if KeyCode = VK_COPY then begin
				keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('C'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);

      end else if KeyCode = VK_PASTE then begin
				keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
				keybd_event(ord('V'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);
			end;

      ButtonState.PressedOnce:=true;
    end;
  end else if not ButtonPressed and ButtonState.UnpressedOnce then begin

		if KeyCode < 500 then
		  keybd_event(KeyCode, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0)
		else if KeyCode = VK_HIDE_APPS then begin
			keybd_event(ord('D'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);

		end else if KeyCode = VK_SWITCH_APP then begin
			keybd_event(VK_TAB, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
		
		end else if KeyCode = VK_DISPLAY_KEYBOARD then begin
			keybd_event(ord('O'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_CONTROL, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
		
		end else if KeyCode = VK_GAMEBAR then begin
			keybd_event(ord('G'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);

		end else if (KeyCode = VK_GAMEBAR_SCREENSHOT) or (KeyCode = VK_MULTI_SCREENSHOT) then begin
			keybd_event(VK_SNAPSHOT, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_MENU, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LWIN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			if KeyCode = VK_MULTI_SCREENSHOT then begin keybd_event(VK_F12, $45, KEYEVENTF_EXTENDEDKEY or 0, 0);  keybd_event(VK_F12, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0); end;

		end else if KeyCode = VK_STEAM_SCREENSHOT then
			keybd_event(VK_F12, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0)

		else if (KeyCode = VK_FULLSCREEN) or (KeyCode = VK_FULLSCREEN_PLUS) then begin
			keybd_event(VK_RETURN, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_MENU, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			if KeyCode = VK_FULLSCREEN_PLUS then begin keybd_event(ord('F'), $45, KEYEVENTF_EXTENDEDKEY or 0, 0);  keybd_event(ord('F'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0); end; // YouTube / Twitch fullscreen on F
		
		end else if KeyCode = VK_CHANGE_LANGUAGE then begin
			keybd_event(VK_SHIFT, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LMENU, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);

		end else if KeyCode = VK_CUT then begin
			keybd_event(ord('X'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);

		end else if KeyCode = VK_COPY then begin
			keybd_event(ord('C'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);

		end else if KeyCode = VK_PASTE then begin
			keybd_event(ord('V'), $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
			keybd_event(VK_LCONTROL, $45, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
		end;

    ButtonState.UnpressedOnce:=false;
		ButtonState.PressedOnce:=false;
  end;
end;

procedure TMain.TimerTimer(Sender: TObject);
var
  Buttons: string;
begin
  Buttons:='';
  PedalsConnected:=JoyGetPos(JoyIndex, @MyJoy) = JOYERR_NOERROR;

  //TimerIntervalLbl.Caption:=IntToStr(Timer.Interval);

  if PedalsConnected then begin
    StatusLbl.Caption:=IDS_PEDALS_CONNECTED;
    if TimerChanged = false then begin
      TimerChanged:=true;
      Timer.Interval:=1;
    end;
  end else begin
    StatusLbl.Caption:=IDS_NOT_CONNECTED;
    Timer.Interval:=100;
    FindJoy;
    Exit;
  end;

  TimerIntervalLbl.Caption:=IntToStr(Timer.Interval);

  MyKeyPress(JoyButtons[1].KeyCode, (MyJoy.wButtons and JOY_BUTTON1) > 0, JoyButtons[1]);
  MyKeyPress(JoyButtons[2].KeyCode, (MyJoy.wButtons and JOY_BUTTON2) > 0, JoyButtons[2]);

  if (MyJoy.wButtons and JOY_BUTTON1) > 0 then
    Buttons:=Buttons + IDS_LEFT_PEDAL + ' ';
  if (MyJoy.wButtons and JOY_BUTTON2) > 0 then
    Buttons:=Buttons + IDS_RIGHT_PEDAL + ' ';
  if Buttons = '' then
    Buttons:='-';
  PedalsPressedLbl.Caption:=IDS_PEDALS_PRESSED + ' ' + Buttons;
end;

procedure SelectComboBoxItemByText(ComboBox: TComboBox; Text: string);
var
  i: integer;
begin
  for i:=0 to ComboBox.Items.Count - 1 do
    if ComboBox.Items[i]=Text then begin
      ComboBox.ItemIndex:=i;
      break;
    end;
end;

procedure Tray(ActInd: integer);  //1 - add, 2 - update, 3 - remove
var
  NIM: TNotifyIconData;
begin
  with NIM do begin
    cbSize:=SizeOf(NIM);
    Wnd:=Main.Handle;
    uId:=1;
    uFlags:=NIF_MESSAGE or NIF_ICON or NIF_TIP;
    hIcon:=SendMessage(Application.Handle, WM_GETICON, ICON_SMALL2, 0);
    uCallBackMessage:=WM_USER + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case ActInd of
    1: Shell_NotifyIcon(NIM_ADD, @NIM);
    2: Shell_NotifyIcon(NIM_MODIFY, @NIM);
    3: Shell_NotifyIcon(NIM_DELETE, @NIM);
  end;
end;

function GetLocaleInformation(Flag: integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  i: integer; Ini: TIniFile;
begin
  Application.Title:=Caption;
  WM_TaskBarCreated:=RegisterWindowMessage('TaskbarCreated');

  IDS_PEDALS_CONNECTED:='External Pedals: connected';
  IDS_NOT_CONNECTED:='External Pedals: not connected';
  IDS_PEDALS_PRESSED:='Pedals pressed:';
  IDS_LEFT_PEDAL:='left';
  IDS_RIGHT_PEDAL:='right';
  IDS_ABOUT_TITLE:='About...';
  IDS_LAST_UPDATE:='Last update';

  if GetLocaleInformation(LOCALE_SENGLANGUAGE) = 'Russian' then begin
    IDS_PEDALS_CONNECTED:='Внешние педали: подключены';
    IDS_NOT_CONNECTED:='Внешние педали: не подключены';
    IDS_PEDALS_PRESSED:='Педали нажаты:';
    IDS_LEFT_PEDAL:='левая';
    IDS_RIGHT_PEDAL:='правая';
    IDS_ABOUT_TITLE:='О программе...';
    IDS_LAST_UPDATE:='Последнее обновление';

    PedalsPressedLbl.Caption:=IDS_PEDALS_PRESSED + ' - ';
    LeftPedalKeyLbl.Caption:='Клавиша левой педали:';
    RightPedalKeyLbl.Caption:='Клавиша правой педали:';
    ShownBtn.Caption:='Показать';
    AboutBtn.Caption:=IDS_ABOUT_TITLE;
    CloseBtn.Caption:='Выход';
    CloseBtn2.Caption:=CloseBtn.Caption;
  end;

  for i:=1 to Length(JoyButtons) - 1 do begin
    JoyButtons[i].PressedOnce:=false;
    JoyButtons[i].UnpressedOnce:=false;
  end;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');

  SelectComboBoxItemByText(LeftPedalKeyCB, Ini.ReadString('Main', 'LeftPedalKey', '1'));
  SelectComboBoxItemByText(RightPedalKeyCB, Ini.ReadString('Main', 'RightPedalKey', '2'));
  JoyButtons[1].KeyCode:=KeyNameToKeyCode(LeftPedalKeyCB.Items.Strings[LeftPedalKeyCB.ItemIndex]);
  JoyButtons[2].KeyCode:=KeyNameToKeyCode(RightPedalKeyCB.Items.Strings[RightPedalKeyCB.ItemIndex]);

  Ini.Free;

  ExternalPedalsJoyInfo.dwFlags:=JOY_RETURNALL;
	ExternalPedalsJoyInfo.dwSize:=sizeof(ExternalPedalsJoyInfo);
  FindJoy;

  AppHide;
  Tray(1);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TMain.FindJoy;
var
  i: Integer;
  MyJoy: TJoyInfoEx;
  ExternalPedalsJoyCaps: TJoyCaps;
begin
  TimerChanged:=false;
  PedalsConnected:=false;
  for i:=0 to 3 do begin
    if (JoyGetPos(i, @MyJoy) = JOYERR_NOERROR) and (JoyGetDevCaps(i, @ExternalPedalsJoyCaps, SizeOf(ExternalPedalsJoyCaps)) = JOYERR_NOERROR) and (ExternalPedalsJoyCaps.wNumButtons = 16) then begin
      JoyIndex:=i;
      PedalsConnected:=true;
      //Timer.Interval:=1;
      break;
    end;
  end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
begin
  if KeysChanged = false then Exit;
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  Ini.WriteString('Main', 'LeftPedalKey', LeftPedalKeyCB.Items.Strings[LeftPedalKeyCB.ItemIndex]);
  Ini.WriteString('Main', 'RightPedalKey', RightPedalKeyCB.Items.Strings[RightPedalKeyCB.ItemIndex]);
  Ini.Free;
end;

procedure TMain.LeftPedalKeyCBChange(Sender: TObject);
begin
  JoyButtons[1].KeyCode:=KeyNameToKeyCode(LeftPedalKeyCB.Items.Strings[LeftPedalKeyCB.ItemIndex]);
  KeysChanged:=true;
end;

procedure TMain.RightPedalKeyCBChange(Sender: TObject);
begin
  JoyButtons[2].KeyCode:=KeyNameToKeyCode(RightPedalKeyCB.Items.Strings[RightPedalKeyCB.ItemIndex]);
  KeysChanged:=true;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  Tray(3);
end;

procedure TMain.AboutBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.0' + #13#10 +
  IDS_LAST_UPDATE + ': 30.06.2020' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(IDS_ABOUT_TITLE), MB_ICONINFORMATION);
end;

procedure TMain.DefaultHandler(var Message);
begin
  if TMessage(Message).Msg = WM_TASKBARCREATED then
    Tray(1);
  inherited;
end;

procedure TMain.IconMouse(var Msg: TMessage);
begin
  case Msg.lParam of

    WM_LBUTTONDOWN: begin
      PostMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, 0);
      PostMessage(Handle, WM_LBUTTONUP, MK_LBUTTON, 0);
    end;

    WM_LBUTTONDBLCLK:
      if IsWindowVisible(Handle) then AppHide else AppShow;

    WM_RBUTTONDOWN:
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TMain.WMActivate(var Msg: TMessage);
begin
  if Msg.WParam = WA_INACTIVE then
    AppHide;
end;

procedure TMain.CloseBtnClick(Sender: TObject);
begin
  AllowClose:=true;
  Close;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if AllowClose = false then CanClose:=false;
  AppHide;
end;

procedure TMain.AppHide;
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TMain.AppShow;
begin
  if RunOnce = false then begin
    Main.AlphaBlendValue:=255;
    Main.AlphaBlend:=false;
    RunOnce:=true;
  end;

  ShowWindow(Handle, SW_NORMAL);
  SetForegroundWindow(Handle);
end;

procedure TMain.CloseBtn2Click(Sender: TObject);
begin
  CloseBtn.Click;
end;

procedure TMain.ShownBtnClick(Sender: TObject);
begin
  if IsWindowVisible(Handle) then AppHide else AppShow;
end;

end.
