unit Main_Form;

interface

{$WRITEABLECONST ON}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, Menus, CodeExplorer, Compiler, Waiter//,
  {Menus,} {Classes};

const
  PANEL_OFFSET: Integer = 20;
  PANEL_LENGTH: Integer = 60;
  PANEL_WIDTH: Integer  = 8;

  PANEL_TOP = 0;
  PANEL_RIGHT = 1;
  PANEL_BOTTOM = 2;
  PANEL_LEFT = 3;

  PANEL_COLOR_CLICKED: TColor = clBlack;
  PANEL_COLOR_NONE: TColor = clWebLightgrey;

type
  TField = class;
  TPanel_Parent = class;

  TPanel_Vertical  = class(TPanel)
  private
    FActive: Boolean;
    FParentPanel: TPanel_Parent;
    FPos: Integer;
    FInvis: Boolean;
    procedure SetInvis(const Value: Boolean);
    procedure setActive(const Value: Boolean);
  public
    property Active: Boolean read FActive write setActive;
    property ParentPanel: TPanel_Parent read FParentPanel write FParentPanel;
    property Position: Integer read FPos write FPos;
    property Invisible: Boolean read FInvis write SetInvis;

    procedure Clicked(Sender: TObject);
    procedure UpdateColors;
    constructor Create(AOwner: TComponent); override;
  end;

  TPanel_Horizontal = class(TPanel)
  private
    FActive: Boolean;
    FParentPanel: TPanel_Parent;
    FPos: Integer;
    FInvis: Boolean;
    procedure SetInvis(const Value: Boolean);
    procedure setActive(const Value: Boolean);
  public
    property Active: Boolean read FActive write setActive;
    property ParentPanel: TPanel_Parent read FParentPanel write FParentPanel;
    property Position: Integer read FPos write FPos;
    property Invisible: Boolean read FInvis write SetInvis;

    procedure Clicked(Sender: Tobject);
    procedure UpdateColors;
    constructor Create(AOwner: TComponent); override;
  end;

  TPanel_Parent = class(TPanel)
  private
    FRow: Integer;
    FColumn: Integer;
    FField: TField;
    FPanel_Horizontal_Bottom: TPanel_Horizontal;
    FPanel_Vertical_Left: TPanel_Vertical;
    FPanel_Vertical_Right: TPanel_Vertical;
    FPanel_Horizontal_Top: TPanel_Horizontal;
  public
    property Panel_Vertical_Left: TPanel_Vertical read FPanel_Vertical_Left write FPanel_Vertical_Left;
    property Panel_Vertical_Right: TPanel_Vertical read FPanel_Vertical_Right write FPanel_Vertical_Right;
    property Panel_Horizontal_Top: TPanel_Horizontal read FPanel_Horizontal_Top write FPanel_Horizontal_Top;
    property Panel_Horizontal_Bottom: TPanel_Horizontal read FPanel_Horizontal_Bottom write FPanel_Horizontal_Bottom;

    property Row: Integer read FRow write FRow;
    property Column: Integer read FColumn write FColumn;

    property Field: TField read FField write FField;

    procedure UpdateColors;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  FieldType = array of array of TPanel_Parent;

  TField = class(TObject)
  private
    FField: FieldType;
    FLength: Integer;
    FParent: TWinControl;
    FOwner: TComponent;
  public
    property Field: FieldType read FField write FField;
    property Length: Integer read FLength write FLength;
    property Parent: TWinControl read FParent write FParent;
    property Owner: TComponent read FOwner write FOwner;

    procedure BuildField;
    function ToCSString(): TStringList;
    constructor Create(Length: Integer);
    destructor Destroy; override;
  end;

