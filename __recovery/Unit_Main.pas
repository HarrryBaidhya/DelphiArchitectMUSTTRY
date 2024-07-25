unit Unit_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList, Vcl.WinXPickers,
  Vcl.WindowsStore, Vcl.ExtCtrls, Data.DB, MemDS, DBAccess, Uni, Vcl.StdCtrls,
  Vcl.Buttons, unit_DM, fxn, DAScript, UniScript, Vcl.ComCtrls, Vcl.Grids,
  Vcl.DBGrids,Datasnap.DBClient;

type
  TForm_Main = class(TForm)
    Panel1: TPanel;
    UniQuery_Get: TUniQuery;
    UniQuery_Put: TUniQuery;
    BitBtn_Users: TBitBtn;
    BitBtn_Department: TBitBtn;
    BitBtn_PatientType: TBitBtn;
    BitBtn_TestNames: TBitBtn;
    UniQuery_DigDeep: TUniQuery;
    BitBtn_Patients: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    BitBtn3: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure BitBtn_UsersClick(Sender: TObject);
    procedure BitBtn_DepartmentClick(Sender: TObject);
    procedure BitBtn_PatientTypeClick(Sender: TObject);
    procedure BitBtn_TestNamesClick(Sender: TObject);
    procedure BitBtn_PatientsClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InitializeDataSet;
    procedure AddDataToDataSet;
  private

    { Private declarations }
  public

     Procedure SetMaxID(seq_name,table_name:string; Connection_Name:TUniConnection);
     Function GetMaxID(table_name,field_name:string;Connection_Name:TUniConnection):string;
     Function GetPatientID(hospital_no:string):TStringList;
    { Public declarations }
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

procedure TForm_Main.BitBtn_PatientsClick(Sender: TObject);
var
hospital_no,ls_password,legacy_hospital_no,salutation_id,salutation_name,first_name,middle_name
,last_name,ls_name,gender,age,age_type,dob_vs,dob_ad,is_actual_dob,
country_id,state_id,district_id,vdcmcpt_id,ward_no,address,phone_no,
permanent_country_id,permanent_state_id,permanent_district_id,permanent_vdcmcpt_id
,permanent_ward_no,permanent_address,permanent_phone_no,
mobile_no,email,pan_no,created_date_vs,remarks,modified_date_vs
,search_tag,version_info,created_by,organization_id,sub_organization_id,
created_at,max_id,permanent_address_lab,current_address_lab :string;
default_district_id, default_vdcmcpt_id,pat_id:Integer;
begin
     with UniQuery_Get do
     begin
           close;
          sql.Clear;
          Connection:= gs_Connection_PA;
          sql.Add('select id as district_id from districts d  where is_default is true ');
          open;

          if FieldByName('district_id').AsInteger<=0 then
          begin
               ShowMessage('Set A Default District!')  ;
               Exit;
          end
          else
               default_district_id := FieldByName('district_id').AsInteger ;


          close;
          sql.Clear;
          Connection:= gs_Connection_PA;
          sql.Add('select id vdcmcpt_id from vdcmcpts v where is_default is true ');
          open;

           if FieldByName('vdcmcpt_id').AsInteger<=0 then
          begin
               ShowMessage('Set A Default Palika ID!')  ;
               Exit;
          end
          else
               default_vdcmcpt_id := FieldByName('vdcmcpt_id').AsInteger ;
     end;

