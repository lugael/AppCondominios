import 'package:app_condominios/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

int soma( int a, int b){
  return a + b ;
}


void main(){
  test('Teste Idade Michael Jackeson', () async{
    final morador = Morador(nascimento: DateTime(1990,05,14));
    expect(morador.getIdade(), 31);
  });

  test('Teste Idade Joao', () async{
    final morador = Morador(nascimento: DateTime(2003,05,14));
    expect(morador.getIdade(), 18);
  });
  test('Teste Idade Marcos', () async{
    final morador = Morador(nascimento: DateTime(1980,05,14));
    expect(morador.getIdade(), 41);
  });
  test('Teste Idade Claudia', () async{
    final morador = Morador(nascimento: DateTime(1970,05,14));
    expect(morador.getIdade(), 51);
  });
  test('Teste Idade Julia', () async{
    final morador = Morador(nascimento: DateTime(1950,05,14));
    expect(morador.getIdade(), 71);
  });
  test('Teste Idade Michael Jackeson', () async{
    final morador = Morador(nascimento: DateTime(1990,05,14));
    expect(morador.getIdade(), 31);
  });
  //----------------------------------------------------------------------------
  test('Teste Boleto Situção Pago', () async{
    final boleto = Boleto(
      dataVencto: DateTime(2022,10,25), dataPagto: DateTime(2022,12,01));
    expect(boleto.getSituacao(), SituacaoBoleto.pago);
  });
  test('Teste Boleto Situção vencido', () async{
    final boleto = Boleto(
        dataVencto: DateTime(2022,01,10));
    expect(boleto.getSituacao(), SituacaoBoleto.aberto);
  });
  test('Teste Boleto Situção Pago', () async{
    final boleto = Boleto(dataVencto: DateTime(2022,08,10));
    expect(boleto.getSituacao(), SituacaoBoleto.aberto);
  });

  //----------------------------------------------------------------------------

  test('Teste Condominio.fromMap/ to map',() async{
    final map = {
      'id': Uuid().v4(),
      'nome': 'Parque premiatto',
      'endereco':'Rua Carlos Richbiete,1758',
      'cidade': 'blumenau',
      'uf':'sc',
      'bairro':'centro'
    };
    final condominio = Condominio.fromMap(map);
    expect(condominio.toMap(), map);
  });
}