type
  TForm1 = class(TForm)
    Menu: TMainMenu;
    Field1: TMenuItem;
    Hidenonblocking1: TMenuItem;
    Shownonblocking1: TMenuItem;
    oCode1: TMenuItem;
    oCodeC1: TMenuItem;
    Savetofielddumpbin1: TMenuItem;
    Loadfromfielddumpbin1: TMenuItem;
    Createnewfield1: TMenuItem;
    Createnewcustomfield1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Hidenonblocking1Click(Sender: TObject);
    procedure Shownonblocking1Click(Sender: TObject);
    procedure oCodeC1Click(Sender: TObject);
    procedure Savetofielddumpbin1Click(Sender: TObject);
    procedure Loadfromfielddumpbin1Click(Sender: TObject);
    procedure Createnewfield1Click(Sender: TObject);
    procedure Createnewcustomfield1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MainField: TField;
  FieldLength: Integer = 8;
  HideNonVisible: Boolean = False;

implementation

{$R *.dfm}

{ TPanel_Parent }

procedure SaveField;
var Fil: TFileStream;
    i, k: Integer;
    Temp: Byte;
    Arr: Array [1..1] of byte absolute Temp;
    Arrc: Array [1..4] of Byte absolute FieldLength;
    Wait: TWaiterForm;
begin
  Fil := TFileStream.Create('field_dump.bin', fmCreate);
  Fil.Write(Arrc[1], 4);
  Wait := TWaiterForm.Create(Form1);
  Wait.Identifier.Caption := 'Saving elements: ';
  Wait.Maximum := FieldLength * FieldLength;
  Wait.Current := 0;
  Wait.Show;
  for i := 0 to FieldLength - 1 do begin
    for k := 0 to FieldLength - 1 do begin
      Temp := 0;
      with MainField.Field[i,k] do begin
        if Panel_Horizontal_Top.Active then
          Temp := Temp or 128;
        if Panel_Vertical_Right.Active then
          Temp := Temp or 64;
        if Panel_Horizontal_Bottom.Active then
          Temp := Temp or 32;
        if Panel_Vertical_Left.Active then
          Temp := Temp or 16;
      end;
      Fil.Write(Arr[1], 1);
      Wait.Current := Wait.Current + 1;
    end;
  end;
  Wait.Free;
  Fil.Free;
end;

procedure LoadField;
var Fil: TFileStream;
    i, k: Integer;
    Arrc: Array [1..4] of Byte;
    Arr: Array [1..1] of byte;
    Temp: Byte absolute Arr;
    Len: Integer absolute Arrc;
    Wait: TWaiterForm;
begin
  Fil := TFileStream.Create('field_dump.bin', fmOpenRead);
  Fil.Read(Arrc[1], 4);
  MainField.Free;
  MainField := TField.Create(Len);
  MainField.Parent := Form1;
  MainField.Owner := Application;
  MainField.BuildField;
  FieldLength := Len;
  Wait := TWaiterForm.Create(Form1);
  Wait.Identifier.Caption := 'Loading elements: ';
  Wait.Maximum := Len * Len;
  Wait.Current := 0;
  Wait.Show;
  for i := 0 to Len - 1 do begin
    for k := 0 to Len - 1 do begin
      Temp := 0;
      Fil.Read(Arr[1], 1);
      with MainField.Field[i,k] do begin
        {Panel_Horizontal_Top.Active := Boolean(Temp and 128);
        Panel_Vertical_Right.Active := Boolean(Temp and 64);
        Panel_Horizontal_Bottom.Active := Boolean(TEmp and 32);
        Panel_Vertical_Left.Active := Boolean(Temp and 16);}
        if Panel_Horizontal_Top.Active then
          Panel_Horizontal_Top.Clicked(Application);
        if Panel_Vertical_Right.Active then
          Panel_Vertical_Right.Clicked(Application);
        if Panel_Horizontal_Bottom.Active then
          Panel_Horizontal_Bottom.Clicked(Application);
        if Panel_Vertical_Left.Active then
          Panel_Vertical_Left.Clicked(Application);

        if Boolean(Temp and 128) then
          Panel_Horizontal_Top.Clicked(Application);
        if Boolean(Temp and 64) then
          Panel_Vertical_Right.Clicked(Application);
        if Boolean(Temp and 32) then
          Panel_Horizontal_Bottom.Clicked(Application);
        if Boolean(TEmp and 16) then
          Panel_Vertical_Left.Clicked(Application);
        UpdateColors;
        Wait.Current := Wait.Current + 1;
      end;
    end;
  end;
  Wait.Free;
  Fil.Free;