//     try
//          with UniQuery_Get do
//          begin
//               close;
//               sql.Clear;
//               Connection:= gs_SrcConnection;
//               sql.Add('ALTER TABLE HS_DISTRICT ADD districtid_new integer');
//               ExecSQL;
//          end;
//     Except
//          on E: EUniError do
//          begin
//
//          end;
//     end;
//
//     with UniQuery_Get do
//     begin
//          close;
//          sql.Clear;
//          Connection:= gs_SrcConnection;
//          sql.Add('UPDATE HS_DISTRICT SET districtid_new=districtid-79 WHERE DISTRICTID >75');
//          ExecSQL;
//     end;

     max_id := GetMaxID('patients','hospital_no',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT count(1) cnt FROM HS_PAMA_PATIENTMAIN P where PAMA_PATIENTID > '+max_id+' order by PAMA_PATIENTID');
          open;
     end;
     ProgressBar1.Max :=  UniQuery_Get.FieldByName('cnt').AsInteger;
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT p.*,getengdatefromnep(PAMA_REGDATE) regdatead FROM HS_PAMA_PATIENTMAIN P where PAMA_PATIENTID > '+max_id+' order by PAMA_PATIENTID');
          open;
     end;

     ProgressBar1.Position := 0;
      ProgressBar1.Min := 0;
      UniQuery_Get.First;
      Label1.Caption := '';
      Label1.Parent := progressBar1;
     Label1.AutoSize := False;
     Label1.Transparent := True;
     Label1.Top :=  0;
     Label1.Left :=  0;
     Label1.Width := progressBar1.ClientWidth;
     Label1.Height := progressBar1.ClientHeight;
     Label1.Alignment := taCenter;
     Label1.Layout := tlCenter;
     while not UniQuery_Get.Eof do
     begin
         hospital_no :=  UniQuery_Get.FieldByName('PAMA_PATIENTID').AsString;
         ls_password := 'NULL'; //UniQuery_Get.FieldByName('PAMA_PATIENTID').AsString;    -- not in ppl
         legacy_hospital_no:=  UniQuery_Get.FieldByName('PAMA_PATIENTID').AsString;
          salutation_name :=   UniQuery_Get.FieldByName('PAMA_TITLE').AsString;
          first_name  := UniQuery_Get.FieldByName('PAMA_FNAME').AsString;
          middle_name  :=  UniQuery_Get.FieldByName('PAMA_MNAME').AsString;
          last_name:= UniQuery_Get.FieldByName('PAMA_LNAME').AsString;
          ls_name:= UniQuery_Get.FieldByName('PAMA_PATIENTNAME').AsString;
          gender :=   UniQuery_Get.FieldByName('PAMA_GENDER').AsString;
          age :=  UniQuery_Get.FieldByName('PAMA_AGE').AsString;
          if (UPPERCASE(UniQuery_Get.FieldByName('PAMA_AGETYPE').AsString)='DAY') or (UPPERCASE(UniQuery_Get.FieldByName('PAMA_AGETYPE').AsString)='DAYS') then
               age_type:= 'DAY'
          else if (UPPERCASE(UniQuery_Get.FieldByName('PAMA_AGETYPE').AsString)='MONTH') or (UPPERCASE(UniQuery_Get.FieldByName('PAMA_AGETYPE').AsString)='MONTHS') then
               age_type:= 'MONTH'
          else
               age_type:= 'YEAR' ;
          dob_vs := StringReplace(UniQuery_Get.FieldByName('PAMA_DOBVS').AsString,'/','-',[rfReplaceAll]);
          dob_ad := StringReplace(UniQuery_Get.FieldByName('PAMA_DOBAD').AsString,'/','-',[rfReplaceAll]);
          if UniQuery_Get.FieldByName('PAMA_ISACTUALDOB').AsString = 'Y'then
               is_actual_dob:='Y'
          else
               is_actual_dob:='N';
          country_id := '149';
          state_id :=  '3';
          district_id :=IntToStr(default_district_id);
          vdcmcpt_id := IntToStr(default_vdcmcpt_id);
          ward_no := UniQuery_Get.FieldByName('PAMA_WARDNO').AsString;
          if ward_no='' then
               ward_no := '0';
          address := UniQuery_Get.FieldByName('PAMA_ADDRESS').AsString;
          phone_no:= UniQuery_Get.FieldByName('PAMA_PHONENO').AsString ;
          permanent_country_id := country_id;
          permanent_state_id := state_id ;
          permanent_district_id :=  district_id;
          permanent_vdcmcpt_id :=  vdcmcpt_id;
          permanent_ward_no := ward_no;
          permanent_address := address;
          permanent_address_lab := 'LALITPUR ,'+ permanent_address ;
          current_address_lab   := 'LALITPUR ,'+ permanent_address ;
          permanent_phone_no := phone_no;
          mobile_no := Copy(UniQuery_Get.FieldByName('PAMA_MOBILENO').AsString,1,10) ;
          email :=  UniQuery_Get.FieldByName('PAMA_EMAIL').AsString ;
          pan_no := UniQuery_Get.FieldByName('PAMA_PANNO').AsString ;
          created_date_vs := StringReplace(UniQuery_Get.FieldByName('PAMA_REGDATE').AsString,'/','-',[rfReplaceAll]) ;
          remarks :=  UniQuery_Get.FieldByName('PAMA_REMARKS').AsString ;
          modified_date_vs  := '' ;
          search_tag := ls_name + '|' + mobile_no + '|' + dob_vs + '|' + dob_ad;
          version_info := 'PATCHv1.0';
          created_by :=  UniQuery_Get.FieldByName('PAMA_REGBY').AsString ;
          if (created_by='') or (created_by='0') then
               created_by := '1';
          organization_id := '193';
          sub_organization_id := '191';
          created_at :=  StringReplace(UniQuery_Get.FieldByName('REGDATEAD').AsString,'/','-',[rfReplaceAll])+' '+ UniQuery_Get.FieldByName('PAMA_REGTIME').AsString;
          gs_Connection_PA.StartTransaction;
          gs_Connection_Lab.StartTransaction;
          try
               with UniQuery_Put do
               begin
                    close;
                    sql.Clear;
                    Connection := gs_Connection_PA;
                    sql.Add('insert into patients(') ;
                    sql.Add('hospital_no,"password",legacy_hospital_no,salutation_name,first_name,middle_name');
                    sql.Add(',last_name,"name",gender,age,age_type,dob_vs,dob_ad,is_actual_dob, ');
                    sql.Add('country_id,state_id,district_id,vdcmcpt_id,ward_no,address,phone_no,');
                    sql.Add('permanent_country_id,permanent_state_id,permanent_district_id,permanent_vdcmcpt_id');
                    sql.Add(',permanent_ward_no,permanent_address,permanent_phone_no, ');
                    sql.Add('mobile_no,email,pan_no,created_date_vs,remarks,modified_date_vs  ');
                    sql.Add(',search_tag,version_info,created_by,organization_id,sub_organization_id, ');
                    sql.Add('created_at)');
                    sql.Add('values (');
                    sql.Add(QuotedStr(hospital_no));
                    sql.Add(','+ls_password);
                    sql.Add(','+QuotedStr(legacy_hospital_no));
                    sql.Add(','+QuotedStr(salutation_name));
                    sql.Add(','+QuotedStr(first_name));
                    sql.Add(','+QuotedStr(middle_name));
                    sql.Add(','+QuotedStr(last_name));
                    sql.Add(','+QuotedStr(ls_name));
                    sql.Add(','+QuotedStr(gender));
                    sql.Add(','+QuotedStr(age));
                    sql.Add(','+QuotedStr(age_type));
                    sql.Add(','+QuotedStr(dob_vs));
                    sql.Add(','+QuotedStr(dob_ad));
                    sql.Add(','+QuotedStr(is_actual_dob));
                    sql.Add(','+country_id);
                    sql.Add(','+state_id);
                    sql.Add(','+district_id);
                    sql.Add(','+vdcmcpt_id);
                    sql.Add(','+ward_no);
                    sql.Add(','+QuotedStr(address));
                    sql.Add(','+QuotedStr(phone_no));

                     sql.Add(','+permanent_country_id);
                    sql.Add(','+permanent_state_id);
                    sql.Add(','+permanent_district_id);
                    sql.Add(','+permanent_vdcmcpt_id);
                    sql.Add(','+permanent_ward_no);
                    sql.Add(','+QuotedStr(permanent_address));
                    sql.Add(','+QuotedStr(permanent_phone_no));

                    sql.Add(','+QuotedStr(mobile_no));
                    sql.Add(','+QuotedStr(email));
                    sql.Add(','+QuotedStr(pan_no));
                    sql.Add(','+QuotedStr(created_date_vs));
                    sql.Add(','+QuotedStr(remarks));
                    sql.Add(','+QuotedStr(modified_date_vs));
                    sql.Add(','+QuotedStr(search_tag));
                    sql.Add(','+QuotedStr(version_info));
                    sql.Add(','+created_by);
                    sql.Add(','+organization_id);
                    sql.Add(','+sub_organization_id);
                    sql.Add(','+QuotedStr(created_at));
                    sql.Add(') returning id as pat_id');
                    sql.SaveToFile('C:/patients.txt');
                    Open;
               end;

               pat_id := UniQuery_Put.FieldByName('pat_id').AsInteger;

//               with UniQuery_Put do
//               begin
//                    close;
//                    sql.Clear;
//                    Connection := gs_Connection_Lab;
//                    sql.Add('insert into patients(') ;
//                    sql.Add('id,hospital_no,gender,age,age_type,dob_vs,dob_ad,email,');
//                    sql.Add('permanent_address,current_address');
//                    sql.Add(',patient_name,phone_no,mobile_no,created_by,organization_id,sub_organization_id,created_at)');
//                    sql.Add('values (');
//                    sql.Add(IntToStr(pat_id));
//                    sql.Add(','+QuotedStr(hospital_no));
//                    sql.Add(','+QuotedStr(gender));
//                    sql.Add(','+QuotedStr(age));
//                    sql.Add(','+QuotedStr(age_type));
//                    sql.Add(','+QuotedStr(dob_vs));
//                    sql.Add(','+QuotedStr(dob_ad));
//                    sql.Add(','+QuotedStr(email));
//                    sql.Add(','+QuotedStr(permanent_address_lab));
//                    sql.Add(','+QuotedStr(current_address_lab));
//                    sql.Add(','+QuotedStr(ls_name));
//                    sql.Add(','+QuotedStr(phone_no));
//                    sql.Add(','+QuotedStr(mobile_no));
//                    sql.Add(','+created_by);
//                    sql.Add(','+organization_id);
//                    sql.Add(','+sub_organization_id);
//                    sql.Add(','+QuotedStr(created_at));
//                    sql.Add(')');
//                    sql.SaveToFile('C:/patients.txt');
//                    ExecSQL;
//               end;

                with UniQuery_Put do
               begin
                    close;
                    sql.Clear;
                    Connection := gs_Connection_Lab;
                    sql.Add('insert into patients(') ;
                    sql.Add('id,hospital_no,patient_name,gender,age,age_type,dob_vs,dob_ad, ');
                    sql.Add('country_id,state_id,district_id,vdcmcpt_id,current_address,phone_no,');
                    sql.Add('permanent_country_id,permanent_state_id,permanent_district_id,permanent_vdcmcpt_id');
                    sql.Add(',permanent_address, ');
                    sql.Add('mobile_no,email  ');
                    sql.Add(',created_by,organization_id,sub_organization_id, ');
                    sql.Add('created_at)');
                    sql.Add('values (');
                    sql.Add(IntToStr(pat_id));
                    sql.Add(','+QuotedStr(hospital_no));
                    sql.Add(','+QuotedStr(ls_name));
                    sql.Add(','+QuotedStr(gender));
                    sql.Add(','+QuotedStr(age));
                    sql.Add(','+QuotedStr(age_type));
                    sql.Add(','+QuotedStr(dob_vs));
                    sql.Add(','+QuotedStr(dob_ad));
                    sql.Add(','+country_id);
                    sql.Add(','+state_id);
                    sql.Add(','+district_id);
                    sql.Add(','+vdcmcpt_id);
                    sql.Add(','+QuotedStr(address));
                    sql.Add(','+QuotedStr(phone_no));

                     sql.Add(','+permanent_country_id);
                    sql.Add(','+permanent_state_id);
                    sql.Add(','+permanent_district_id);
                    sql.Add(','+permanent_vdcmcpt_id);
                    sql.Add(','+QuotedStr(permanent_address));

                    sql.Add(','+QuotedStr(mobile_no));
                    sql.Add(','+QuotedStr(email));
                    sql.Add(','+created_by);
                    sql.Add(','+organization_id);
                    sql.Add(','+sub_organization_id);
                    sql.Add(','+QuotedStr(created_at));
                    sql.Add(')');
                    sql.SaveToFile('C:/patientslab.txt');
                    ExecSQL;
               end;

               gs_Connection_PA.Commit;
               gs_Connection_Lab.Commit;
               ProgressBar1.Position := ProgressBar1.Position+1;
               Label1.Caption := 'Total Rows Inserted: '+ IntToStr(ProgressBar1.Position)+'/'+IntToStr(ProgressBar1.Max);
          except
               gs_Connection_PA.Rollback;
               gs_Connection_Lab.Rollback;
               Label1.Caption := 'Total Rows Inserted: '+ IntToStr(ProgressBar1.Position)+'/'+IntToStr(ProgressBar1.Max);
               ProgressBar1.State := pbsError;
               exit;
          end;

         UniQuery_Get.Next;
     end;
end;

procedure TForm_Main.BitBtn_PatientTypeClick(Sender: TObject);
var
excluded_codes:string;
ls_id,ls_code,ls_name,display_order,is_default
,created_by,organization_id,sub_organization_id,
created_at,updated_at:string;
begin
     //
     with UniQuery_Get do
     begin
          close;
          sql.Clear;
          Connection := gs_Connection_PA;
          sql.Add('select code from patient_types pt');
          open;
     end;
     excluded_codes := '';
     while not UniQuery_Get.Eof do
     begin
          excluded_codes := excluded_codes+''''+UniQuery_Get.FieldByName('code').AsString+''',';
          UniQuery_Get.Next;
     end;
     if Length(excluded_codes) > 0 then
     begin
          excluded_codes := Copy(excluded_codes, 1, Length(excluded_codes) - 1);
          with UniQuery_Get do
          begin
               close;
               sql.Clear;
               Connection := gs_SrcConnection;
               sql.Add('SELECT * FROM HS_PATY_PATIENTTYPE hpp');
               sql.Add('where PATY_PATIENTTYPECODE not in ('+excluded_codes+')');
               //sql.SaveToFile('c:/text.txt');
               open;
          end;
     end
     else
     begin
          with UniQuery_Get do
          begin
               close;
               sql.Clear;
               Connection := gs_SrcConnection;
               sql.Add('SELECT * FROM HS_PATY_PATIENTTYPE hpp');
               open;
          end;
     end;
     UniQuery_Get.First;
     while not UniQuery_Get.Eof do
     begin
          ls_id := UniQuery_Get.FieldByName('PATY_PATIENTTYPEID').AsString;
          ls_code:= UniQuery_Get.FieldByName('PATY_PATIENTTYPECODE').AsString;
          ls_name := UniQuery_Get.FieldByName('PATY_PATIENTTYPE').AsString;
          display_order := UniQuery_Get.FieldByName('PATY_DISPLAYORDER').AsString;
          is_default := 'N';
          created_by := '1';
          organization_id:='1';
          sub_organization_id:='1';
          created_at := '2023-01-01 00:00:00';
          updated_at := '2023-01-01 00:00:00';

          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('insert into patient_types (id,code,"name",display_order,is_default,');
               sql.Add('created_by,organization_id,sub_organization_id,created_at,updated_at)');
               sql.Add('Values (');
               sql.Add(ls_id);
               sql.Add(','+QuotedStr(ls_code));
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(display_order));
               sql.Add(','+QuotedStr(is_default));
               sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(','+QuotedStr(updated_at));
               sql.Add(')');
               ExecSQL;

               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('insert into patient_type_system_types (patient_type_code,system_type_code)');
               sql.Add('Values (') ;
               sql.Add(QuotedStr(ls_code));
                sql.Add(',''GEN''');
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;


     if UniQuery_Get.RecordCount>0 then
          SetMaxID('patient_types_id_seq','patient_types',gs_Connection_PA);


end;

