unit avaliacao2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList;

type
  TClient = class
  private
    FIDCliente      : Integer;
    FNome           : String;
    FCPF            : String;
    FDataNascimento : TDate;
  public
    property IDCliente  : Integer read FIDCliente      write FIDCliente;
    property Nome       : String  read FNome           write FNome;
    property CPF        : String  read FCPF            write FCPF;
    property Nascimento : TDate   read FDataNascimento write FDataNascimento;
  end;

  TCar = class
  private
    FIDCarro        : Integer;
    FModelo         : String;
    FDataLancamento : TDate;
  public
    property IDCarro    : Integer read FIDCarro        write FIDCarro;
    property Modelo     : String  read FModelo         write FModelo;
    property Lancamento : TDate   read FDataLancamento write FDataLancamento;
  end;

  TVenda = class
  private
    FIDVenda    : Integer;
    FIDCliente  : Integer;
    FIDCarro    : Integer;
    FDataVenda  : TDate;
    FValorVenda : Double;
  public
    property IDVenda    : Integer read FIDVenda    write FIDVenda;
    property IDCliente  : Integer read FIDCliente  write FIDCliente;
    property IDCarro    : Integer read FIDCarro    write FIDCarro;
    property DataVenda  : TDate   read FDataVenda  write FDataVenda;
    property ValorVenda : Double  read FValorVenda write FValorVenda;
  end;

  TFrmAVALIA = class(TForm)
    ActionList1: TActionList;
    ActAddCliente: TAction;
    ActAddVeiculo: TAction;
    ActAddVendas: TAction;
    ActExcluirVenda: TAction;
    ActMareaQtd: TAction;
    ActUnoQtd: TAction;
    ActSemVenda: TAction;
    ActSorteados: TAction;
    procedure ActAddClienteExecute(Sender: TObject);
    procedure ActAddVeiculoExecute(Sender: TObject);
    procedure ActAddVendasExecute(Sender: TObject);
    procedure ActExcluirVendaExecute(Sender: TObject);
    procedure ActMareaQtdExecute(Sender: TObject);
    procedure ActUnoQtdExecute(Sender: TObject);
    procedure ActSemVendaExecute(Sender: TObject);
    procedure ActSorteadosExecute(Sender: TObject);
  private
    procedure Inserir(Entidade: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CriarTabelas;
    procedure DeletarDadosBD(SQL: String);
    procedure InserirDadosBD(SQL: String);

    function ExecutarSql(SQL: String): Variant;
    function getSQLClientesSorteados: String;
  public
    { Public declarations }
  end;

var
  FrmAVALIA: TFrmAVALIA;

Const
    ID_MAREA = 1;
    ID_UNO   = 2;
    ArrCLIENT : array [0..4] of String = ('Alessandro', 'Rafael', 'Roberto', 'Marcelo', 'Jeferson');
    ArrCPF    : array [0..4] of String = ('42304051979', '80185533949', '20396819907', '60789995913', '11344601987');
    ArrCARRO  : array [0..4] of String = ('Marea', 'Uno', 'Palio', 'Siena', 'Premio');

implementation

{$R *.dfm}

//--------------------------------------------**
procedure TFrmAVALIA.Inserir(Entidade: TObject);
//--------------------------------------------**
var
    SQL: String;
begin
    if (Entidade is TClient) then
    begin
        SQL := ' INSERT INTO public.cliente( ';
        SQL := SQL + 'nome, cpf, nascimento) ';
        SQL := SQL + ' VALUES (';
        SQL := SQL + QuotedStr(TClient(Entidade).Nome) + ',';
        SQL := SQL + QuotedStr(TClient(Entidade).Cpf) +  ',';
        SQL := SQL + QuotedStr(DateToStr(TClient(Entidade).DataNascimento));
        SQL := SQL + ')';
    end
    else if (Entidade is TVenda) then
    begin
        SQL := ' INSERT INTO public.venda(';
        SQL := SQL + ' id_cliente, id_carro, data_venda, valor_venda)';
        SQL := SQL + ' VALUES ( ';
        SQL := SQL + IntToStr(TVenda(Entidade).IDCliente) + ',';
        SQL := SQL + IntToStr(TVenda(Entidade).IDCarro) + ',';
        SQL := SQL + QuotedStr(DateToStr(TVenda(Entidade).DataVenda)) + ',';
        SQL := SQL + FloatToStr(TVenda(Entidade).ValorVenda);
        SQL := SQL + ')';
    end
    else if (Entidade is TCar) then
    begin
        SQL := ' INSERT INTO public.carro(';
        SQL := SQL + ' modelo, lancamento) ';
        SQL := SQL + ' VALUES (';
        SQL := SQL + QuotedStr(TCar(Entidade).Modelo) + ',';
        SQL := SQL + QuotedStr(DateToStr(TCar(Entidade).DataLancamento));
        SQL := SQL + ')';
    end;

    InserirDadosBD(SQL);
end;
//-------------------------------------------------------**
procedure TFrmAVALIA.ActAddClienteExecute(Sender: TObject);
//-------------------------------------------------------**
var
    I: Integer;
    Cliente: TClient;
begin
    Cliente := TClient.Create;
    try
        for I := 1 to 5 do
        begin
            Cliente.Nome           := ArrCLIENTE[I-1];
            Cliente.CPF            := ArrCPF[I-1];
            Cliente.DataNascimento := EncodeDate(1990, I, 1) + I;
            Inserir(Cliente);
        end;
    finally
      Cliente.Free;
    end;
end;
//-------------------------------------------------------**
procedure TFrmAVALIA.ActAddVeiculoExecute(Sender: TObject);
//-------------------------------------------------------**
var
    I: Integer;
    Carro: TCar;
begin
    Carro := TCar.Create;
    try
        for I := 1 to 5 do
        begin
            Carro.Modelo         := ArrCARRO[I-1];
            Carro.DataLancamento := EncodeDate(2022, I, 1);
            Inserir(Carro);
        end;
    finally
      Carro.Free;
    end;
end;
//------------------------------------------------------**
procedure TFrmAVALIA.ActAddVendasExecute(Sender: TObject);
//------------------------------------------------------**
var
    I: Integer;
    Venda: TVenda;
begin
    Venda := TVenda.Create;
    try
        for I := 1 to 5 do
        begin
            Venda.IDCliente  := I;
            Venda.IDCarro    := I;
            Venda.DataVenda  := Now;
            Venda.ValorVenda := 15300+I;
            Inserir(Venda);
        end;
    finally
      Venda.Free;
    end;
end;
//---------------------------------------------------------**
procedure TFrmAVALIA.ActExcluirVendaExecute(Sender: TObject);
//---------------------------------------------------------**
var
    SQL: String;
begin
    SQL := 'DELETE FROM public.Venda USING (';
    SQL := SQL + getSqlClientesSorteados + ') AS Sorteados';
    SQL := SQL + ' WHERE venda.Id_cliente <> sorteados.id_cliente';

    DeletarDadosBD(SQL);
end;
//-----------------------------------------------------**
procedure TFrmAVALIA.ActMareaQtdExecute(Sender: TObject);
//-----------------------------------------------------**
var
    SQL: String;
begin
    SQL := 'SELECT COUNT(*) AS quantidade_vendas_marea';
    SQL := SQL + ' FROM Venda WHERE id_carro=' + IntToStr(ID_MAREA);

    ShowMessage(ExecutarSQL(SQL));
end;
//-----------------------------------------------------**
procedure TFrmAVALIA.ActSemVendaExecute(Sender: TObject);
//-----------------------------------------------------**
var
    SQL: String;
begin
    SQL := 'SELECT COUNT(*) AS quantidade_clientes_sem_venda ';
    SQL := SQL + ' FROM Cliente';
    SQL := SQL + ' LEFT JOIN Venda ON Venda.id_cliente=Cliente.id_cliente';
    SQL := SQL + ' WHERE Venda.id_venda IS NULL';

    ShowMessage(ExecutarSQL(SQL));
end;
//------------------------------------------------------**
procedure TFrmAVALIA.ActSorteadosExecute(Sender: TObject);
//------------------------------------------------------**
begin
    ShowMessage(ExecutarSQL(getSqlClientesSorteados));
end;

//---------------------------------------------------**
procedure TFrmAVALIA.ActUnoQtdExecute(Sender: TObject);
//---------------------------------------------------**
var
    SQL: String;
begin
   SQL := 'SELECT Cliente.nome, COUNT(*) AS quantidade_vendas_uno';
   SQL := SQL + ' FROM Venda ';
   SQL := SQL + ' JOIN Cliente ON Cliente.id_cliente=Venda.id_cliente';
   SQL := SQL + ' WHERE Venda.id_carro = '+IntToStr(ID_UNO);
   SQL := SQL + ' GROUP BY venda.Id_Cliente, Cliente.nome';

   ShowMessage(ExecutarSQL(SQL));
end;

//--------------------------------------------------**
function TFrmAVALIA.ExecutarSql(SQL: String): Variant;
//--------------------------------------------------**
begin
    Result := 0;
end;
//---------------------------------------------**
procedure TFrmAVALIA.FormCreate(Sender: TObject);
//---------------------------------------------**
begin
    CriarTabelas;
end;
//------------------------------**
procedure TFrmAVALIA.CriarTabelas;
//------------------------------**
begin
  ExecutarSql(
    'CREATE TABLE IF NOT EXISTS Cliente (' +
    '  id_cliente SERIAL PRIMARY KEY,' +
    '  nome VARCHAR(100),' +
    '  cpf VARCHAR(11) UNIQUE,' +
    '  nascimento DATE' +
    ');'
  );

  ExecutarSql(
    'CREATE TABLE IF NOT EXISTS Carro (' +
    '  id_carro SERIAL PRIMARY KEY,' +
    '  modelo VARCHAR(50),' +
    '  lancamento DATE' +
    ');'
  );

  ExecutarSql(
    'CREATE TABLE IF NOT EXISTS Venda (' +
    '  id_venda SERIAL PRIMARY KEY,' +
    '  id_cliente INT,' +
    '  id_carro INT,' +
    '  data_venda DATE,' +
    '  valor_venda NUMERIC(13,2),'+
    '  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),' +
    '  FOREIGN KEY (id_carro) REFERENCES Carro(id_carro)' +
    ');'
  );
end;
//---------------------------------------------**
procedure TFrmAVALIA.DeletarDadosBD(SQL: String);
//---------------------------------------------**
begin
    //Deletar
end;
//---------------------------------------------**
procedure TFrmAVALIA.InserirDadosBD(SQL: String);
//---------------------------------------------**
begin
    //Inserir....
end;
//------------------------------------------------**
function TFrmAVALIA.getSQLClientesSorteados: String;
//------------------------------------------------**
begin
    Result := 'SELECT Cliente.nome, cliente.id_cliente';
    Result := Result + ' FROM Cliente';
    Result := Result + ' JOIN Venda ON Venda.id_cliente=Cliente.id_cliente';
    Result := Result + ' JOIN Carro ON Carro.id_carro=Venda.id_carro';
    Result := Result + ' WHERE SUBSTRING(Cliente.cpf, 1, 1) = ''0''';
    Result := Result +   ' AND EXTRACT(YEAR FROM Carro.data_lancamento) = 2021';
    Result := Result +   ' AND Cliente.id_cliente NOT IN (';
    Result := Result +          ' SELECT id_cliente';
    Result := Result +          ' FROM Venda AS V';
    Result := Result +          ' JOIN Carro AS C ON C.id_carro=V.id_carro';
    Result := Result +          ' WHERE C.id_carro = '+IntToStr(ID_MAREA);
    Result := Result +          ' GROUP BY V.id_cliente';
    Result := Result +          ' HAVING COUNT(*) >= 2)';
    Result := Result + ' GROUP BY Cliente.id_cliente, Cliente.nome, Venda.data_venda';
    Result := Result + ' ORDER BY Venda.data_venda';
    Result := Result + ' LIMIT 15';
end;

end.
