unit Bool.Router;

interface

uses
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections,
  Classe.SmartPointer;

type
  TBoolMethod = TProc<TArray<TValue>>;

  IBoolRouter = Interface(IInterface)
    ['{4B319973-EEE9-4B61-A13B-5B16D20A4F4B}']
    procedure Execute(const ACondition: Boolean; const Args: TArray<TValue>);
  End;

  TBoolRouter = class(TInterfacedObject, IBoolRouter)
  strict private
  var
    FListMethods: ISmartPointer<TDictionary<Boolean, TBoolMethod>>;
  public
    constructor Create(const ATrue, AFalse: TBoolMethod);
    class function New(const ATrue, AFalse: TBoolMethod): IBoolRouter;
    procedure Execute(const ACondition: Boolean; const Args: TArray<TValue>);
  End;

implementation

{ TBoolRouter }

constructor TBoolRouter.Create(const ATrue, AFalse: TBoolMethod);
begin
  FListMethods := TSmartPointer<TDictionary<Boolean, TBoolMethod>>.Create(
    TDictionary<Boolean, TBoolMethod>.Create);
  FListMethods.Add(True, ATrue);
  FListMethods.Add(False, AFalse);
end;

procedure TBoolRouter.Execute(const ACondition: Boolean; const Args: TArray<TValue>);
var
  lMethod: TBoolMethod;
begin
  FListMethods.TryGetValue(ACondition, lMethod);
  lMethod(Args);
end;

class function TBoolRouter.New(const ATrue, AFalse: TBoolMethod): IBoolRouter;
begin
  Result := Self.Create(ATrue, AFalse);
end;

end.