procedure TForm_Main.BitBtn_TestNamesClick(Sender: TObject);
var
max_id:string;
created_by,organization_id,sub_organization_id,
created_at,updated_at,ls_type,operation_type,package_type
,archived_at,archived_by,included_codes, tenc_code,is_vat,is_price_with_vat,vat,is_discountable,
is_editable,is_fractionable,price:string;
begin

     try
     with UniQuery_Get do
          begin
               close;
               Connection := gs_SrcConnection;
               sql.Clear;
               sql.Add('alter table HS_TENC_TESTNAMECATEGORY add TENC_ORDERBY  integer default 0');
               ExecSQL;
          end;
     Except
          on E: EUniError do
          begin

          end;
     end;

     created_by := '1';
     organization_id:='193';
     sub_organization_id:='191';
     created_at := '2023-01-01 00:00:00';
     updated_at := '2023-01-01 00:00:00';

     max_id := GetMaxID('test_name_categories','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_TENC_TESTNAMECATEGORY hdd where TENC_TNCATEGORYID > '+max_id+' order by TENC_TNCATEGORYID');
          open;
     end;

     UniQuery_Get.First;
     while not UniQuery_Get.Eof do
     begin
          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('insert into test_name_categories ');
               sql.Add('(id,"name",code,display_order,created_by,');
               sql.Add('organization_id,sub_organization_id,created_at)');
               sql.Add('Values (');
               sql.Add(UniQuery_Get.FieldByName('TENC_TNCATEGORYID').AsString);
               sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENC_TESTNAMECATEGORY').AsString));
               sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENC_TNCATEGORYCODE').AsString));
               sql.Add(','+UniQuery_Get.FieldByName('TENC_ORDERBY').AsString);
                sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;

      if UniQuery_Get.RecordCount>0 then
          SetMaxID('test_name_categories_id_seq','test_name_categories',gs_Connection_PA);

     // test names and prices

     max_id := GetMaxID('test_names','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT hdd.*');
          sql.Add(',(SELECT htt.TENC_TNCATEGORYID  FROM HS_TENC_TESTNAMECATEGORY htt ');
          sql.Add('WHERE htt.TENC_TNCATEGORYCODE= TENC_TNCATEGORYCODE AND rownum=1) category_id');
          sql.Add('FROM HS_TENA_TESTNAME hdd where TENA_TESTNAMEID > '+max_id+' order by TENA_TESTNAMEID');
          open;
     end;

     UniQuery_Get.First;
      try
          gs_Connection_PA.StartTransaction;
          while not UniQuery_Get.Eof do
          begin
               if UniQuery_Get.FieldByName('TENA_TESTNAMETYPE').AsString ='O' then
                    ls_type := 'OPR'
               else
                    ls_type := 'SER';

               if  (UniQuery_Get.FieldByName('TENA_TESTNAMETYPE').AsString ='O') and  (UniQuery_Get.FieldByName('TENA_OTTYPE').AsString <> '' ) then
                    operation_type:=  UniQuery_Get.FieldByName('TENA_OTTYPE').AsString
               else
                    operation_type := 'NULL';


                if  UniQuery_Get.FieldByName('TENA_ISPACKAGETEST').AsString = 'Y'  then
                    package_type:=  'P'
               else
                    package_type := 'NULL';

                if UniQuery_Get.FieldByName('TENA_ISACTIVE').AsString='Y' then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
               end;



                    with UniQuery_Put do
                    begin
                         close;
                         sql.Clear;
                         Connection := gs_Connection_PA;
                         sql.Add('insert into test_names ');
                         sql.Add('(id,department_id,test_name_category_id,"name",code,"type",');
                         sql.Add('operation_type,package_type ,created_by,organization_id,sub_organization_id,');
                         sql.Add('archived_by,archived_at,created_at)');
                         sql.Add('Values (');
                         sql.Add(UniQuery_Get.FieldByName('TENA_TESTNAMEID').AsString);
                         sql.Add(','+UniQuery_Get.FieldByName('TENA_DEPID').AsString);
                         sql.Add(','+UniQuery_Get.FieldByName('category_id').AsString);
                         sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENA_TESTNAME').AsString));
                         sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENA_TESTNAMECODE').AsString));
                         sql.Add(','+QuotedStr(ls_type));
                         if operation_type='NULL' then
                              sql.Add(','+operation_type)
                         else
                              sql.Add(','+QuotedStr(operation_type));
                         if package_type='NULL' then
                              sql.Add(','+package_type)
                         else
                              sql.Add(','+QuotedStr(package_type));
                          sql.Add(','+created_by);
                         sql.Add(','+organization_id);
                         sql.Add(','+sub_organization_id);
                         if archived_at='NULL' then
                         begin
                              sql.Add(','+archived_by)  ;
                              sql.Add(','+archived_at)  ;
                         end
                         else
                         begin
                              sql.Add(','+QuotedStr(archived_by))  ;
                              sql.Add(','+QuotedStr(archived_at))  ;
                         end;
                         sql.Add(','+QuotedStr(created_at));
                         sql.Add(')');
                         sql.SaveToFile('C:/test.txt')  ;
                         ExecSQL;
                    end;

                    with UniQuery_DigDeep do
                    begin
                         close;
                         sql.Clear;
                         Connection := gs_Connection_PA;
                         sql.Add('select code from patient_types pt');
                         open;
                    end;
                    included_codes := '';
                    while not UniQuery_DigDeep.Eof do
                    begin
                         included_codes := included_codes+''''+UniQuery_DigDeep.FieldByName('code').AsString+''',';
                         UniQuery_DigDeep.Next;
                    end;
                    if Length(included_codes) > 0 then
                    begin
                         included_codes := Copy(included_codes, 1, Length(included_codes) - 1);
                         with UniQuery_DigDeep do
                         begin
                              close;
                              sql.Clear;
                              Connection := gs_SrcConnection;
                              sql.Add('select * from HS_TENP_TESTNAMEPRICE');
                              sql.Add('where TENP_PATIENTTYPECODE  in ('+included_codes+')');
                              sql.Add('and TENP_TESTNAMEID='+UniQuery_Get.FieldByName('TENA_TESTNAMEID').AsString);
                              open;
                         end;
                         UniQuery_DigDeep.First;
                         while not UniQuery_DigDeep.eof do
                         begin
                              with UniQuery_Put do
                              begin
                                   if UniQuery_DigDeep.FieldByName('TENP_PATIENTTYPECODE').AsString='INS' then
                                        tenc_code := UniQuery_Get.FieldByName('TENA_INSCODE').AsString
                                   else if UniQuery_DigDeep.FieldByName('TENP_PATIENTTYPECODE').AsString='SSF' then
                                        tenc_code := UniQuery_Get.FieldByName('TENA_SSFCODE').AsString
                                   else
                                         tenc_code := UniQuery_Get.FieldByName('TENA_TESTNAMECODE').AsString ;

                                   if tenc_code='' then
                                        tenc_code := UniQuery_Get.FieldByName('TENA_TESTNAMECODE').AsString;

                                  if UniQuery_DigDeep.FieldByName('TENP_ISVATABLE').AsString ='Y'  then
                                        is_vat := 'Y'
                                  else
                                        is_vat := 'N';

                                  if UniQuery_DigDeep.FieldByName('TENP_ISCHARGEWITHSVRTAX').AsString ='Y'  then
                                        is_price_with_vat := 'Y'
                                  else
                                        is_price_with_vat := 'N';


                                  if UniQuery_DigDeep.FieldByName('TENP_VATAMT').AsString =''  then
                                        vat := '0'
                                  else
                                       vat := UniQuery_DigDeep.FieldByName('TENP_VATAMT').AsString;

                                  if UniQuery_DigDeep.FieldByName('TENP_ISDISCOUNTABLE').AsString ='Y'  then
                                        is_discountable := 'Y'
                                  else
                                       is_discountable := 'N';

                                  if UniQuery_DigDeep.FieldByName('TENP_ISTESTPRICEEDITABLE').AsString ='Y'  then
                                        is_editable := 'Y'
                                  else
                                       is_editable := 'N';

                                  if UniQuery_Get.FieldByName('TENA_ISFRACTIONABLEITEM').AsString ='Y'  then
                                        is_fractionable := 'Y'
                                  else
                                       is_fractionable := 'N';


                                  if UniQuery_DigDeep.FieldByName('TENP_TESTPRICE').AsInteger > 0 then
                                  begin
                                        price := UniQuery_DigDeep.FieldByName('TENP_TESTPRICE').AsString;
                                  end
                                  else
                                  begin
                                        price := '0';
                                  end;

                                   sql.Clear;
                                   Connection := gs_Connection_PA;
                                   sql.Add('insert into test_name_prices ');
                                   sql.Add('(id,test_name_id,patient_type_code,code,price,is_vat,is_price_with_vat,vat,is_discountable,');
                                   sql.Add('is_editable,is_fractionable,created_by,organization_id,sub_organization_id,created_at)');
                                   sql.Add('Values (');
                                   sql.Add(UniQuery_DigDeep.FieldByName('TENP_TESTNAMEPRICEID').AsString);
                                   sql.Add(','+QuotedStr(UniQuery_DigDeep.FieldByName('TENP_TESTNAMEID').AsString));
                                   sql.Add(','+QuotedStr(UniQuery_DigDeep.FieldByName('TENP_PATIENTTYPECODE').AsString));
                                   sql.Add(','+QuotedStr(tenc_code));
                                   sql.Add(','+price);
                                   sql.Add(','+QuotedStr(is_vat));
                                   sql.Add(','+QuotedStr(is_price_with_vat));
                                   sql.Add(','+vat);
                                   sql.Add(','+QuotedStr(is_discountable));
                                   sql.Add(','+QuotedStr(is_editable));
                                   sql.Add(','+QuotedStr(is_fractionable));
                                   sql.Add(','+created_by);
                                   sql.Add(','+organization_id);
                                   sql.Add(','+sub_organization_id);
                                   sql.Add(','+QuotedStr(created_at));
                                   sql.Add(')');
                                   sql.SaveToFile('C:/test.txt')  ;
                                   ExecSQL;
                              end;
                              UniQuery_DigDeep.Next;
                         end;

                         if UniQuery_Get.FieldByName('TENA_ISPACKAGETEST').AsString='Y' then
                         begin
     //                         with UniQuery_DigDeep do
     //                         begin
     //                              close;
     //                              sql.Clear;
     //                              Connection:=gs_Connection_PA;
     //
     //                         end;  get data from testpackagedetail and insert into new pg table logic goes here
                         end;

                    end;
               UniQuery_Get.Next;
          end;
           gs_Connection_PA.Commit;
      except
          on E : Exception do
          begin
               ShowMessage(e.Message);
               gs_Connection_PA.Rollback;
          end;
      end;

      if UniQuery_Get.RecordCount>0 then
          SetMaxID('test_names_id_seq','test_names',gs_Connection_PA);

      if UniQuery_Get.RecordCount>0 then
          SetMaxID('test_name_prices_id_seq','test_name_prices',gs_Connection_PA);





     max_id := GetMaxID('test_names','id',gs_Connection_LAB);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT hdd.*');
          sql.Add(',(SELECT htt.TENC_TNCATEGORYID  FROM HS_TENC_TESTNAMECATEGORY htt ');
          sql.Add('WHERE htt.TENC_TNCATEGORYCODE= TENC_TNCATEGORYCODE AND rownum=1) category_id');
          sql.Add('FROM HS_TENA_TESTNAME hdd where TENA_TESTNAMEID > '+max_id+' order by TENA_TESTNAMEID');
          open;
     end;

     UniQuery_Get.First;
      try
          gs_Connection_Lab.StartTransaction;
          while not UniQuery_Get.Eof do
          begin
               if UniQuery_Get.FieldByName('TENA_TESTNAMETYPE').AsString ='O' then
                    ls_type := 'OPR'
               else
                    ls_type := 'SER';

               if  (UniQuery_Get.FieldByName('TENA_TESTNAMETYPE').AsString ='O') and  (UniQuery_Get.FieldByName('TENA_OTTYPE').AsString <> '' ) then
                    operation_type:=  UniQuery_Get.FieldByName('TENA_OTTYPE').AsString
               else
                    operation_type := 'NULL';


                if  UniQuery_Get.FieldByName('TENA_ISPACKAGETEST').AsString = 'Y'  then
                    package_type:=  'P'
               else
                    package_type := 'NULL';

                if UniQuery_Get.FieldByName('TENA_ISACTIVE').AsString='Y' then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
               end;



                    with UniQuery_Put do
                    begin
                         close;
                         sql.Clear;
                         Connection := gs_Connection_Lab;
                         sql.Add('insert into test_names ');
                         sql.Add('(id,department_id,"name",');
                         sql.Add('package_type ,created_by,organization_id,sub_organization_id,');
                         sql.Add('archived_by,archived_at,created_at,updated_by)');
                         sql.Add('Values (');
                         sql.Add(UniQuery_Get.FieldByName('TENA_TESTNAMEID').AsString);
                         sql.Add(','+UniQuery_Get.FieldByName('TENA_DEPID').AsString);
                        // sql.Add(','+UniQuery_Get.FieldByName('category_id').AsString);
                         sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENA_TESTNAME').AsString));
                         //sql.Add(','+QuotedStr(UniQuery_Get.FieldByName('TENA_TESTNAMECODE').AsString));
                        // sql.Add(','+QuotedStr(ls_type));
