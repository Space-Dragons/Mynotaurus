unit Waiter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TWaiterForm = class(TForm)
    Identifier: TLabel;
    Counter: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    FMax: Integer;
    FCurrent: Integer;
    procedure SetCurrent(const Value: Integer);
    { Private declarations }
  public
    { Public declarations }
    property Maximum: Integer read FMax write FMax;
    property Current: Integer read FCurrent write SetCurrent;
  end;

var
  WaiterForm: TWaiterForm;

implementation

{$R *.dfm}

procedure TWaiterForm.FormCreate(Sender: TObject);
begin
  Identifier.Caption := '';
  Counter.Caption := '';
  Position := poDesktopCenter;
  Application.ProcessMessages;
end;

procedure TWaiterForm.SetCurrent(const Value: Integer);
begin
  FCurrent := Value;
  Counter.Caption:= IntToStr(Value) + '/' + IntToStr(Maximum);
  ProgressBar1.Position := Round((Current/Maximum) * 100);
  Application.ProcessMessages;
end;

end.
