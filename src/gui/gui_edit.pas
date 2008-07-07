{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2008 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Defines a Text Edit control. Also known a Text Entry control.
}

unit gui_edit;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  gfxbase,
  fpgfx,
  gfx_widget,
  gui_menu;

type
  TfpgEditBorderStyle = (ebsNone, ebsDefault, ebsSingle);


  TfpgBaseEdit = class(TfpgWidget)
  private
    FAutoSelect: Boolean;
    FHideSelection: Boolean;
    FPopupMenu: TfpgPopupMenu;
    FDefaultPopupMenu: TfpgPopupMenu;
    FText: string;
    FFont: TfpgFont;
    FPasswordMode: Boolean;
    FBorderStyle: TfpgEditBorderStyle;
    FOnChange: TNotifyEvent;
    FMaxLength: integer;
    FSelecting: Boolean;
    procedure   Adjust(UsePxCursorPos: boolean = false);
    procedure   AdjustTextOffset(UsePxCursorPos: boolean);
    procedure   AdjustDrawingInfo;
    // function    PointToCharPos(x, y: integer): integer;
    procedure   DeleteSelection;
    procedure   DoCopy;
    procedure   DoPaste;
    procedure   SetAutoSelect(const AValue: Boolean);
    procedure   SetBorderStyle(const AValue: TfpgEditBorderStyle);
    procedure   SetHideSelection(const AValue: Boolean);
    procedure   SetPasswordMode(const AValue: boolean);
    function    GetFontDesc: string;
    procedure   SetFontDesc(const AValue: string);
    procedure   SetText(const AValue: string);
    procedure   DefaultPopupCut(Sender: TObject);
    procedure   DefaultPopupCopy(Sender: TObject);
    procedure   DefaultPopupPaste(Sender: TObject);
    procedure   DefaultPopupClearAll(Sender: TObject);
    procedure   SetDefaultPopupMenuItemsState;
  protected
    FSideMargin: integer;
    FMouseDragPos: integer;
    FSelStart: integer;
    FSelOffset: integer;
    FCursorPos: integer; // Caret position (characters)
    FCursorPx: integer;  // Caret position (pixels)
    FTextOffset: integer;
    FDrawOffset: integer;
    FVisibleText: TfpgString;
    FVisSelStartPx: integer;
    FVisSelEndPx: integer;
    procedure   DoOnChange; virtual;
    procedure   ShowDefaultPopupMenu(const x, y: integer; const shiftstate: TShiftState); virtual;
    procedure   HandlePaint; override;
    procedure   HandleResize(awidth, aheight: TfpgCoord); override;
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleLMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleRMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState); override;
    procedure   HandleDoubleClick(x, y: integer; button: word; shiftstate: TShiftState); override;
    procedure   HandleMouseEnter; override;
    procedure   HandleMouseExit; override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    function    GetDrawText: String;
    property    AutoSelect: Boolean read FAutoSelect write SetAutoSelect default True;
    property    BorderStyle: TfpgEditBorderStyle read FBorderStyle write SetBorderStyle default ebsDefault;
    property    Font: TfpgFont read FFont;
    property    FontDesc: String read GetFontDesc write SetFontDesc;
    property    HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property    MaxLength: Integer read FMaxLength write FMaxLength;
    property    PasswordMode: Boolean read FPasswordMode write SetPasswordMode default False;
    property    PopupMenu: TfpgPopupMenu read FPopupMenu write FPopupMenu;
    property    Text: String read FText write SetText;
    property    OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    SelectionText: string;
    procedure   SelectAll;
    procedure   Clear;
    procedure   ClearSelection;
    procedure   CopyToClipboard;
    procedure   CutToClipboard;
    procedure   PasteFromClipboard;
  end;


  TfpgEdit = class(TfpgBaseEdit)
  public
    property    Font;
    property    PopupMenu;  // UI Designer doesn't fully support it yet
  published
    property    AutoSelect;
    property    BackgroundColor default clBoxColor;
    property    BorderStyle;
    property    FontDesc;
    property    HideSelection;
    property    MaxLength;
    property    PasswordMode;
    property    TabOrder;
    property    Text;
    property    TextColor;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
  end;


  TfpgBaseNumericEdit = class(TfpgBaseEdit)
  private
    fOldColor: TfpgColor;
    fAlignment: TAlignment;
    fDecimalSeparator: char;
    fNegativeColor: TfpgColor;
    fThousandSeparator: char;
    procedure   SetOldColor(const AValue: TfpgColor);
    procedure   SetAlignment(const AValue: TAlignment);
    procedure   SetDecimalSeparator(const AValue: char);
    procedure   SetNegativeColor(const AValue: TfpgColor);
    procedure   SetThousandSeparator(const AValue: char);
  protected
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandlePaint; override;
    procedure   Format; virtual;
    procedure   Justify; virtual; // to implement in derived classes
    property    OldColor: TfpgColor read fOldColor write SetOldColor;
    property    Alignment: TAlignment read fAlignment write SetAlignment default taRightJustify;
    property    AutoSelect;
    property    BackgroundColor default clBoxColor;
    property    BorderStyle;
    {Someone likes to use English operating system but localized decimal and thousand separators
     Still to implement !!}
    property    DecimalSeparator: char read fDecimalSeparator write SetDecimalSeparator;
    property    ThousandSeparator: char read fThousandSeparator write SetThousandSeparator;
    property    NegativeColor: TfpgColor read fNegativeColor write SetNegativeColor;
    property    HideSelection;