//                         if operation_type='NULL' then
//                              sql.Add(','+operation_type)
//                         else
//                              sql.Add(','+QuotedStr(operation_type));
                         if package_type='NULL' then
                              sql.Add(','+package_type)
                         else
                              sql.Add(','+QuotedStr(package_type));
                          sql.Add(','+created_by);
                         sql.Add(','+organization_id);
                         sql.Add(','+sub_organization_id);
                         if archived_at='NULL' then
                         begin
                              sql.Add(','+archived_by)  ;
                              sql.Add(','+archived_at)  ;
                         end
                         else
                         begin
                              sql.Add(','+QuotedStr(archived_by))  ;
                              sql.Add(','+QuotedStr(archived_at))  ;
                         end;
                         sql.Add(','+QuotedStr(created_at));
                         sql.Add(','+created_by);
                         sql.Add(')');
                         sql.SaveToFile('C:/test.txt')  ;
                         ExecSQL;
                    end;
               UniQuery_Get.Next;
          end;
           gs_Connection_Lab.Commit;
      except
          on E : Exception do
          begin
               ShowMessage(e.Message);
               gs_Connection_Lab.Rollback;
          end;
      end;

end;

procedure TForm_Main.BitBtn1Click(Sender: TObject);
var
max_id:string;
id,code,ls_name,display_order,created_by
,organization_id,sub_organization_id,
archived_by,archived_at,created_at,is_active:string;
//schemes
community_id,valid_from_bs,valid_to_bs,
reg_dis,is_reg_credit,is_reg_dis_editable,is_reg_paytype_editable,op_dis,is_op_credit,
is_op_dis_editable,is_op_paytype_editable,ip_dis,is_ip_credit,is_ip_dis_editable,is_ip_paytype_editable,
admn_dis,is_admn_credit,is_admn_dis_editable,bed_dis,is_bed_credit,is_bed_dis_editable,is_phar,phar_ip_dis,
is_phar_ip_credit,is_phar_ip_dis_editable,is_phar_ip_paytype_editable,phar_op_dis,is_phar_op_credit
,is_phar_op_dis_editable,is_phar_op_paytype_editable:string;
begin
     max_id := GetMaxID('communities','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_COMM_COMMUNITY where COMM_COMMUNITYID > '+max_id+' order by COMM_COMMUNITYID');
          open;
     end;
     UniQuery_Get.First;
     while not UniQuery_Get.Eof do
     begin
          id := UniQuery_Get.FieldByName('COMM_COMMUNITYID').AsString;
          code :=   UniQuery_Get.FieldByName('COMM_COMCODE').AsString;
          ls_name := UniQuery_Get.FieldByName('COMM_COMMUNITY').AsString;

          if (UniQuery_Get.FieldByName('COMM_PRIORITY').AsString = '0') or (UniQuery_Get.FieldByName('COMM_PRIORITY').AsString = '')   then
               display_order := 'NULL'
          else
               display_order := UniQuery_Get.FieldByName('COMM_PRIORITY').AsString;

          if UniQuery_Get.FieldByName('COMM_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
               is_active := 'Y';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
               is_active := 'N';
          end;
          created_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';

          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('INSERT INTO communities (');
               sql.Add('id,"name",code,display_order,');
               sql.Add('archived_at, archived_by, ');
               sql.Add('created_by,organization_id,sub_organization_id,');
               sql.Add('created_at) VALUES ( ');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(code));
               sql.Add(','+display_order);
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;

     if UniQuery_Get.RecordCount>0 then
          SetMaxID('communities_id_seq','communities',gs_Connection_PA);

          // schemes
     max_id := GetMaxID('schemes','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_SCHE_SCHEME where SCHE_SCHEMEID > '+max_id+' order by SCHE_SCHEMEID');
          open;
     end;
     while not UniQuery_Get.Eof do
     begin
           id := UniQuery_Get.FieldByName('SCHE_SCHEMEID').AsString;
          code :=   UniQuery_Get.FieldByName('SCHE_SCHEMECODE').AsString;
          community_id :=  UniQuery_Get.FieldByName('SCHE_COMMUNITYID').AsString;
          ls_name := UniQuery_Get.FieldByName('SCHE_SCHEME').AsString;
          valid_from_bs := StringReplace(UniQuery_Get.FieldByName('SCHE_VALIDFROMDATE').AsString,'/','-',[rfReplaceAll]);
          valid_to_bs := StringReplace(UniQuery_Get.FieldByName('SCHE_VALIDTODATE').AsString,'/','-',[rfReplaceAll]);
          if (UniQuery_Get.FieldByName('SCHE_REGDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_REGDISPER').AsString = '')   then
               reg_dis := '0'
          else
               reg_dis := UniQuery_Get.FieldByName('SCHE_REGDISPER').AsString;
          if UniQuery_Get.FieldByName('SCHE_ISREGCRFACILITY').AsString='Y' then
               is_reg_credit := 'Y'
          else
               is_reg_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISREGDISEDITABLE').AsString='Y' then
               is_reg_dis_editable := 'Y'
          else
               is_reg_dis_editable := 'N';
          is_reg_paytype_editable:= 'Y';

          //op
          if (UniQuery_Get.FieldByName('SCHE_OPBILLDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_OPBILLDISPER').AsString = '')   then
                 op_dis := '0'
          else
               op_dis := UniQuery_Get.FieldByName('SCHE_OPBILLDISPER').AsString;

          if UniQuery_Get.FieldByName('SCHE_ISOPBILLCRFACILITY').AsString='Y' then
               is_op_credit := 'Y'
          else
               is_op_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISOPBILLDISEDITABLE').AsString='Y' then
               is_op_dis_editable := 'Y'
          else
               is_op_dis_editable := 'N';
          is_op_paytype_editable:= 'Y';

          //ip
          if (UniQuery_Get.FieldByName('SCHE_IPBILLDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_IPBILLDISPER').AsString = '')   then
                 ip_dis := '0'
          else
               ip_dis := UniQuery_Get.FieldByName('SCHE_IPBILLDISPER').AsString;

          if UniQuery_Get.FieldByName('SCHE_ISIPBILLCRFACILITY').AsString='Y' then
               is_ip_credit := 'Y'
          else
               is_ip_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISiPBILLDISEDITABLE').AsString='Y' then
               is_ip_dis_editable := 'Y'
          else
               is_ip_dis_editable := 'N';
          is_ip_paytype_editable:= 'Y';


           //admn
          if (UniQuery_Get.FieldByName('SCHE_ADMNDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_ADMNDISPER').AsString = '')   then
                 admn_dis := '0'
          else
               admn_dis := UniQuery_Get.FieldByName('SCHE_ADMNDISPER').AsString;


          is_admn_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISADMNDISEDITABLE').AsString='Y' then
               is_admn_dis_editable := 'Y'
          else
               is_admn_dis_editable := 'N';


          //bed
          if (UniQuery_Get.FieldByName('SCHE_BEDDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_BEDDISPER').AsString = '')   then
                 bed_dis := '0'
          else
               bed_dis := UniQuery_Get.FieldByName('SCHE_BEDDISPER').AsString;


          is_bed_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISBEDDISEDITABLE').AsString='Y' then
               is_bed_dis_editable := 'Y'
          else
               is_bed_dis_editable := 'N';

          //phar
           if UniQuery_Get.FieldByName('SCHE_ISPHARMACYDISCOUNTSCHEME').AsString='Y' then
               is_phar := 'Y'
          else
               is_phar := 'N';

          //phar op

           if (UniQuery_Get.FieldByName('SCHE_PHOPDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_PHOPDISPER').AsString = '')   then
                 phar_op_dis := '0'
          else
                phar_op_dis := UniQuery_Get.FieldByName('SCHE_PHOPDISPER').AsString;

          if UniQuery_Get.FieldByName('SCHE_ISPHOPCRFACILITY').AsString='Y' then
               is_phar_op_credit := 'Y'
          else
               is_phar_op_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISPHOPDISEDITABLE').AsString='Y' then
               is_phar_op_dis_editable := 'Y'
          else
               is_phar_op_dis_editable := 'N';
          is_phar_op_paytype_editable:= 'Y';

          //phar ip

           if (UniQuery_Get.FieldByName('SCHE_PHIPDISPER').AsString = '0') or (UniQuery_Get.FieldByName('SCHE_PHIPDISPER').AsString = '')   then
                 phar_ip_dis := '0'
          else
                phar_ip_dis := UniQuery_Get.FieldByName('SCHE_PHIPDISPER').AsString;

          if UniQuery_Get.FieldByName('SCHE_ISPHIPCRFACILITY').AsString='Y' then
               is_phar_ip_credit := 'Y'
          else
               is_phar_ip_credit := 'N';
          if UniQuery_Get.FieldByName('SCHE_ISPHIPDISEDITABLE').AsString='Y' then
               is_phar_ip_dis_editable := 'Y'
          else
               is_phar_ip_dis_editable := 'N';
          is_phar_ip_paytype_editable:= 'Y';


           if UniQuery_Get.FieldByName('SCHE_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
               is_active := 'Y';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
               is_active := 'N';
          end;
          created_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';

          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('INSERT INTO schemes (');
               sql.Add('id,community_id,code,"name",valid_from_bs,valid_to_bs,');
               sql.Add('reg_dis,is_reg_credit,is_reg_dis_editable,is_reg_paytype_editable,op_dis,is_op_credit,');
               sql.Add('is_op_dis_editable,is_op_paytype_editable,ip_dis,is_ip_credit,is_ip_dis_editable,is_ip_paytype_editable,');
               sql.Add('admn_dis,is_admn_credit,is_admn_dis_editable,bed_dis,is_bed_credit,is_bed_dis_editable,is_phar,phar_ip_dis,');
               sql.add('is_phar_ip_credit,is_phar_ip_dis_editable,is_phar_ip_paytype_editable,phar_op_dis,is_phar_op_credit');
               sql.Add(',is_phar_op_dis_editable,is_phar_op_paytype_editable,created_by,organization_id,sub_organization_id');
               sql.add(',archived_by,archived_at,created_at) VALUES ( ');
               sql.Add(id);
               sql.Add(','+QuotedStr(community_id));
               sql.Add(','+QuotedStr(code));
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(valid_from_bs));
               sql.Add(','+QuotedStr(valid_to_bs));
               sql.Add(','+reg_dis);
               sql.Add(','+QuotedStr(is_reg_credit));
               sql.Add(','+QuotedStr(is_reg_dis_editable));
               sql.Add(','+QuotedStr(is_reg_paytype_editable));

               sql.Add(','+op_dis);
               sql.Add(','+QuotedStr(is_op_credit));
               sql.Add(','+QuotedStr(is_op_dis_editable));
               sql.Add(','+QuotedStr(is_op_paytype_editable));

               sql.Add(','+ip_dis);
               sql.Add(','+QuotedStr(is_ip_credit));
               sql.Add(','+QuotedStr(is_ip_dis_editable));
               sql.Add(','+QuotedStr(is_ip_paytype_editable));

               sql.Add(','+admn_dis);
               sql.Add(','+QuotedStr(is_admn_credit));
               sql.Add(','+QuotedStr(is_admn_dis_editable));

               sql.Add(','+bed_dis);
               sql.Add(','+QuotedStr(is_bed_credit));
               sql.Add(','+QuotedStr(is_bed_dis_editable));

               sql.Add(','+QuotedStr( is_phar));


               sql.Add(','+phar_ip_dis );
               sql.Add(','+QuotedStr( is_phar_ip_credit));
               sql.Add(','+QuotedStr( is_phar_ip_dis_editable));
               sql.Add(','+QuotedStr( is_phar_ip_paytype_editable));

               sql.Add(','+phar_op_dis );
               sql.Add(','+QuotedStr( is_phar_op_credit));
               sql.Add(','+QuotedStr( is_phar_op_dis_editable));
               sql.Add(','+QuotedStr( is_phar_op_paytype_editable));


               sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_by)  ;
                    sql.Add(','+archived_at)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_by))  ;
                    sql.Add(','+QuotedStr(archived_at))  ;
               end;


               sql.Add(','+QuotedStr(created_at));
               sql.Add(')');
               ExecSQL;
          end;

          UniQuery_Get.Next;
     end;
     if UniQuery_Get.RecordCount>0 then
          SetMaxID('schemes_id_seq','schemes',gs_Connection_PA);
