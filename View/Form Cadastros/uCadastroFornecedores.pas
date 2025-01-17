﻿unit uCadastroFornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCadastroPai, Vcl.Buttons, Vcl.StdCtrls,
  campoEdit, Vcl.ExtCtrls, ComboBox, Vcl.Mask, MaskEdit1, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, uFornecedores, uCtrlFornecedores, uConsulta_Cidades,
  uConsulta_TiposContatos, uConsulta_CondicoesPagamentos;

type
  Tform_cadastro_fornecedores = class(Tform_cadastro_pai)
    lbl_titulo_dados_gerais: TLabel;
    lbl_tipo_fornecedor: TLabel;
    ComboBox_tipo_fornecedor: TComboBox1;
    edt_nome_razao_social: PriTEdit;
    edt_apelido_nome_fantasia: PriTEdit;
    lbl_nome_razao_social: TLabel;
    lbl_apelido_nome_fantasia: TLabel;
    lbl_titulo_endereco: TLabel;
    lbl_endereco: TLabel;
    edt_endereco: PriTEdit;
    edt_numero: PriTEdit;
    lbl_numero: TLabel;
    lbl_complemento: TLabel;
    edt_complemento: PriTEdit;
    lbl_bairro: TLabel;
    edt_bairro: PriTEdit;
    lbl_cep: TLabel;
    edt_cep: PriTMaskEdit;
    lbl_codigo_cidade: TLabel;
    edt_cod_cidade: PriTEdit;
    lbl_cidade: TLabel;
    lbl_uf: TLabel;
    edt_uf: PriTEdit;
    edt_pesquisar_cidade: PriTEdit;
    pnl_btn_pesquisa: TPanel;
    btn_pesquisa: TSpeedButton;
    lbl_contatos: TLabel;
    lbl_tipo_contato: TLabel;
    edt_tipo_contato: PriTEdit;
    lbl_nome_tipo: TLabel;
    edt_nome_tipo_selecionado: PriTEdit;
    edt_algo: PriTEdit;
    lbl_algo_contato: TLabel;
    pnl_pesquisa_tipo_contato: TPanel;
    btn_pesquisa_tipo_contato: TSpeedButton;
    pnl_adicionar_contato: TPanel;
    btn_adicionar_contato: TSpeedButton;
    lbl_cpf_cnpj: TLabel;
    edt_cpf_cnpj: PriTMaskEdit;
    edt_rg_ie: PriTEdit;
    lbl_rg_ie: TLabel;
    lbl_titulo_financeiro: TLabel;
    pnl_pesquisa_condicao_pagamento: TPanel;
    btn_pesquisa_condicao_pagamento: TSpeedButton;
    edt_pesquisa_condicao_pagamento: PriTEdit;
    edt_cod_condicao_pagamento: PriTEdit;
    lbl_cod_condicao_pagamento: TLabel;
    lbl_condicao_pagamento: TLabel;
    lbl_cod_contato: TLabel;
    edt_cod_contato: PriTEdit;
    ListView_contatos: TListView;
    pnl_botao_alterar: TPanel;
    btn_botao_alterar_item: TSpeedButton;
    pnl_botao_excluir_item: TPanel;
    btn_botao_excluir_item: TSpeedButton;
    pbl_limpar_grid: TPanel;
    btn_limpar_grid: TSpeedButton;
    procedure ComboBox_tipo_fornecedorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btn_pesquisaClick(Sender: TObject);
    procedure btn_pesquisa_tipo_contatoClick(Sender: TObject);
    procedure btn_pesquisa_condicao_pagamentoClick(Sender: TObject);
    procedure btn_adicionar_contatoClick(Sender: TObject);
    procedure btn_limpar_gridClick(Sender: TObject);
    procedure btn_botao_excluir_itemClick(Sender: TObject);
    procedure ListView_contatosSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btn_botao_alterar_itemClick(Sender: TObject);
  private
    { Private declarations }

    oFornecedor : Fornecedores;
    aCtrlFornecedores : ctrlFornecedores;

    aConsultacidades : Tform_consulta_cidades;
    aConsultaContatos : Tform_consulta_tipos_contatos;
    aConsultacondicao : Tform_consulta_condicoes_pagamentos;
  public
    { Public declarations }
    procedure conhecaObj ( pCtrl, pObj : TObject );  override;
    procedure salvar;         override;
    procedure sair;           override;
    procedure limpaEdt;       override;
    procedure carregaEdt;     override;
    procedure bloqueiaEdt;    override;
    procedure desbloqueiaEdt; override;
    procedure bloqueaiaBtnPesquisa;
    procedure desbloqueiaBtnPesquisa;

    function validaFormulario : Boolean; override;

    procedure setFrmConsultaCidade ( pConsulta : TObject );
    procedure setFrmConsultaContatos ( pConsulta : TObject );
    procedure setFrmConsultaCondicaoPagamento ( pConsulta : TObject );

    procedure tipoFornecedor;
    procedure adicionarItens;
    procedure limparItens;
    function validaItens : Boolean;
  end;

