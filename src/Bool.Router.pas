unit Bool.Router;

interface

uses
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections,
  Classe.SmartPointer;

type
  IBoolRouter = Interface(IInterface)
    ['{4B319973-EEE9-4B61-A13B-5B16D20A4F4B}']
    procedure Execute(const ACondition: Boolean; const Args: TArray<TValue>);
  End;

  TBoolRouter = class(TInterfacedObject, IBoolRouter)
  strict private
  var
    FListMethods: ISmartPointer<TDictionary<Boolean, TProc<TArray<TValue>>>>;
  public
    constructor Create(const ATrue, AFalse: TProc<TArray<TValue>>); overload;
    constructor Create(const AProc: TProc<TArray<TValue>>;
      const ACondition: Boolean); overload;
    class function New(const ATrue, AFalse: TProc<TArray<TValue>>): IBoolRouter; overload;
    class function New(const AProc: TProc<TArray<TValue>>;
      const ACondition: Boolean): IBoolRouter; overload;
    procedure Execute(const ACondition: Boolean; const Args: TArray<TValue>);
  End;

implementation

{ TBoolRouter }

constructor TBoolRouter.Create(const ATrue, AFalse: TProc<TArray<TValue>>);
begin
  FListMethods := TSmartPointer<TDictionary<Boolean, TProc<TArray<TValue>>>>.Create(
    TDictionary<Boolean, TProc<TArray<TValue>>>.Create);
  FListMethods.Add(True, ATrue);
  FListMethods.Add(False, AFalse);
end;

constructor TBoolRouter.Create(const AProc: TProc<TArray<TValue>>;
  const ACondition: Boolean);
begin
  FListMethods := TSmartPointer<TDictionary<Boolean, TProc<TArray<TValue>>>>.Create(
    TDictionary<Boolean, TProc<TArray<TValue>>>.Create);
  FListMethods.Add(ACondition, AProc);
  FListMethods.Add(not ACondition,
    procedure(Args: TArray<TValue>)
    begin
    end);
end;

procedure TBoolRouter.Execute(const ACondition: Boolean; const Args: TArray<TValue>);
var
  lMethod: TProc<TArray<TValue>>;
begin
  FListMethods.TryGetValue(ACondition, lMethod);
  lMethod(Args);
end;

class function TBoolRouter.New(const AProc: TProc<TArray<TValue>>;
  const ACondition: Boolean): IBoolRouter;
begin
  Result := Self.Create(AProc, ACondition);
end;

class function TBoolRouter.New(const ATrue, AFalse: TProc<TArray<TValue>>): IBoolRouter;
begin
  Result := Self.Create(ATrue, AFalse);
end;

end.

