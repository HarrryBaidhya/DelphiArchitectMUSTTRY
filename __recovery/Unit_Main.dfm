object Form_Main: TForm_Main
  Left = 0
  Top = 0
  Caption = 'Oracle2PG'
  ClientHeight = 484
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 484
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -40
    ExplicitTop = 8
    object BitBtn_Department: TBitBtn
      Left = 8
      Top = 73
      Width = 153
      Height = 25
      Caption = 'Departments'
      TabOrder = 0
      OnClick = BitBtn_DepartmentClick
    end
    object BitBtn_PatientType: TBitBtn
      Left = 8
      Top = 10
      Width = 153
      Height = 25
      Caption = 'Patient Type'
      TabOrder = 1
      OnClick = BitBtn_PatientTypeClick
    end
    object BitBtn_TestNames: TBitBtn
      Left = 8
      Top = 104
      Width = 153
      Height = 25
      Caption = 'Test names'
      TabOrder = 2
      OnClick = BitBtn_TestNamesClick
    end
    object BitBtn_Patients: TBitBtn
      Left = 8
      Top = 203
      Width = 153
      Height = 25
      Caption = 'Patients'
      TabOrder = 3
      OnClick = BitBtn_PatientsClick
    end
    object BitBtn1: TBitBtn
      Left = 8
      Top = 170
      Width = 153
      Height = 25
      Caption = 'Scheme && Community'
      TabOrder = 4
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 8
      Top = 135
      Width = 153
      Height = 25
      Caption = 'Test Package'
      TabOrder = 5
      OnClick = BitBtn2Click
    end
    object TPanel
      Left = 1
      Top = 442
      Width = 714
      Height = 41
      Align = alBottom
      TabOrder = 6
      ExplicitWidth = 747
      object Label1: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 5
        Height = 19
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object ProgressBar1: TProgressBar
        Left = 1
        Top = 1
        Width = 712
        Height = 39
        Align = alClient
        Step = 1
        TabOrder = 0
        ExplicitWidth = 745
      end
    end
    object BitBtn3: TBitBtn
      Left = 8
      Top = 234
      Width = 153
      Height = 25
      Caption = 'Patient Visits'
      TabOrder = 7
      OnClick = BitBtn3Click
    end
    object DBGrid1: TDBGrid
      Left = 321
      Top = 41
      Width = 393
      Height = 144
      TabOrder = 8
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'ProviderName'
          Title.Caption = 'Provider Name'
          Width = 83
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Port'
          Width = 49
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ServerIP'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Database'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UserName'
          Width = 81
          Visible = True
        end>
    end
  end
  object BitBtn_Users: TBitBtn
    Left = 8
    Top = 41
    Width = 153
    Height = 25
    Caption = 'Users'
    TabOrder = 1
    OnClick = BitBtn_UsersClick
  end
  object UniQuery_Get: TUniQuery
    Left = 360
    Top = 216
  end
  object UniQuery_Put: TUniQuery
    Left = 504
    Top = 224
  end
  object UniQuery_DigDeep: TUniQuery
    Left = 424
    Top = 216
  end
  object DataSource1: TDataSource
    Left = 648
    Top = 216
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 576
    Top = 216
  end
end
