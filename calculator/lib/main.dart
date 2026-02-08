import 'package:calculator/button_value.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
      ),
      home: const MyHomePage(title: 'Caluclator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String numbe1 = "";
  String number2 = "";
  String operand = "";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 40),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,

                padding: EdgeInsets.all(10),
                child: Text(
                  "$numbe1 $operand $number2".trim().isEmpty
                      ? "0"
                      : "$numbe1 $operand $number2",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues.map((value) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 5,
                  child: builButton(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget? builButton(String value) {
    final isOperator = [
      Btn.clear,
      Btn.delete,

      Btn.percent,
      Btn.plus,
      Btn.minus,
      Btn.multiply,
      Btn.divide,
      Btn.equal,
    ].contains(value);

    return Material(
      color: isOperator ? Colors.orange : Colors.grey,
      elevation: 1,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: () => _handleButtonTap(value),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isOperator ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonTap(String value) {
    if (value == Btn.clear) {
      _clearAll();
      return;
    }
      if (value == Btn.equal) {
      _calculate();
      setState(() {});
      return;
    }


    if (value == Btn.delete) {
      _delete();
      setState(() {});
      return;
    }
    // Additional button handling logic would go here
    _appendValue(value);
    setState(() {});
  }

  void _appendValue(String value) {
    if (int.tryParse(value) == null && value != Btn.dot) {
      if (numbe1.isEmpty) return;
      if (operand.isNotEmpty && number2.isNotEmpty) {
        _calculate();
      }
      operand = value;
      return;
    }

    if (operand.isEmpty) {
      numbe1 += value;
    } else {
      number2 += value;
    }
    
  }

  void _calculate() {
    if (numbe1.isEmpty || number2.isEmpty || operand.isEmpty) return;

    double n1 = double.parse(numbe1);
    double n2 = double.parse(number2);
    double result = 0;

    switch (operand) {
      case Btn.plus:
        result = n1 + n2;
        break;
      case Btn.minus:
        result = n1 - n2;
        break;
      case Btn.multiply:
        result = n1 * n2;
        break;
      case Btn.divide:
        if (n2 == 0) {
          _clearAll();
          numbe1 = "Error";
          return;
        }
        result = n1 / n2;
        break;
      case Btn.percent:
        result = n1 % n2;
        break;
      default:
        return;
    }

    numbe1 = result.toString();
    number2 = "";
    operand = "";
  }

  void _clearAll() {
    numbe1 = "";
    number2 = "";
    operand = "";
    setState(() {});
  }

  void _delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (numbe1.isNotEmpty) {
      numbe1 = numbe1.substring(0, numbe1.length - 1);
    }
  }
}
