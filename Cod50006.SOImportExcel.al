codeunit 50006 "SO Import Excel"
{
    /*
      #001 VJ 20230620 Created new object to import SO TO-2023052302
      1. Customer No.
      2. Ship to Code
      3. Document Date
      4. Order Date
      5.  Order Rec'd Date
      6.  Due Date
      7.  External Document No.
      8.  No.
      9.  Quantity
      10. Location Code
      11. Unit Price Excl. VAT
      12. Qty. to Ship
      13. Shipment Date
      14. Priority
      15. Serial Number
      16. Remarks
      17. Country/Region of Origin Code
    */
    procedure ExcelImport()
    var
        myInt: Integer;
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromServerFileName, Istream);
        if FromServerFileName <> '' then
            ServerFileName := FileManagement.GetFileName(FromServerFileName)
        else
            ERROR('File does not exit');
        IF SheetName = '' THEN
            SheetName := ExcelBuffer.SelectSheetsNameStream(Istream)
        else
            ERROR('');

        ExcelBuffer.DELETEALL;
        ExcelBuffer.LOCKTABLE;
        ExcelBuffer.OpenBookStream(Istream, SheetName);
        ExcelBuffer.ReadSheet;
        GetLastRowandColumn;

        Counter := 0;
        SONo := 101;
        IsError := false;

        FOR X := 2 TO TotalRows DO begin
            InsertData(X);
        end;
        ExcelBuffer.DELETEALL;
        // onpost
        if X = TotalRows then begin

            IF Counter = 0 THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text0009));
                IsError := TRUE;
                ShowWarning := TRUE;
            END;
            IF NOT ErrorFileCreated THEN BEGIN
                CreateSalesOrders;
            END;
            IF ErrorFileCreated THEN BEGIN
                // MyFile.CLOSE;
                ErroFileName := 'C:\Users\ERRORLOG' + '.txt';
                // cdu3TierMgt.DownloadTempFile(ErroFileName);
                // cdu3TierMgt.DownloadToFile(THFileName, ErroFileName);
                // FileManagement.DownloadTempFile(THFileName);
                TempBlob.CreateInStream(InS);
                TempBlob.CreateOutStream(OutS);
                OutS.WriteText(TxtBuilder.ToText());
                DownloadFromStream(InS, '', '', '', ErroFileName);
            END;
            IF ErrorFileCreated THEN BEGIN
                ERROR(Text0008, ErroFileName);
            END ELSE
                MESSAGE(Text00012);

            IF GUIALLOWED THEN BEGIN
                FileName := 'Test1';
            END;
        end;
    end;

    local procedure GetLastRowandColumn()
    begin
        ExcelBuffer.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuffer.COUNT;

        ExcelBuffer.RESET;
        IF ExcelBuffer.FINDLAST THEN
            TotalRows := ExcelBuffer."Row No.";
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): text
    begin
        IF ExcelBuffer.GET(RowNo, ColNo) THEN;
        EXIT(ExcelBuffer."Cell Value as Text");
    end;

    procedure InsertData(RowNo: Integer)
    begin
        //Integer - Import::OnAfterInsertRecord()       
        ImportField1 := GetValueAtCell(RowNo, 1);
        ImportField2 := GetValueAtCell(RowNo, 2);
        ImportField3 := GetValueAtCell(RowNo, 3);
        ImportField4 := GetValueAtCell(RowNo, 4);
        ImportField5 := GetValueAtCell(RowNo, 5);
        ImportField6 := GetValueAtCell(RowNo, 6);
        ImportField7 := GetValueAtCell(RowNo, 7);
        ImportField8 := GetValueAtCell(RowNo, 8);
        ImportField9 := GetValueAtCell(RowNo, 9);
        ImportField10 := GetValueAtCell(RowNo, 10);
        ImportField11 := GetValueAtCell(RowNo, 11);
        ImportField12 := GetValueAtCell(RowNo, 12);
        ImportField13 := GetValueAtCell(RowNo, 13);
        ImportField14 := GetValueAtCell(RowNo, 14);
        ImportField15 := GetValueAtCell(RowNo, 15);
        ImportField16 := GetValueAtCell(RowNo, 16);
        ImportField17 := GetValueAtCell(RowNo, 17);

        ImportFieldArr[1] := GetValueAtCell(RowNo, 1);
        ImportFieldArr[2] := GetValueAtCell(RowNo, 2);
        ImportFieldArr[3] := GetValueAtCell(RowNo, 3);
        ImportFieldArr[4] := GetValueAtCell(RowNo, 4);
        ImportFieldArr[5] := GetValueAtCell(RowNo, 5);
        ImportFieldArr[6] := GetValueAtCell(RowNo, 6);
        ImportFieldArr[7] := GetValueAtCell(RowNo, 7);
        ImportFieldArr[8] := GetValueAtCell(RowNo, 8);
        ImportFieldArr[9] := GetValueAtCell(RowNo, 9);
        ImportFieldArr[10] := GetValueAtCell(RowNo, 10);
        ImportFieldArr[11] := GetValueAtCell(RowNo, 11);
        ImportFieldArr[12] := GetValueAtCell(RowNo, 12);
        ImportFieldArr[13] := GetValueAtCell(RowNo, 13);
        ImportFieldArr[14] := GetValueAtCell(RowNo, 14);
        ImportFieldArr[15] := GetValueAtCell(RowNo, 15);
        ImportFieldArr[16] := GetValueAtCell(RowNo, 16);
        ImportFieldArr[17] := GetValueAtCell(RowNo, 17);

        IF NOT IsFirstRecord THEN BEGIN
            Counter += 1;
            IsError := FALSE;
            ValidateRecord;

            IF IsError = FALSE THEN BEGIN
                IF UPPERCASE(ImportFieldArr[7]) = PrevExternalOrderNo THEN BEGIN
                    InsertOrder := FALSE
                END ELSE BEGIN
                    InsertOrder := TRUE;
                END;
                PrevExternalOrderNo := ImportFieldArr[7];

                IF InsertOrder THEN BEGIN
                    LineNo := 0;

                    IF Customer.GET(ImportField1) THEN BEGIN
                        IF (ImportField2 <> '') THEN
                            ShipToAddress.GET(Customer."No.", ImportField2);

                        SONo := SONo + 1;
                        WITH SalesHeaderTemp DO BEGIN
                            INIT;
                            "Document Type" := "Document Type"::Order;
                            "No." := FORMAT(SONo);

                            "Sell-to Customer No." := Customer."No.";

                            IF ImportField3 <> '' THEN
                                EVALUATE("Document Date", ImportField3);

                            IF ImportField4 <> '' THEN
                                EVALUATE("Order Date", ImportField4);

                            IF ImportField5 <> '' THEN BEGIN
                                EVALUATE("Requested Delivery Date", ImportField5);
                                "Requested Delivery Date" := "Order Date";
                            END;

                            IF ImportField6 <> '' THEN
                                EVALUATE("Due Date", ImportField6);

                            "External Document No." := COPYSTR(ImportField7, 1, MAXSTRLEN("External Document No."));
                            "Ship-to Code" := ShipToAddress.Code;

                            "Posting Date" := "Order Date";
                            "Document Date" := "Order Date";

                            IF ImportField10 <> '' THEN BEGIN
                                Location.GET(ImportField10);
                                "Location Code" := ImportField10;
                            END;
                            IF ImportField13 <> '' THEN BEGIN
                                EVALUATE("Shipment Date", ImportField13);
                            END;
                            INSERT;
                        END;
                    END;
                END;
                WITH SalesLineTemp DO BEGIN
                    INIT;
                    "Document Type" := "Document Type"::Order;
                    "Document No." := FORMAT(SONo);
                    LineNo := LineNo + 10000;
                    "Line No." := LineNo;
                    "Sell-to Customer No." := Customer."No.";
                    Type := SalesLineTemp.Type::Item;
                    "No." := Item."No.";
                    IF ImportField9 <> '' THEN
                        EVALUATE(Quantity, ImportField9);
                    IF ImportField10 <> '' THEN
                        EVALUATE("Location Code", ImportField10);
                    IF ImportField11 <> '' THEN
                        EVALUATE("Unit Price", ImportField11);
                    IF ImportField12 <> '' THEN
                        EVALUATE("Qty. to Ship", ImportField12);
                    IF ImportField13 <> '' THEN
                        EVALUATE("Shipment Date", ImportField13);
                    IF ImportField14 <> '' THEN
                        EVALUATE(Priority, ImportField14);
                    IF ImportField15 <> '' THEN
                        EVALUATE("Serial Number", ImportField15);
                    IF ImportField16 <> '' THEN
                        EVALUATE(Remarks, ImportField16);
                    IF ImportField17 <> '' THEN
                        EVALUATE("Country/Region of Origin Code", ImportField17);
                    INSERT;
                END;
            END;
        END;
        IsFirstRecord := FALSE;
        // onAfterInitRecord
        ClearVar();

    end;

    PROCEDURE ValidateRecord();
    var
        IMPORT15: Integer;
    BEGIN

        IF ImportField1 = '' THEN BEGIN
            WriteErrorLog(STRSUBSTNO(Text0001, Counter));
            IsError := TRUE;
        END ELSE
            IF NOT Customer.GET(ImportField1) THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text0002, ImportField1, ImportField7));
                IsError := TRUE;
                ShowWarning := TRUE;
            END;

        IF (ImportField2 <> '') THEN
            IF NOT ShipToAddress.GET(Customer."No.", ImportField2) THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text0004, ImportField2, ImportField1));
                IsError := TRUE;
            END;

        IF NOT Item.GET(ImportField8) THEN BEGIN
            WriteErrorLog(STRSUBSTNO(Text0003, ImportField8, ImportField7, Counter));
            IsError := TRUE;
        END;

        IF ImportField7 <> '' THEN BEGIN
            SalesHeader2.RESET;
            SalesHeader2.SETRANGE("Document Type", SalesHeader2."Document Type"::Order);
            SalesHeader2.SETRANGE("External Document No.", ImportField7);
            IF SalesHeader2.FINDFIRST THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text0007, ImportField7, Counter));
                IsError := TRUE;
            END;

            SalesHeaderTemp.RESET;
            SalesHeaderTemp.SETRANGE("Document Type", SalesHeaderTemp."Document Type"::Order);
            SalesHeaderTemp.SETFILTER("Sell-to Customer No.", '<>%1', Customer."No.");
            SalesHeaderTemp.SETRANGE("External Document No.", ImportField7);
            IF SalesHeaderTemp.FINDFIRST THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text00011, ImportField7, Counter));
                IsError := TRUE;
            END;
        END;

        // IF ImportField9 = '' THEN BEGIN
        //     WriteErrorLog(STRSUBSTNO(Text0005, ImportField14, ImportField7));
        //     IsError := TRUE;
        // END;
        IF ImportField9 = '0' THEN BEGIN
            WriteErrorLog(STRSUBSTNO(Text0005, ImportField9, ImportField7));
            IsError := TRUE;
        END;

        IF ImportField10 = '' THEN BEGIN
            WriteErrorLog(STRSUBSTNO(Text00010, Counter));
            IsError := TRUE;
        END;

        IF ImportField11 = '0' THEN BEGIN
            WriteErrorLog(STRSUBSTNO(Text0006, ImportField11, ImportField7));
            IsError := TRUE;
        END;

        IF ImportField15 <> '' THEN BEGIN
            SalesLineTemp.RESET;
            SalesLineTemp.SETRANGE("Document Type", SalesHeaderTemp."Document Type"::Order);
            Evaluate(IMPORT15, ImportField15);
            SalesLineTemp.SetRange("Serial Number", IMPORT15);
            IF SalesLineTemp.FINDFIRST THEN BEGIN
                WriteErrorLog(STRSUBSTNO(Text00013, ImportField15, Counter));
                IsError := TRUE;
            END;
        END;
    END;

    PROCEDURE WriteErrorLog(ErrorText: Text[250]);

    BEGIN
        // IF NOT ErrorFileCreated THEN BEGIN
        TxtBuilder.AppendLine(ErrorText);
        // Message(ErrorText);
        ErrorFileCreated := TRUE;
        // end
    END;

    LOCAL PROCEDURE CreateSalesOrders();
    BEGIN
        SalesHeaderTemp.RESET;
        SalesHeaderTemp.SETRANGE("Document Type", SalesHeaderTemp."Document Type"::Order);
        IF SalesHeaderTemp.FINDSET THEN
            REPEAT
                SalesHeader.INIT;
                SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader."No." := '';
                SalesHeader.INSERT(TRUE);
                SalesHeader.VALIDATE("Sell-to Customer No.", SalesHeaderTemp."Sell-to Customer No.");
                SalesHeader.VALIDATE("Document Date", SalesHeaderTemp."Document Date");
                SalesHeader.VALIDATE("Order Date", SalesHeaderTemp."Order Date");
                SalesHeader.VALIDATE("External Document No.", SalesHeaderTemp."External Document No.");
                SalesHeader.VALIDATE("Ship-to Code", SalesHeaderTemp."Ship-to Code");
                SalesHeader.VALIDATE("Requested Delivery Date", SalesHeaderTemp."Requested Delivery Date");
                SalesHeader.VALIDATE("Due Date", SalesHeaderTemp."Due Date");
                SalesHeader.VALIDATE("Document Date", SalesHeaderTemp."Document Date");
                SalesHeader.VALIDATE("Location Code", SalesHeaderTemp."Location Code");
                SalesHeader.MODIFY(TRUE);
                NoofSO := NoofSO + 1;

                SalesLineTemp.RESET;
                SalesLineTemp.SETRANGE("Document Type", SalesHeaderTemp."Document Type");
                SalesLineTemp.SETRANGE("Document No.", SalesHeaderTemp."No.");
                IF SalesLineTemp.FINDSET THEN
                    REPEAT
                        SalesLine.INIT;
                        SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                        SalesLine.VALIDATE("Document No.", SalesHeader."No.");
                        SalesLine.VALIDATE("Line No.", SalesLineTemp."Line No.");
                        SalesLine.VALIDATE(Type, SalesLineTemp.Type);
                        SalesLine.VALIDATE("No.", SalesLineTemp."No.");
                        SalesLine.VALIDATE(Quantity, SalesLineTemp.Quantity);
                        SalesLine.VALIDATE("Location Code", SalesLineTemp."Location Code");
                        SalesLine.VALIDATE("Unit Price", SalesLineTemp."Unit Price");
                        SalesLine.VALIDATE("Qty. to Ship", SalesLineTemp."Qty. to Ship");
                        SalesLine.VALIDATE("Shipment Date", SalesLineTemp."Shipment Date");
                        SalesLine."Serial Number" := SalesLineTemp."Serial Number";
                        SalesLine.VALIDATE(Priority, SalesLineTemp.Priority);
                        SalesLine.VALIDATE(Remarks, SalesLineTemp.Remarks);
                        SalesLine.VALIDATE("Country/Region of Origin Code", SalesLineTemp."Country/Region of Origin Code");
                        SalesLine.INSERT(TRUE);
                    UNTIL SalesLineTemp.NEXT = 0;
            UNTIL SalesHeaderTemp.NEXT = 0;
        IF NoofSO > 0 THEN
            MESSAGE('No of %1 order created successfully', NoofSO);
    END;

    procedure ClearVar()
    begin
        ImportField1 := '';
        ImportField2 := '';
        ImportField3 := '';
        ImportField4 := '';
        ImportField5 := '';
        ImportField6 := '';
        ImportField7 := '';
        ImportField8 := '';
        ImportField9 := '';
        ImportField10 := '';
        ImportField11 := '';
        ImportField12 := '';
        ImportField13 := '';
        ImportField14 := '';
        ImportField15 := '';
        ImportField16 := '';
        ImportField17 := '';
    end;

    var
        SheetName: Text;
        ServerFileName: Text;
        FromServerFileName: Text;
        ExcelBuffer: record "Excel Buffer";
        FileManagement: Codeunit "File Management";
        TotalColumns: Integer;
        TotalRows: Integer;
        X: Integer;
        Istream: InStream;
        UploadExcelMsg: Text;

        SalesHeader: Record 36;
        SalesHeaderTemp: Record 36 TEMPORARY;
        SalesLineTemp: Record 37 TEMPORARY;
        SalesLine: Record 37;
        SalesSetup: Record 311;
        SpecialtyStoreLocation: Record 14;
        ItemChargeSales: Record 5809;
        Customer: Record 18;
        DefShipToAddress: Record 222;
        ShipToAddress: Record 222;
        DefItemCharge: Record 5800;
        DefGenJnlBatch: Record 232;
        GenJnlLine: Record 81;
        SalesInvoiceHeader: Record 112;
        TaxGroupRec: Record 321;
        ItemChargeAssgntSales: Codeunit 5807;

        InsertOrder: Boolean;
        LineNo: Integer;
        Counter: Integer;
        Item: Record 27;
        PrevExternalOrderNo: Code[20];
        CurrentQtyLine: Integer;
        FileSalesOrderTotal: Decimal;
        FileLineTotal: Decimal;
        LastConsShiptoAddr: Code[10];
        //FileName: Text[250];
        Name: Text[1024];
        FilePath: Text[1024];
        LastPos: Integer;
        NewName: Text[1024];
        OldName: Text[1024];
        HSFile: File;
        "3PLLocation": Record 14;
        ItemVariantRec: Record 5401;
        OriginalItemNoTxt: Text[80];
        ItemNoFirst6CharSeparated: Code[6];
        VariantCodeSeparated: Code[10];
        MemoLineExists: Boolean;
        MemoLineText: Text[80];
        NewHSFilePath: Text[250];
        ProcessedHSFilePath: Text[250];
        ImportFieldArr: ARRAY[17] OF Text[250];
        IsError: Boolean;
        ErrorFileCreated: Boolean;
        MyFile: File;
        MyOutStream: OutStream;
        THFileName: Text[250];
        cdu3TierMgt: Codeunit 419;
        ErroFileName: Text[250];
        IsFirstRecord: Boolean;
        ShowWarning: Boolean;
        OrderDate: Date;
        SalesHeader2: Record 36;
        Text0001: TextConst ENU = 'Customer id is not valid line no. %1';
        Text0002: TextConst ENU = 'Customer No. %1 for order %2 not found';
        Text0003: TextConst ENU = 'Item No. %1 for order %2 not found line no. %3';
        Text0004: TextConst ENU = 'Ship to Code %1 for Customer %2 not found';
        Text0005: TextConst ENU = 'Quantity %1 for order %2 not found';
        Text0006: TextConst ENU = 'Price %1 for order %2 not found';
        Text0007: TextConst ENU = 'External Document No. %1 already exist. line no. %2';
        Text0008: TextConst ENU = 'see text file %1 for error.';
        Text0009: TextConst ENU = 'No record imported. please check header.';
        Text00010: TextConst ENU = 'Location Code is not valid line no. %1';
        Text00011: TextConst ENU = 'External Document No. %1 is duplicated line no. %2';
        Text00012: TextConst ENU = 'SO Successfully Created.';
        Text00013: TextConst ENU = 'Serial Number %1 is duplicated line no. %2';
        SONo: Integer;
        NoofSO: Integer;
        Location: Record 14;
        ImportField1: Text;
        ImportField2: Text;
        ImportField3: Text;
        ImportField4: Text;
        ImportField5: Text;
        ImportField6: Text;
        ImportField7: Text;
        ImportField8: Text;
        ImportField9: Text;
        ImportField10: Text;
        ImportField11: Text;
        ImportField12: Text;
        ImportField13: Text;
        ImportField14: Text;
        ImportField15: Text;
        ImportField16: Text;
        ImportField17: Text;
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        FileName: Text;
        TxtBuilder: TextBuilder;
}