end;

constructor TPanel_Parent.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  ParentBackground := False;
  Width := PANEL_LENGTH;
  Height := PANEL_LENGTH;
  Color := clWhite;

  Panel_Vertical_Left := TPanel_Vertical.Create(AOwner);
  with Panel_Vertical_Left do begin
    ParentPanel := Self;
    Left := 0;
    Top := 0;
    Parent := Self;
    Position := PANEL_LEFT;
  end;
  Panel_Vertical_Right := TPanel_Vertical.Create(AOwner);
  with Panel_Vertical_Right do begin
    ParentPanel := Self;
    Left := PANEL_LENGTH - PANEL_WIDTH;
    Top := 0;
    Parent := Self;
    Position := PANEL_RIGHT;
  end;
  Panel_Horizontal_Top := TPanel_Horizontal.Create(AOwner);
  with Panel_Horizontal_Top do begin
    ParentPanel := Self;
    Left := 0;
    Top := 0;
    Parent := Self;
    Position := PANEL_TOP;
  end;
  Panel_Horizontal_Bottom := TPanel_Horizontal.Create(AOwner);
  with Panel_Horizontal_Bottom do begin
    ParentPanel := Self;
    Left := 0;
    Top := PANEL_LENGTH - PANEL_WIDTH;
    Parent := Self;
    Position := PANEL_BOTTOM;
  end;

end;

destructor TPanel_Parent.Destroy;
begin
  inherited Destroy;
end;

procedure TPanel_Parent.UpdateColors;
begin
  Panel_Vertical_Left.UpdateColors;
  Panel_Vertical_Right.UpdateColors;
  Panel_Horizontal_Top.UpdateColors;
  Panel_Horizontal_Bottom.UpdateColors;
end;

{ TPanel_Vertical }

procedure TPanel_Vertical.Clicked(Sender: TObject);
begin
  Active := not Active;
  case Position of
    PANEL_TOP: begin
      try
        with ParentPanel do begin
          Field.Field[Row - 1, Column].Panel_Horizontal_Bottom.Active := Self.Active;
//          Field.Field[Row - 1, Column].Panel_Horizontal_Bottom.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_BOTTOM: begin
      try
        with ParentPanel do begin
          Field.Field[Row + 1, Column].Panel_Horizontal_Top.Active := Self.Active;
//          Field.Field[Row + 1, Column].Panel_Horizontal_Top.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_LEFT: begin
      try
        with ParentPanel do begin
          Field.Field[Row, Column - 1].Panel_Vertical_Right.Active := Self.Active;
//          Field.Field[Row, Column - 1].Panel_Vertical_Right.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_RIGHT: begin
      try
        with ParentPanel do begin
          Field.Field[Row, Column + 1].Panel_Vertical_Left.Active := Self.Active;
//          Field.Field[Row, Column - 1].Panel_Vertical_Left.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
  end;
end;

constructor TPanel_Vertical.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  ParentBackground := False;
  Width := PANEL_WIDTH;
  Height := PANEL_LENGTH;
  Color := clWebLightgrey;
  OnClick := Clicked;
end;

procedure TPanel_Vertical.setActive(const Value: Boolean);
begin
  FActive := Value;
  UpdateColors;
end;

procedure TPanel_Vertical.SetInvis(const Value: Boolean);
begin
  FInvis := Value;
  if Value then begin
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    ParentBackground := True;
    SendToBack;
  end
  else begin
    BevelOuter := bvRaised;
    ParentBackground := False;
    BringToFront;
  end;
end;

procedure TPanel_Vertical.UpdateColors;
begin
  if HideNonVisible then
    if not Active then
      Invisible := True
    else
      Invisible := False
  else
    if Active then
      Invisible := False;
  if Active then
    Color := PANEL_COLOR_CLICKED
  else
    Color := PANEL_COLOR_NONE;
//  if HideNonVisible then
//    if not Active then
//      InVisible := True
//    else
//      Invisible := False
//  else
//    if Active then
//      Invisible := False;
end;

