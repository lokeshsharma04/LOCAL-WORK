codeunit 50151 BubbleSort
{
    trigger OnRun()
    begin
        BubbleSort();
    end;


    LOCAL procedure BubbleSort()
    begin
        //Init integer array
        rankArray[1] := 25;
        rankArray[2] := 24;
        rankArray[3] := 30;
        rankArray[4] := 28;
        rankArray[5] := 39;
        rankArray[6] := 27;
        rankArray[7] := 22;
        rankArray[8] := 25;
        rankArray[9] := 34;
        rankArray[10] := 35;

        numLength := ARRAYLEN(rankArray);
        flag := TRUE;

        MESSAGE('Before Sorting: ' + FORMAT(rankArray[1]) + ',' + FORMAT(rankArray[2]) + ',' + FORMAT(rankArray[3]) + ',' +
          FORMAT(rankArray[4]) + ',' + FORMAT(rankArray[5]) + ',' + FORMAT(rankArray[6]) + ',' +
            FORMAT(rankArray[7]) + ',' + FORMAT(rankArray[8]) + ',' + FORMAT(rankArray[9]) + ',' +
              FORMAT(rankArray[10]));

        //Bubble Sort Start
        FOR i := 1 TO numLength - 1 DO BEGIN
            flag := FALSE;
            FOR j := 1 TO numLength - 1 DO BEGIN
                IF rankArray[j] > rankArray[j + 1] THEN BEGIN
                    temp := rankArray[j + 1];
                    rankArray[j + 1] := rankArray[j];
                    rankArray[j] := temp;
                    flag := TRUE;
                END;
            END;
        END;
        //Bubble Sort End
        MESSAGE('After Sorting: ' + FORMAT(rankArray[1]) + ',' + FORMAT(rankArray[2]) + ',' + FORMAT(rankArray[3]) + ',' +
          FORMAT(rankArray[4]) + ',' + FORMAT(rankArray[5]) + ',' + FORMAT(rankArray[6]) + ',' +
            FORMAT(rankArray[7]) + ',' + FORMAT(rankArray[8]) + ',' + FORMAT(rankArray[9]) + ',' +
              FORMAT(rankArray[10]));
    end;
    // view rawBubbleSort.pas hosted with ❤ by GitHub
    var
        myInt: Integer;
        i: Integer;
        flag: Boolean;
        j: Integer;
        rankArray: array[10] of Integer;
        numlength: Integer;
        Temp: integer;

}