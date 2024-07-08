codeunit 50111 SampleCodeunit24
{
    procedure GetOrderConfirmation(DocumentType: Integer; DocumentNo: Code[20]): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        SalesHeader: Record "Sales Header";
        TempBlob: Codeunit "Temp Blob";
        Outs: OutStream;
        Ins: InStream;
        Base64Text: Text;
        RecRef: RecordRef;
        StartDate: Date;
        EndDate: Date;
        RepOrderConfirm: Report "Standard Sales - Order Conf.";
        PostSalesShip: Record "Sales Shipment Header";
        PostSalesInv: Record "Sales Invoice Header";
        RepSalesInv: Report "Standard Sales - Invoice";
        RepSalesShip: Report "Sales - Shipment";


    begin
        if DocumentType = 1 then begin
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange("No.", DocumentNo);
            if SalesHeader.FindFirst() then begin
                TempBlob.CreateOutStream(Outs);
                RecRef.GetTable(SalesHeader);
                RepOrderConfirm.SaveAs('', ReportFormat::Pdf, Outs, RecRef);
                TempBlob.CreateInStream(Ins);
                Base64Text := Base64Convert.ToBase64(Ins);
                exit(Base64Text);
            end;
        end else
            if DocumentType = 2 then begin
                PostSalesShip.SetRange("No.", DocumentNo);
                if PostSalesShip.FindFirst() then begin
                    TempBlob.CreateOutStream(Outs);
                    RecRef.GetTable(PostSalesShip);
                    RepSalesShip.SaveAs('', ReportFormat::Pdf, Outs, RecRef);
                    TempBlob.CreateInStream(Ins);
                    Base64Text := Base64Convert.ToBase64(Ins);
                    exit(Base64Text);
                end;
            end else
                if DocumentType = 3 then begin
                    PostSalesInv.SetRange("No.", DocumentNo);
                    if PostSalesInv.FindFirst() then begin
                        TempBlob.CreateOutStream(Outs);
                        RecRef.GetTable(PostSalesInv);
                        RepSalesInv.SaveAs('', ReportFormat::Pdf, Outs, RecRef);
                        TempBlob.CreateInStream(Ins);
                        Base64Text := Base64Convert.ToBase64(Ins);
                        exit(Base64Text);
                    end;
                end;
    end;
}