procedure TForm1.Createnewcustomfield1Click(Sender: TObject);
var Len: Integer;
begin
  Len := StrToInt(InputBox('Length dialog', 'Length of field', '8'));
  MainField.Free;
  MainField := TField.Create(Len);
  MainField.Parent := Form1;
  MainField.Owner := Application;
  FieldLength := Len;
  MainField.BuildField;
end;

procedure TForm1.Createnewfield1Click(Sender: TObject);
begin
  MainField.Free;
  MainField := TField.Create(8);
  MainField.Parent := Self;
  MainField.Owner := Application;
  MainField.BuildField;
  Height := PANEL_OFFSET * 2 + FieldLength * (PANEL_LENGTH + 1);
  Width := Height;
  Height := Height + PANEL_OFFSET * 2;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MainField := TField.Create(FieldLength);
  MainField.Parent := Self;
  MainField.Owner := Application;
  MainField.BuildField;
  Height := PANEL_OFFSET * 2 + FieldLength * (PANEL_LENGTH + 1);
  Width := Height;
  Height := Height + PANEL_OFFSET * 2;
  Position := poDesktopCenter;
  AutoScroll := true;
end;

{ TPanel_Horizontal }

procedure TPanel_Horizontal.Clicked(Sender: Tobject);
begin
  Active := not Active;
  case Position of
    PANEL_TOP: begin
      try
        with ParentPanel do begin
          Field.Field[Row - 1, Column].Panel_Horizontal_Bottom.Active := Self.Active;
//          Field.Field[Row - 1, Column].Panel_Horizontal_Bottom.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_BOTTOM: begin
      try
        with ParentPanel do begin
          Field.Field[Row + 1, Column].Panel_Horizontal_Top.Active := Self.Active;
//          Field.Field[Row + 1, Column].Panel_Horizontal_Top.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_LEFT: begin
      try
        with ParentPanel do begin
          Field.Field[Row, Column - 1].Panel_Vertical_Right.Active := Self.Active;
//          Field.Field[Row, Column - 1].Panel_Vertical_Right.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
    PANEL_RIGHT: begin
      try
        with ParentPanel do begin
          Field.Field[Row, Column + 1].Panel_Vertical_Left.Active := Self.Active;
//          Field.Field[Row, Column - 1].Panel_Vertical_Left.Clicked(Self);
        end;
      except
        on E: Exception do begin

        end;
      end;
    end;
  end;
  UpdateColors;
end;

constructor TPanel_Horizontal.Create(AOwner: TComponent);
begin
  inherited;
  ParentColor := False;
  ParentBackground := False;
  Width := PANEL_LENGTH;
  Height := PANEL_WIDTH;
  Color := clWebLightgrey;
  OnClick := Clicked;
end;

procedure TPanel_Horizontal.setActive(const Value: Boolean);
begin
  FActive := Value;
  UpdateColors;
end;

procedure TPanel_Horizontal.SetInvis(const Value: Boolean);
begin
  FInvis := Value;
  if Value then begin
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    ParentBackground := True;
    SendToBack;
  end
  else begin
    BevelOuter := bvRaised;
    ParentBackground := False;
    BringToFront;
  end;
end;

procedure TPanel_Horizontal.UpdateColors;
begin
  if HideNonVisible then
    if not Active then
      Invisible := True
    else
      Invisible := False
  else
    if Active then
      Invisible := False;
  if Active then
    Color := PANEL_COLOR_CLICKED
  else
    Color := PANEL_COLOR_NONE;
end;

{ TField }

procedure TField.BuildField;
var i, k: Integer;
    Wait: TWaiterForm;
