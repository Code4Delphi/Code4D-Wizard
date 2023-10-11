{ Freepascal TProcess ported to Delphi

  License: FPC Modified LGPL (can use in commercial apps)

 Changes to the code marked with "L505" in comments  }

{
 This file is part of the Free Component Library (FCL)
 Copyright (c) 1999-2000 by the Free Pascal development team

 See the file COPYING.FPC, included in this distribution,
 for details about the copyright.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit C4D.Wizard.dprocess;

interface

uses
  classes,
  C4D.Wizard.dpipes,
  system.types,
  sysutils;

Type
  TProcessOption = (poRunSuspended, poWaitOnExit,
    poUsePipes, poStderrToOutPut,
    poNoConsole, poNewConsole,
    poDefaultErrorMode, poNewProcessGroup,
    poDebugProcess, poDebugOnlyThisProcess);

  TShowWindowOptions = (swoNone, swoHIDE, swoMaximize, swoMinimize, swoRestore, swoShow,
    swoShowDefault, swoShowMaximized, swoShowMinimized,
    swoshowMinNOActive, swoShowNA, swoShowNoActivate, swoShowNormal);

  TStartupOption = (suoUseShowWindow, suoUseSize, suoUsePosition,
    suoUseCountChars, suoUseFillAttribute);

  TProcessPriority = (ppHigh, ppIdle, ppNormal, ppRealTime);

  TProcessOptions = set of TProcessOption;
  TStartupOptions = set of TStartupOption;

Type
  {$IFDEF MACOS} //L505
  TProcessForkEvent = procedure(Sender: TObject) of object;
  {$ENDIF}
  { TProcess }

  TProcess = Class(TComponent)
  Private
    FProcessOptions: TProcessOptions;
    FStartupOptions: TStartupOptions;
    FProcessID: Integer;
    FTerminalProgram: string;
    FThreadID: Integer;
    FProcessHandle: Thandle;
    FThreadHandle: Thandle;
    FFillAttribute: Cardinal;
    FApplicationName: string;
    FConsoleTitle: string;
    FCommandLine: string;
    FCurrentDirectory: string;
    FDesktop: string;
    FEnvironment: TStrings;
    FExecutable: string;
    FParameters: TStrings;
    FShowWindow: TShowWindowOptions;
    FInherithandles: Boolean;
    {$IFDEF MACOS} // L505
    FForkEvent: TProcessForkEvent;
    {$ENDIF}
    FProcessPriority: TProcessPriority;
    dwXCountchars,
      dwXSize,
      dwYsize,
      dwx,
      dwYcountChars,
      dwy: Cardinal;
    FXTermProgram: string;
    FPipeBufferSize: Cardinal;
    Procedure FreeStreams;
    Function GetExitStatus: Integer;
    Function GetExitCode: Integer;
    Function GetRunning: Boolean;
    Function GetWindowRect: TRect;
    procedure SetCommandLine(const AValue: string);
    procedure SetParameters(const AValue: TStrings);
    Procedure SetWindowRect(Value: TRect);
    Procedure SetShowWindow(Value: TShowWindowOptions);
    Procedure SetWindowColumns(Value: Cardinal);
    Procedure SetWindowHeight(Value: Cardinal);
    Procedure SetWindowLeft(Value: Cardinal);
    Procedure SetWindowRows(Value: Cardinal);
    Procedure SetWindowTop(Value: Cardinal);
    Procedure SetWindowWidth(Value: Cardinal);
    procedure SetApplicationName(const Value: string);
    procedure SetProcessOptions(const Value: TProcessOptions);
    procedure SetActive(const Value: Boolean);
    procedure SetEnvironment(const Value: TStrings);
    Procedure ConvertCommandLine;
    function PeekExitStatus: Boolean;
  Protected
    FRunning: Boolean;
    FExitCode: Cardinal;
    FInputStream: TOutputPipeStream;
    FOutputStream: TInputPipeStream;
    FStderrStream: TInputPipeStream;
    procedure CloseProcessHandles; virtual;
    Procedure CreateStreams(InHandle, OutHandle, ErrHandle: Longint); virtual;
    procedure FreeStream(var AStream: THandleStream);
    procedure Loaded; override;
  Public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Execute; virtual;
    procedure CloseInput; virtual;
    procedure CloseOutput; virtual;
    procedure CloseStderr; virtual;
    Function Resume: Integer; virtual;
    Function Suspend: Integer; virtual;
    Function Terminate(AExitCode: Integer): Boolean; virtual;
    Function WaitOnExit: Boolean;
    Property WindowRect: TRect Read GetWindowRect Write SetWindowRect;
    Property Handle: Thandle Read FProcessHandle;
    Property ProcessHandle: Thandle Read FProcessHandle;
    Property ThreadHandle: Thandle Read FThreadHandle;
    Property ProcessID: Integer Read FProcessID;
    Property ThreadID: Integer Read FThreadID;
    Property Input: TOutputPipeStream Read FInputStream;
    Property Output: TInputPipeStream Read FOutputStream;
    Property Stderr: TInputPipeStream Read FStderrStream;
    Property ExitStatus: Integer Read GetExitStatus;
    Property ExitCode: Integer Read GetExitCode;
    Property InheritHandles: Boolean Read FInherithandles Write FInherithandles;
    {$IFDEF MACOS} // L505
    property OnForkEvent: TProcessForkEvent Read FForkEvent Write FForkEvent;
    {$ENDIF}
  Published
    property PipeBufferSize: Cardinal read FPipeBufferSize write FPipeBufferSize default 1024;
    Property Active: Boolean Read GetRunning Write SetActive;
    Property ApplicationName: string Read FApplicationName Write SetApplicationName; //deprecated; //L505
    Property CommandLine: string Read FCommandLine Write SetCommandLine; //deprecated;  //L505
    Property Executable: string Read FExecutable Write FExecutable;
    Property Parameters: TStrings Read FParameters Write SetParameters;
    Property ConsoleTitle: string Read FConsoleTitle Write FConsoleTitle;
    Property CurrentDirectory: string Read FCurrentDirectory Write FCurrentDirectory;
    Property Desktop: string Read FDesktop Write FDesktop;
    Property Environment: TStrings Read FEnvironment Write SetEnvironment;
    Property Options: TProcessOptions Read FProcessOptions Write SetProcessOptions;
    Property Priority: TProcessPriority Read FProcessPriority Write FProcessPriority;
    Property StartupOptions: TStartupOptions Read FStartupOptions Write FStartupOptions;
    Property Running: Boolean Read GetRunning;
    Property ShowWindow: TShowWindowOptions Read FShowWindow Write SetShowWindow;
    Property WindowColumns: Cardinal Read dwXCountchars Write SetWindowColumns;
    Property WindowHeight: Cardinal Read dwYsize Write SetWindowHeight;
    Property WindowLeft: Cardinal Read dwx Write SetWindowLeft;
    Property WindowRows: Cardinal Read dwYcountChars Write SetWindowRows;
    Property WindowTop: Cardinal Read dwy Write SetWindowTop;
    Property WindowWidth: Cardinal Read dwXSize Write SetWindowWidth;
    Property FillAttribute: Cardinal read FFillAttribute Write FFillAttribute;
    Property XTermProgram: string Read FXTermProgram Write FXTermProgram;
  end;

  EProcess = Class(Exception);

Procedure CommandToList(S: string; List: TStrings);

{$IFDEF MACOS}
//L505
Var
  TryTerminals: Array of string;
  XTermProgram: string;
Function DetectXTerm: string;
{$ENDIF}

{ // L505: changed to AnsiString
  function RunCommandIndir(const curdir:string;const exename:string;const commands:array of string;out outputstring:string; out exitstatus:integer; Options : TProcessOptions = []):integer; overload; //L505
 function RunCommandIndir(const curdir:string;const exename:string;const commands:array of string;out outputstring:string; Options : TProcessOptions = []):boolean; overload; // L505
 function RunCommand(const exename:string;const commands:array of string;out outputstring:string; Options : TProcessOptions = []):boolean; overload;// L505


 function RunCommandInDir(const curdir,cmdline:string;out outputstring:string):boolean; deprecated; overload; // L505
 function RunCommand(const cmdline:string;out outputstring:string):boolean; deprecated; overload; // L505
}

function RunCommandIndir(const curdir: string; const exename: string; const commands: array of string; out outputstring: AnsiString; out ExitStatus: Integer; Options: TProcessOptions = []): Integer;
  overload; //L505
function RunCommandIndir(const curdir: string; const exename: string; const commands: array of string; out outputstring: AnsiString; Options: TProcessOptions = []): Boolean; overload; // L505
function RunCommand(const exename: string; const commands: array of string; out outputstring: AnsiString; Options: TProcessOptions = []): Boolean; overload;// L505

function RunCommandIndir(const curdir, cmdline:string;out outputstring: AnsiString): Boolean; deprecated; overload; // L505
function RunCommand(const cmdline:string;out outputstring: AnsiString): Boolean; deprecated; overload; // L505

implementation

{$IFDEF MACOS} //L505
{$I process_macos.inc}
{$ENDIF}

{$IFDEF MSWINDOWS}  //L505
{$I process_win.inc}
{$ENDIF}


Procedure CommandToList(S: string; List: TStrings);

  Function GetNextWord: string;

  Const
    WhiteSpace = [' ', #9, #10, #13];
    Literals = ['"', ''''];

  Var
    Wstart, wend: Integer;
    InLiteral: Boolean;
    LastLiteral: char;

  begin
    Wstart:=1;
    // L505 change "in" to CharInSet
    While (Wstart<=Length(S)) and (CharInSet(S[Wstart], WhiteSpace)) do
      Inc(Wstart);
    wend:=Wstart;
    InLiteral:=False;
    LastLiteral:=#0;
    // L505
    // While (Wend<=Length(S)) and (Not (S[Wend] in WhiteSpace) or InLiteral) do
    While (wend<=Length(S)) and (Not (CharInSet(S[wend], WhiteSpace)) or InLiteral) do
    begin
      // L505 changed "in" to CharInSet
      if CharInSet(S[wend], Literals) then
        If InLiteral then
          InLiteral:=Not (S[wend]=LastLiteral)
        else
        begin
          InLiteral:=True;
          LastLiteral:=S[wend];
        end;
      Inc(wend);
    end;

    Result:=Copy(S, Wstart, wend-Wstart);
    // L505 changed "in" to CharInSet
    if (Length(Result) > 0)
      and (Result[1] = Result[Length(Result)]) // if 1st char = last char and..
      and (CharInSet(Result[1], Literals)) then // it's one of the literals, then
      Result:=Copy(Result, 2, Length(Result) - 2); //delete the 2 (but not others in it)
    // L505
    // While (WEnd<=Length(S)) and (S[Wend] in WhiteSpace) do
    While (wend<=Length(S)) and (CharInSet(S[wend], WhiteSpace)) do
      Inc(wend);
    Delete(S, 1, wend-1);

  end;

Var
  W: string;

begin
  While Length(S)>0 do
  begin
    W:=GetNextWord;
    If (W<>'') then
      List.Add(W);
  end;
end;

Constructor TProcess.Create(AOwner: TComponent);
begin
  Inherited;
  FProcessPriority:=ppNormal;
  FShowWindow:=swoNone;
  FInherithandles:=True;
  {$IFDEF MACOS} // L505
  FForkEvent:=nil;
  {$ENDIF}
  FPipeBufferSize := 1024;
  FEnvironment:=TStringList.Create;
  FParameters:=TStringList.Create;
end;

Destructor TProcess.Destroy;
begin
  FParameters.Free;
  FEnvironment.Free;
  FreeStreams;
  CloseProcessHandles;
  Inherited Destroy;
end;

Procedure TProcess.FreeStreams;
begin
  If FStderrStream<>FOutputStream then
    FreeStream(THandleStream(FStderrStream));
  FreeStream(THandleStream(FOutputStream));
  FreeStream(THandleStream(FInputStream));
end;

Function TProcess.GetExitStatus: Integer;
begin
  GetRunning;
  Result:=FExitCode;
end;

{$IFNDEF OS_HASEXITCODE}

Function TProcess.GetExitCode: Integer;
begin
  if Not Running then
    Result:=GetExitStatus
  else
    Result:=0
end;
{$ENDIF}


Function TProcess.GetRunning: Boolean;
begin
  IF FRunning then
    FRunning:=Not PeekExitStatus;
  Result:=FRunning;
end;

Procedure TProcess.CreateStreams(InHandle, OutHandle, ErrHandle: Longint);

begin
  FreeStreams;
  FInputStream:=TOutputPipeStream.Create(InHandle);
  FOutputStream:=TInputPipeStream.Create(OutHandle);
  if Not (poStderrToOutPut in FProcessOptions) then
    FStderrStream:=TInputPipeStream.Create(ErrHandle);
end;

procedure TProcess.FreeStream(var AStream: THandleStream);
begin
  if AStream = nil then
    exit;
  FreeAndNil(AStream);
end;

procedure TProcess.Loaded;
begin
  inherited Loaded;
  If (csDesigning in ComponentState) and (FCommandLine<>'') then
    ConvertCommandLine;
end;

procedure TProcess.CloseInput;
begin
  FreeStream(THandleStream(FInputStream));
end;

procedure TProcess.CloseOutput;
begin
  FreeStream(THandleStream(FOutputStream));
end;

procedure TProcess.CloseStderr;
begin
  FreeStream(THandleStream(FStderrStream));
end;

Procedure TProcess.SetWindowColumns(Value: Cardinal);
begin
  if Value<>0 then
    Include(FStartupOptions, suoUseCountChars);
  dwXCountchars:=Value;
end;

Procedure TProcess.SetWindowHeight(Value: Cardinal);
begin
  if Value<>0 then
    Include(FStartupOptions, suoUsePosition);
  dwYsize:=Value;
end;

Procedure TProcess.SetWindowLeft(Value: Cardinal);
begin
  if Value<>0 then
    Include(FStartupOptions, suoUseSize);
  dwx:=Value;
end;

Procedure TProcess.SetWindowTop(Value: Cardinal);
begin
  if Value<>0 then
    Include(FStartupOptions, suoUsePosition);
  dwy:=Value;
end;

Procedure TProcess.SetWindowWidth(Value: Cardinal);
begin
  If (Value<>0) then
    Include(FStartupOptions, suoUseSize);
  dwXSize:=Value;
end;

Function TProcess.GetWindowRect: TRect;
begin
  With Result do
  begin
    Left:=dwx;
    Right:=dwx+dwXSize;
    Top:=dwy;
    Bottom:=dwy+dwYsize;
  end;
end;

procedure TProcess.SetCommandLine(const AValue: string);
begin
  if FCommandLine=AValue then
    exit;
  FCommandLine:=AValue;
  If Not (csLoading in ComponentState) then
    ConvertCommandLine;
end;

procedure TProcess.SetParameters(const AValue: TStrings);
begin
  FParameters.Assign(AValue);
end;

Procedure TProcess.SetWindowRect(Value: TRect);
begin
  Include(FStartupOptions, suoUseSize);
  Include(FStartupOptions, suoUsePosition);
  With Value do
  begin
    dwx:=Left;
    dwXSize:=Right-Left;
    dwy:=Top;
    dwYsize:=Bottom-Top;
  end;
end;

Procedure TProcess.SetWindowRows(Value: Cardinal);
begin
  if Value<>0 then
    Include(FStartupOptions, suoUseCountChars);
  dwYcountChars:=Value;
end;

procedure TProcess.SetApplicationName(const Value: string);
begin
  FApplicationName := Value;
  If (csDesigning in ComponentState) and
    (FCommandLine='') then
    FCommandLine:=Value;
end;

procedure TProcess.SetProcessOptions(const Value: TProcessOptions);
begin
  FProcessOptions := Value;
  If poNewConsole in FProcessOptions then
    Exclude(FProcessOptions, poNoConsole);
  if poRunSuspended in FProcessOptions then
    Exclude(FProcessOptions, poWaitOnExit);
end;

procedure TProcess.SetActive(const Value: Boolean);
begin
  if (Value<>GetRunning) then
    If Value then
      Execute
    else
      Terminate(0);
end;

procedure TProcess.SetEnvironment(const Value: TStrings);
begin
  FEnvironment.Assign(Value);
end;

procedure TProcess.ConvertCommandLine;
begin
  FParameters.Clear;
  CommandToList(FCommandLine, FParameters);
  If FParameters.Count>0 then
  begin
    Executable:=FParameters[0];
    FParameters.Delete(0);
  end;
end;

Const
  READ_BYTES = 65536; // not too small to avoid fragmentation when reading large files.

  // helperfunction that does the bulk of the work.
  // We need to also collect stderr output in order to avoid
  // lock out if the stderr pipe is full.
  // L505: changed to AnsiString
  // function internalRuncommand(p:TProcess;out outputstring: string;
  //                            out stderrstring: string; out exitstatus:integer):integer;
function internalRuncommand(p: TProcess;out outputstring: AnsiString;
  out stderrstring: AnsiString; out ExitStatus: Integer): Integer;
var
  numbytes, bytesread, available: Integer;
  outputlength, stderrlength: Integer;
  stderrnumbytes, stderrbytesread: Integer;
begin
  Result:=-1;
  bytesread:=0;
  outputlength:=0;
  stderrbytesread:=0;
  stderrlength:=0;

  try
    try
      p.Options := p.Options + [poUsePipes];
      p.Execute;

      while p.Running do
      begin
        // Only call ReadFromStream if Data from corresponding stream
        // is already available, otherwise, on  linux, the read call
        // is blocking, and thus it is not possible to be sure to handle
        // big data amounts bboth on output and stderr pipes. PM.
        available:=p.Output.NumBytesAvailable;
        // writeln('DEBUG: bytesavail: ', P.Output.NumBytesAvailable);
        if available > 0 then
        begin
          if (bytesread + available > outputlength) then
          begin
            outputlength:=bytesread + READ_BYTES;
            Setlength(outputstring, outputlength);
          end;
          numbytes := p.Output.Read(outputstring[1+bytesread], available);
          // L505 if in the future above string is unicodestring, above may need work NOTE: pchar is zero based . http://docwiki.embarcadero.com/RADStudio/Seattle/en/Using_Streams_to_Read_or_Write_Data
          // NumBytes := p.Output.Read(pchar(outputstring)[bytesread], available);

          if numbytes > 0 then
            Inc(bytesread, numbytes);
        end
        // The check for assigned(P.stderr) is mainly here so that
        // if we use poStderrToOutput in p.Options, we do not access invalid memory.
        else if assigned(p.Stderr) and (p.Stderr.NumBytesAvailable > 0) then
        begin
          available:=p.Stderr.NumBytesAvailable;
          if (stderrbytesread + available > stderrlength) then
          begin
            stderrlength:=stderrbytesread + READ_BYTES;
            Setlength(stderrstring, stderrlength);
          end;
          stderrnumbytes := p.Stderr.Read(stderrstring[1+stderrbytesread], available);
          // L505 in the future if the above is a unicodestring this may need work, and NOTE: pchar is zero based
          // StderrNumBytes := p.StdErr.Read(pchar(stderrstring)[StderrBytesRead], available);

          if stderrnumbytes > 0 then
            Inc(stderrbytesread, stderrnumbytes);
        end
        else
          Sleep(100);
      end;
      // Get left output after end of execution
      available:=p.Output.NumBytesAvailable;
      while available > 0 do
      begin
        if (bytesread + available > outputlength) then
        begin
          outputlength:=bytesread + READ_BYTES;
          Setlength(outputstring, outputlength);
        end;
        numbytes := p.Output.Read(outputstring[1+bytesread], available);
        // L505 if above is unicodestring in the future it may need work, and NOTE: pchar is zero based
        // NumBytes := p.Output.Read(pchar(outputstring)[bytesread], available);

        if numbytes > 0 then
          Inc(bytesread, numbytes);
        available:=p.Output.NumBytesAvailable;
      end;
      Setlength(outputstring, bytesread);
      while assigned(p.Stderr) and (p.Stderr.NumBytesAvailable > 0) do
      begin
        available:=p.Stderr.NumBytesAvailable;
        if (stderrbytesread + available > stderrlength) then
        begin
          stderrlength:=stderrbytesread + READ_BYTES;
          Setlength(stderrstring, stderrlength);
        end;
        stderrnumbytes := p.Stderr.Read(stderrstring[1+stderrbytesread], available);
        // L505 if above is unicodestring in the future, it may need work and NOTE: pchar is zero based
        // StderrNumBytes := p.StdErr.Read(pchar(stderrstring)[StderrBytesRead], available);

        if stderrnumbytes > 0 then
          Inc(stderrbytesread, stderrnumbytes);
      end;
      Setlength(stderrstring, stderrbytesread);
      ExitStatus:=p.ExitStatus;
      Result:=0; // we came to here, document that.
    except
      on e: Exception do
      begin
        Result:=1;
        Setlength(outputstring, bytesread);
      end;
    end;
  finally
    p.Free;
  end;
end;

{ Functions without Stderrstring }

Const
  ForbiddenOptions = [poRunSuspended, poWaitOnExit];

  // L505 changed to AnsiString
  // function RunCommandIndir(const curdir:string;const exename:string;const commands:array of string;out outputstring:string;out exitstatus:integer; Options : TProcessOptions = []):integer;
function RunCommandIndir(const curdir: string; const exename: string; const commands: array of string; out outputstring: AnsiString;out ExitStatus: Integer; Options: TProcessOptions = []): Integer;
Var
  p: TProcess;
  i: Integer;
  // Errorstring : string;  // L505
  Errorstring: AnsiString;
begin
  p:=TProcess.Create(nil);
  if Options<>[] then
    p.Options:=Options - ForbiddenOptions;
  p.Executable:=exename;
  if curdir<>'' then
    p.CurrentDirectory:=curdir;
  if high(commands)>=0 then
    for i:=low(commands) to high(commands) do
      p.Parameters.Add(commands[i]);
  Result:=internalRuncommand(p, outputstring, Errorstring, ExitStatus);
end;

// L505 changed to AnsiString
// function RunCommandInDir(const curdir,cmdline:string;out outputstring:string):boolean; deprecated;
function RunCommandIndir(const curdir, cmdline:string;out outputstring: AnsiString): Boolean; deprecated;
Var
  p: TProcess;
  ExitStatus: Integer;
  // Errorstring : string;  // L505
  Errorstring: AnsiString; // L505
begin
  p:=TProcess.Create(nil);
  p.SetCommandLine(cmdline);
  if curdir<>'' then
    p.CurrentDirectory:=curdir;
  Result:=internalRuncommand(p, outputstring, Errorstring, ExitStatus)=0;
  if ExitStatus<>0 then
    Result:=False;
end;

// L505 changed to AnsiString
// function RunCommandIndir(const curdir:string;const exename:string;const commands:array of string;out outputstring:string; Options : TProcessOptions = []):boolean;
function RunCommandIndir(const curdir: string; const exename: string; const commands: array of string; out outputstring: AnsiString; Options: TProcessOptions = []): Boolean;
Var
  p: TProcess;
  i,
    ExitStatus: Integer;
  // Errorstring : string;  // L505
  Errorstring: AnsiString; // L505
begin
  p:=TProcess.Create(nil);
  if Options<>[] then
    p.Options:=Options - ForbiddenOptions;
  p.Executable:=exename;
  if curdir<>'' then
    p.CurrentDirectory:=curdir;
  if high(commands)>=0 then
    for i:=low(commands) to high(commands) do
      p.Parameters.Add(commands[i]);
  Result:=internalRuncommand(p, outputstring, Errorstring, ExitStatus)=0;
  if ExitStatus<>0 then
    Result:=False;
end;

// L505 changed to AnsiString
// function RunCommand(const cmdline:string; out outputstring:string):boolean; deprecated;
function RunCommand(const cmdline: string; out outputstring: AnsiString): Boolean; deprecated;
Var
  p: TProcess;
  ExitStatus: Integer;
  // Errorstring : string; // L505
  Errorstring: AnsiString; // L505
begin
  p:=TProcess.Create(nil);
  p.SetCommandLine(cmdline);
  Result:=internalRuncommand(p, outputstring, Errorstring, ExitStatus)=0;
  if ExitStatus<>0 then
    Result:=False;
end;

// L505: Changed to AnsiString
// function RunCommand(const exename:string;const commands:array of string;out outputstring:string; Options : TProcessOptions = []):boolean;
function RunCommand(const exename:string; const commands: array of string; out outputstring: AnsiString; Options: TProcessOptions = []): Boolean;
Var
  p: TProcess;
  i,
    ExitStatus: Integer;
  // Errorstring : string;  // L505
  Errorstring: AnsiString; // L505
begin
  p:=TProcess.Create(nil);
  if Options<>[] then
    p.Options:=Options - ForbiddenOptions;
  p.Executable:=exename;
  if high(commands)>=0 then
    for i:=low(commands) to high(commands) do
      p.Parameters.Add(commands[i]);
  Result:=internalRuncommand(p, outputstring, Errorstring, ExitStatus)=0;
  if ExitStatus<>0 then
    Result:=False;
end;

end.
