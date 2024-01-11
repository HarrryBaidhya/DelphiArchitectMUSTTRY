unit Unit_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ControlList, Vcl.WinXPickers,
  Vcl.WindowsStore, Vcl.ExtCtrls, Data.DB, MemDS, DBAccess, Uni, Vcl.StdCtrls,
  Vcl.Buttons, unit_DM, fxn, DAScript, UniScript;

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
    procedure BitBtn_UsersClick(Sender: TObject);
    procedure BitBtn_DepartmentClick(Sender: TObject);
    procedure BitBtn_PatientTypeClick(Sender: TObject);
    procedure BitBtn_TestNamesClick(Sender: TObject);
    procedure BitBtn_PatientsClick(Sender: TObject);
  private
    { Private declarations }
  public

     Procedure SetMaxID(seq_name,table_name:string; Connection_Name:TUniConnection);
     Function GetMaxID(table_name,field_name:string;Connection_Name:TUniConnection):string;
    { Public declarations }
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

procedure TForm_Main.BitBtn_PatientsClick(Sender: TObject);
begin
     try
          with UniQuery_Get do
          begin
               close;
               sql.Clear;
               Connection:= gs_SrcConnection;
               sql.Add('ALTER TABLE HS_DISTRICT ADD districtid_new integer');
               ExecSQL;
          end;
     except
          on E : Exception do
          begin
               ShowMessage(e.Message);
          end;
     end;
     with UniQuery_Get do
     begin
          close;
          sql.Clear;
          Connection:= gs_SrcConnection;
          sql.Add('UPDATE HS_DISTRICT SET districtid_new=districtid-79 WHERE DISTRICTID >75');
          ExecSQL;
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
     created_by := '1';
     organization_id:='1';
     sub_organization_id:='1';
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

end;

procedure TForm_Main.BitBtn_DepartmentClick(Sender: TObject);
var
max_id,id,ls_name,code,department_id,display_order,is_service,is_clinical
,is_diagnostic,is_accounting,is_inventory,is_hr,is_ward,ls_type,IS_active,
archived_by,archived_at,
created_by,updated_by,organization_id,sub_organization_id,
created_at,updated_at:string;
begin
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
          organization_id := '1';
          sub_organization_id  := '1';
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
end;

procedure TForm_Main.BitBtn_UsersClick(Sender: TObject);
var
max_id,id,ls_name,username,email,u_password,created_at,created_by,archived_at,archived_by,is_active:string;
begin
     max_id := GetMaxID('users','id',gs_Connection_UM);
     with UniQuery_Get do
     begin
          close;
          Connection := gs_SrcConnection;
          sql.Clear;
          sql.Add('select u.*, getengdatefromnep(USMA_USERCREATEDATE) createdatead from hs_usma_usermain u where usma_userid > '+max_id+' order by usma_userid');
          open;
     end;

     while not UniQuery_Get.Eof do
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
          sql.Add('SELECT max('+field_name+') max_id from ' +table_name);
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