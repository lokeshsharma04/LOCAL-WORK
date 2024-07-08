pageextension 50126 "Posted sales inv" extends "Posted Sales Invoice"
{
    actions
    {
        addafter(Dimensions)
        {
            action(OrderConf)
            {
                Caption = 'Sample Codeunit24';
                Promoted = true;
                PromotedCategory = Process;
                Image = Navigate;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SampleCode: Codeunit SampleCodeunit24;

                    DocumnetNo: Integer;
                begin
                    Message('%1', SampleCode.GetOrderConfirmation(3, '103110'));
                end;
            }
        }
    }
}