end;

procedure TForm_Main.BitBtn2Click(Sender: TObject);
     var
id,test_package_id,test_name_id,remarks,display_order,
quantity,created_by,updated_by
,organization_id,sub_organization_id,created_at , archived_by , archived_at, max_id :string;
begin

     max_id := GetMaxID('test_package_details','id',gs_Connection_PA);

     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_TEPD_TESTPACKAGEDETAIL hdd where TEPD_TESTPACKAGEDETAILID > '+max_id+' order by TEPD_TESTPACKAGEDETAILID');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin

          id := UniQuery_Get.FieldByName('TEPD_TESTPACKAGEDETAILID').AsString;
          test_package_id :=   UniQuery_Get.FieldByName('TEPD_TESTPACKAGEID').AsString;
          test_name_id := UniQuery_Get.FieldByName('TEPD_TESTNAMEID').AsString;
          remarks :=  UniQuery_Get.FieldByName('TEPD_REMARKS').AsString;
          quantity  :=   '1';
          display_order :=  UniQuery_Get.FieldByName('TEPD_DISPLAYORDER').AsString;
          if display_order='' then
               display_order := '0';
          if UniQuery_Get.FieldByName('TEPD_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
          end;
          created_by := '191';
          organization_id := '193';
          sub_organization_id  := '1';
          created_at := '2023-01-01 00:00:00';


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('INSERT INTO test_package_details (');
               sql.Add('id,test_package_id,test_name_id,remarks,');
               sql.Add('     quantity,created_by');
               sql.Add(',organization_id,sub_organization_id,created_at,archived_at , archived_by,display_order)');
               sql.Add('VALUES ( ');
               sql.Add(id);
               sql.Add(','+test_package_id);
               sql.Add(','+test_name_id);
               if remarks='' then
               sql.Add(',NULL')
               else
               sql.Add(','+QuotedStr(remarks));
               sql.Add(','+quantity);

               sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
                if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+display_order);
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;
     if UniQuery_Get.RecordCount>0 then
          SetMaxID('test_package_details_id_seq','test_package_details',gs_Connection_PA);


     max_id := GetMaxID('test_package_details','id',gs_Connection_LAB);

     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_TEPD_TESTPACKAGEDETAIL hdd where TEPD_TESTPACKAGEDETAILID > '+max_id+' order by TEPD_TESTPACKAGEDETAILID');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin

          id := UniQuery_Get.FieldByName('TEPD_TESTPACKAGEDETAILID').AsString;
          test_package_id :=   UniQuery_Get.FieldByName('TEPD_TESTPACKAGEID').AsString;
          test_name_id := UniQuery_Get.FieldByName('TEPD_TESTNAMEID').AsString;
          remarks :=  UniQuery_Get.FieldByName('TEPD_REMARKS').AsString;
          quantity  :=   '1';
          display_order :=  UniQuery_Get.FieldByName('TEPD_DISPLAYORDER').AsString;
          if display_order='' then
               display_order := '0';
          if UniQuery_Get.FieldByName('TEPD_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
          end;
          created_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_LAB;
               sql.Add('INSERT INTO test_package_details (');
               sql.Add('id,test_package_id,test_name_id,remarks,');
               sql.Add('     quantity,created_by');
               sql.Add(',organization_id,sub_organization_id,created_at,archived_at , archived_by,updated_by,display_order)');
               sql.Add('VALUES ( ');
               sql.Add(id);
               sql.Add(','+test_package_id);
               sql.Add(','+test_name_id);
               if remarks='' then
               sql.Add(',NULL')
               else
               sql.Add(','+QuotedStr(remarks));
               sql.Add(','+quantity);

               sql.Add(','+created_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
                if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+created_by);
               sql.Add(','+display_order);
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;

end;

procedure TForm_Main.BitBtn3Click(Sender: TObject);
var
max_id: string;

id,patient_id,hospital_no,patient_age,patient_age_type
,patient_type_code,visit_date_vs,
visit_date_ad,employee_id,department_id,ref_employee_id,ref_department_id,
scheme_id,scheme_code,claim_code,scheme_code_id,scheme_type,sub_product_id,member_id,
visit_count,visit_type,billing_status,check_up_status,
is_cancel,cancel_date,cancel_date_vs,cancel_by,emergency_no,queue_no,queue_type,remarks,
created_by,organization_id,sub_organization_id,created_at,version_info:string;
patient_info:TStringList;
begin
     max_id := GetMaxID('patient_visits','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT count(1) cnt FROM HS_PAVI_PATIENTVISIT P where PAVI_PATIENTVISITID > '+max_id+' order by PAVI_PATIENTVISITID');
          open;
     end;
     ProgressBar1.Max :=  UniQuery_Get.FieldByName('cnt').AsInteger;
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT p.*,getengdatefromnep(PAVI_VISITDATE) VISITDATEAD ,getengdatefromnep(PAVI_VISITCANCELDATE) VISITCANCELDATEAD FROM HS_PAVI_PATIENTVISIT P where PAVI_PATIENTVISITID > '+max_id+' order by PAVI_PATIENTVISITID');
          open;
     end;
     ProgressBar1.Position := 0;
      ProgressBar1.Min := 0;
      UniQuery_Get.First;
      Label1.Caption := '';
      Label1.Parent := progressBar1;
     Label1.AutoSize := False;
     Label1.Transparent := True;
     Label1.Top :=  0;
     Label1.Left :=  0;
     Label1.Width := progressBar1.ClientWidth;
     Label1.Height := progressBar1.ClientHeight;
     Label1.Alignment := taCenter;
     Label1.Layout := tlCenter;
     while not UniQuery_Get.Eof do
     begin
          patient_info := GetPatientID(UniQuery_Get.FieldByName('PAVI_PATIENTID').AsString) ;
           id := UniQuery_Get.FieldByName('PAVI_PATIENTVISITID').AsString;
          patient_id := patient_info[0];
          hospital_no := UniQuery_Get.FieldByName('PAVI_PATIENTID').AsString;
          patient_age := patient_info[1];
          patient_age_type :=  patient_info[2];
          patient_type_code := UniQuery_Get.FieldByName('PAVI_PATIENTTYPECODE').AsString;
          if patient_type_code='' then
               patient_type_code := 'GEN';

          visit_date_vs := StringReplace(UniQuery_Get.FieldByName('PAVI_VISITDATE').AsString,'/','-',[rfReplaceAll]);
          visit_date_ad := StringReplace(UniQuery_Get.FieldByName('VISITDATEAD').AsString,'/','-',[rfReplaceAll]);
          employee_id :=  UniQuery_Get.FieldByName('PAVI_DOCID').AsString ;
          department_id :=  UniQuery_Get.FieldByName('PAVI_DEPID').AsString ;
          ref_employee_id :=  '0';
          ref_department_id := UniQuery_Get.FieldByName('PAVI_DEPID').AsString ;
          scheme_id := UniQuery_Get.FieldByName('PAVI_SCHEMEID').AsString ;
          scheme_code :=  '';
          claim_code := '';
          scheme_code_id := '';
          scheme_type := '';
          sub_product_id := '';
          member_id := '';
          visit_count := UniQuery_Get.FieldByName('PAVI_VISITCOUNT').AsString ;
          visit_type :=  UniQuery_Get.FieldByName('PAVI_VISITTYPE').AsString ;
          billing_status := 'N' ;
          check_up_status :='N' ;
          is_cancel :=  UniQuery_Get.FieldByName('PAVI_ISVISITCANCEL').AsString ;
          cancel_date :=   StringReplace(UniQuery_Get.FieldByName('PAVI_VISITCANCELDATE').AsString,'/','-',[rfReplaceAll]);
          cancel_date_vs :=StringReplace(UniQuery_Get.FieldByName('VISITCANCELDATEAD').AsString,'/','-',[rfReplaceAll]);
          cancel_by :=   '';
          emergency_no := UniQuery_Get.FieldByName('PAVI_EMERGENCYNO').AsString;
          queue_no := UniQuery_Get.FieldByName('PAVI_DOCWISEQUEUENO').AsString;
          queue_type := 'DOCWISE';
          version_info := 'PATCHv1.0';
          if (queue_no='0') or (queue_no='') then
          begin
               queue_no := UniQuery_Get.FieldByName('PAVI_DEPWISEQUEUENO').AsString;
               queue_type := 'DEPWISE'
          end;

          if (queue_no='0') or (queue_no='') then
          begin
               queue_no := '';
               queue_type := ''
          end;

          remarks:= UniQuery_Get.FieldByName('PAVI_REMARKS').AsString;
          created_by :=  UniQuery_Get.FieldByName('PAVI_DATAPOSTBY').AsString;
          if (created_by='0') or (created_by='') then
          begin
               created_by := '1';
          end;

          organization_id := '193';
          sub_organization_id := '191';
          created_at :=  StringReplace(UniQuery_Get.FieldByName('VISITDATEAD').AsString,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('PAVI_VISITTIME').AsString;
          gs_Connection_PA.StartTransaction;
          try
               with UniQuery_Put do
               begin
                    close;
                    sql.Clear;
                    Connection := gs_Connection_PA;
                    sql.Add('insert into patient_visits(');
                    sql.Add('id,patient_id,hospital_no,patient_age,patient_age_type');
                    sql.Add(',patient_type_code,visit_date_vs,');
                    sql.Add('visit_date_ad,employee_id,department_id,ref_employee_id,ref_department_id,');
                    sql.Add('scheme_id,scheme_code,claim_code,scheme_code_id,scheme_type,sub_product_id,member_id,');
                    sql.Add('visit_count,visit_type,billing_status,check_up_status, ');
                    sql.Add('is_cancel,cancel_date,cancel_date_vs,cancel_by,emergency_no,queue_no,queue_type,remarks, ');
                    sql.Add('created_by,organization_id,sub_organization_id,created_at,version_info');
                    sql.Add(')');
                    sql.Add('values(');
                    sql.Add(id);
                    sql.Add(','+patient_id);
                    sql.Add(','+QuotedStr(hospital_no));
                    sql.Add(','+patient_age);
                    sql.Add(','+QuotedStr(patient_age_type));
                    sql.Add(','+QuotedStr(patient_type_code));
                    sql.Add(','+QuotedStr(visit_date_vs));
                    sql.Add(','+QuotedStr(visit_date_ad));
                    if (employee_id='0') or (employee_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+employee_id);

                    if (department_id='0') or (department_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+department_id);

                    if (ref_employee_id='0') or (ref_employee_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+ref_employee_id);

                    if (ref_department_id='0') or (ref_department_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+ref_department_id);

                    if (scheme_id='0') or (scheme_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+scheme_id);

                    if (scheme_code='0') or (scheme_code='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+QuotedStr(scheme_code));

                    if (claim_code='0') or (claim_code='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+QuotedStr(claim_code));


                    if (scheme_code_id='0') or (scheme_code_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+scheme_code_id);

                    if (scheme_type='0') or (scheme_type='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+QuotedStr(scheme_type));

                    if (sub_product_id='0') or (sub_product_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+sub_product_id);

                    if (member_id='0') or (member_id='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+member_id);

                    sql.Add(','+visit_count);

                    sql.Add(','+QuotedStr(visit_type));
                    sql.Add(','+QuotedStr(billing_status));
                    sql.Add(','+QuotedStr(check_up_status));
                    if is_cancel = 'Y' then
                    begin
                          sql.Add(','+QuotedStr(is_cancel));
                          sql.Add(','+QuotedStr(cancel_date));
                          sql.Add(','+QuotedStr(cancel_date_vs));
                          if (cancel_by='0') or (cancel_by='') then
                              sql.Add(',NULL')
                          else
                              sql.Add(','+cancel_by);
                    end
                    else
                    begin
                          sql.Add(',''N''') ;
                          sql.Add(',NULL');
                          sql.Add(',NULL');
                          sql.Add(',NULL');
                    end;

                    if (emergency_no='0') or (emergency_no='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+QuotedStr(emergency_no));

                    if (queue_no='0') or (queue_no='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+queue_no);

                    if (queue_type='0') or (queue_type='') then
                         sql.Add(',NULL')
                    else
                         sql.Add(','+QuotedStr(queue_type));


                    sql.Add(','+QuotedStr(remarks));

                    sql.Add(','+created_by);
                    sql.Add(','+organization_id);
                    sql.Add(','+sub_organization_id);
                    sql.Add(','+QuotedStr(created_at));
                    sql.Add(','+QuotedStr(version_info));
                    sql.Add(')');
                    sql.SaveToFile('C:/patientvisits.txt');
                    ExecSQL;
               end;
               gs_Connection_PA.Commit;
               ProgressBar1.Position := ProgressBar1.Position+1;
               Label1.Caption := 'Total Rows Inserted: '+ IntToStr(ProgressBar1.Position)+'/'+IntToStr(ProgressBar1.Max);

          except
               gs_Connection_PA.Rollback;
               Label1.Caption := 'Total Rows Inserted: '+ IntToStr(ProgressBar1.Position)+'/'+IntToStr(ProgressBar1.Max);
               ProgressBar1.State := pbsError;
               exit;
          end;
          UniQuery_Get.Next;
     end;
      if UniQuery_Get.RecordCount>0 then
          SetMaxID('patient_visits_id_seq','patient_visits',gs_Connection_PA);
end;

procedure TForm_Main.BitBtn_DepartmentClick(Sender: TObject);
var
max_id,id,ls_name,code,department_id,display_order,is_service,is_clinical
,is_diagnostic,is_accounting,is_inventory,is_hr,is_ward,ls_type,IS_active,
archived_by,archived_at,
created_by,updated_by,organization_id,sub_organization_id,
created_at,updated_at:string;
begin
     try
     with UniQuery_Get do
          begin
               close;
               Connection := gs_SrcConnection;
               sql.Clear;
               sql.Add('alter table HS_DEPT_DEPARTMENT add DEPT_ISEMERGENCYDEPT  char(1) default ''N''');
               ExecSQL;
          end;
     Except
          on E: EUniError do
          begin

          end;
     end;

     try
     with UniQuery_Get do
          begin
               close;
               Connection := gs_SrcConnection;
               sql.Clear;
               sql.Add('alter table HS_DEPT_DEPARTMENT add DEPT_ISACTIVE  char(1) default ''Y''');
               ExecSQL;
          end;
     Except
          on E: EUniError do
          begin

          end;
     end;

     max_id := GetMaxID('departments','id',gs_Connection_UM);

     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_DEPT_DEPARTMENT hdd where dept_depid > '+max_id+' order by dept_depid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin

          id := UniQuery_Get.FieldByName('dept_depid').AsString;
          ls_name := UniQuery_Get.FieldByName('dept_depname').AsString;
          code :=   UniQuery_Get.FieldByName('dept_depcode').AsString;
          if (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '')   then
               department_id :=   'NULL'
          else
               department_id :=  UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString ;

          if (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '')   then
               display_order := 'NULL'
          else
               display_order := UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString;

          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')   then
               is_service := 'N'
          else
               is_service := 'Y';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'C') then
               is_clinical := 'Y'
          else
               is_clinical := 'N';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R') then
               is_diagnostic := 'Y'
          else
              is_diagnostic := 'N';
          is_accounting := 'Y';
          is_inventory := 'N' ;
          is_hr := 'Y';
          is_ward := 'N';
          if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P' then
               ls_type :='PATHO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R' then
               ls_type :='RADIO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H' then
               ls_type :='HISTO'
          else if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')  then
               ls_type :='EMR'
          else if (UniQuery_Get.FieldByName('DEPT_ISFEMININEDEPT').AsString = 'Y')  then
               ls_type :='FEM'
//          else if (UniQuery_Get.FieldByName('DEPT_ISCHILDDEPT').AsString = 'Y')  then
//               ls_type :='FEM'
          else
               ls_type := 'NULL';

          if UniQuery_Get.FieldByName('DEPT_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
               is_active := 'Y';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
               is_active := 'N';
          end;
          created_by := '1';
          updated_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';
          updated_at := '2023-01-01 00:00:00';


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_UM;
               sql.Add('INSERT INTO departments (');
               sql.Add('id,"name",code,department_id,display_order,is_service,is_clinical ');
               sql.Add(',is_diagnostic,is_accounting,is_inventory,is_hr,is_ward,"type",active,');
               sql.Add('archived_at, archived_by, ');
               sql.Add('created_by,updated_by,organization_id,sub_organization_id,');
               sql.Add('created_at, updated_at) VALUES ( ');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(code));
               sql.Add(','+department_id);
               sql.Add(','+display_order);
               sql.Add(','+QuotedStr(is_service));
               sql.Add(','+QuotedStr(is_clinical));
               sql.Add(','+QuotedStr(is_diagnostic));
               sql.Add(','+QuotedStr(is_accounting));
               sql.Add(','+QuotedStr(is_inventory));
               sql.Add(','+QuotedStr(is_hr));
               sql.Add(','+QuotedStr(is_ward));
               if ls_type = 'NULL' then
                     sql.Add(','+ls_type)
               else
                    sql.Add(','+QuotedStr(ls_type));
               sql.Add(','+QuotedStr(IS_active));
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+created_by);
               sql.Add(','+updated_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(','+QuotedStr(updated_at));
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;
     if UniQuery_Get.RecordCount>0 then
          SetMaxID('departments_id_seq','departments',gs_Connection_UM);



     max_id := GetMaxID('departments','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_DEPT_DEPARTMENT hdd where dept_depid > '+max_id+' order by dept_depid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin

          id := UniQuery_Get.FieldByName('dept_depid').AsString;
          ls_name := UniQuery_Get.FieldByName('dept_depname').AsString;
          code :=   UniQuery_Get.FieldByName('dept_depcode').AsString;
          if (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '')   then
               department_id :=   'NULL'
          else
               department_id :=  UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString ;

          if (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '')   then
               display_order := 'NULL'
          else
               display_order := UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString;

          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')   then
               is_service := 'N'
          else
               is_service := 'Y';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'C') then
               is_clinical := 'Y'
          else
               is_clinical := 'N';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R') then
               is_diagnostic := 'Y'
          else
              is_diagnostic := 'N';
          is_accounting := 'Y';
          is_inventory := 'N' ;
          is_hr := 'Y';
          is_ward := 'N';
          if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P' then
               ls_type :='PATHO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R' then
               ls_type :='RADIO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H' then
               ls_type :='HISTO'
          else if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')  then
               ls_type :='EMR'
          else if (UniQuery_Get.FieldByName('DEPT_ISFEMININEDEPT').AsString = 'Y')  then
               ls_type :='FEM'
//          else if (UniQuery_Get.FieldByName('DEPT_ISCHILDDEPT').AsString = 'Y')  then
//               ls_type :='FEM'
          else
               ls_type := 'NULL';

          if UniQuery_Get.FieldByName('DEPT_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
               is_active := 'Y';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
               is_active := 'N';
          end;
          created_by := '1';
          updated_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';
          updated_at := '2023-01-01 00:00:00';


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('INSERT INTO departments (');
               sql.Add('id,"name",code,department_id,display_order,is_service,is_clinical ');
               sql.Add(',is_diagnostic,is_accounting,is_inventory,is_hr,is_ward,"type",active,');
               sql.Add('archived_at, archived_by, ');
               sql.Add('created_by,updated_by,organization_id,sub_organization_id,');
               sql.Add('created_at, updated_at) VALUES ( ');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(code));
               sql.Add(','+department_id);
               sql.Add(','+display_order);
               sql.Add(','+QuotedStr(is_service));
               sql.Add(','+QuotedStr(is_clinical));
               sql.Add(','+QuotedStr(is_diagnostic));
               sql.Add(','+QuotedStr(is_accounting));
               sql.Add(','+QuotedStr(is_inventory));
               sql.Add(','+QuotedStr(is_hr));
               sql.Add(','+QuotedStr(is_ward));
               if ls_type = 'NULL' then
                     sql.Add(','+ls_type)
               else
                    sql.Add(','+QuotedStr(ls_type));
               sql.Add(','+QuotedStr(IS_active));
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+created_by);
               sql.Add(','+updated_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(','+QuotedStr(updated_at));
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;


      max_id := GetMaxID('departments','id',gs_Connection_Lab);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('SELECT * FROM HS_DEPT_DEPARTMENT hdd where dept_depid > '+max_id+' order by dept_depid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin

          id := UniQuery_Get.FieldByName('dept_depid').AsString;
          ls_name := UniQuery_Get.FieldByName('dept_depname').AsString;
          code :=   UniQuery_Get.FieldByName('dept_depcode').AsString;
          if (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString = '')   then
               department_id :=   'NULL'
          else
               department_id :=  UniQuery_Get.FieldByName('DEPT_PARENTDEPID').AsString ;

          if (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '0') or (UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString = '')   then
               display_order := 'NULL'
          else
               display_order := UniQuery_Get.FieldByName('DEPT_DEPORDER').AsString;

          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')   then
               is_service := 'N'
          else
               is_service := 'Y';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'C') then
               is_clinical := 'Y'
          else
               is_clinical := 'N';
          if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H') or
             (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R') then
               is_diagnostic := 'Y'
          else
              is_diagnostic := 'N';
          is_accounting := 'Y';
          is_inventory := 'N' ;
          is_hr := 'Y';
          is_ward := 'N';
          if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'P' then
               ls_type :='PATHO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'R' then
               ls_type :='RADIO'
          else if UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'H' then
               ls_type :='HISTO'
          else if (UniQuery_Get.FieldByName('DEPT_DEPTYPE').AsString = 'E') or (UniQuery_Get.FieldByName('DEPT_ISEMERGENCYDEPT').AsString = 'Y')  then
               ls_type :='EMR'
          else if (UniQuery_Get.FieldByName('DEPT_ISFEMININEDEPT').AsString = 'Y')  then
               ls_type :='FEM'
//          else if (UniQuery_Get.FieldByName('DEPT_ISCHILDDEPT').AsString = 'Y')  then
//               ls_type :='FEM'
          else
               ls_type := 'NULL';

          if UniQuery_Get.FieldByName('DEPT_ISACTIVE').AsString='Y' then
          begin
               archived_at := 'NULL';
               archived_by := 'NULL';
               is_active := 'Y';
          end
          else
          begin
               archived_at := '2023-01-01 00:00:00';
               archived_by := '1' ;
               is_active := 'N';
          end;
          created_by := '1';
          updated_by := '1';
          organization_id := '193';
          sub_organization_id  := '191';
          created_at := '2023-01-01 00:00:00';
          updated_at := '2023-01-01 00:00:00';


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_Lab;
               sql.Add('INSERT INTO departments (');
               sql.Add('id,"name",code,department_id,display_order,is_service,is_clinical ');
               sql.Add(',is_diagnostic,is_accounting,is_inventory,is_hr,is_ward,"type",active,');
               sql.Add('archived_at, archived_by, ');
               sql.Add('created_by,updated_by,organization_id,sub_organization_id,');
               sql.Add('created_at, updated_at) VALUES ( ');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(code));
               sql.Add(','+department_id);
               sql.Add(','+display_order);
               sql.Add(','+QuotedStr(is_service));
               sql.Add(','+QuotedStr(is_clinical));
               sql.Add(','+QuotedStr(is_diagnostic));
               sql.Add(','+QuotedStr(is_accounting));
               sql.Add(','+QuotedStr(is_inventory));
               sql.Add(','+QuotedStr(is_hr));
               sql.Add(','+QuotedStr(is_ward));
               if ls_type = 'NULL' then
                     sql.Add(','+ls_type)
               else
                    sql.Add(','+QuotedStr(ls_type));
               sql.Add(','+QuotedStr(IS_active));
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.Add(','+created_by);
               sql.Add(','+updated_by);
               sql.Add(','+organization_id);
               sql.Add(','+sub_organization_id);
               sql.Add(','+QuotedStr(created_at));
               sql.Add(','+QuotedStr(updated_at));
               sql.Add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;
end;

procedure TForm_Main.BitBtn_UsersClick(Sender: TObject);
var
max_id,id,ls_name,username,email,u_password,created_at,created_by,archived_at,archived_by,is_active:string;
int_is_active:Integer;
begin
     max_id := GetMaxID('users','id',gs_Connection_UM);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          if gs_orgnamecode='PPL' then
          sql.Add('select u.*, getengdatefromnep(DATAPOSTDATE) createdatead from LAB_USERMAIN u where userid > '+max_id+' order by userid')
          else
          sql.Add('select u.*, getengdatefromnep(USMA_USERCREATEDATE) createdatead from hs_usma_usermain u where usma_userid > '+max_id+' order by usma_userid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin
          if gs_orgnamecode='PPL' then
          BEGIN
               id := UniQuery_Get.FieldByName('USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               u_password :=  '$2y$10$iH8fyS4QAPorjOe68AXl8.1Y0B7Fn2QxvurXrGf.huPfylhp0.XgG';//UniQuery_Get.FieldByName('UPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('DATAPOSTTIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('DATAPOSTTIME').AsString;
               created_by := '1' ;
               if (UniQuery_Get.FieldByName('ISACTIVE').AsString='Y') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='T') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='') then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
                    int_is_active := 1;
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
                    int_is_active := 0;
               end;
          END
          else
          begin
               id := UniQuery_Get.FieldByName('USMA_USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('USMA_FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USMA_USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USMA_EMAIl').AsString;
               u_password :=  UniQuery_Get.FieldByName('USMA_USERPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USMA_USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString;
               created_by := '1' ;
               if UniQuery_Get.FieldByName('USMA_ISACTIVE').AsString='Y' then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
               end;
          end;


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_UM;
               sql.Add('insert into users(id,name,username,email,"password",created_at,created_by,is_active,archived_at,archived_by) values(');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(username)) ;
               sql.Add(','+QuotedStr(email))  ;
               sql.Add(','+QuotedStr(u_password))  ;
               sql.Add(','+QuotedStr(created_at))  ;
               sql.Add(','+QuotedStr(created_by))  ;
               sql.Add(','+QuotedStr(is_active))  ;
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.add(')');
               ExecSQL;
          end;
          UniQuery_Get.Next;
     end;
     if UniQuery_Get.RecordCount>0 then
          SetMaxID('users_id_seq','users',gs_Connection_UM);



     max_id := GetMaxID('users','id',gs_Connection_PA);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          if gs_orgnamecode='PPL' then
          sql.Add('select u.*, getengdatefromnep(DATAPOSTDATE) createdatead from LAB_USERMAIN u where userid > '+max_id+' order by userid')
          else
          sql.Add('select u.*, getengdatefromnep(USMA_USERCREATEDATE) createdatead from hs_usma_usermain u where usma_userid > '+max_id+' order by usma_userid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin
          if gs_orgnamecode='PPL' then
          BEGIN
               id := UniQuery_Get.FieldByName('USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               u_password :=  UniQuery_Get.FieldByName('UPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('DATAPOSTTIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('DATAPOSTTIME').AsString;
               created_by := '1' ;
               if (UniQuery_Get.FieldByName('ISACTIVE').AsString='Y') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='T') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='') then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
               end;
          END
          else
          begin
               id := UniQuery_Get.FieldByName('USMA_USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('USMA_FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USMA_USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USMA_EMAIl').AsString;
               u_password :=  UniQuery_Get.FieldByName('USMA_USERPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USMA_USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString;
               created_by := '1' ;
               if UniQuery_Get.FieldByName('USMA_ISACTIVE').AsString='Y' then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
               end;
          end;


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_PA;
               sql.Add('insert into users(id,name,username,email,created_at,created_by,archived_at,archived_by) values(');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(username)) ;
               sql.Add(','+QuotedStr(email))  ;
             //  sql.Add(','+QuotedStr(u_password))  ;
               sql.Add(','+QuotedStr(created_at))  ;
               sql.Add(','+QuotedStr(created_by))  ;
              // sql.Add(','+QuotedStr(is_active))  ;
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.add(')');
               ExecSQL;
          end;


          UniQuery_Get.Next;
     end;


     max_id := GetMaxID('users','id',gs_Connection_Lab);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          if gs_orgnamecode='PPL' then
          sql.Add('select u.*, getengdatefromnep(DATAPOSTDATE) createdatead from LAB_USERMAIN u where userid > '+max_id+' order by userid')
          else
          sql.Add('select u.*, getengdatefromnep(USMA_USERCREATEDATE) createdatead from hs_usma_usermain u where usma_userid > '+max_id+' order by usma_userid');
          open;
     end;

     while not UniQuery_Get.Eof do
     begin
          if gs_orgnamecode='PPL' then
          BEGIN
               id := UniQuery_Get.FieldByName('USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               u_password :=  UniQuery_Get.FieldByName('UPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('DATAPOSTTIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('DATAPOSTTIME').AsString;
               created_by := '1' ;
               if (UniQuery_Get.FieldByName('ISACTIVE').AsString='Y') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='T') or (UniQuery_Get.FieldByName('ISACTIVE').AsString='') then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
               end;
          END
          else
          begin
               id := UniQuery_Get.FieldByName('USMA_USERID').AsString;
               ls_name := UniQuery_Get.FieldByName('USMA_FULLNAME').AsString;
               username := UniQuery_Get.FieldByName('USMA_USERNAME').AsString;
               email := UniQuery_Get.FieldByName('USMA_EMAIl').AsString;
               u_password :=  UniQuery_Get.FieldByName('USMA_USERPASSWORD').AsString;
               if email = '' then
               begin
                    email := UniQuery_Get.FieldByName('USMA_USERNAME').AsString+'@'+gs_orgnamecode+'.com';
               end;
               created_at := UniQuery_Get.FieldByName('createdatead').AsString;
               if UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString = '' then
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+'00:00:00'
               else
                    created_at := StringReplace(created_at,'/','-',[rfReplaceAll])+' '+UniQuery_Get.FieldByName('USMA_USERCREATETIME').AsString;
               created_by := '1' ;
               if UniQuery_Get.FieldByName('USMA_ISACTIVE').AsString='Y' then
               begin
                    archived_at := 'NULL';
                    archived_by := 'NULL' ;
                    is_active := 'Y';
                    int_is_active := 1;
               end
               else
               begin
                    archived_at := '2023-01-01 00:00:00';
                    archived_by := '1' ;
                    is_active := 'N';
                    int_is_active := 0;
               end;
          end;


          with UniQuery_Put do
          begin
               close;
               sql.Clear;
               Connection := gs_Connection_Lab;
               sql.Add('insert into users(id,name,username,is_active ,email,created_at,created_by,archived_at,archived_by) values(');
               sql.Add(id);
               sql.Add(','+QuotedStr(ls_name));
               sql.Add(','+QuotedStr(username)) ;
               sql.Add(','+IntToStr(int_is_active));
               sql.Add(','+QuotedStr(email))  ;
             //  sql.Add(','+QuotedStr(u_password))  ;
               sql.Add(','+QuotedStr(created_at))  ;
               sql.Add(','+QuotedStr(created_by))  ;
              // sql.Add(','+QuotedStr(is_active))  ;
               if archived_at='NULL' then
               begin
                    sql.Add(','+archived_at)  ;
                    sql.Add(','+archived_by)  ;
               end
               else
               begin
                    sql.Add(','+QuotedStr(archived_at))  ;
                    sql.Add(','+QuotedStr(archived_by))  ;
               end;
               sql.add(')');
               ExecSQL;
          end;


          UniQuery_Get.Next;
     end;

     with UniQuery_Put do
     begin
          close;
          sql.Clear;
          Connection := gs_Connection_UM;
          sql.Add('insert into user_details(id,user_id,organization_id,sub_organization_id)');
          sql.Add('(select id user_id ,id user_id,193 organization_id,191 sub_organization_id from ');
          sql.Add('users where id not in (select user_id from user_details)) ');
          ExecSQL;
     end;
     SetMaxID('user_details_id_seq','user_details',gs_Connection_UM);
end;


procedure TForm_Main.FormShow(Sender: TObject);
begin
  InitializeDataSet;
  DataSource1.DataSet := ClientDataSet1;
  DBGrid1.DataSource := DataSource1;
   AddDataToDataSet;

end;


procedure TForm_Main.AddDataToDataSet;
Var
TID:Integer;
begin
  TID := 1;
  if(gs_Srcdbusername_orcl_ini)<>'' then
  Begin
    ClientDataSet1.Append;
  ClientDataSet1.FieldByName('ID').AsInteger := TID;
  ClientDataSet1.FieldByName('ProviderName').AsString:= 'Oracle';
  ClientDataSet1.FieldbyName('Port').AsString:= gs_Srcdbport_orcl_ini;
  ClientDataSet1.FieldbyName('ServerIP').AsString:=gs_Srcdbserverini;
  ClientDataSet1.FieldbyName('Database').AsString:=gs_Srcdatabase_orcl_ini;
  ClientDataSet1.FieldbyName('UserName').AsString:=gs_Srcdbusername_orcl_ini;
  ClientDataSet1.Post;
    Inc(TID);
  end;
     {UserManagement}
     if(gs_Srcdbusername_pos_Umini)<>'' then
     Begin
  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('ID').AsInteger := TID;
  ClientDataSet1.FieldByName('ProviderName').AsString:= 'UserMangement';
  ClientDataSet1.FieldbyName('Port').AsString:= gs_Srcdbport_Pos_UmIni;
  ClientDataSet1.FieldbyName('ServerIP').AsString:=gs_Srcdbserver_Pos_UmIni;
  ClientDataSet1.FieldbyName('Database').AsString:=gs_Srcdatabase_Pos_Umini;
  ClientDataSet1.FieldbyName('UserName').AsString:=gs_Srcdbusername_pos_Umini;
    Inc(TID);
end;
    {Lab}
      if(gs_Srcdbusername_pos_labini)<>'' then
     Begin
  ClientDataSet1.Append;
  ClientDataSet1.FieldByName('ID').AsInteger := TID;
  ClientDataSet1.FieldByName('ProviderName').AsString:= 'Lab';
  ClientDataSet1.FieldbyName('Port').AsString:= gs_Srcdbport_Pos_labIni;
  ClientDataSet1.FieldbyName('ServerIP').AsString:=gs_Srcdbserver_Pos_labIni;
  ClientDataSet1.FieldbyName('Database').AsString:=gs_Srcdatabase_Pos_labini;
  ClientDataSet1.FieldbyName('UserName').AsString:=gs_Srcdbusername_pos_labini;
    ClientDataSet1.Post;
      Inc(TID);
   end;

   {Lab}
      if(gs_Srcdbusername_pos_Paini)<>'' then
    Begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('ID').AsInteger := TID;
    ClientDataSet1.FieldByName('ProviderName').AsString:= 'PA';
    ClientDataSet1.FieldbyName('Port').AsString:= gs_Srcdbport_Pos_PaIni;
    ClientDataSet1.FieldbyName('ServerIP').AsString:=gs_Srcdbserver_Pos_PaIni;
    ClientDataSet1.FieldbyName('Database').AsString:=gs_Srcdatabase_Pos_Paini;
    ClientDataSet1.FieldbyName('UserName').AsString:=gs_Srcdbusername_pos_Paini;
    ClientDataSet1.Post;
      Inc(TID);
   end;

end;

procedure TForm_Main.InitializeDataSet;
begin
  // Define the structure of the dataset
  ClientDataSet1.FieldDefs.Clear;
  ClientDataSet1.FieldDefs.Add('ID', ftInteger);
  ClientDataSet1.FieldDefs.Add('ProviderName', ftString, 50);
  ClientDataSet1.FieldDefs.Add('Port', ftString, 50);
  ClientDataSet1.FieldDefs.Add('ServerIP', ftString, 50);
  ClientDataSet1.FieldDefs.Add('Database', ftString, 50);
  ClientDataSet1.FieldDefs.Add('UserName', ftString, 50);
  ClientDataSet1.FieldDefs.Add('Value', ftFloat);
  ClientDataSet1.CreateDataSet;
end;



Procedure TForm_Main.SetMaxID(seq_name,table_name:string;Connection_Name:TUniConnection);
var
UniQuery:TUniQuery;
begin
     UniQuery := TUniQuery.Create(nil);
     with UniQuery do
     begin
          close;
          sql.Clear;
          Connection := Connection_Name;
          sql.Add('SELECT setval('+QuotedStr(seq_name)+', (SELECT MAX(id) FROM '+table_name+'))');
         // sql.SaveToFile('C:/hello.txt');
          open;
     end;
     UniQuery.Free;
end;


Function TForm_Main.GetPatientID(hospital_no:string):TStringList;
var
UniQuery:TUniQuery;
begin
     UniQuery := TUniQuery.Create(nil);
     with UniQuery do
     begin
          close;
          sql.Clear;
          Connection := gs_Connection_PA;
          sql.Add('SELECT id, age, age_type from patients where hospital_no='+QuotedStr(hospital_no));
          open;
     end;
          Result := TStringList.Create;
          Result.Add(UniQuery.FieldByName('id').AsString);
          Result.Add(UniQuery.FieldByName('age').AsString);
          Result.Add(UniQuery.FieldByName('age_type').AsString);
     UniQuery.Free;

end;




Function TForm_Main.GetMaxID(table_name,field_name:string;Connection_Name:TUniConnection):string;
var
UniQuery:TUniQuery;
begin
     UniQuery := TUniQuery.Create(nil);
     with UniQuery do
     begin
          close;
          sql.Clear;
          Connection := Connection_Name;
          sql.Add('SELECT COALESCE(max('+field_name+'),''0'') max_id from ' +table_name);
          sql.SaveToFile('C:/hello.txt');
          open;
     end;
     if UniQuery.FieldByName('max_id').AsInteger > 0  then
         Result := UniQuery.FieldByName('max_id').AsString
     else
          Result := '0';


     UniQuery.Free;
end;

end.
