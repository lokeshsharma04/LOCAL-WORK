table 50125 "Kinsyu Poscm"
{
    Caption = 'Kinsyu Poscm';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Created date"; Date)
        {
            Caption = 'Created date';
            DataClassification = ToBeClassified;
        }
        field(2; "Time stamp"; Code[50])
        {
            Caption = 'Time stamp';
            DataClassification = ToBeClassified;
        }
        field(3; "Store Code"; Code[50])
        {
            Caption = 'Store Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Slip date"; Date)
        {
            Caption = 'Slip date';
            DataClassification = ToBeClassified;
        }
        field(5; "Species of gold"; Code[50])
        {
            Caption = 'Species of gold';
            DataClassification = ToBeClassified;
        }
        field(6; "Gold cord"; Code[50])
        {
            Caption = 'Gold cord';
            DataClassification = ToBeClassified;
        }
        field(7; Nickname; Text[20])
        {
            Caption = 'Nickname';
            DataClassification = ToBeClassified;
        }
        field(8; "Payment category"; Code[20])
        {
            Caption = 'Payment category';
            DataClassification = ToBeClassified;
        }
        field(9; "Payment division name"; Code[20])
        {
            Caption = 'Payment division  name';
            DataClassification = ToBeClassified;
        }
        field(10; "Amount used"; Decimal)
        {
            Caption = 'Amount used';
            DataClassification = ToBeClassified;
        }
        field(11; "System item"; Code[20])
        {
            Caption = 'System item';
            DataClassification = ToBeClassified;
        }
        field(12; "Business category"; Code[20])
        {
            Caption = 'Business category';
            DataClassification = ToBeClassified;
        }
        field(13; Posno; Integer)
        {
            Caption = 'Posno';
            DataClassification = ToBeClassified;
        }
        field(14; "Entry NO"; Integer)
        {
            Caption = 'Entry NO';
            DataClassification = ToBeClassified;
        }
        field(15; "Line No."; Integer)
        {
            Caption = 'Line NO';
            DataClassification = ToBeClassified;
        }
        field(16; "Slip Number"; Integer)
        {
            Caption = 'Slip Number';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry NO", "Line No.")
        {
            Clustered = true;
        }
    }
}
