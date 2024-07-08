pageextension 50125 "Posted Sales Shipment " extends "Posted Sales Shipment"
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
                    Message('%1', SampleCode.GetOrderConfirmation(2, '102119'));
                end;
            }
        }
    }
}
