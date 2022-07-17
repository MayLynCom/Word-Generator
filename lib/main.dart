import 'package:flutter/material.dart'; //importando um pacote chamado material, que tem widgets padrões
import 'package:english_words/english_words.dart'; //pacote que importa as palavras mais utilizadas em inglês
//para importa-lo antes você deve executar o comando "flutter pub add english_words", ele ira adicionar as dependencias necessarias

void main() {
  //void main é a função padrão do dart, ela não retorna nada
  runApp(
      const MyApp()); //o MyApp tem const pq ele é um StatelessWidget, ou seja , não modificavel
}

//StatelessWidget é um widget que não muda de estado ele é constante, fixo, não altera, como por exemplo a estilização da página
class MyApp extends StatelessWidget {
  //classe MyApp criada por você que extende de StatelessWidget
  const MyApp({Key? key}) : super(key: key); //constructor MyApp
  //super é usado para chamar o construtor da classe base.
  //Portanto, no seu exemplo, o construtor de MyApp está chamando o construtor de StatelessWidget.
  //Ele declara parâmetros nomeados opcionais (nomeado opcional por causa de {})
  //Key? = quer dizer que o parametro é nullo, ou seja não tem valor

  @override //@override é quando você reescreve um método que ja existe
  Widget build(BuildContext context) {
    //build é um método que esta retornando um Widget(MaterialApp)
    //BuildContext context = a função dele é localizar cada widget nessa árvore, pois no flutter os widgets estão em uma árvore
    return MaterialApp(
      //MaterialApp = serve para acessar widgets padrões
      title: 'Startup Name Generator', //title = aparece quando selecionado
      theme: ThemeData(//ThemeData = é uma classe com temas padrões
        appBarTheme: const AppBarTheme(//modifica o AppBar
          backgroundColor: Colors.red,
          foregroundColor: Colors.black,//modifica a cor de dentro do AppBar como textos ou icones
        ),
      ),
      home: const RandomWords(),//chama a classe RandomWords
    );
  }
}

//se você digitar "st", irá aparecer opções de StatefulWidget e StatelessWidget, necessitando só que você crie o nome
class RandomWords extends StatefulWidget {
  //StatefulWidget é um widget que muda de estado, pode ser modificado
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  void _pushSaved() {
    //função que vai para a outra página onde estão salvos os favoritos
    Navigator.of(context).push(
      //navigator.push é uma função que permite ir para outra pagina
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            //map = serve para mapear a lista
            (pair) //pair = busca um par de cada vez
            {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              //se tiles.isNotEmpty = true então a lista será exibida
              ? ListTile.divideTiles(
                  context: context,
                  tiles:
                      tiles, //aqui é exibida a lista mapeada por isso precisa do .toList para mudar para lista
                ).toList()
              // caso seja falso ela vai exibir uma lista vazia
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  final _suggestions = <WordPair>[];
  //<WordPair>[] = lista de pares de palavras, nada alem disso pode ser adicionado a essa lista 

  final _saved = <WordPair>{};

  final _biggerFont = const TextStyle(fontSize: 18);
  //variavel para aumentar o tamanho da fonte

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //WordPair = par de palavras, random() = função que torna essas palavras aleatórias
    //final ele pode ser nullo e modificado depois
    // wordPair = nome da variavel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          //actions = vai ficar a esquerda do AppBar
          IconButton(
            icon: const Icon(Icons.list), //icone de lista
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
            //tooltip = dica
          ),
        ],
      ),
      body: ListView.builder(
        //ListView = Uma lista rolável de widgets organizados linearmente.
        //O construtor ListView.builder usa um IndexedWidgetBuilder , que constrói os filhos sob demanda.
        //Esse construtor é apropriado para exibições de lista com um número grande (ou infinito) de filhos porque o construtor
        //é chamado apenas para os filhos que são realmente visíveis.
        padding: const EdgeInsets.all(16.0),
        //padding = preenchimento, ou seja o tamanho de dentro do Widget
        //.all significa que vai preencher todos os lados
        itemBuilder: (context, i) {
          //(context, i) = dois parametro são passados para o itemBuilder
          if (i.isOdd) return const Divider();
          //.isOdd = i = ímpar
          //Divider() = Uma linha horizontal fina, com preenchimento em ambos os lados, abaixo

          final index = i ~/ 2;
          // ~/ = Dividir, retornando um resultado inteiro
          if (index >= _suggestions.length) {
            //_suggestions.length = tamanho da lista
            //se index for maior ou igual ao tamanho de da lista
            _suggestions.addAll(generateWordPairs().take(10));
            //_suggestions.addAll = adicionar tudo
            //(generateWordPairs() = gera aleatóriamente pares de palavras
            //.take(10) = pega os 10 primeiros elementos gerados
          }
          final alreadySaved = _saved.contains(_suggestions[index]);
          // alreadySaved verificação para garantir que um emparelhamento de palavras ainda não tenha sido adicionado aos favoritos.

          return ListTile(
            //retorna uma ListTile = que mostra só o titulo da lista
            title: Text(
              _suggestions[index].asPascalCase,
              //_suggestions[index] = ele exibe uma de cada vez, do primeiro até o último
              style: _biggerFont,
            ),
            trailing: Icon(
              //trailing = Um widget a ser exibido após o título. Normalmente, um widget [ícone].
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              //se alreadySaved = true irá exibir um icone de favorito preenchido se = false ira exibir a borda do coração
              color: Colors.red,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              //se alreadySaved = true o semanticLabel vai ser 'Remove from saved' se for false vai ser 'Save'
            ),
            onTap: () {
              //onTap torna clicavel
              setState(() {
                //setState() para notificar a estrutura de que o estado foi alterado.
                if (alreadySaved) {
                  //se alreadySaved = true vai remover a palavra
                  _saved.remove(_suggestions[index]);
                } else {
                  //se alreadySaved = false vai adicionar a palavra
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );

    //return Text(wordPair.asPascalCase);
    //PascalCase = todas as palavras vão começar com letra maiuscula.
    //quando você utiliza o ".as", significa que você esta quer utilizar aquela variavel "como"
    //.asPascalCase = você informa que quer utilizar a variavel com a primeira letra maiuscula
  }
}
