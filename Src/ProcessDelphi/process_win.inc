{ Freepascal TProcess ported to Delphi

  License: FPC Modified LGPL (can use in commercial apps)

  Changes to the code marked with "L505" in comments }

{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2008 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$WARNINGS OFF}
{$HINTS OFF}

Uses
  Windows;


Resourcestring
  SNoCommandLine        = 'Cannot execute empty command-line';
  SErrCannotExecute     = 'Failed to execute %s : %d';
{  SErrNoSuchProgram     = 'Executable not found: "%s"';
  SErrNoTerminalProgram = 'Could not detect X-Terminal program';
}

Const
  PriorityConstants : Array [TProcessPriority] of Cardinal =
                      (HIGH_PRIORITY_CLASS,IDLE_PRIORITY_CLASS,
                       NORMAL_PRIORITY_CLASS,REALTIME_PRIORITY_CLASS);

procedure TProcess.CloseProcessHandles;
begin
  if (FProcessHandle<>0) then
    CloseHandle(FProcessHandle);
  if (FThreadHandle<>0) then
    CloseHandle(FThreadHandle);
end;

Function TProcess.PeekExitStatus : Boolean;

begin
  GetExitCodeProcess(ProcessHandle,FExitCode);
  Result:=(FExitCode<>Still_Active);
end;

Function GetStartupFlags (P : TProcess): Cardinal;

begin
  With P do
    begin
    Result:=0;
    if poUsePipes in FProcessOptions then
       Result:=Result or Startf_UseStdHandles;
    if suoUseShowWindow in FStartupOptions then
      Result:=Result or startf_USESHOWWINDOW;
    if suoUSESIZE in FStartupOptions then
      Result:=Result or startf_usesize;
    if suoUsePosition in FStartupOptions then
      Result:=Result or startf_USEPOSITION;
    if suoUSECOUNTCHARS in FStartupoptions then
      Result:=Result or startf_usecountchars;
    if suoUsefIllAttribute in FStartupOptions then
      Result:=Result or startf_USEFILLATTRIBUTE;
    end;
end;

Function GetCreationFlags(P : TProcess) : Cardinal;

begin
  With P do
    begin
    Result:=0;
    if poNoConsole in FProcessOptions then
      Result:=Result or Detached_Process;
    if poNewConsole in FProcessOptions then
      Result:=Result or Create_new_console;
    if poNewProcessGroup in FProcessOptions then
      Result:=Result or CREATE_NEW_PROCESS_GROUP;
    If poRunSuspended in FProcessOptions Then
      Result:=Result or Create_Suspended;
    if poDebugProcess in FProcessOptions Then
      Result:=Result or DEBUG_PROCESS;
    if poDebugOnlyThisProcess in FProcessOptions Then
      Result:=Result or DEBUG_ONLY_THIS_PROCESS;
    if poDefaultErrorMode in FProcessOptions Then
      Result:=Result or CREATE_DEFAULT_ERROR_MODE;
    result:=result or PriorityConstants[FProcessPriority];
    end;
end;

//L505 note: unicode string could be used, but msdn says CREATE_UNICODE_ENVIRONMENT
// must be used with CreateProcessW. For now, ansistring will be used instead
Function StringsToPChars(List : TStrings): pointer;
var
  EnvBlock, item: ansistring;
  I: Integer;
  memsize: integer;
begin
  EnvBlock := '';
  For I:=0 to List.Count-1 do begin
    item := List[i];
    EnvBlock := EnvBlock + item + #0;
  end;
  EnvBlock := EnvBlock + #0;
  memsize := Length(EnvBlock);  // if using unicode in the future, remember CHAR size (4) for memory allocation
  GetMem(Result, memsize);
  CopyMemory(Result, @EnvBlock[1], memsize);
end;

Procedure InitProcessAttributes(P : TProcess; Var PA : TSecurityAttributes);

begin
  FillChar(PA,SizeOf(PA),0);
  PA.nLength := SizeOf(PA);
end;