//    property    MaxLength;  { probably MaxValue and MinValue }
    property    TabOrder;
    property    TextColor;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
    property    Text;   { this should become Value }
  public
    constructor Create(AOwner: TComponent); override;
  published
    property    FontDesc;
  end;


  TfpgEditInteger = class(TfpgBaseNumericEdit)
  protected
    function    GetValue: integer; virtual;
    procedure   SetValue(const AValue: integer); virtual;
    procedure   Format; override;
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
  published
    property    Alignment;
    property    NegativeColor;
    property    Value: integer read GetValue write SetValue;
    property    TabOrder;
    property    TextColor;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
  end;


  TfpgEditFloat = class(TfpgBaseNumericEdit)
  protected
    function    GetValue: extended; virtual;
    procedure   SetValue(const AValue: extended); virtual;
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
  published
    property    Alignment;
    property    NegativeColor;
    property    DecimalSeparator;
    property    Value: extended read GetValue write SetValue;
    property    TabOrder;
    property    TextColor;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
  end;


function CreateEdit(AOwner: TComponent; x, y, w, h: TfpgCoord): TfpgEdit;


implementation

uses
  gfx_UTF8utils,
  gfx_constants;

const
  // internal popupmenu item names
  ipmCut        = 'miDefaultCut';
  ipmCopy       = 'miDefaultCopy';
  ipmPaste      = 'miDefaultPaste';
  ipmClearAll   = 'miDefaultClearAll';


function CreateEdit(AOwner: TComponent; x, y, w, h: TfpgCoord): TfpgEdit;
begin
  Result       := TfpgEdit.Create(AOwner);
  Result.Left  := x;
  Result.Top   := y;
  if w > 0 then
    Result.Width := w;
  if h < TfpgEdit(Result).FFont.Height + 6 then
    Result.Height:= TfpgEdit(Result).FFont.Height + 6
  else
    Result.Height:= h;
end;

{ TfpgBaseEdit }

procedure TfpgBaseEdit.Adjust(UsePxCursorPos: boolean = false);
begin
  AdjustTextOffset(False);
  AdjustDrawingInfo;
end;

procedure TfpgBaseEdit.AdjustTextOffset(UsePxCursorPos: boolean);
{If UsePxCursorPos then determines FCursorPos from FCursorPx (that holds mouse pointer coordinates)
 Calculates exact FCursorPx (relative to the widget bounding box) from FCursorPos
 Calculates FTextOffset based on FCursorPx}
var
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  bestchx: integer; // chx, nearest to the mouse position (indicated by FCursorPx if UsePxCursorPos = True)
  tw: integer;      // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;
  dpos: integer;  // helps to pass through an utf-8 string quickly
  VisibleWidth: integer; // width of the edit field minus side margins