begin
  FieldLength := Length;
  Wait := TWaiterForm.Create(Form1);
  Wait.Maximum := Length * Length;
  Wait.Current := 0;
  Wait.Identifier.Caption := 'Creating new assemblies: ';
  Wait.Show;
  for i := 0 to Length - 1 do begin
    for k := 0 to Length - 1 do begin
      Field[i, k] := TPanel_Parent.Create(Owner);
      with Field[i, k] do begin
        Parent := Self.Parent;
        Field := Self;
        Row := i;
        Column := k;
        Left := k * PANEL_LENGTH + PANEL_OFFSET;
        Top := i * PANEL_LENGTH + PANEL_OFFSET;
      end;
      Wait.Current := i * Length + k;
    end;
  end;
  Wait.Free;
  Wait := TWaiterForm.Create(Form1);
  Wait.Identifier.Caption := 'Fixing corners: ';
  Wait.Maximum := Length * 4;
  Wait.Current := 0;
  Wait.Show;
  for i := 0 to Length - 1 do begin
    Field[0, i].Panel_Horizontal_Top.Clicked(Self);
    Field[Length - 1, i].FPanel_Horizontal_Bottom.Clicked(Self);
    Wait.Current := Wait.Current + 2;
  end;
  for i := 0 to Length - 1 do begin
    Field[i, 0].Panel_Vertical_Left.Clicked(Self);
    Field[i, Length - 1].Panel_Vertical_Right.Clicked(Self);
    Wait.Current := Wait.Current + 2;
  end;
  Wait.Free;
  Wait := TWaiterForm.Create(Application);
  Wait.Identifier.Caption := 'Fixing bottom panels: ';
  Wait.Maximum := (Length - 2) * (Length - 1);
  Wait.Current := 0;
  Wait.Show;
  for i := 0 to Length - 2 do begin
    for k := 0 to Length - 1 do begin
      with Wait do
        Current := Current + 1;
      Field[i, k].Panel_Horizontal_Bottom.Top := Field[i, k].Panel_Horizontal_Bottom.Top + (Field[i, k].Panel_Horizontal_Bottom.Height div 2);
    end;
  end;
  Wait.Identifier.Caption := 'Fixing left panels: ';
  Wait.Maximum := (Length - 2) * (Length - 1);
  Wait.Current := 0;
  for i := 0 to Length - 1 do begin
    for k := 1 to Length - 1 do begin
      with Wait do
        Current := Current + 1;
      Field[i, k].Panel_Vertical_Left.Left := Field[i, k].Panel_Vertical_Left.Left - (Field[i, k].Panel_Vertical_Left.Width div 2);
    end;
  end;
  Wait.Identifier.Caption := 'Fixing right panels: ';
  Wait.Maximum := (Length - 2) * (Length - 1);
  Wait.Current := 0;
  for i := 0 to Length - 1 do begin
    for k := 0 to Length - 2 do begin
      with Wait do
        Current := Current + 1;
      with Field[i,k].Panel_Vertical_Right do
        Left := Left + (Width div 2);
    end;
  end;
  Wait.Identifier.Caption := 'Fixing top panels: ';
  Wait.Maximum := (Length - 2) * (Length - 1);
  Wait.Current := 0;
  for i := 1 to Length - 1 do begin
    for k := 0 to Length - 1 do begin
      with Wait do
        Current := Current + 1;
      with Field[i,k].Panel_Horizontal_Top do begin
        Top := Top - (Height div 2);
      end;
    end;
  end;
  Wait.Free;
end;

constructor TField.Create(Length: Integer);
begin
  inherited Create;
  Self.Length := Length;
  SetLength(Self.FField, Length, Length);
end;

destructor TField.Destroy;
var i, k: integer;
    Wait: TWaiterForm;
begin
  Wait := TWaiterForm.Create(Form1);
  Wait.Maximum := Length * Length;
  Wait.Current := 0;
  Wait.Identifier.Caption := 'Disposing elements: ';
  Wait.Show;
  for i := 0 to Length - 1 do
    for k := 0 to Length - 1 do begin
      Field[i, k].Destroy;
      Wait.Current := i * Length + k;
    end;
  Wait.Free;
  inherited Destroy;
end;

function TField.ToCSString: TStringList;
var S: TStringList;
    i, k, CurrentLine: Integer;
    s1: String;