var
  form_cadastro_fornecedores: Tform_cadastro_fornecedores;

implementation

{$R *.dfm}

{ Tform_cadastro_fornecedores }

procedure Tform_cadastro_fornecedores.adicionarItens;
var item : TListItem;
begin
  item:= ListView_contatos.Items.Add;

  item.Caption:= edt_tipo_contato.Text;
  item.SubItems.Add( edt_nome_tipo_selecionado.Text );
  item.SubItems.Add( edt_algo.Text );
end;

procedure Tform_cadastro_fornecedores.bloqueaiaBtnPesquisa;
begin
  self.btn_pesquisa.Visible:= False;
  self.btn_pesquisa_tipo_contato.Visible:= False;
  self.btn_pesquisa_condicao_pagamento.Visible:= False;
  self.ComboBox_tipo_fornecedor.Visible:= False;

  self.btn_adicionar_contato.Enabled:= False;
  self.btn_botao_alterar_item.Enabled:= False;
  self.btn_botao_excluir_item.Enabled:= False;
  self.btn_limpar_grid.Enabled:= False;
end;

procedure Tform_cadastro_fornecedores.bloqueiaEdt;
begin
  inherited;
  self.edt_nome_razao_social.Enabled:= False;
  self.edt_apelido_nome_fantasia.Enabled:= False;
  self.edt_endereco.Enabled:= False;
  self.edt_numero.Enabled:= False;
  self.edt_complemento.Enabled:= False;
  self.edt_bairro.Enabled:= False;
  self.edt_cep.Enabled:= False;
  self.edt_cod_cidade.Enabled:= False;
  self.edt_pesquisar_cidade.Enabled:= False;
  self.edt_uf.Enabled:= False;
  self.edt_cod_contato.Enabled:= False;
  self.edt_tipo_contato.Enabled:= False;
  self.edt_nome_tipo_selecionado.Enabled:= False;
  self.edt_algo.Enabled:= False;
  self.edt_cpf_cnpj.Enabled:= False;
  self.edt_rg_ie.Enabled:= False;
  self.edt_cod_condicao_pagamento.Enabled:= False;
  self.edt_pesquisa_condicao_pagamento.Enabled:= False;
end;

procedure Tform_cadastro_fornecedores.btn_adicionar_contatoClick(
  Sender: TObject);
begin
  inherited;
  if validaItens then
  begin
    adicionarItens;
    limparItens;
    edt_cod_contato.SetFocus;
  end;
end;

procedure Tform_cadastro_fornecedores.btn_botao_alterar_itemClick(
  Sender: TObject);
var item : TListItem;
begin
  inherited;

  edt_tipo_contato.Text:= ListView_contatos.Selected.Caption;
  edt_nome_tipo_selecionado.Text:= ListView_contatos.Selected.SubItems[0];
  edt_algo.Text:= ListView_contatos.Selected.SubItems[1];
end;