Procedure InitThreadAttributes(P : TProcess; Var TA : TSecurityAttributes);

begin
  FillChar(TA,SizeOf(TA),0);
  TA.nLength := SizeOf(TA);
end;

// L505 changed to STARTUPINFOW
// Procedure InitStartupInfo(P : TProcess; Var SI : STARTUPINFOA);
procedure InitStartupInfo(P : TProcess; Var SI : STARTUPINFOW);
Const
  SWC : Array [TShowWindowOptions] of Cardinal =
             (0,SW_HIDE,SW_Maximize,SW_Minimize,SW_Restore,SW_Show,
             SW_ShowDefault,SW_ShowMaximized,SW_ShowMinimized,
               SW_showMinNOActive,SW_ShowNA,SW_ShowNoActivate,SW_ShowNormal);

begin
  FillChar(SI,SizeOf(SI),0);
  With SI do
    begin
    dwFlags:=GetStartupFlags(P);
    if P.FShowWindow<>swoNone then
     dwFlags:=dwFlags or Startf_UseShowWindow
    else
      dwFlags:=dwFlags and not Startf_UseShowWindow;
    wShowWindow:=SWC[P.FShowWindow];
    if (poUsePipes in P.Options) then
      begin
      dwFlags:=dwFlags or Startf_UseStdHandles;
      end;
    if P.FillAttribute<>0 then
      begin
      dwFlags:=dwFlags or Startf_UseFillAttribute;
      dwFillAttribute:=P.FillAttribute;
      end;
    dwXCountChars:=P.WindowColumns;
    dwYCountChars:=P.WindowRows;
    dwYsize:=P.WindowHeight;
    dwXsize:=P.WindowWidth;
    dwy:=P.WindowTop;
    dwX:=P.WindowLeft;
    end;
end;

{ The handles that are to be passed to the child process must be
  inheritable. On the other hand, only non-inheritable handles
  allow the sending of EOF when the write-end is closed. This
  function is used to duplicate the child process's ends of the
  handles into inheritable ones, leaving the parent-side handles
  non-inheritable.
}
function DuplicateHandleFP(var handle: THandle): Boolean;
var
  oldHandle: THandle;
begin
  oldHandle := handle;
  Result := DuplicateHandle
  ( GetCurrentProcess(),
    oldHandle,
    GetCurrentProcess(),
    @handle,
    0,
    true,
    DUPLICATE_SAME_ACCESS
  );
  if Result then
    Result := CloseHandle(oldHandle);
end;

// L505 changed to TStartupInfoW
// Procedure CreatePipes(Var HI,HO,HE : Thandle; Var SI : TStartupInfoA; CE : Boolean; APipeBufferSize : Cardinal);
procedure CreatePipes(Var HI,HO,HE : Thandle; Var SI : TStartupInfoW; CE : Boolean; APipeBufferSize : Cardinal);
begin
  CreatePipeHandles(SI.hStdInput,HI, APipeBufferSize);
  DuplicateHandleFP(SI.hStdInput);
  CreatePipeHandles(HO,Si.hStdOutput, APipeBufferSize);
  DuplicateHandleFP(Si.hStdOutput);
  if CE then begin
    CreatePipeHandles(HE,SI.hStdError, APipeBufferSize);
    DuplicateHandleFP(   SI.hStdError);
    end
  else
    begin
    SI.hStdError:=SI.hStdOutput;
    HE:=HO;
    end;
end;

Function MaybeQuote(Const S : String) : String;
begin
  If (Pos(' ',S)<>0) then
    Result:='"'+S+'"'
  else
     Result:=S;
end;

Function MaybeQuoteIfNotQuoted(Const S : String) : String;
begin
  If (Pos(' ',S)<>0) and (pos('"',S)=0) then
    Result:='"'+S+'"'
  else
     Result:=S;
end;

