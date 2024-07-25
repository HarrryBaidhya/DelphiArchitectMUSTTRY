object Form_CreateUser: TForm_CreateUser
  Left = 0
  Top = 0
  Caption = 'Form_CreateUser'
  ClientHeight = 312
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Upperpanel: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 602
    object Btn_Save: TButton
      Left = 405
      Top = 2
      Width = 100
      Height = 39
      BiDiMode = bdRightToLeft
      Caption = 'Save'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ImageIndex = 1
      Images = ImageList1
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
      OnClick = Btn_SaveClick
    end
    object Btn_Close: TButton
      Left = 509
      Top = 1
      Width = 92
      Height = 40
      BiDiMode = bdRightToLeft
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ImageIndex = 0
      Images = ImageList1
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 1
      OnClick = Btn_CloseClick
    end
  end
  object TPanel
    Left = 0
    Top = 41
    Width = 635
    Height = 271
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    ExplicitTop = 47
    ExplicitWidth = 704
    object Lbl_Username: TLabel
      Left = 39
      Top = 74
      Width = 81
      Height = 16
      AutoSize = False
      Caption = 'User Name'
    end
    object Label1: TLabel
      Left = 39
      Top = 112
      Width = 84
      Height = 16
      AutoSize = False
      Caption = 'PassWord'
    end
    object Label2: TLabel
      Left = 36
      Top = 10
      Width = 114
      Height = 16
      AutoSize = False
      Caption = 'Organization Code'
    end
    object Label3: TLabel
      Left = 38
      Top = 145
      Width = 78
      Height = 16
      AutoSize = False
      Caption = 'Server Port'
    end
    object Label4: TLabel
      Left = 38
      Top = 205
      Width = 114
      Height = 16
      AutoSize = False
      Caption = 'Database Source'
    end
    object Text_ServerName: TLabel
      Left = 36
      Top = 179
      Width = 103
      Height = 13
      AutoSize = False
      Caption = 'ServerName/ IP'
    end
    object Label5: TLabel
      Left = 38
      Top = 38
      Width = 81
      Height = 16
      AutoSize = False
      Caption = 'Provider Name'
    end
    object Edit_UserName: TEdit
      Left = 167
      Top = 73
      Width = 202
      Height = 23
      TabOrder = 0
    end
    object Edit_password: TEdit
      Left = 167
      Top = 108
      Width = 202
      Height = 23
      TabOrder = 1
    end
    object Edit_OrganizationCode: TEdit
      Left = 167
      Top = 7
      Width = 202
      Height = 23
      TabOrder = 2
    end
    object Edit_ServerPort: TEdit
      Left = 167
      Top = 142
      Width = 202
      Height = 23
      Color = clHighlightText
      TabOrder = 3
    end
    object Edit_DatabaseSource: TEdit
      Left = 167
      Top = 202
      Width = 202
      Height = 23
      TabOrder = 4
    end
    object Combo_ProviderName: TComboBox
      Left = 167
      Top = 38
      Width = 202
      Height = 23
      TabOrder = 5
      Text = 'Choose DataSource'
      Items.Strings = (
        'Oracle'
        'UM'
        'PA'
        'LAB ')
    end
    object Edit_ServerName: TEdit
      Left = 167
      Top = 173
      Width = 202
      Height = 23
      TabOrder = 6
    end
    object ConnectionList: TListBox
      Left = 440
      Top = 28
      Width = 201
      Height = 107
      ItemHeight = 15
      TabOrder = 7
      OnClick = ConnectionListClick
    end
  end
  object ImageList1: TImageList
    Top = 65534
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000021BCAEF021DD5FF00000000001E0066004B00FF004B
      00FF8E7B73FF8E7B73FF8E7B73FF8E7B73FF8E7B73FF8E7B73FF8E7B73FF8E7B
      73FF004B00FF004B00FF001E0066000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000528300000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000010B5260021DD7FF021BC8EF00000000004B00FF008100FF0081
      00FF5B5B3DFFE2D9D9FFC4AFADFFE2CFCCFFF3EDEAFFE5DEDEFFDAE0DEFF5777
      33FF285E05FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001169FBF021DD4FF021D
      D4FF000000000000000000000000000000000000000000000000000000000000
      0000021EDCFF021EDAFF000529300000000000000000004B00FF008100FF0081
      00FF386219FFE2D9D9FF004B00FF038103FFFAF8F4FFFEF8F4FFFCFFFFFF5777
      33FF285E05FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000010B5060021DD4FF021D
      D4FF010B51600000000000000000000000000000000000000000000000000113
      8C9F021EDCFF021CCCEF000000000000000000000000004B00FF008100FF0081
      00FF376318FFE2D9D9FF004B00FF038103FFEBEAE7FFFAF4F2FFFCFFFFFF5777
      33FF285E05FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000041B200218
      AFCF021EDAFF021EDDFF00000000000000000000000000020E10021EE1FF021E
      E0FF00062A3000000000000000000000000000000000004B00FF008100FF0081
      00FF39681AFFE2D9D9FF004B00FF038103FFA7AFADFFD3D4D0FFFCFFFFFF5777
      33FF285C04FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000002
      0E10021EDCFF021EDEFF01138C9F0000000000020E100118BACF021EE1FF021C
      D2EF0000000000000000000000000000000000000000004B00FF008100FF0081
      00FF357313FFE2D9D9FFE2D9D9FFE2D9D9FFE2D9D9FFE2D9D9FFE2D9D9FF5777
      33FF286906FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000010B5560011EE5FF011EE6FF011EE6FF011EE5FF00062B300000
      00000000000000000000000000000000000000000000004B00FF008100FF0081
      00FF008100FF008100FF008100FF008100FF008100FF008100FF008100FF0081
      00FF008100FF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000011AC9DF011FE7FF011FE9FF011CD7EF000000000000
      00000000000000000000000000000000000000000000004B00FF008100FF9DC2
      9DFF9DC29DFF9DC29DFF9DC29DFF9DC29DFF9DC29DFF9DC29DFF9DC29DFF9DC2
      9DFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000C5A60011FEBFF011FEAFF011FEEFF011FF0FF00020F100000
      00000000000000000000000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000C5A60011FEFFF011FEBFF0119BECF000C5A60011FF2FF0119C6CF0002
      0F100000000000000000000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000113
      989F011FF0FF011FEFFF00020F100000000000000000000000000119C9CF011F
      FAFF0002101000000000000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000113999F011F
      F4FF011FF0FF0119C2CF00000000000000000000000000000000000210100113
      9C9F0119CBCF00021010000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000119C9CF011FF6FF011F
      F4FF00020F100000000000000000000000000000000000000000000000000000
      0000000A4E50011DEAEF000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000011FFAFF011FF6FF0119
      C6CF000000000000000000000000000000000000000000000000000000000000
      00000000000000021010000000000000000000000000004B00FF008100FF9DC2
      9DFFFEFEFEFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFFEFE
      FEFF9DC29DFF008100FF004B00FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000001E0066004B00FF9DC2
      9DFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFF9DC29DFF004B00FF001E0066000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
