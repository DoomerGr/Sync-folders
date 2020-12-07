object FmViewLog: TFmViewLog
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1083#1086#1075#1072' '#1086#1087#1077#1088#1072#1094#1080#1081' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 580
  ClientWidth = 855
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 101
  TextHeight = 13
  object RzRichEdit1: TRzRichEdit
    Left = 0
    Top = 0
    Width = 855
    Height = 580
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    FrameStyle = fsGroove
    FrameVisible = True
    FramingPreference = fpCustomFraming
  end
  object MainMenu1: TMainMenu
    Left = 104
    Top = 24
    object C1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N1Save: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089' '#1080#1079#1084#1077#1085#1077#1085#1080#1103#1084#1080
        OnClick = N1SaveClick
      end
      object N3: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
        OnClick = N3Click
      end
    end
  end
end