begin
  if UsePxCursorPos then
  begin
    if FCursorPx > 0 then // bestchx < chx minimum
      bestchx := Low(chx)  + 1 + FCursorPx
    else                  // bestchx > chx maximum
      bestchx := High(chx) - 1 + FCursorPx;
  end else
    FCursorPx := 0;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;

  while dpos <= Length(dtext) do
  begin
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    chx := tw - FTextOffset + FSideMargin;
    if UsePxCursorPos then
    begin
      if abs(chx - FCursorPx) < abs(bestchx - FCursorPx) then
      begin
        bestchx := chx;
        FCursorPos := chnum;
      end else
      begin
        tw := ptw;
        break;
      end;
    end else
    begin
      if chnum >= FCursorPos then
        break;
    end;
    Inc(chnum);
  end;

  VisibleWidth := (FWidth - 2 * FSideMargin);
  if tw - FTextOffset > VisibleWidth - 2 then
    FTextOffset := tw - VisibleWidth + 2
  else if tw - FTextOffset < 0 then
  begin
    FTextOffset := tw;
    if tw <> 0 then
      Dec(FTextOffset, 2);
  end;

  FCursorPx := tw - FTextOffset + FSideMargin;
end;

procedure TfpgBaseEdit.AdjustDrawingInfo;
// Calculates FVisSelStartPx, FVisSelEndPx, FVisibleText, FDrawOffset
var
  // fvc, lvc: integer; // first/last visible characters
  vtstartbyte, vtendbyte: integer; // visible characters' start/end in utf-8 string, bytes
  bestfx, bestlx: integer;
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  tw: integer;    // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;   // total width on the previous step
  dpos: integer;  // helps to pass through an utf-8 string quickly
  pdp: integer;   // dpos on the previous step
  vstart, vend: integer;    // visible area start and end, pixels
  slstart, slend: integer;  // selection start and end, pixels
begin
  vstart  := FSideMargin;
  vend    := FWidth - FSideMargin;
  if FSelOffset > 0 then
  begin
    slstart := FSelStart;
    slend   := FSelStart + FSelOffset;
  end else
  begin
    slstart := FSelStart + FSelOffset;
    slend   := FSelStart;
  end;
  FVisSelStartPx := vend; // because we stop the search
  FVisSelEndPx   := vend; // after last visible character is found
  bestfx := High(chx) - 1 + vstart;
  bestlx := Low(chx)  + 1 + vend;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;
  {fvc   := 0;
  lvc   := 0;}
  FDrawOffset := 0;
  while dpos <= Length(dtext) do
  begin
    pdp := dpos;
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    chx := tw - FTextOffset + FSideMargin;

    // calculate selection-related fields
    if chnum = slstart then
      FVisSelStartPx := chx;
    if chnum = slend then
      FVisSelEndPx := chx;

    // search for the first/last visible characters
    if abs(chx - vstart) < abs(bestfx - vstart) then
    begin
      bestfx := chx;
      // fvc    := chnum;
      vtstartbyte := pdp;
      FDrawOffset := ptw;
    end;
    // in small edit field the same character can be both the first and the last, so no 'else' allowed
    if abs(chx - vend) < abs(bestlx - vend) then
    begin
      bestlx := chx;
      // lvc    := chnum;
      vtendbyte := UTF8CharAtByte(dtext, dpos, ch); // plus one more character
    end else
      break; // we can safely break after last visible character is found
    Inc(chnum);
  end;

  if FVisSelStartPx < vstart then
    FVisSelStartPx := vstart;
  if FVisSelEndPx > vend then
    FVisSelEndPx := vend;

  // FVisibleText := UTF8Copy(dtext, fvc, lvc - fvc + 2);
  FVisibleText := Copy(dtext, vtstartbyte, vtendbyte - vtstartbyte);
  FDrawOffset := FTextOffset - FDrawOffset;
end;

{function TfpgBaseEdit.PointToCharPos(x, y: integer): integer;
var
  n: integer;
  cx: integer; // character X position
  bestcx: integer;
  dtext: string;
  tw, dpos: integer;
  ch: string;
begin
  ch     := '';
  dtext  := GetDrawText;
  if x > 0 then // bestcx < cx minimum
    bestcx := Low(cx) + 1 + x
  else          // bestcx > cx maximum
    bestcx := High(cx) - 1 + x;
    
  tw   := 0;
  dpos := 0;
  n    := 0;
  Result := n;
  // searching the appropriate character position
  while dpos <= Length(dtext) do
  begin
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    tw := tw + FFont.TextWidth(ch);
    cx := tw - FTextOffset + FSideMargin;
    if abs(cx - x) < abs(bestcx - x) then
    begin
      bestcx := cx;
      Result := n;
    end else
      Exit; //==>
    Inc(n);
  end;
end;}

