import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const int COM = 2;
const int PERSON = 0;
const int row = 2;
const int col = 0;
class _MyHomePageState extends State<MyHomePage> {
  String currChessPlayer = 'p'; // p代表玩家，c代表电脑
  String hint = "请选择下棋位置";
  bool gameBegin = false;
  bool gameOver = false;
  bool gameFrist = false; // 电脑是否为先手
  int step = 0;
  int x;
  int y;
  int nextX = -1;
  int nextY = -1;
  List<List> array = [
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1],
  ];
  // 玩家表示O，电脑表示X
  List<String> showArray = [
    'O', '', 'X'
  ];
  int isWin(newArray) {
    int sumLeftCorner = 0;
    int sumRightCorner = 0;
    for (int i = 0; i < 3; i++){
      int sumr = 0;
      int sumc = 0;
      for (int j = 0 ; j < 3; j++) {
        sumr += newArray[i][j];
        sumc += newArray[j][i];
        if (i == j) {
          sumLeftCorner += newArray[j][i];
        }
        if (i+j == 2) {
          sumRightCorner += newArray[j][i];
        }
      }
      if (sumr == PERSON*3 || sumc == PERSON*3){ 
        setState(() {
          gameOver = true;
          hint = "恭喜您，您赢了";
        });
        return 1;
      }
      else if (sumr == COM*3 || sumc == COM*3) {
        setState(() {
          gameOver = true;
          hint = "很遗憾，您输了";
        });
        return -1;
      }
    }
    if (sumLeftCorner ==PERSON*3 || sumRightCorner == PERSON*3){
      setState(() {
        gameOver = true;
        hint = "恭喜您，您赢了";
      });
      return 1;
    }
    else if (sumLeftCorner ==COM*3 || sumRightCorner == COM*3) {
      setState(() {
        gameOver = true;
        hint = "很遗憾，您输了";
      });
      return -1;
    }
    return 0;
  }
  bool isFull(newArray) {
    for (int i = 0; i < 3; i++){
      for (int j = 0 ; j < 3; j++) {
        if (newArray[i][j] == 1) return false;
      }
    }
    setState(() {
      gameOver = true;
      hint = "游戏结束，没有胜负";
    });
    return true;
  }
  bool canWin(getWin) {
    int num = 2;
    if (!getWin) {
      num = 0;
    }
    int sumLeftCorner = 0;
    int sumRightCorner = 0;
    for (int i = 0; i < 3; i++){
      int sumr = 0;
      int sumc = 0;
      for (int j = 0 ; j < 3; j++) {
        sumr += array[i][j];
        sumc += array[j][i];
        if (i == j) {
          sumLeftCorner += array[j][i];
        }
        if (i+j == 2) {
          sumRightCorner += array[j][i];
        }
      }
      if (sumr == num*2+1){
        List<List> newArray = array;
        for (int j = 0 ; j < 3; j++) {
          if (newArray[i][j] == 1) {
            newArray[i][j] = COM;
            break;
          }
        }
        setState(() {
          array = newArray;
        });
        if (getWin) isWin(newArray);
        return true;
      }
      if (sumc == num*2+1){
        List<List> newArray = array;
        for (int j = 0 ; j < 3; j++) {
          if (newArray[j][i] == 1) {
            newArray[j][i] = COM;
            break;
          }
        }
        setState(() {
          array = newArray;
        });
        if (getWin) isWin(newArray);
        return true;
      }
    }
    if (sumLeftCorner ==num*2+1) {
      List<List> newArray = array;
      if (newArray[0][0] == 1) {
        newArray[0][0] = COM;
      } else if (newArray[1][1] == 1) {
        newArray[1][1] = COM;
      } else if (newArray[2][2] == 1) {
        newArray[2][2] = COM;
      }
      setState(() {
        array = newArray;
      });
      if (getWin) isWin(newArray);
      return true;
    }
    if (sumRightCorner ==num*2+1) {
      List<List> newArray = array;
      if (newArray[0][2] == 1) {
        newArray[0][2] = COM;
      } else if (newArray[1][1] == 1) {
        newArray[1][1] = COM;
      } else if (newArray[2][0] == 1) {
        newArray[2][0] = COM;
      }
      setState(() {
        array = newArray;
      });
      if (getWin) isWin(newArray);
      return true;
    }
    return false; 
  }
  void _setPlayerMove(r, c) {
    if (isFull(array)) {
      return;     
    }
    if (gameOver) {
      return;
    }
    if (currChessPlayer == 'p' && array[r][c] == 1) {
      List<List> newArray =array;
      newArray[r][c] = PERSON;
      setState(() {
        array = newArray;
        currChessPlayer='p';
        x = r;
        y = c;
        gameBegin: true;
      });
      if (isWin(newArray) == 1) {
        return;
      }
      _setComputerMove();
    }
  }
  // https://www.guokr.com/article/4754/
  void _setComputerMove() {
    if (isFull(array)) {
      return;     
    }
    if (gameOver) {
      return;
    }
    if (canWin(true)) {
      return;
    }
    if (canWin(false)) {
      isFull(array);
      return;
    }
    if (gameFrist) {
      List<List> newArray =array;
      int newNextx = nextX;
      int newNextY = nextY;
      // 先占角
      if (step == 0) {
        newArray[row][col] = COM;
      } else if (step == 1) {
        if ((x == row-1 && y == col)||(x == row && y == col+1)) {
          newArray[row-1][col+1] = COM;
          // 下一步走角
          newNextx = row-2; newNextY = col;
        } else if ((x == row && y == col+2) || (x == row-2 && y == col)) {
          newArray[col][row] = COM;
          newNextx = row-2; newNextY = col;
        } else if ((x == row-2 && y == col+1) || (x == row-1 && y == col+2)) {
          newArray[row-1][col+1] = COM;
          newNextx = row; newNextY = col+2;
        } else if (x == col && y == row) {
          newArray[row][col+2] = COM;
          newNextx = row-2; newNextY = col;
        } else if (x == row-1 && y == col+1) { // 走中间
          newArray[col][row] = COM;
        }
      } else if (step == 2 && newNextx > -1 && newNextY > -1 && newArray[newNextx][newNextY] == 1) {
        newArray[newNextx][newNextY] = COM;
      } else {
        for (int i = 0; i < 3; i++){
          for (int j = 0 ; j < 3; j++) {
            if (newArray[i][j] == 1) {
              newArray[i][j] = COM;
              isFull(newArray);
              setState(() {
                array = newArray;
                currChessPlayer='p';
                step = step + 1;
                nextX = -1;
                nextY = -1;
              }); 
              return;
            }     
          }
        }
      }     
      setState(() {
        array = newArray;
        currChessPlayer='p';
        step = step + 1;
        nextX = newNextx;
        nextY = newNextY;
      }); 
      isWin(newArray);
      isFull(array); 
    } else {
      List<List> newArray =array;
      int newNextX = nextX;
      int newNextY = nextY;
      if (step == 0) {
        // 角
        if ((x == 0 || x == 2) && ((y == 0 || y == 2))) {
          newArray[1][1] = COM;
          newNextX = 0; newNextY = 1;
        }
        // 中心
        else if (x==1 && y==1) {
          newArray[row][col] = COM;
          newNextX = 0; newNextY = 0;
        } else {
          if (y == 1) {
            newArray[x][y-1] = COM;
          } else {
            newArray[x-1][y] = COM;
          }
          newNextX = 1; newNextY = 1;
        }
      }else if (step == 1 && newNextX > -1 && newNextY > -1 && (newArray[newNextX][newNextY] == 1)||(newArray[newNextY][newNextX] == 1)){
        if (newArray[newNextX][newNextY] == 1) {
          newArray[newNextX][newNextY] = COM;
        } else if (newArray[newNextY][newNextX] == 1){
          newArray[newNextY][newNextX] = COM;
        }
      } else {
        for (int i = 0; i < 3; i++){
          for (int j = 0 ; j < 3; j++) {
            if (newArray[i][j] == 1) {
              newArray[i][j] = COM;
              isFull(newArray);
              setState(() {
                array = newArray;
                currChessPlayer='p';
                step = step + 1;
                nextX = -1;
                nextY = -1;
              }); 
              return;
            }     
          }
        }
      }
      setState(() {
        array = newArray;
        currChessPlayer='p';
        step = step + 1;
        nextX = newNextX;
        nextY = newNextY;
      }); 
      isWin(newArray);
      isFull(array);
    }
    // 
  }
  void _incrementCounter() {
    if (gameBegin == false) {
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        currChessPlayer='c';
        gameBegin = true;
        gameFrist = true;
      });
      _setComputerMove();
    }
  }
  Widget buildGrid() {
    List<Widget> tiles = [];//先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for(var i in [0, 1, 2]) {
      double size = 30.0;
      BoxDecoration bootomBorder;
      if (i <= 1) {
        bootomBorder = new BoxDecoration(
          border: Border(bottom:BorderSide(color: Colors.black,width: 1)),
        );
      }
      tiles.add(
        new Container(
          decoration: bootomBorder,
          child: new Row(
              children: <Widget>[
                new InkWell(
                  onTap: () {
                    _setPlayerMove(i, 0);
                  },
                  child: new Baseline(
                    baseline: size,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 60.0,
                      height: 60.0,
                      alignment: Alignment.center,
                      child: new Text(showArray[array[i][0]]),
                      decoration: new BoxDecoration(
                        border: Border(right:BorderSide(color: Colors.black,width: 2)),
                      ),
                    ),
                  ),
                ),
                new InkWell(
                  onTap: () {
                    _setPlayerMove(i, 1);
                  },
                  child: new Baseline(
                    baseline: size,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 60.0,
                      height: 60.0,
                      alignment: Alignment.center,
                      child: new Text(showArray[array[i][1]]),
                      decoration: new BoxDecoration(
                        border: Border(right:BorderSide(color: Colors.black,width: 2)),
                      ),
                    ),
                  ),
                ),                
                new InkWell(
                  onTap: () {
                    _setPlayerMove(i, 2);
                  },
                  child: new Baseline(
                    baseline: size,
                    baselineType: TextBaseline.alphabetic,
                    child: new Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 60.0,
                      height: 60.0,
                      alignment: Alignment.center,
                      child: new Text(showArray[array[i][2]]),
                    ),
                  ),
                ),
              ]
          )
        )
      );
    }
    content = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
    );
    return content;
  }
  // Widget ExampleWidget = buildGrid();
  @override
  Widget build(BuildContext context) {
    Text hintText = new Text('');
    if (currChessPlayer == 'p') {
      hintText = new Text('$hint');
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(0.0),
              width: 100.0,
              height: 100.0,
              alignment: Alignment.center,
              child: new Text('井字棋', style: TextStyle(fontSize: 25.0)),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildGrid()
              ]
            ),
            new Container(
              padding: const EdgeInsets.all(0.0),
              width: 200.0,
              height: 100.0,
              alignment: Alignment.center,
              child: hintText,
            ),
            // Text(
            //   'You have clickedfd the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Text('我后手'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
