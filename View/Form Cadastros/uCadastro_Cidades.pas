unit uCadastro_Cidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCadastroPai, Vcl.Buttons, Vcl.StdCtrls,
  campoEdit, Vcl.ExtCtrls,
  uCidades,
  uCtrlCidades,
  uConsulta_Estados;

type
  Tform_cadastro_cidades = class(Tform_cadastro_pai)
    edt_cidade: PriTEdit;
    edt_sigla: PriTEdit;
    edt_ddd: PriTEdit;
    edt_pesquisar_estado_cidade: PriTEdit;
    pnl_btn_pesquisa: TPanel;
    btn_pesquisa: TSpeedButton;
    lbl_cidade: TLabel;
    lbl_sigla: TLabel;
    lbl_ddd: TLabel;
    lbl_estado_cidade: TLabel;
    lbl_cod_estado: TLabel;
    edt_codigo_estado: PriTEdit;
    edt_uf: PriTEdit;
    lbl_uf: TLabel;
    procedure btn_pesquisaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }

    aCidade : Cidades;
    aCtrlCidades : ctrlCidades;

    aConsultaEstados : Tform_consulta_estados;
  public
    { Public declarations }
    procedure conhecaObj ( pCtrl, pObj : TObject );  override;
    procedure salvar;         override;
    procedure sair;           override;
    procedure limpaEdt;       override;
    procedure carregaEdt;     override;
    procedure bloqueiaEdt;    override;
    procedure desbloqueiaEdt; override;
    function validaFormulario : Boolean; override;
    procedure setFrmConsultaEstados ( pConsulta : TObject );
  end;

var
  form_cadastro_cidades: Tform_cadastro_cidades;

implementation

{$R *.dfm}

{ Tform_cadastro_cidades }

procedure Tform_cadastro_cidades.bloqueiaEdt;
begin
  inherited;
  self.edt_cidade.Enabled:= False;
  self.edt_sigla.Enabled:= False;
  self.edt_ddd.Enabled:= False;
  self.edt_codigo_estado.Enabled:= False;
  self.edt_pesquisar_estado_cidade.Enabled:= False;
  self.edt_uf.Enabled:= False;
end;

procedure Tform_cadastro_cidades.btn_pesquisaClick(Sender: TObject);
var aux : string;
begin
  //inherited;
  aConsultaEstados.conhecaObj( aCtrlCidades.getCtrlEstados, aCidade.getoEstado );
  aux:= aConsultaEstados.btn_botao_sair.Caption;
  aConsultaEstados.btn_botao_sair.Caption:= 'Selecionar';
  aConsultaEstados.ShowModal;
  self.edt_codigo_estado.Text:= IntToStr( aCidade.getoEstado.getCodigo );
  self.edt_pesquisar_estado_cidade.Text:= aCidade.getoEstado.getEstado;
  self.edt_uf.Text:= aCidade.getoEstado.getUF;
end;

procedure Tform_cadastro_cidades.carregaEdt;
begin
  inherited;

  if aCidade.getCodigo <> 0 then
     self.edt_codigo.Text:= IntToStr( aCidade.getCodigo );

  self.edt_cidade.Text:= aCidade.getCidade;
  self.edt_sigla.Text:= aCidade.getSigla;
  self.edt_ddd.Text:= aCidade.getDDD;

  self.edt_codigo_estado.Text:= IntToStr( aCidade.getoEstado.getCodigo );
  self.edt_pesquisar_estado_cidade.Text:= aCidade.getoEstado.getEstado;
  self.edt_uf.Text:= aCidade.getoEstado.getUF;

  self.edt_data_cadastro.Text:= DateToStr( aCidade.getDataCad);
  self.edt_data_ult_alt.Text:= DateToStr(aCidade.getUltAlt);
end;

procedure Tform_cadastro_cidades.conhecaObj(pCtrl, pObj: TObject);
begin
  inherited;
  aCidade:= Cidades( pObj );
  aCtrlCidades:= ctrlCidades( pCtrl );

  self.limpaEdt;
  self.carregaEdt;
end;

procedure Tform_cadastro_cidades.desbloqueiaEdt;
begin
  inherited;
  self.edt_cidade.Enabled:= True;
  self.edt_sigla.Enabled:= True;
  self.edt_ddd.Enabled:= True;
  self.edt_codigo_estado.Enabled:= True;
  self.edt_pesquisar_estado_cidade.Enabled:= True;
  self.edt_uf.Enabled:= True;
end;

procedure Tform_cadastro_cidades.FormActivate(Sender: TObject);
begin
  inherited;

  if Self.btn_botao_salvar.Caption='Salvar' then
          edt_cidade.SetFocus;
end;

procedure Tform_cadastro_cidades.limpaEdt;
begin
  inherited;
  self.edt_cidade.Clear;
  self.edt_sigla.Clear;
  self.edt_ddd.Clear;
  self.edt_codigo_estado.Clear;
  self.edt_pesquisar_estado_cidade.Clear;
  self.edt_data_cadastro.Clear;
  self.edt_data_ult_alt.Clear;
  self.edt_cod_usuario.Clear;
  self.edt_uf.Clear;
end;

procedure Tform_cadastro_cidades.sair;
begin
  inherited;

end;

procedure Tform_cadastro_cidades.salvar;
begin
  inherited;
  if validaFormulario then
  begin
    aCidade.setCodigo( StrToInt ( self.edt_codigo.Text ) );
    aCidade.setCidade( self.edt_cidade.Text );
    aCidade.setSigla( self.edt_sigla.Text );
    aCidade.setDDD( self.edt_ddd.Text );
    aCidade.getoEstado.setCodigo( StrToInt ( self.edt_codigo_estado.text ) );
    aCidade.getoEstado.setEstado( self.edt_pesquisar_estado_cidade.Text );
    aCidade.getoEstado.setUF( self.edt_uf.Text );
    aCidade.setDataCad( Date );
    aCidade.setUltAlt( Date );
    aCidade.setCodUsu( StrToInt ( Self.edt_cod_usuario.Text ) );

    if self.btn_botao_salvar.Caption = 'Salvar' then
       aCtrlCidades.salvar( aCidade.clone )
    else
       aCtrlCidades.excluir( aCidade.clone );

    self.sair;
  end;
end;

procedure Tform_cadastro_cidades.setFrmConsultaEstados(pConsulta: TObject);
begin
  aConsultaEstados:= Tform_consulta_estados( pConsulta );
end;

function Tform_cadastro_cidades.validaFormulario: Boolean;
begin
  Result:= False;

  if Self.edt_cidade.Text = '' then
  begin
    MessageDlg( 'O campo Cidade � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_cidade.SetFocus;
    Exit;
  end;

  if Self.edt_ddd.Text = '' then
  begin
    MessageDlg( 'O campo DDD � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_ddd.SetFocus;
    Exit;
  end;

  if Self.edt_pesquisar_estado_cidade.Text = '' then
  begin
    MessageDlg( 'O campo Estado � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_pesquisar_estado_cidade.SetFocus;
    Exit;
  end;

 Result:= true;
end;

end.