procedure TfpgBaseEdit.SetBorderStyle(const AValue: TfpgEditBorderStyle);
begin
  if FBorderStyle = AValue then
    Exit; //==>
  FBorderStyle := AValue;
  RePaint;
end;

procedure TfpgBaseEdit.SetHideSelection(const AValue: Boolean);
begin
  if FHideSelection = AValue then
    Exit;
  FHideSelection := AValue;
end;

procedure TfpgBaseEdit.HandlePaint;
var
  r: TfpgRect;
  tw, tw2, st, len: integer;
  dtext: string;

  // paint selection rectangle
  procedure DrawSelection;
  var
    lcolor: TfpgColor;
    r: TfpgRect;
  begin
    if Focused then
    begin
      lcolor := clSelection;
      Canvas.SetTextColor(clSelectionText);
    end
    else
    begin
      lcolor := clInactiveSel;
      Canvas.SetTextColor(clText1);
    end;

    r.SetRect(FVisSelStartPx, 3, FVisSelEndPx - FVisSelStartPx, FFont.Height);
    Canvas.SetColor(lcolor);
    Canvas.FillRectangle(r);
    Canvas.SetTextColor(clWhite);
    Canvas.AddClipRect(r);
    fpgStyle.DrawString(Canvas, -FDrawOffset + FSideMargin, 3, FVisibleText, Enabled);
    Canvas.ClearClipRect;
  end;
  
begin
  Canvas.ClearClipRect;
  r.SetRect(0, 0, Width, Height);
  case BorderStyle of
    ebsNone:
        begin
          // do nothing
        end;
    ebsDefault:
        begin
          Canvas.DrawControlFrame(r);
          InflateRect(r, -2, -2);
        end;
    ebsSingle:
        begin
          Canvas.SetColor(clShadow2);
          Canvas.DrawRectangle(r);
          InflateRect(r, -1, -1);
        end;
  end;
  Canvas.SetClipRect(r);

  if Enabled then
    Canvas.SetColor(FBackgroundColor)
  else
    Canvas.SetColor(clWindowBackground);

  Canvas.FillRectangle(r);
  dtext := GetDrawText;
  
  Canvas.SetFont(FFont);
  Canvas.SetTextColor(FTextColor);
  fpgStyle.DrawString(Canvas, -FDrawOffset + FSideMargin, 3, FVisibleText, Enabled);

  if Focused then
  begin
    // drawing selection
    if FSelOffset <> 0 then
      DrawSelection;

    // drawing cursor
    fpgCaret.SetCaret(Canvas, FCursorPx, 3, fpgCaret.Width, FFont.Height);
  end
  else
  begin
    // drawing selection
    if (AutoSelect = False) and (FSelOffset <> 0) and (HideSelection = False) then
      DrawSelection;
    fpgCaret.UnSetCaret(Canvas);
  end;
end;

procedure TfpgBaseEdit.HandleResize(awidth, aheight: TfpgCoord);
begin
  inherited HandleResize(awidth, aheight);
  AdjustDrawingInfo;
end;

procedure TfpgBaseEdit.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  s: TfpgChar;
  prevval: string;
begin
  prevval   := Text;
  s         := AText;

  if not consumed then
  begin
    // Handle only printable characters
    // UTF-8 characters beyond ANSI range are supposed to be printable
    if ((Ord(AText[1]) > 31) and (Ord(AText[1]) < 127)) or (Length(AText) > 1) then
    begin
      if (FMaxLength <= 0) or (UTF8Length(FText) < FMaxLength) then
      begin
        DeleteSelection;
        UTF8Insert(s, FText, FCursorPos + 1);
        Inc(FCursorPos);
        FSelStart := FCursorPos;
        Adjust;
      end;
      consumed := True;
    end;

    if prevval <> Text then
      DoOnChange;
  end;
  
  if consumed then
    RePaint;

  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgBaseEdit.HandleKeyPress(var keycode: word;
  var shiftstate: TShiftState; var consumed: boolean);
var
  hasChanged: boolean;

  procedure StopSelection;
  begin
    FSelStart  := FCursorPos;
    FSelOffset := 0;
  end;

