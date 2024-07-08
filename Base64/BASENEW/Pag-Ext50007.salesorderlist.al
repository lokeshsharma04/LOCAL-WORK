pageextension 50007 "Sales order" extends "Sales Order List"
{
    actions
    {
        addafter("&Print")
        {

            action(Excelimport)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Excelimport: Codeunit ExcelImport;
                begin
                    Excelimport.ExcelImport3();
                end;
            }
            action(ExcelImportRep)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ExcelimportRep: Report ExcelReader;
                begin
                    ExcelimportRep.Run();

                end;
            }
            action(ExcelImportVia)
            {
                ApplicationArea = All;
                Caption = 'Excel Import New';
                trigger OnAction()
                var
                    CodeunitExcel: Codeunit "SO Import Excel";
                begin
                    CodeunitExcel.ExcelImport();
                end;
            }
            action(CurrDateTime)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CodeunitCurrdate: codeunit ErrorFileCreate;
                begin
                    CodeunitCurrdate.Run();
                end;
            }
        }
    }
}
