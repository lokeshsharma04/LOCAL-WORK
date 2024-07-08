table 50002 "Api Testing"
{
    Caption = 'Api Testing';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Integer)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(3; Attachment; Blob)
        {
            DataClassification = CustomerContent;
            SubType = Bitmap;
        }

    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
    procedure ImportAttachment(Bit64InputValue: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        TempOutstream: OutStream;
        Recref: RecordRef;
    begin
        If Bit64InputValue = '' Then
            exit;
        Recref.Open(Database::"SDH API Attachment");
        Recref.GetTable(Rec);
        TempBlob.CreateOutStream(TempOutstream);
        Base64Convert.FromBase64(Bit64InputValue, TempOutstream);

        TempBlob.ToRecordRef(Recref, Rec.FieldNo(Attachment));
        Recref.SetTable(Rec);
        Recref.Close();
    end;

    procedure ExportAttachment()
    var
        IStream: InStream;
        ExportFileName: Text;
    begin
        ExportFileName := 'Report' + '.' + 'PDF';
        Rec.CalcFields(Attachment);
        If Not Rec.Attachment.HasValue then
            exit;
        Rec.Attachment.CreateInStream(IStream);
        DownloadFromStream(IStream, '', '', '', ExportFileName);
    end;

    procedure ConvertedTo64Value(): Text
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Recref: RecordRef;
    begin
        Recref.Open(Database::"Api Testing");
        Recref.GetTable(Rec);
        TempBlob.FromRecordRef(RecRef, Rec.FieldNo(Attachment));
        TempBlob.CreateInStream(TempInStream);
        Recref.SetTable(Rec);
        Recref.Close();
        Exit(Base64Convert.ToBase64(TempInStream));
    end;
}
