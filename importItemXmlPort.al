xmlport 50100 "Import Items XMLport"
{
    Caption = 'Import Items';
    Format = VariableText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    FileName = 'ItemsViaXMLport.csv';
    TableSeparator = '<NewLine>';

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                RequestFilterFields = "No.";
                fieldelement(No; Item."No.")
                {
                }
                fieldelement(Description; Item.Description)
                {
                }
                fieldelement(Type; Item.Type)
                {
                }
                fieldelement(Inventory; Item.Inventory)
                {
                }
                fieldelement(BaseUnitofMeasure; Item."Base Unit of Measure")
                {
                }
                fieldelement(CostisAdjusted; Item."Cost is Adjusted")
                {
                }
                fieldelement(UnitCost; Item."Unit Cost")
                {
                }
                fieldelement(UnitPrice; Item."Unit Price")
                {
                }
                fieldelement(VendorNo; Item."Vendor No.")
                {
                }
                trigger OnAfterInitRecord()
                begin
                    if IsFirstline then begin
                        IsFirstline := false;
                        currXMLport.Skip();
                    end;
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        IsFirstline := true;
    end;

    trigger OnPostXmlPort()
    begin
        Message('Data is Imported');
    end;

    var
        IsFirstline: Boolean;
}
