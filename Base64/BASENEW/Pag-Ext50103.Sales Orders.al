pageextension 50103 "Sales Orders" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Discount Master Exist"; Rec."Discount Master Exist")
            {
                ApplicationArea = all;
            }

        }
        addafter("Sell-to Customer No.")
        {


            // field("Source of sales"; Rec."Source of sales")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Recipt. Number field.';
            // }

        }
    }

    //         addafter(General)
    //         {
    //             field("Auto Payment Recepit No"; Rec."Auto Payment Recepit No")
    //             {
    //                 ApplicationArea = all;

    //             }
    //         }

    //     }
    actions
    {
        addafter(Post)
        {
            action(NewSalesOrder)
            {
                Caption = 'New Sales Order';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Action;

                trigger OnAction()
                var
                    FromSalesHeader: Record "Sales Header";
                    ToSalesHeader: Record "Sales Header";
                    FromSalesLine: Record "Sales Line";
                    ToSalesLine: Record "Sales Line";
                    salesorder: Page "Sales Order";

                // NoSeriesMan: Codeunit NoSeriesManagement;
                begin
                    FromSalesHeader.Get(rec."Document Type", Rec."No.");
                    ToSalesHeader.Init();
                    ToSalesHeader."Document Type" := ToSalesHeader."Document Type"::Order;
                    ToSalesHeader.TransferFields(FromSalesHeader);
                    ToSalesHeader."No." := '';
                    ToSalesHeader.Status := ToSalesHeader.Status::Open;

                    // ToSalesHeader."Sell-to Customer No." := FromSalesHeader."Sell-to Customer No.";
                    // ToSalesHeader."Sell-to Customer Name" := FromSalesHeader."Sell-to Customer Name";
                    // ToSalesHeader."Due Date" := Rec."Due Date";
                    // ToSalesHeader."Posting Date" := Rec."Posting Date";
                    ToSalesHeader.Insert(true);
                    // FromSalesLine.Get(Rec."Document Type", rec."No.");
                    FromSalesLine.Reset();
                    FromSalesLine.SetRange("Document Type", FromSalesHeader."Document Type");
                    FromSalesLine.SetRange("Document No.", FromSalesHeader."No.");
                    if FromSalesLine.FindSet() then
                        repeat
                            ToSalesLine.Init();
                            ToSalesLine.TransferFields(FromSalesLine);
                            ToSalesLine."Document No." := ToSalesHeader."No.";
                            // ToSalesLine.Quantity := 0;
                            ToSalesLine.Insert(true);
                        until FromSalesLine.Next() = 0;
                    if Confirm('do you want open new sales Order No. %1 ', false, ToSalesHeader."No.") then
                        Page.Run(Page::"Sales Order", ToSalesHeader);
                    // Message('Sales Order No. %1 created Successfully', ToSalesHeader."No.");
                end;
            }
            action(SampleCodeunit)
            {
                Caption = 'Sample Codeunit24';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Action;

                trigger OnAction()
                var
                    SampleCode: Codeunit SampleCodeunit24;
                    DocumentType: Integer;
                    DocumentNo: Code[20];
                    SalesHeader: Record "Sales Header";
                    PdfBAse64: Record "SDH API Attachment";
                begin
                    // Message('%1', SampleCode.GetOrderConfirmation(1, '1036'));
                    Rec.ImportAttachment(SampleCode.GetOrderConfirmation(1, Rec."No."));
                end;
            }
        }
    }
}