codeunit 50104 "Asking Date"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        PagInputPostingDate: Page "Date-Time Dialog";

    begin
        PagInputPostingDate.UseDateOnly();
        IF PagInputPostingDate.RUNMODAL = ACTION::OK THEN begin
            SalesHeader.Validate("Posting Date", PagInputPostingDate.GetDate());
        end Else
            SalesHeader.Validate("Posting Date", Today);
    end;

    var
        myInt: Integer;
}