begin
  CurrentLine := 0;
  Form3.Show;
  Form3.NameLabel.Caption := 'Direction_Main';
  Form3.Expecting.Caption := IntToStr(FieldLength * FieldLength * 5);
  Form3.CurrentLine.Caption := IntToStr(CurrentLine);
  S := TStringList.Create;
  S.Add('using Direction_Main;');
  S.Add('');
  S.Add('namespace Field_Generated');
  S.Add('{');
  S.Add('  class Field_Generated_Class');
  S.Add('  {');
  S.Add('    public static TField Generate()');
  S.Add('    {');
  S.Add('      int Len = ' + IntToStr(FieldLength) + ';');
  S.Add('      TField Result = new TField(Len, Len);');
  S.Add('');

  for i := 0 to FieldLength - 1 do begin
    for k := 0 to FieldLength - 1 do begin
      Inc(CurrentLine);
      Form3.CurrentLine.Caption := IntToStr(CurrentLine);
      S.Add('      Result[' + IntToStr(i) + ', ' + IntToStr(k) + '] = new TFieldSection(Result);');
      if Field[i, k].FPanel_Horizontal_Top.Active then
        s1 := 'Constants.FieldSection_Blocked;'
      else
        s1 := 'Constants.FieldSection_Free;';
      Inc(CurrentLine);
      Form3.CurrentLine.Caption := IntToStr(CurrentLine);
      S.Add('        Result[' + IntToStr(i) + ', ' + IntToStr(k) + '].Forward_Wall_Raw = ' + s1);
      if Field[i, k].FPanel_Vertical_Right.Active then
        s1 := 'Constants.FieldSection_Blocked;'
      else
        s1 := 'Constants.FieldSection_Free;';
      Inc(CurrentLine);
      Form3.CurrentLine.Caption := IntToStr(CurrentLine);
      S.Add('        Result[' + IntToStr(i) + ', ' + IntToStr(k) + '].Right_Wall_Raw = ' + s1);
      if Field[i, k].FPanel_Horizontal_Bottom.Active then
        s1 := 'Constants.FieldSection_Blocked;'
      else
        s1 := 'Constants.FieldSection_Free;';
      Inc(CurrentLine);
      Form3.CurrentLine.Caption := IntToStr(CurrentLine);
      S.Add('        Result[' + IntToStr(i) + ', ' + IntToStr(k) + '].Backward_Wall_Raw = ' + s1);
      if Field[i, k].FPanel_Vertical_Left.Active then
        s1 := 'Constants.FieldSection_Blocked;'
      else
        s1 := 'Constants.FieldSection_Free;';
      Inc(CurrentLine);
      Form3.CurrentLine.Caption := IntToStr(CurrentLine);
      S.Add('        Result[' + IntToStr(i) + ', ' + IntToStr(k) + '].Left_Wall_Raw = ' + s1);
    end;
  end;
  Form3.Close;
  S.Add('');
  S.Add('      return Result;');
  S.Add('    }');
  S.Add('  }');
  S.Add('}');
  if True then begin end;
  Result := S;
end;

procedure TForm1.Hidenonblocking1Click(Sender: TObject);
var i, k: Integer;
begin
//  PANEL_COLOR_NONE := clWhite;
  HideNonVisible := True;
  for i := 0 to FieldLength - 1 do begin
    for k := 0 to FieldLength - 1 do begin
      with MainField.Field[i, k] do begin
        UpdateColors;
      end;
    end;
  end;
end;

procedure TForm1.Loadfromfielddumpbin1Click(Sender: TObject);
begin
  LoadField;
end;

procedure TForm1.oCodeC1Click(Sender: TObject);
var S: TStringList;
    i: Integer;
begin
  //
  S := MainField.ToCSString;
  Form2.mmo1.Clear;
  for i := 0 to S.Count - 1 do
    Form2.mmo1.Lines.Add(S[i]);
  Form2.ShowModal;
end;

procedure TForm1.Savetofielddumpbin1Click(Sender: TObject);
begin
  SaveField;
end;

procedure TForm1.Shownonblocking1Click(Sender: TObject);
var I, k: Integer;
begin
  HideNonVisible := False;
  for i := 0 to FieldLength - 1 do begin
    for k := 0 to FieldLength - 1 do begin
      with MainField.Field[i, k] do begin
        UpdateColors;
      end;
    end;
  end;
end;

end.