procedure Tform_cadastro_fornecedores.btn_botao_excluir_itemClick(Sender: TObject);
begin
  inherited;
  if ListView_contatos.ItemFocused.Index = ListView_contatos.Items.Count - 1 then
     ListView_contatos.DeleteSelected
  else
    MessageDlg( 'Primeiro deve excluir o último contato!', MtInformation, [ MbOK ], 0 );
end;

procedure Tform_cadastro_fornecedores.btn_limpar_gridClick(Sender: TObject);
begin
  inherited;
  ListView_contatos.Clear;
end;

procedure Tform_cadastro_fornecedores.btn_pesquisaClick(Sender: TObject);
var aux : string;
begin
  //inherited;
  aConsultacidades.conhecaObj( aCtrlFornecedores.getCtrlCidades, oFornecedor.getaCidade );
  aux:= aConsultacidades.btn_botao_sair.Caption;
  aConsultacidades.btn_botao_sair.Caption:= 'Selecionar';
  aConsultacidades.ShowModal;
  aConsultacidades.btn_botao_sair.Caption:= aux;

  self.edt_cod_cidade.Text:= IntToStr( oFornecedor.getaCidade.getCodigo );
  self.edt_pesquisar_cidade.Text:= oFornecedor.getaCidade.getCidade;
  self.edt_uf.Text:= oFornecedor.getaCidade.getoEstado.getUF;
end;

procedure Tform_cadastro_fornecedores.btn_pesquisa_condicao_pagamentoClick(
  Sender: TObject);
  var aux : string;
begin
  inherited;
  aConsultacondicao.conhecaObj( aCtrlFornecedores.getCtrlCondicoes, oFornecedor.getaCondicao );
  aux:= aConsultacondicao.btn_botao_sair.Caption;
  aConsultacondicao.btn_botao_sair.Caption:= 'Selecionar';
  aConsultacondicao.ShowModal;
  aConsultacondicao.btn_botao_sair.Caption:= aux;

  self.edt_cod_condicao_pagamento.Text:= IntToStr( oFornecedor.getaCondicao.getCodigo );
  self.edt_pesquisa_condicao_pagamento.Text:= oFornecedor.getaCondicao.getCondicao;

end;

procedure Tform_cadastro_fornecedores.btn_pesquisa_tipo_contatoClick(
  Sender: TObject);
  var aux : string;
begin
//  inherited;
  aConsultaContatos.conhecaObj( aCtrlFornecedores.getCtrlTiposContatos, oFornecedor.getoContato );
  aux:= aConsultaContatos.btn_botao_sair.Caption;
  aConsultaContatos.btn_botao_sair.Caption:= 'Selecionar';
  aConsultaContatos.ShowModal;
  aConsultaContatos.btn_botao_sair.Caption:= aux;

  self.edt_cod_contato.Text:= IntToStr( oFornecedor.getoContato.getCodigo );
  self.edt_tipo_contato.Text:= oFornecedor.getoContato.getTipoContato;

  lbl_nome_tipo.Caption:= edt_tipo_contato.Text;
end;

