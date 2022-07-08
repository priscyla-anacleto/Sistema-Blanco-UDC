unit uCtrlFornecedores;

interface

uses uController, uDaoFornecedores, uFilterSearch, uCtrlTiposContatos,
  uCtrlCidades, uCtrlCondicoesPagamentos, uCidades, uTiposContatos,
  uCondicoesPagamentos, uFornecedores;

type ctrlFornecedores = class( Ctrl )
  private
  protected
    aDaoFornecedores : daoFornecedores;

    aCtrlCidades : ctrlCidades;
    aCtrlTiposContatos : ctrlTiposContatos;
    aCtrlCondicoes : ctrlCondicoesPagamentos;
  public
    constructor crieObj;                              override;
    destructor destrua_se;                            override;
    procedure setDM ( pDM : TObject );                override;
    function getDS : TObject;                         override;
    function pesquisar ( AFilter: TFilterSearch; pChave : string ): string; override;
    function salvar ( pObj : TObject ) : string;      override;
    function excluir ( pObj : TObject ) : string;     override;
    function carregar ( pObj : TObject ) : string;    override;

    procedure setCtrlCidades ( pCtrl : ctrlCidades );
    procedure setCtrlTiposContatos ( pCtrl : ctrlTiposContatos );
    procedure setCtrlCondicoes ( pCtrl : ctrlCondicoesPagamentos );

    function getCtrlCidades : ctrlCidades;
    function getCtrlTiposContatos : ctrlTiposContatos;
    function getCtrlCondicoes : ctrlCondicoesPagamentos;
end;

implementation

{ ctrlFornecedores }

function ctrlFornecedores.carregar(pObj: TObject): string;
var mCidade : Cidades; mContato : TiposContatos; mCondicao : CondicoesPagamentos;
    AFilter : TFilterSearch; pchave : string;
begin
  aDaoFornecedores.carregar( pObj );

  mCidade:= Fornecedores( pObj ).getaCidade;
  aCtrlCidades.pesquisar( AFilter, pchave );
 // aCtrlCidades.carregar( TObject ( mCidade ) );

  mContato:= Fornecedores( pObj ).getoContato;
  aCtrlTiposContatos.pesquisar( AFilter, pchave );
 // aCtrlTiposContatos.carregar( TObject ( mContato ) );

  mCondicao:= Fornecedores( pObj ).getaCondicao;
  aCtrlCondicoes.pesquisar( AFilter, pchave );
 // aCtrlCondicoes.carregar( TObject ( mCondicao ) );
end;

constructor ctrlFornecedores.crieObj;
begin
  aDaoFornecedores:= daoFornecedores.crieObj;
end;

destructor ctrlFornecedores.destrua_se;
begin
  aDaoFornecedores.destrua_se;
end;

function ctrlFornecedores.excluir(pObj: TObject): string;
begin

end;

function ctrlFornecedores.getCtrlCidades: ctrlCidades;
begin
  Result:= aCtrlCidades;
end;

function ctrlFornecedores.getCtrlCondicoes: ctrlCondicoesPagamentos;
begin
  Result:= aCtrlCondicoes;
end;

function ctrlFornecedores.getCtrlTiposContatos: ctrlTiposContatos;
begin
  Result:= aCtrlTiposContatos;
end;

function ctrlFornecedores.getDS: TObject;
begin
  Result:= aDaoFornecedores.getDS;
end;

function ctrlFornecedores.pesquisar(AFilter: TFilterSearch;
  pChave: string): string;
begin
  Result:= aDaoFornecedores.pesquisar( AFilter, pChave );
end;

function ctrlFornecedores.salvar(pObj: TObject): string;
begin
  aDaoFornecedores.salvar( pObj );
end;

procedure ctrlFornecedores.setCtrlCidades(pCtrl: ctrlCidades);
begin
  aCtrlCidades:= pCtrl;
end;

procedure ctrlFornecedores.setCtrlCondicoes(pCtrl: ctrlCondicoesPagamentos);
begin
  aCtrlCondicoes:= pCtrl;
end;

procedure ctrlFornecedores.setCtrlTiposContatos(pCtrl: ctrlTiposContatos);
begin
  aCtrlTiposContatos:= pCtrl;
end;

procedure ctrlFornecedores.setDM(pDM: TObject);
begin
  inherited;
  aDaoFornecedores.setDM( pDM );
end;

end.
