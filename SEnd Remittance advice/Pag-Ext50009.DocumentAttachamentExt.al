pageextension 50009 "Document Attachament Ext" extends "Document Attachment Details"
{
    layout
    {
        addafter("Document Flow Sales")
        {
            field("Include on Remittance"; Rec."Include on Remittance")
            {
                ApplicationArea = all;
            }
        }
    }
}