Procedure TProcess.Execute;
Var
  i : Integer;
  PName,PDir,PCommandLine : PChar;
  FEnv: pointer;
  FCreationFlags : Cardinal;
  FProcessAttributes : TSecurityAttributes;
  FThreadAttributes : TSecurityAttributes;
  FProcessInformation : TProcessInformation;
  // FStartupInfo : STARTUPINFOA;  // L505
  FStartupInfo : STARTUPINFOW;  // L505
  HI,HO,HE : THandle;
  Cmd : String;

begin
  PName:=Nil;
  PCommandLine:=Nil;
  PDir:=Nil;

  if (FApplicationName='') and (FCommandLine='') and (FExecutable='') then
    Raise EProcess.Create(SNoCommandline);
  if (FApplicationName<>'') then
    begin
    PName:=PChar(FApplicationName);
    PCommandLine:=PChar(FCommandLine);
    end
  else If (FCommandLine<>'') then
    PCommandLine:=PChar(FCommandLine)
  else if (Fexecutable<>'') then
    begin
    Cmd:=MaybeQuoteIfNotQuoted(Executable);
    For I:=0 to Parameters.Count-1 do
      Cmd:=Cmd+' '+MaybeQuoteIfNotQuoted(Parameters[i]);
    PCommandLine:=PChar(Cmd);
    end;
  If FCurrentDirectory<>'' then
    PDir:=PChar(FCurrentDirectory);
  if FEnvironment.Count<>0 then
    FEnv:=StringsToPChars(FEnvironment)
  else begin
    // writeln('DEBUG: environment nil');
    FEnv:=Nil;
  end;

  Try
    FCreationFlags:=GetCreationFlags(Self);
    InitProcessAttributes(Self,FProcessAttributes);
    InitThreadAttributes(Self,FThreadAttributes);
    InitStartupInfo(Self,FStartUpInfo);
    If poUsePipes in FProcessOptions then begin
      CreatePipes(HI,HO,HE,FStartupInfo,Not(poStdErrToOutPut in FProcessOptions), FPipeBufferSize);
    end;

    Try
      // L505: changed to CreateProcessW, fpc uses CreateProcess which is CreateProcessA
      If Not CreateProcessW(PName,PCommandLine,@FProcessAttributes,@FThreadAttributes,
                   FInheritHandles,FCreationFlags,FEnv,PDir,FStartupInfo,
                   fProcessInformation) then
        Raise EProcess.CreateFmt(SErrCannotExecute,[FCommandLine,GetLastError]);
      FProcessHandle:=FProcessInformation.hProcess;
      FThreadHandle:=FProcessInformation.hThread;
      FProcessID:=FProcessINformation.dwProcessID;
    Finally
      if POUsePipes in FProcessOptions then
        begin
        FileClose(FStartupInfo.hStdInput);
        FileClose(FStartupInfo.hStdOutput);
        if Not (poStdErrToOutPut in FProcessOptions) then
          FileClose(FStartupInfo.hStdError);
        CreateStreams(HI,HO,HE);
        end;
    end;
    FRunning:=True;
  Finally
    If FEnv<>Nil then
      FreeMem(FEnv);
  end;
  if not (csDesigning in ComponentState) and // This would hang the IDE !
     (poWaitOnExit in FProcessOptions) and
      not (poRunSuspended in FProcessOptions) then
    WaitOnExit;
end;

Function TProcess.WaitOnExit : Boolean;
Var
  R : DWord;
begin
  R:=WaitForSingleObject (FProcessHandle,Infinite);
  Result:=(R<>Wait_Failed);
  If Result then
    GetExitStatus;
  FRunning:=False;
end;

Function TProcess.Suspend : Longint;
begin
  Result:=SuspendThread(ThreadHandle);
end;

Function TProcess.Resume : LongInt;
begin
  Result:=ResumeThread(ThreadHandle);
end;

Function TProcess.Terminate(AExitCode : Integer) : Boolean;
begin
  Result:=False;
  If ExitStatus=Still_active then
    Result:=TerminateProcess(Handle,AexitCode);
end;

Procedure TProcess.SetShowWindow (Value : TShowWindowOptions);
begin
  FShowWindow:=Value;
end;
