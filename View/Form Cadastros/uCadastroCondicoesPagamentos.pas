unit uCadastroCondicoesPagamentos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCadastroPai, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.StdCtrls, campoEdit, Vcl.ExtCtrls, Vcl.ComCtrls,
  uCondicoesPagamentos, uCtrlCondicoesPagamentos, uConsulta_FormasPagamentos;

type
  Tform_cadastro_condicao_pagamento = class(Tform_cadastro_pai)
    edt_condicao_pagamento: PriTEdit;
    edt_num_parcelas: PriTEdit;
    edt_desconto: PriTEdit;
    edt_juros: PriTEdit;
    edt_multa: PriTEdit;
    lbl_condicao_pagamento: TLabel;
    lbl_num_parcelas: TLabel;
    lbl_desconto: TLabel;
    lbl_juros: TLabel;
    lbl_multa: TLabel;
    pnl_adicionar_contato: TPanel;
    btn_adicionar_contato: TSpeedButton;
    pnl_remover_item: TPanel;
    btn_remover_item: TSpeedButton;
    ListView_condicao_pagamento: TListView;
    pnl_botao_alterar_item: TPanel;
    btn_botao_alterar_item: TSpeedButton;
    lbl_dias: TLabel;
    edt_dias: PriTEdit;
    lbl_porcentagem: TLabel;
    edt_porcentagem: PriTEdit;
    pbl_limpar_grid: TPanel;
    btn_limpar_grid: TSpeedButton;
    lbl_totais: TLabel;
    lbl_total_porc: TLabel;
    edt_pesquisar_registro: PriTEdit;
    pnl_btn_pesquisa: TPanel;
    btn_pesquisa: TSpeedButton;
    edt_cod_forma: PriTEdit;
    lbl_codigo_forma: TLabel;
    Label2: TLabel;

    procedure btn_adicionar_contatoMouseEnter(
  Sender: TObject);
    procedure btn_adicionar_contatoMouseLeave(
  Sender: TObject);

    procedure btn_botao_alterar_itemMouseEnter(Sender: TObject);
    procedure btn_botao_alterar_itemMouseLeave(Sender: TObject);
    procedure btn_adicionar_contatoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_limpar_gridClick(Sender: TObject);
    procedure btn_remover_itemClick(Sender: TObject);
    procedure ListView_condicao_pagamentoSelectItem(Sender: TObject;
      Item: TListItem; Selected: Boolean);
    procedure btn_botao_alterar_itemClick(Sender: TObject);
    procedure btn_pesquisaClick(Sender: TObject);
    procedure edt_porcentagemKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }

    aCondicao : CondicoesPagamentos;
    aCtrlCondicoes : ctrlCondicoesPagamentos;

    aConsultaFormas : Tform_consulta_formas_pagamentos;
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
    procedure setFrmConsultaFormas ( pConsulta : TObject );
    procedure bloqueaiaBtnPesquisa;
    procedure desbloqueiaBtnPesquisa;

    procedure adicionarItens;
    procedure limparItens;
    function validaItens : Boolean;
  end;

var
  form_cadastro_condicao_pagamento: Tform_cadastro_condicao_pagamento;

implementation

{$R *.dfm}

procedure Tform_cadastro_condicao_pagamento.adicionarItens;
var item : TListItem;
begin

  if ListView_condicao_pagamento.Items.Count > 0 then
  begin
    if StrToInt ( edt_dias.Text ) <= StrToInt ( ListView_condicao_pagamento.Items[ListView_condicao_pagamento.Items.Count - 1].SubItems[0] ) then
    begin
      MessageDlg( 'O dia informado n�o pode ser menor ou igual ao �ltimo dia da parcela adicionada!', MtInformation, [ MbOK ], 0 );
      edt_dias.SetFocus;
      Exit;
    end
    else
    begin
      item:= ListView_condicao_pagamento.Items.Add;

      item.Caption:= edt_num_parcelas.Text;
      item.SubItems.Add(edt_dias.Text);
      item.SubItems.Add(edt_porcentagem.Text);
      item.SubItems.Add(edt_desconto.Text);
      item.SubItems.Add(edt_juros.Text);
      item.SubItems.Add(edt_multa.Text);
      item.SubItems.Add(edt_pesquisar_registro.Text);

      edt_num_parcelas.Text:= IntToStr( StrToInt ( edt_num_parcelas.Text) + 1 );

     lbl_total_porc.Caption:= FloatToStr (StrToFloat (lbl_total_porc.Caption) + StrToFloat (edt_porcentagem.Text));
    end;
  end
  else
  begin
    item:= ListView_condicao_pagamento.Items.Add;

    item.Caption:= edt_num_parcelas.Text;
    item.SubItems.Add(edt_dias.Text);
    item.SubItems.Add(edt_porcentagem.Text);
    item.SubItems.Add(edt_desconto.Text);
    item.SubItems.Add(edt_juros.Text);
    item.SubItems.Add(edt_multa.Text);
    item.SubItems.Add(edt_pesquisar_registro.Text);
    
    edt_num_parcelas.Text:= IntToStr( StrToInt ( edt_num_parcelas.Text) + 1 );

    lbl_total_porc.Caption:= FloatToStr (StrToFloat (lbl_total_porc.Caption) + StrToFloat (edt_porcentagem.Text));
  end;

