object FmShowSnimok: TFmShowSnimok
  Left = 0
  Top = 0
  Caption = #1057#1087#1080#1089#1086#1082' '#1092#1072#1081#1083#1086#1074
  ClientHeight = 582
  ClientWidth = 1006
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 101
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 41
    Width = 1006
    Height = 541
    Align = alClient
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
    ParentFont = False
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
    ExplicitLeft = -8
    ExplicitTop = 160
    ExplicitHeight = 291
    ColWidths = (
      64
      614
      105
      92
      95)
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 1006
    Height = 41
    Align = alTop
    BorderInner = fsBump
    BorderOuter = fsNone
    TabOrder = 1
    OnResize = RzPanel1Resize
    ExplicitLeft = 440
    ExplicitTop = 96
    ExplicitWidth = 185
    object RzLabel1: TRzLabel
      Left = 18
      Top = 13
      Width = 53
      Height = 17
      Caption = #1055#1072#1087#1082#1072': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RzLabelFolderName: TRzLabel
      Left = 71
      Top = 13
      Width = 900
      Height = 17
      AutoSize = False
      Caption = #1055#1072#1087#1082#1072': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
