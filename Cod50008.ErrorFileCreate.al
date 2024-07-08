codeunit 50008 ErrorFileCreate
{
    trigger OnRun()
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        FileName: Text;
        TxtBuilder: TextBuilder;
        Lines: Integer;
    begin
        FileName := 'TestFile_' + UserId + '_' + Format(CurrentDateTime) + '.txt';
        TxtBuilder.AppendLine('Start time: ' + Format(Time));
        for Lines := 1 to 1000000 do
            TxtBuilder.AppendLine(StrSubstNo('This is %1 line in the text file.', Lines));
        TxtBuilder.AppendLine('End time: ' + Format(Time));
        TempBlob.CreateOutStream(OutS);
        OutS.WriteText(TxtBuilder.ToText());
        TempBlob.CreateInStream(InS);
        DownloadFromStream(InS, '', '', '', FileName);
    end;
}
