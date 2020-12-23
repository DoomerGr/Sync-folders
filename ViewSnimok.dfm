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
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect, goThumbTracking]
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnClick = StringGrid1Click
    OnDblClick = StringGrid1DblClick
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
  object PopupMenu1: TPopupMenu
    Left = 792
    Top = 280
    object N1_Find: TMenuItem
      Caption = #1053#1072#1081#1090#1080' '#1092#1072#1081#1083
      OnClick = N1_FindClick
    end
  end
  object FindDialog1: TFindDialog
    OnShow = FindDialog1Show
    OnFind = FindDialog1Find
    Left = 624
    Top = 256
  end
end
