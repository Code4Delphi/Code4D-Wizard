unit C4D.Wizard.Utils.ListOfFilesInFolder;

interface

uses
  System.SysUtils,
  System.Classes,
  C4D.Wizard.Types;

type
  IC4DWizardUtilsListOfFilesInFolder = interface
    ['{843DF59B-4858-4223-B953-7E05A2BBE345}']
    function FolderPath(const Value: string): IC4DWizardUtilsListOfFilesInFolder;
    function IncludeSubdirectories(const Value: Boolean): IC4DWizardUtilsListOfFilesInFolder;
    function ExtensionsOfFiles(Value: TC4DExtensionsOfFiles): IC4DWizardUtilsListOfFilesInFolder;
    procedure GetListOfFiles(out Result: TStrings);
  end;

  TC4DWizardUtilsListOfFilesInFolder = class(TInterfacedObject, IC4DWizardUtilsListOfFilesInFolder)
  private
    FFolderPath: string;
    FIncludeSubdirectories: Boolean;
    FExtensionsOfFiles: TC4DExtensionsOfFiles;
    FStrResult: TStrings;
    procedure GetListOfFilesInternal(const AFolderPath: string);
  protected
    function FolderPath(const Value: string): IC4DWizardUtilsListOfFilesInFolder;
    function IncludeSubdirectories(const Value: Boolean): IC4DWizardUtilsListOfFilesInFolder;
    function ExtensionsOfFiles(Value: TC4DExtensionsOfFiles): IC4DWizardUtilsListOfFilesInFolder;
    procedure GetListOfFiles(out Result: TStrings);
  public
    class function New: IC4DWizardUtilsListOfFilesInFolder;
    constructor Create;
  end;

implementation


class function TC4DWizardUtilsListOfFilesInFolder.New: IC4DWizardUtilsListOfFilesInFolder;
begin
  Result := Self.Create;
end;

constructor TC4DWizardUtilsListOfFilesInFolder.Create;
begin
  FIncludeSubdirectories := True;
  FExtensionsOfFiles := [TC4DExtensionsFiles.ALL];
end;

function TC4DWizardUtilsListOfFilesInFolder.FolderPath(const Value: string): IC4DWizardUtilsListOfFilesInFolder;
begin
  Result := Self;
  FFolderPath := Value;
end;

function TC4DWizardUtilsListOfFilesInFolder.IncludeSubdirectories(const Value: Boolean): IC4DWizardUtilsListOfFilesInFolder;
begin
  Result := Self;
  FIncludeSubdirectories := Value;
end;

function TC4DWizardUtilsListOfFilesInFolder.ExtensionsOfFiles(Value: TC4DExtensionsOfFiles): IC4DWizardUtilsListOfFilesInFolder;
begin
  Result := Self;
  FExtensionsOfFiles := Value;
end;

procedure TC4DWizardUtilsListOfFilesInFolder.GetListOfFiles(out Result: TStrings);
begin
  FStrResult := Result;
  Self.GetListOfFilesInternal(FFolderPath);
end;

procedure TC4DWizardUtilsListOfFilesInFolder.GetListOfFilesInternal(const AFolderPath: string);
var
  LFolderPath: string;
  LSearchRec: TSearchRec;
  LRet: Integer;
  LName: string;
  LSubDirectoryPath: string;
begin
  LFolderPath := IncludeTrailingPathDelimiter(AFolderPath);
  if(LFolderPath.IsEmpty)then
    Exit;

  if(not DirectoryExists(LFolderPath))then
    Exit;

  LRet := FindFirst(LFolderPath + '*.*', faAnyFile, LSearchRec);
  try
    while(LRet = 0)do
    begin
      LName := LSearchRec.Name;
      //SE HE UMA PASTA
      if(LSearchRec.Attr and faDirectory = faDirectory)then
      begin
        if(LName <> '.')and(LName <> '..')then
        begin
          if(FIncludeSubdirectories)then
          begin
            LSubDirectoryPath := LFolderPath + LName;
            Self.GetListOfFilesInternal(LSubDirectoryPath);
          end;
        end;
      end
      else if(FExtensionsOfFiles.ContainsStr(ExtractFileExt(LName)))then
        FStrResult.Add(LFolderPath + LName);

      LRet := FindNext(LSearchRec);
    end;
  finally
    System.SysUtils.FindClose(LSearchRec);
  end;
end;

end.