end;

procedure Tform_cadastro_condicao_pagamento.bloqueaiaBtnPesquisa;
begin
  self.btn_pesquisa.Visible:= False;

  self.btn_adicionar_contato.Enabled:= False;
  self.btn_botao_alterar_item.Enabled:= False;
  self.btn_remover_item.Enabled:= False;
  self.btn_limpar_grid.Enabled:= False;
end;

procedure Tform_cadastro_condicao_pagamento.bloqueiaEdt;
begin
  inherited;
  self.edt_condicao_pagamento.Enabled:= False;
  self.edt_num_parcelas.Enabled:= False;
  self.edt_dias.Enabled:= False;
  self.edt_porcentagem.Enabled:= False;
  self.edt_desconto.Enabled:= False;
  self.edt_juros.Enabled:= False;
  self.edt_multa.Enabled:= False;
  self.edt_cod_forma.Enabled:= False;
end;

procedure Tform_cadastro_condicao_pagamento.btn_adicionar_contatoClick(
  Sender: TObject);
begin
  if validaItens then
  begin
     adicionarItens;
     limparItens;
     edt_dias.SetFocus;
  end;
end;

procedure Tform_cadastro_condicao_pagamento.carregaEdt;
begin
  inherited;

  if aCondicao.getCodigo <> 0 then
     self.edt_codigo.Text:= IntToStr( aCondicao.getCodigo );

  self.edt_condicao_pagamento.Text:= aCondicao.getCondicao;
  self.edt_data_cadastro.Text:= DateToStr( aCondicao.getDataCad);
  self.edt_data_ult_alt.Text:= DateToStr(aCondicao.getUltAlt);

  self.edt_cod_forma.Text:=  IntToStr (aCondicao.getaFormaPagamento.getCodigo);
  self.edt_pesquisar_registro.Text:= aCondicao.getaFormaPagamento.getFormaPagamento;
end;

procedure Tform_cadastro_condicao_pagamento.conhecaObj(pCtrl, pObj: TObject);
begin
  inherited;
  aCondicao:= CondicoesPagamentos( pObj );
  aCtrlCondicoes:= ctrlCondicoesPagamentos( pCtrl );

  self.limpaEdt;
  self.limparItens;
  self.carregaEdt;
end;

procedure Tform_cadastro_condicao_pagamento.desbloqueiaBtnPesquisa;
begin
  self.btn_pesquisa.Visible:= True;

  self.btn_adicionar_contato.Enabled:= True;
  self.btn_botao_alterar_item.Enabled:= True;
  self.btn_remover_item.Enabled:= True;
  self.btn_limpar_grid.Enabled:= True;
end;

procedure Tform_cadastro_condicao_pagamento.desbloqueiaEdt;
begin
  inherited;
  self.edt_condicao_pagamento.Enabled:= True;
  self.edt_num_parcelas.Enabled:= True;
  self.edt_dias.Enabled:= True;
  self.edt_porcentagem.Enabled:= True;
  self.edt_desconto.Enabled:= True;
  self.edt_juros.Enabled:= True;
  self.edt_multa.Enabled:= True;
  self.edt_cod_forma.Enabled:= True;
end;

procedure Tform_cadastro_condicao_pagamento.edt_porcentagemKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9',',',#8]) then
    key :=#0;