begin
  hasChanged := False;

  Consumed := True;
  case CheckClipBoardKey(keycode, shiftstate) of
    ckCopy:
        begin
          DoCopy;
        end;
    ckPaste:
        begin
          DoPaste;
          hasChanged := True;
        end;
    ckCut:
        begin
          DoCopy;
          DeleteSelection;
          Adjust;
          hasChanged := True;
        end;
  else
    Consumed := False;
  end;


  if not Consumed then
  begin
    // checking for movement keys:
    case keycode of
      keyLeft:
        if FCursorPos > 0 then
        begin
          consumed := True;
          Dec(FCursorPos);

          if (ssCtrl in shiftstate) then
            // word search...
            //                    while (FCursorPos > 0) and not ptkIsAlphaNum(copy(FText,FCursorPos,1))
            //                      do Dec(FCursorPos);
            //                    while (FCursorPos > 0) and ptkIsAlphaNum(copy(FText,FCursorPos,1))
            //                      do Dec(FCursorPos);
          ;

        end;

      keyRight:
        if FCursorPos < UTF8Length(FText) then
        begin
          consumed := True;
          Inc(FCursorPos);

          if (ssCtrl in shiftstate) then
            // word search...
            //                    while (FCursorPos < Length(FText)) and ptkIsAlphaNum(copy(FText,FCursorPos+1,1))
            //                      do Inc(FCursorPos);
            //                    while (FCursorPos < Length(FText)) and not ptkIsAlphaNum(copy(FText,FCursorPos+1,1))
            //                      do Inc(FCursorPos);
          ;
        end;

      keyHome:
        begin
          consumed := True;
          FCursorPos := 0;
        end;

      keyEnd:
        begin
          consumed := True;
          FCursorPos := UTF8Length(FText);
        end;
    end;

    if Consumed then
    begin
      FSelecting := (ssShift in shiftstate);

      if FSelecting then
        FSelOffset := FCursorPos - FSelStart
      else
        StopSelection;
        
      Adjust;
    end;
  end; // movement key checking

  if not Consumed then
  begin
    consumed := True;

    case keycode of
      keyBackSpace:
          begin
            if FCursorPos > 0 then
            begin
              UTF8Delete(FText, FCursorPos, 1);
              Dec(FCursorPos);
              hasChanged := True;
            end;// backspace
          end;


      keyDelete:
          begin
            if FSelOffset <> 0 then
              DeleteSelection
            else if FCursorPos < UTF8Length(FText) then
              UTF8Delete(FText, FCursorPos + 1, 1);
            hasChanged := True;
          end;
      else
        Consumed := False;
    end;

    if Consumed then
    begin
      StopSelection;
      Adjust;
    end;
  end;  { if }

  if consumed then
    RePaint
  else
    inherited;

  if hasChanged then
    if Assigned(FOnChange) then
      FOnChange(self);
end;

procedure TfpgBaseEdit.HandleLMouseDown(x, y: integer; shiftstate: TShiftState);
{var
  cp: integer;}
begin
  inherited HandleLMouseDown(x, y, shiftstate);
  
  {cp := PointToCharPos(x, y);
  FMouseDragPos := cp;
  FCursorPos    := cp;
  if (ssShift in shiftstate) then
    FSelOffset := FCursorPos - FSelStart
  else
  begin
    FSelStart  := cp;
    FSelOffset := 0;
  end;
  Adjust;
  Repaint;}
  
  FCursorPx := x;
  AdjustTextOffset(True);
  FMouseDragPos := FCursorPos;
  if (ssShift in shiftstate) then
    FSelOffset := FCursorPos - FSelStart
  else
  begin
    FSelStart  := FCursorPos;
    FSelOffset := 0;
  end;
  AdjustDrawingInfo;
  RePaint;
end;

procedure TfpgBaseEdit.HandleRMouseDown(x, y: integer; shiftstate: TShiftState);
begin
  inherited HandleRMouseDown(x, y, shiftstate);
  if Assigned(PopupMenu) then
    PopupMenu.ShowAt(self, x, y)
  else
    ShowDefaultPopupMenu(x, y, ShiftState);
end;

procedure TfpgBaseEdit.HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState);
var
  cp: integer;