procedure Tform_cadastro_fornecedores.carregaEdt;
begin
  inherited;

  if oFornecedor.getCodigo <> 0 then
     self.edt_codigo.Text:= IntToStr( oFornecedor.getCodigo );

  self.edt_nome_razao_social.Text:= oFornecedor.getNomeRazaoSocial;
  self.edt_apelido_nome_fantasia.Text:= oFornecedor.getApelidoFantasia;
  self.edt_endereco.Text:= oFornecedor.getEndereco;
  self.edt_numero.Text:= oFornecedor.getNumero;
  self.edt_complemento.Text:= oFornecedor.getComplemento;
  self.edt_bairro.Text:= oFornecedor.getBairro;
  self.edt_cep.Text:= oFornecedor.getCep;
  self.edt_cod_cidade.Text:= IntToStr ( oFornecedor.getaCidade.getCodigo );
  self.edt_pesquisar_cidade.Text:= oFornecedor.getaCidade.getCidade;
  self.edt_uf.Text:= oFornecedor.getaCidade.getoEstado.getUF;
  self.edt_cod_contato.Text:= IntToStr ( oFornecedor.getoContato.getCodigo );
  self.edt_tipo_contato.Text:= oFornecedor.getoContato.getTipoContato;
  self.edt_nome_tipo_selecionado.Text:= oFornecedor.getContatoAux1;
  self.edt_algo.Text:= oFornecedor.getContatoAux2;
  self.edt_cpf_cnpj.Text:= oFornecedor.getCnpjCpf;
  self.edt_rg_ie.Text:= oFornecedor.getIeRg;
  self.edt_cod_condicao_pagamento.Text:= IntToStr ( oFornecedor.getaCondicao.getCodigo );
  self.edt_pesquisa_condicao_pagamento.Text:= oFornecedor.getaCondicao.getCondicao;
  self.edt_data_cadastro.Text:= DateToStr( oFornecedor.getDataCad);
  self.edt_data_ult_alt.Text:= DateToStr(oFornecedor.getUltAlt);
  self.edt_uf.Text:= oFornecedor.getaCidade.getoEstado.getUF;
  self.ComboBox_tipo_fornecedor.Text:= oFornecedor.getTipoForn;
end;

procedure Tform_cadastro_fornecedores.ComboBox_tipo_fornecedorChange(
  Sender: TObject);
begin
  inherited;
  tipoFornecedor;
end;

procedure Tform_cadastro_fornecedores.conhecaObj(pCtrl, pObj: TObject);
begin
  inherited;
  oFornecedor:= Fornecedores( pObj );
  aCtrlFornecedores:= ctrlFornecedores( pCtrl );

  self.limpaEdt;
  self.limparItens;
  self.carregaEdt;

end;

procedure Tform_cadastro_fornecedores.desbloqueiaBtnPesquisa;
begin
  self.btn_pesquisa.Visible:= True;
  self.btn_pesquisa_tipo_contato.Visible:= True;
  self.btn_pesquisa_condicao_pagamento.Visible:= True;
  self.ComboBox_tipo_fornecedor.Visible:= True;

  self.btn_adicionar_contato.Enabled:= True;
  self.btn_botao_alterar_item.Enabled:= True;
  self.btn_botao_excluir_item.Enabled:= True;
  self.btn_limpar_grid.Enabled:= True;
end;

procedure Tform_cadastro_fornecedores.desbloqueiaEdt;
begin
  inherited;
  self.edt_nome_razao_social.Enabled:= True;
  self.edt_apelido_nome_fantasia.Enabled:= True;
  self.edt_endereco.Enabled:= True;
  self.edt_numero.Enabled:= True;
  self.edt_complemento.Enabled:= True;
  self.edt_bairro.Enabled:= True;
  self.edt_cep.Enabled:= True;
  self.edt_cod_cidade.Enabled:= True;
  self.edt_pesquisar_cidade.Enabled:= True;
  self.edt_uf.Enabled:= True;
  self.edt_cod_contato.Enabled:= True;
  self.edt_tipo_contato.Enabled:= True;
  self.edt_nome_tipo_selecionado.Enabled:= True;
  self.edt_algo.Enabled:= True;
  self.edt_cpf_cnpj.Enabled:= True;
  self.edt_rg_ie.Enabled:= True;
  self.edt_cod_condicao_pagamento.Enabled:= True;
  self.edt_pesquisa_condicao_pagamento.Enabled:= True;
end;

procedure Tform_cadastro_fornecedores.FormActivate(Sender: TObject);
begin
  inherited;

  if Self.btn_botao_salvar.Caption='Salvar' then
        edt_nome_razao_social.SetFocus;
end;

procedure Tform_cadastro_fornecedores.FormShow(Sender: TObject);
begin
  inherited;
  tipoFornecedor;

  if Self.btn_botao_salvar.Caption='Salvar' then
        edt_nome_razao_social.SetFocus;
end;

