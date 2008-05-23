program panel_test;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  { you can add units after this } fpgfx,
  MainForm;

procedure MainProc;
var
  frmMain: TfrmMain;
begin
fpgApplication.Initialize;
frmMain:= TfrmMain.Create(nil);
try
  frmMain.Show;
  fpgApplication.Run;
finally
  frmMain.Free;
  end;
end;

begin
MainProc;
end.