begin
  if (btnstate and MOUSE_LEFT) = 0 then
    Exit;
    
  {cp := PointToCharPos(x, y);

  //FMouseDragPos := cp;
  FSelOffset := cp - FSelStart;
  if FCursorPos <> cp then
  begin
    FCursorPos := cp;
    Adjust;
    Repaint;
  end;}
  
  cp := FCursorPos;
  FCursorPx := x;
  AdjustTextOffset(True);
  if FCursorPos <> cp then
  begin
    FSelOffset := FCursorPos - FSelStart;
    AdjustDrawingInfo;
    Repaint;
  end;
end;

procedure TfpgBaseEdit.HandleDoubleClick(x, y: integer; button: word; shiftstate: TShiftState);
begin
  // button is always Mouse_Left, but lets leave this test here for good measure
  if button = MOUSE_LEFT then
    SelectAll
  else
    inherited;
end;

procedure TfpgBaseEdit.HandleMouseEnter;
begin
  inherited HandleMouseEnter;
  if (csDesigning in ComponentState) then
    Exit;
  if Enabled then
    MouseCursor := mcIBeam;
end;

procedure TfpgBaseEdit.HandleMouseExit;
begin
  inherited HandleMouseExit;
  if (csDesigning in ComponentState) then
    Exit;
  MouseCursor := mcDefault;
end;

procedure TfpgBaseEdit.HandleSetFocus;
begin
  inherited HandleSetFocus;
  if AutoSelect then
    SelectAll;
end;

procedure TfpgBaseEdit.HandleKillFocus;
begin
  inherited HandleKillFocus;
  if AutoSelect then
    FSelOffset := 0;
end;

function TfpgBaseEdit.GetDrawText: string;
begin
  if not PassWordMode then
    Result := FText
  else
    Result := StringOfChar('*', UTF8Length(FText));
end;

constructor TfpgBaseEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont             := fpgGetFont('#Edit1');  // owned object !
  Focusable         := True;
  FHeight           := FFont.Height + 6;
  FWidth            := 120;
  FTextColor        := Parent.TextColor;
  FBackgroundColor  := clBoxColor;
  FAutoSelect       := True;
  FSelecting        := False;
  FHideSelection    := True;
  FSideMargin       := 3;
  FMaxLength        := 0; // no limit
  FText             := '';
  FCursorPos        := UTF8Length(FText);
  FSelStart         := FCursorPos;
  FSelOffset        := 0;
  FTextOffset       := 0;
  FPasswordMode     := False;
  FBorderStyle      := ebsDefault;
  FPopupMenu        := nil;
  FDefaultPopupMenu := nil;
  FOnChange         := nil;
end;

destructor TfpgBaseEdit.Destroy;
begin
  if Assigned(FDefaultPopupMenu) then
    FDefaultPopupMenu.Free;
  FFont.Free;
  inherited Destroy;
end;

function TfpgBaseEdit.SelectionText: string;
begin
  if FSelOffset <> 0 then
  begin
    if FSelOffset < 0 then
      Result := UTF8Copy(FText, 1 + FSelStart + FSelOffset, -FSelOffset)
    else
    begin
      Result := UTF8Copy(FText, 1 + FSelStart, FSelOffset);
    end;
  end
  else
    Result := '';
end;

procedure TfpgBaseEdit.SetPasswordMode (const AValue: boolean );
begin
  if FPasswordMode = AValue then
    Exit; //==>
  FPasswordMode := AValue;
  Adjust;
  RePaint;
end;

function TfpgBaseEdit.GetFontDesc: string;
begin
  Result := FFont.FontDesc;
end;

procedure TfpgBaseEdit.SetFontDesc(const AValue: string);
begin
  FFont.Free;
  FFont := fpgGetFont(AValue);
  if Height < FFont.Height + 6 then
    Height:= FFont.Height + 6;
  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.SetText(const AValue: string);
var
  s: string;
begin
  if FText = AValue then
    Exit;

  if FMaxLength <> 0 then
  begin
    if UTF8Length(FText) > FMaxLength then
      s := UTF8Copy(AValue, 1, FMaxLength)
    else
      s := AValue;
  end
  else
    s := AValue;

  FText       := s;
  FCursorPos  := UTF8Length(FText);
  FSelStart   := FCursorPos;
  FSelOffset  := 0;
  FTextOffset := 0;

  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.DefaultPopupCut(Sender: TObject);
begin
  CutToClipboard;
end;

