codeunit 50009 EventMgmt1
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure OnafterSendEmail(EmailDocName: Text[250]; EmailScenario: Enum "Email Scenario"; SenderUserID: Code[50]; var EmailSentSuccesfully: Boolean;
     var HideDialog: Boolean; var IsFromPostedDoc: Boolean; var IsHandled: Boolean; var PostedDocNo: Code[20]; var ReportUsage: Integer; var TempEmailItem: Record "Email Item" temporary)
    var
        PurchaseInvheader: Record "Purch. Inv. Header";
        DocumentAttachment: Record "Document Attachment";
        PaymentJournal: Record "Gen. Journal Line";
        NoofDoc: Integer;
        FilePath: text;
        FileMgt: codeunit "File Management";
        Isstream: InStream;
        Tempblob: CodeUnit "Temp Blob";
        DocumentStream: OutStream;
    begin
        if ReportUsage = 86 then begin
            PaymentJournal.Reset();
            PaymentJournal.SetRange("Document No.", PostedDocNo);
            PaymentJournal.SetRange("Applies-to Doc. Type", PaymentJournal."Applies-to Doc. Type"::Invoice);
            PaymentJournal.SetFilter("Applies-to Doc. No.", '<>%1', '');
            if PaymentJournal.FindFirst() then begin
                PurchaseInvheader.Reset();
                PurchaseInvheader.SetRange("No.", PaymentJournal."Applies-to Doc. No.");
                if PurchaseInvheader.FindFirst() then begin
                    DocumentAttachment.Reset();
                    DocumentAttachment.SetRange("Table ID", 122);
                    DocumentAttachment.SetRange("No.", PurchaseInvheader."No.");
                    DocumentAttachment.SetRange("Include on Remittance", true);
                    if DocumentAttachment.FindSet() then
                        repeat
                            TempBlob.CreateOutStream(DocumentStream);
                            DocumentAttachment."Document Reference ID".ExportStream(DocumentStream);
                            TempBlob.CreateInStream(Isstream);
                            TempEmailItem.AddAttachment(Isstream, DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension");
                        until DocumentAttachment.Next() = 0;
                end;
            end;
        end;
    end;
}