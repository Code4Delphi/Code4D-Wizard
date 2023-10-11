unit C4D.Wizard.Utils.stringList;

interface

uses
  System.Classes,
  System.StrUtils,
  System.SysUtils;

type
  TC4DWizardUtilsstringList = class
  public
    class function SortTrim(List: TStringList; Index1, Index2: Integer): Integer; static;
    class function SortNamespaces(List: TStringList; Index1, Index2: Integer): Integer; static;
  end;

implementation

class function TC4DWizardUtilsstringList.SortTrim(List: TStringList; Index1, Index2: Integer): Integer;
var
  LStr1: string;
  LStr2: string;
begin
  LStr1 := List[Index1].Trim;
  LStr2 := List[Index2].Trim;
  Result := CompareStr(LStr1, LStr2)
end;

class function TC4DWizardUtilsstringList.SortNamespaces(List: TStringList; Index1, Index2: Integer): Integer;
var
  LStr1: string;
  LStr2: string;
begin
  LStr1 := List[Index1].Trim;
  LStr2 := List[Index2].Trim;
  Result := -1;
  if(ContainsStr(LStr1, '.') = ContainsStr(LStr2, '.'))then
    Result := CompareStr(LStr1, LStr2)
  else if(ContainsStr(LStr1, '.'))then
    Result := 1;
end;

end.