procedure TfpgBaseEdit.DefaultPopupCopy(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TfpgBaseEdit.DefaultPopupPaste(Sender: TObject);
begin
  PasteFromClipboard
end;

procedure TfpgBaseEdit.DefaultPopupClearAll(Sender: TObject);
begin
  Clear;
end;

procedure TfpgBaseEdit.SetDefaultPopupMenuItemsState;
var
  i: integer;
  itm: TfpgMenuItem;
begin
  for i := 0 to FDefaultPopupMenu.ComponentCount-1 do
  begin
    if FDefaultPopupMenu.Components[i] is TfpgMenuItem then
    begin
      itm := TfpgMenuItem(FDefaultPopupMenu.Components[i]);
      // enabled/disable menu items
      if itm.Name = ipmCut then
        itm.Enabled := FSelOffset <> 0
      else if itm.Name = ipmCopy then
        itm.Enabled := FSelOffset <> 0
      else if itm.Name = ipmPaste then
        itm.Enabled := fpgClipboard.Text <> ''
      else if itm.Name = ipmClearAll then
        itm.Enabled := Text <> '';
    end;
  end;
end;

procedure TfpgBaseEdit.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

procedure TfpgBaseEdit.ShowDefaultPopupMenu(const x, y: integer;
  const shiftstate: TShiftState);
var
  itm: TfpgMenuItem;
begin
  if not Assigned(FDefaultPopupMenu) then
  begin
    { todo: This text needs to be localized }
    FDefaultPopupMenu := TfpgPopupMenu.Create(nil);
    itm := FDefaultPopupMenu.AddMenuItem(rsCut, '', @DefaultPopupCut);
    itm.Name := ipmCut;
    itm := FDefaultPopupMenu.AddMenuItem(rsCopy, '', @DefaultPopupCopy);
    itm.Name := ipmCopy;
    itm := FDefaultPopupMenu.AddMenuItem(rsPaste, '', @DefaultPopupPaste);
    itm.Name := ipmPaste;
    itm := FDefaultPopupMenu.AddMenuItem(rsDelete, '', @DefaultPopupClearAll);
    itm.Name := ipmClearAll;
  end;
  
  SetDefaultPopupMenuItemsState;
  FDefaultPopupMenu.ShowAt(self, x, y);
end;

procedure TfpgBaseEdit.DeleteSelection;
begin
  if FSelOffset <> 0 then
  begin
    if FSelOffset < 0 then
    begin
      UTF8Delete(FText, 1 + FSelStart + FSelOffset, -FSelOffset);
      FCurSorPos := FSelStart + FSelOffset;
    end
    else
    begin
      UTF8Delete(FText, 1 + FSelStart, FSelOffset);
      FCurSorPos := FSelStart;
    end;
    FSelOffset := 0;
    FSelStart := FCursorPos;
  end;
end;

procedure TfpgBaseEdit.DoCopy;
begin
  if FSelOffset = 0 then
    Exit; //==>
  fpgClipboard.Text := SelectionText;
end;

procedure TfpgBaseEdit.DoPaste;
var
  s: string;
begin
  DeleteSelection;
  s := fpgClipboard.Text;

  if (FMaxLength > 0) then
    if UTF8Length(FText) + UTF8Length(s) > FMaxLength then
      s := UTF8Copy(s, 1, FMaxLength - UTF8Length(FText));  // trim the clipboard text if needed

  if UTF8Length(s) < 1 then
    Exit; //==>

  UTF8Insert(s, FText, FCursorPos + 1);
  FCursorPos := FCursorPos + UTF8Length(s);
  FSelStart  := FCursorPos;
  Adjust;
  Repaint;
end;

procedure TfpgBaseEdit.SetAutoSelect(const AValue: Boolean);
begin
  if FAutoSelect = AValue then
    Exit; //==>
  FAutoSelect := AValue;
end;

procedure TfpgBaseEdit.SelectAll;
begin
  FSelecting  := True;
  FSelStart   := 0;
  FSelOffset  := UTF8Length(FText);
  FCursorPos  := FSelOffset;
  Adjust;
  Repaint;
end;

procedure TfpgBaseEdit.Clear;
begin
  Text := '';
end;

procedure TfpgBaseEdit.ClearSelection;
begin
  DeleteSelection;
  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.CopyToClipboard;
begin
  DoCopy;
end;

procedure TfpgBaseEdit.CutToClipboard;
begin
  DoCopy;
  DeleteSelection;
  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.PasteFromClipboard;
begin
  DoPaste;
end;

{ TfpgBaseNumericEdit }

procedure TfpgBaseNumericEdit.SetOldColor(const AValue: TfpgColor);
begin
  if fOldColor=AValue then exit;
  fOldColor:=AValue;
end;

procedure TfpgBaseNumericEdit.SetAlignment(const AValue: TAlignment);
begin
  if fAlignment=AValue then exit;
  fAlignment:=AValue;
end;

procedure TfpgBaseNumericEdit.SetDecimalSeparator(const AValue: char);
begin
  if fDecimalSeparator=AValue then exit;
  fDecimalSeparator:=AValue;
end;

procedure TfpgBaseNumericEdit.SetNegativeColor(const AValue: TfpgColor);
begin
  if fNegativeColor=AValue then exit;
  fNegativeColor:=AValue;
end;

procedure TfpgBaseNumericEdit.SetThousandSeparator(const AValue: char);
begin
  if fThousandSeparator=AValue then exit;
  fThousandSeparator:=AValue;
end;

procedure TfpgBaseNumericEdit.Justify;
begin
  //based on Alignment property this method will align the derived edit correctly.
end;

procedure TfpgBaseNumericEdit.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
begin
  Format; // just call format virtual procedure to have a simple way to manage polymorphism here
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgBaseNumericEdit.HandlePaint;
var
  x: TfpgCoord;
  s: string;
  r: TfpgRect;
  tw: integer;
begin
  if Alignment = taRightJustify then
  begin
    Canvas.BeginDraw;
    inherited HandlePaint;
    //  Canvas.ClearClipRect;
    //  r.SetRect(0, 0, Width, Height);
    Canvas.Clear(BackgroundColor);
    Canvas.SetFont(Font);
    Canvas.SetTextColor(TextColor);
    x := Width - Font.TextWidth(Text) - 1;
    Canvas.DrawString(x,1,Text);
    Canvas.EndDraw;
    if Focused then
      fpgCaret.SetCaret(Canvas, x + Font.TextWidth(Text) - 1, 3, fpgCaret.Width, Font.Height);
  end
  else
  inherited;
end;

procedure TfpgBaseNumericEdit.Format;
begin
  // Colour negative number
  if LeftStr(Text,1) = '-' then
    TextColor := NegativeColor
  else
    TextColor := OldColor;
end;

constructor TfpgBaseNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fAlignment := taRightJustify;
  DecimalSeparator := SysUtils.DecimalSeparator;
  ThousandSeparator := SysUtils.ThousandSeparator;
  NegativeColor := clRed;
  OldColor := TextColor;
end;

{ TfpgEditInteger }

function TfpgEditInteger.GetValue: integer;
begin
  try
    Result := StrToInt(Text);
  except
    on E: EConvertError do
    begin
      Result := 0;
      Text := '';
      Invalidate;
    end;
  end;
end;

procedure TfpgEditInteger.SetValue(const AValue: integer);
begin
  try
    Text := IntToStr(AValue);
  except
    on E: EConvertError do
      Text := '';
  end;
end;

procedure TfpgEditInteger.Format;
begin
// here there will be, for example, thousand separator integer formatting routine
  inherited Format;
end;

procedure TfpgEditInteger.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  n: integer;
begin
  n := Ord(AText[1]);
  if ((n >= 48) and (n <= 57) or (n = Ord('-')) and (Pos(AText[1], Self.Text) <= 0)) then
    consumed := False
  else
    consumed := True;
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

{ TfpgEditFloat }

function TfpgEditFloat.GetValue: extended;
begin
  try
    Result := StrToFloat(Text);
  except
    on E: EConvertError do
    begin
      Result := 0;
      Text := FloatToStr(Result);
    end;
  end;
end;

procedure TfpgEditFloat.SetValue(const AValue: extended);
begin
  try
    Text := FloatToStr(AValue);
  except
    on E: EConvertError do
      Text := '';
  end;
end;

procedure TfpgEditFloat.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  n: integer;
begin
  n := Ord(AText[1]);
  if ((n >= 48) and (n <= 57) or (n = Ord('-')) and (Pos(AText[1], Self.Text) <= 0))
     or ((n = Ord(Self.DecimalSeparator)) and (Pos(AText[1], Self.Text) <= 0)) then
    consumed := False
  else
    consumed := True;
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;


end.

