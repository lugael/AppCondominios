import 'package:app_condominios/model.dart';
final _condominioPremiatto = Condominio(
  nome: 'Parque Premiatto',
  bairro: 'Boa vista',
  cidade: 'Blumenau'
);
List<Morador> fakeMoradores(){
  return [
    Morador(
      nome: 'Bob Marley',
      nascimento: DateTime(2000,04,16),
      condominio: _condominioPremiatto,
      bloco: 'A',
      apto: 902,
      cpf: '123.123.123-04',
      imagemAsset: 'bobmarley.jpg'
    ),Morador(
        nome: 'Bobdy Lan',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'bobdylan.jpg'
    ),Morador(
        nome: 'Bon Jovi',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'bonjovi.jpg'
    ),Morador(
        nome: 'David',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'david.jpg'
    ),Morador(
        nome: 'Dua Lipa',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'dualipa.jpg'
    ),Morador(
        nome: 'elvis',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'elvis.jpg'
    ),Morador(
        nome: 'Eric',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'eric.jpg'
    ),Morador(
        nome: 'Freddie',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'freddie.jpg'
    ),Morador(
        nome: 'Jack Johnson',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'jackjohnson.jpg'
    ),Morador(
        nome: 'Madonna',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'madonna.jpg'
    ),Morador(
        nome: 'Michael',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'michael.jpg'
    ),Morador(
        nome: 'ozzy',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'ozzy.jpg'
    ),Morador(
        nome: 'Paul',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'paul.jpg'
    ),Morador(
        nome: 'Taylor',
        nascimento: DateTime(2000,04,16),
        condominio: _condominioPremiatto,
        bloco: 'A',
        apto: 902,
        cpf: '123.123.123-04',
        imagemAsset: 'taylor.jpg'
    )
  ];
}