object Form_Main: TForm_Main
  Left = 0
  Top = 0
  Caption = 'Oracle2PG'
  ClientHeight = 484
  ClientWidth = 749
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 749
    Height = 484
    Align = alClient
    TabOrder = 0
    object BitBtn_Department: TBitBtn
      Left = 8
      Top = 72
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
      Top = 137
      Width = 153
      Height = 25
      Caption = 'Patients'
      TabOrder = 3
      OnClick = BitBtn_PatientsClick
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
    Left = 408
    Top = 16
  end
  object UniQuery_Put: TUniQuery
    Left = 600
    Top = 16
  end
  object UniQuery_DigDeep: TUniQuery
    Left = 472
    Top = 144
  end
end
