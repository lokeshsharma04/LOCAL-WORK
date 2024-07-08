page 50005 "Api Testing"
{
    PageType = API;
    Caption = 'Api Testing';
    APIVersion = 'v1.0';
    APIPublisher = 'Lokesh';
    APIGroup = 'demo';
    EntityName = 'ApiTesting';
    EntitySetName = 'ApiTestings';
    SourceTable = "Api Testing";
    Extensible = false;
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id';
                    Editable = false;
                }


                field("DocumentType"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Doccument Type field.';
                }
                field("DocumentNo"; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(In64bitValue; In64bitValue)
                {
                    ApplicationArea = All;
                    Caption = 'Bit64';

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        IF In64bitValue <> '' THEN begin
                            Rec.ImportAttachment(In64bitValue);
                            rec.ExportAttachment()
                        end
                        Else
                            Error('No Bith 64 value.');
                    end;
                }
                field(Out64bitValue; Out64bitValue)
                {
                    ApplicationArea = All;
                    Caption = '64-Bit Out';
                }
            }
        }
    }

    var
        In64bitValue: Text;
        Out64bitValue: Text;


    trigger OnAfterGetRecord()
    begin
        Out64bitValue := Rec.ConvertedTo64Value();
    end;
}