procedure Tform_cadastro_fornecedores.limpaEdt;
begin
  inherited;
  self.edt_nome_razao_social.Clear;
  self.edt_apelido_nome_fantasia.Clear;
  self.edt_endereco.Clear;
  self.edt_numero.Clear;
  self.edt_complemento.Clear;
  self.edt_bairro.Clear;
  self.edt_cep.Clear;
  self.edt_cod_cidade.Clear;
  self.edt_pesquisar_cidade.Clear;
  self.edt_uf.Clear;
  self.edt_cod_contato.Clear;
  self.edt_tipo_contato.Clear;
  self.edt_nome_tipo_selecionado.Clear;
  self.edt_algo.Clear;
  self.edt_cpf_cnpj.Clear;
  self.edt_rg_ie.Clear;
  self.edt_cod_condicao_pagamento.Clear;
  self.edt_pesquisa_condicao_pagamento.Clear;
  Self.edt_data_cadastro.Clear;
  self.edt_data_ult_alt.Clear;
end;

procedure Tform_cadastro_fornecedores.limparItens;
begin
  self.edt_cod_contato.Clear;
  self.edt_tipo_contato.Clear;
  self.edt_nome_tipo_selecionado.Clear;
  self.edt_algo.Clear;
end;

procedure Tform_cadastro_fornecedores.ListView_contatosSelectItem(
  Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  inherited;
  if Selected then
  begin
    btn_botao_excluir_item.Enabled:= True;
    btn_botao_alterar_item.Enabled:= True;
  end
  else
  begin
    btn_botao_excluir_item.Enabled:= False;
    btn_botao_alterar_item.Enabled:= False;
  end;
end;

procedure Tform_cadastro_fornecedores.sair;
begin
  inherited;

end;

procedure Tform_cadastro_fornecedores.salvar;
begin
  inherited;
  if validaFormulario then
  begin
    oFornecedor.setCodigo( StrToInt ( self.edt_codigo.Text ) );
    oFornecedor.setNomeRazaoSocial( self.edt_nome_razao_social.Text );
    oFornecedor.setApelidoFantasia( self.edt_apelido_nome_fantasia.Text );
    oFornecedor.setEndereco( self.edt_endereco.Text );
    oFornecedor.setNumero( self.edt_numero.Text );
    oFornecedor.setComplemento( self.edt_complemento.Text );
    oFornecedor.setBairro( self.edt_bairro.Text );
    oFornecedor.setCep( self.edt_cep.Text );
    oFornecedor.getaCidade.setCodigo( StrToInt ( self.edt_cod_cidade.Text ) );
    oFornecedor.getaCidade.setCidade( self.edt_pesquisar_cidade.Text );
    oFornecedor.getaCidade.getoEstado.setUF( self.edt_uf.Text );
    oFornecedor.getoContato.setCodigo( StrToInt ( self.edt_cod_contato.Text ) );
    oFornecedor.getoContato.setTipoContato( self.edt_tipo_contato.Text );
    oFornecedor.setContatoAux1( self.edt_nome_tipo_selecionado.Text );
    oFornecedor.setContatoAux2( self.edt_algo.Text );
    oFornecedor.setCnpjCpf( self.edt_cpf_cnpj.Text );
    oFornecedor.setIeRg( self.edt_rg_ie.Text );
    oFornecedor.getaCondicao.setCodigo( StrToInt ( self.edt_cod_condicao_pagamento.Text ) );
    oFornecedor.getaCondicao.setCondicao( self.edt_pesquisa_condicao_pagamento.Text );
    oFornecedor.setDataCad( Date );
    oFornecedor.setUltAlt( Date );
    oFornecedor.setCodUsu( StrToInt ( Self.edt_cod_usuario.Text ) );
    oFornecedor.setTipoForn( self.ComboBox_tipo_fornecedor.Text);

    if Self.btn_botao_salvar.Caption = 'Salvar' then // INCLUIR-ALTERAR
       aCtrlFornecedores.salvar( oFornecedor.clone )
    else //EXCLUIR
       aCtrlFornecedores.excluir( oFornecedor.clone );

    self.sair;
  end;
end;

procedure Tform_cadastro_fornecedores.setFrmConsultaCidade(pConsulta: TObject);
begin
  aConsultacidades:= Tform_consulta_cidades( pConsulta );
end;

procedure Tform_cadastro_fornecedores.setFrmConsultaCondicaoPagamento(
  pConsulta: TObject);
begin
  aConsultacondicao:= Tform_consulta_condicoes_pagamentos( pConsulta );
end;

procedure Tform_cadastro_fornecedores.setFrmConsultaContatos(
  pConsulta: TObject);
begin
  aConsultaContatos:= Tform_consulta_tipos_contatos( pConsulta );
end;

procedure Tform_cadastro_fornecedores.tipoFornecedor;
begin
  case ComboBox_tipo_fornecedor.ItemIndex of
    0:  //pessoa física
      begin
        lbl_nome_razao_social.Caption:= 'Nome *';
        lbl_apelido_nome_fantasia.Caption:= 'Apelido *';
        lbl_cpf_cnpj.Caption:= 'CPF *';
        lbl_rg_ie.Caption:= 'RG *';

        edt_cpf_cnpj.TipoMascara:= tmCPF;
      end;
    1: //pessoa jurídica
      begin
        lbl_nome_razao_social.Caption:= 'Razão Social *';
        lbl_apelido_nome_fantasia.Caption:= 'Nome Fantasia *';
        lbl_cpf_cnpj.Caption:= 'CNPJ *';
        lbl_rg_ie.Caption:= 'IE *';

        edt_cpf_cnpj.TipoMascara:= tmCNPJ;
      end;
  end;
end;

function Tform_cadastro_fornecedores.validaFormulario: Boolean;
begin
  Result:= False;

  if Self.edt_nome_razao_social.Text = '' then
  begin
    MessageDlg( 'O campo Nome/Razão Social é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_nome_razao_social.SetFocus;
    Exit;
  end;

  if Self.edt_apelido_nome_fantasia.Text = '' then
  begin
    MessageDlg( 'O campo Apelido/Nome Fantasia é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_apelido_nome_fantasia.SetFocus;
    Exit;
  end;

  if Self.edt_endereco.Text = '' then
  begin
    MessageDlg( 'O campo Endereço é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_endereco.SetFocus;
    Exit;
  end;

  if Self.edt_numero.Text = '' then
  begin
    MessageDlg( 'O campo Número é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_numero.SetFocus;
    Exit;
  end;

  if Self.edt_bairro.Text = '' then
  begin
    MessageDlg( 'O campo Bairro é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_bairro.SetFocus;
    Exit;
  end;

  if Self.edt_pesquisar_cidade.Text = '' then
  begin
    MessageDlg( 'O campo Cidade é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_pesquisar_cidade.SetFocus;
    Exit;
  end;

//  if Self.edt_cpf_cnpj.Text = '' then
//  begin
//    MessageDlg( 'O campo CPF/CNPJ é obrigatório!', MtInformation, [ MbOK ], 0 );
//    edt_cpf_cnpj.SetFocus;
//    Exit;
//  end;

  if Self.edt_rg_ie.Text = '' then
  begin
    MessageDlg( 'O campo RG/IE é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_rg_ie.SetFocus;
    Exit;
  end;

  if Self.edt_pesquisa_condicao_pagamento.Text = '' then
  begin
    MessageDlg( 'O campo Condição de Pagamento é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_pesquisa_condicao_pagamento.SetFocus;
    Exit;
  end;

 Result:= true;
end;

function Tform_cadastro_fornecedores.validaItens: Boolean;
begin
  Result:= False;

  if Self.edt_tipo_contato.Text = '' then
  begin
    MessageDlg( 'O campo Tipo de Contato é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_tipo_contato.SetFocus;
    Exit;
  end;

  if Self.edt_nome_tipo_selecionado.Text = '' then
  begin
    MessageDlg( 'O campo é obrigatório!', MtInformation, [ MbOK ], 0 );
    edt_nome_tipo_selecionado.SetFocus;
    Exit;
  end;

 Result:= true;
end;

end.