end;

procedure Tform_cadastro_condicao_pagamento.FormShow(Sender: TObject);
begin
  inherited;

  if Self.btn_botao_salvar.Caption='Salvar' then
        edt_condicao_pagamento.SetFocus;

  edt_num_parcelas.Text:= '1';
end;

procedure Tform_cadastro_condicao_pagamento.limpaEdt;
begin
  inherited;
  self.edt_condicao_pagamento.Clear;
  Self.edt_data_cadastro.Clear;
  self.edt_data_ult_alt.Clear;
end;

procedure Tform_cadastro_condicao_pagamento.limparItens;
begin
//  self.edt_num_parcelas.Clear;
  self.edt_dias.Clear;
  self.edt_porcentagem.Clear;
  self.edt_desconto.Clear;
  self.edt_juros.Clear;
  self.edt_multa.Clear;
  self.edt_cod_forma.Clear;
  self.edt_pesquisar_registro.Clear;
end;

procedure Tform_cadastro_condicao_pagamento.ListView_condicao_pagamentoSelectItem(
  Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  inherited;
  if Selected then
  begin
    btn_remover_item.Enabled:= True;
    btn_botao_alterar_item.Enabled:= True;
  end
  else
  begin
    btn_remover_item.Enabled:= False;
    btn_botao_alterar_item.Enabled:= False;
  end;
end;

procedure Tform_cadastro_condicao_pagamento.sair;
begin
  inherited;

end;

procedure Tform_cadastro_condicao_pagamento.salvar;
begin
  inherited;
  if validaFormulario then
  begin
    aCondicao.setCodigo( StrToInt ( self.edt_codigo.Text ) );
    aCondicao.setCondicao( self.edt_condicao_pagamento.Text );
    aCondicao.setTotalParcelas( self.ListView_condicao_pagamento.ItemIndex );
    aCondicao.setDataCad( Date );
    aCondicao.setUltAlt( Date );
    aCondicao.setCodUsu( StrToInt ( Self.edt_cod_usuario.Text ) );

    if Self.btn_botao_salvar.Caption = 'Salvar' then // INCLUIR-ALTERAR
       aCtrlCondicoes.salvar( aCondicao.clone )
    else //EXCLUIR
       aCtrlCondicoes.excluir( aCondicao.clone );

    self.sair;
  end;
end;

procedure Tform_cadastro_condicao_pagamento.setFrmConsultaFormas(
  pConsulta: TObject);
begin
  aConsultaFormas:= Tform_consulta_formas_pagamentos ( pConsulta );
end;

function Tform_cadastro_condicao_pagamento.validaFormulario: Boolean;
begin
  Result:= False;

  if Self.edt_condicao_pagamento.Text = '' then
  begin
    MessageDlg( 'O campo Condi��o de Pagamento � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_condicao_pagamento.SetFocus;
    Exit;
  end;

  if ListView_condicao_pagamento.Items.Count = 0 then
  begin
    MessageDlg( 'A condi��o de pagamento deve possuir pelo menos uma parcela!', MtInformation, [ MbOK ], 0 );
    ListView_condicao_pagamento.SetFocus;
    Exit;
  end;

 Result:= true;
end;

function Tform_cadastro_condicao_pagamento.validaItens: Boolean;
begin
  Result:= False;

  if Self.edt_num_parcelas.Text = '' then
  begin
    MessageDlg( 'O campo N�mero de Parcelas � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_num_parcelas.SetFocus;
    Exit;
  end;

  if Self.edt_dias.Text = '' then
  begin
    MessageDlg( 'O campo Dias � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_dias.SetFocus;
    Exit;
  end;

  if Self.edt_porcentagem.Text = '' then
  begin
    MessageDlg( 'O campo Porcentagem � obrigat�rio!', MtInformation, [ MbOK ], 0 );
    edt_porcentagem.SetFocus;
    Exit;
  end;

  if ( StrToFloat ( self.edt_porcentagem.Text ) ) > 100 then
  begin
    MessageDlg( 'A porcentagem n�o pode ultrapassar 100%!', MtInformation, [ MbOK ], 0 );
    edt_porcentagem.SetFocus;
    Exit;
  end;

  if ( StrToFloat ( self.lbl_total_porc.Caption ) ) = 100 then
  begin
    MessageDlg( 'O total da porcentagem n�o pode ultrapassar de 100%!', MtInformation, [ MbOK ], 0 );
    edt_porcentagem.SetFocus;
    Exit;
  end;

  if Self.edt_pesquisar_registro.Text = '' then
  begin
    MessageDlg( 'A forma de pagamento � obrigat�ria!', MtInformation, [ MbOK ], 0 );
    edt_pesquisar_registro.SetFocus;
    Exit;
  end;

  if ( StrToFloat ( self.lbl_total_porc.Caption ) ) +  ( StrToFloat ( self.edt_porcentagem.Text ) ) > 100 then
  begin
    MessageDlg( 'O total da porcentagem n�o pode ultrapassar de 100%!', MtInformation, [ MbOK ], 0 );
    edt_porcentagem.SetFocus;
    Exit;
  end;

 Result:= true;
end;

procedure Tform_cadastro_condicao_pagamento.btn_remover_itemClick(
  Sender: TObject);
begin
  if ListView_condicao_pagamento.ItemFocused.Index = ListView_condicao_pagamento.Items.Count - 1 then
  begin
    lbl_total_porc.Caption:= FloatToStr( StrToFloat ( lbl_total_porc.Caption ) - StrToFloat ( ListView_condicao_pagamento.ItemFocused.SubItems[1] ) );
    ListView_condicao_pagamento.DeleteSelected;
    edt_num_parcelas.Text:= IntToStr( StrToInt ( edt_num_parcelas.Text ) - 1 );
  end
  else
    MessageDlg( 'Primeiro deve excluir a �ltima parcela!', MtInformation, [ MbOK ], 0 );
end;

procedure Tform_cadastro_condicao_pagamento.btn_limpar_gridClick(
  Sender: TObject);
begin
  inherited;
  ListView_condicao_pagamento.Clear;
  lbl_total_porc.Caption:= '0';
  edt_num_parcelas.Text:= '1';
end;

procedure Tform_cadastro_condicao_pagamento.btn_pesquisaClick(Sender: TObject);
var aux : string;
begin
 // inherited;
  aConsultaFormas.conhecaObj( aCtrlCondicoes.getCtrlFormas, aCondicao.getaFormaPagamento );
  aux:= aConsultaFormas.btn_botao_sair.Caption;
  aConsultaFormas.btn_botao_sair.Caption:= 'Selecionar';
  aConsultaFormas.ShowModal;
  aConsultaFormas.btn_botao_sair.Caption:= aux;

  self.edt_cod_forma.Text:= IntToStr( aCondicao.getaFormaPagamento.getCodigo );
  self.edt_pesquisar_registro.Text:= aCondicao.getaFormaPagamento.getFormaPagamento;
end;

procedure Tform_cadastro_condicao_pagamento.btn_botao_alterar_itemClick(
  Sender: TObject);
var item : TListItem;
begin
  edt_dias.Text:= ListView_condicao_pagamento.Selected.SubItems[0];
  edt_porcentagem.Text:= ListView_condicao_pagamento.Selected.SubItems[1];
  edt_desconto.Text:= ListView_condicao_pagamento.Selected.SubItems[2];
  edt_juros.Text:= ListView_condicao_pagamento.Selected.SubItems[3];
  edt_multa.Text:= ListView_condicao_pagamento.Selected.SubItems[4];
  edt_pesquisar_registro.Text:= ListView_condicao_pagamento.Selected.SubItems[5];
end;

//---------------------ESTILOS BOT�ES---------------------//

procedure Tform_cadastro_condicao_pagamento.btn_adicionar_contatoMouseEnter(
  Sender: TObject);
begin
  btn_adicionar_contato.Font.Style:= [fsBold];
end;

procedure Tform_cadastro_condicao_pagamento.btn_adicionar_contatoMouseLeave(
  Sender: TObject);
begin
  btn_adicionar_contato.Font.Style:= [];
end;

procedure Tform_cadastro_condicao_pagamento.btn_botao_alterar_itemMouseEnter(Sender: TObject);
begin
  btn_botao_alterar_item.Font.Style:= [fsBold];
end;

procedure Tform_cadastro_condicao_pagamento.btn_botao_alterar_itemMouseLeave(Sender: TObject);
begin
  btn_botao_alterar_item.Font.Style:= [];
end;

end.
