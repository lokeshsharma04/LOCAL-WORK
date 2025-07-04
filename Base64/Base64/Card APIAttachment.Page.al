page 50004 "SDH API Attachment"
{
    PageType = Card;
    SourceTable = "SDH API Attachment";
    Caption = 'API Attachment';
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'File Name';
                    ToolTip = 'Stores the Code.';
                }
                field("Base 64 Value"; Bit64TextValue)
                {
                    ApplicationArea = All;
                    Caption = 'Base 64 Value';
                    ToolTip = 'Used for inputting Bit 64 value';
                    MultiLine = true;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Caption = 'File Extension';
                    ToolTip = 'Stores File Extension.';
                }
                field(Attachment; Rec.Attachment)
                {
                    ApplicationArea = All;
                    Caption = 'Attachment';
                    ToolTip = 'stores the attachment.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Convert To Blob")
            {
                ApplicationArea = All;
                Caption = 'Convert To Blob';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                trigger OnAction()
                begin
                    Rec.ImportAttachment(Bit64TextValue);
                    //Rec.ImportAttachmentOldWay(Bit64TextValue);
                    Message('Attachment Uploaded');
                    rec.ExportAttachment();
                end;
            }
            action("Export Attachment")
            {
                ApplicationArea = All;
                Caption = 'Download Attachment';
                Promoted = true;
                PromotedCategory = Process;
                Image = Export;
                trigger OnAction()
                begin
                    rec.ExportAttachment();
                end;
            }
        }
    }
    var
        Bit64TextValue: Text;
}