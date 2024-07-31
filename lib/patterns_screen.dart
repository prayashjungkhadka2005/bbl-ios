import 'package:bbl_security/AppsScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PatternsScreen extends StatefulWidget {
  final String useremail;

  PatternsScreen({required this.useremail});

  @override
  _PatternsScreenState createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen>
    with TickerProviderStateMixin {
  Offset? offset;
  List<int> codes = [];
  final GlobalKey _paintKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;
  String errorMessage = '';
  List<int> initialPattern = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _sizePainter = Size.square(_width);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Draw Pattern to setup Lock",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(223, 4, 4, 4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                child: CustomPaint(
                  key: _paintKey,
                  painter: _LockScreenPainter(
                    codes: codes,
                    offset: offset,
                    onSelect: _onSelect,
                    animation: _animation,
                  ),
                  size: _sizePainter,
                ),
                onPanStart: (details) {
                  _clearCodes();
                  _onPanUpdate(DragUpdateDetails(
                      globalPosition: details.globalPosition));
                },
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails event) {
    RenderBox box = _paintKey.currentContext!.findRenderObject() as RenderBox;
    setState(() => offset = box.globalToLocal(event.globalPosition));
  }

  void _onPanEnd(DragEndDetails event) {
    if (codes.length < 4) {
      setState(() {
        errorMessage = "You must draw at least 4 points to set a pattern.";
      });
      _clearCodes();
    } else {
      setState(() {
        errorMessage = '';
        initialPattern = List.from(codes);
        _clearCodes();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPatternScreen(
            initialPattern: initialPattern,
            useremail: widget.useremail,
          ),
        ),
      );
    }
    setState(() => offset = null);
    print(
        "Generated code: ${initialPattern.join()}"); // Print the initial pattern
  }

  void _onSelect(int code) {
    if (!codes.contains(code)) {
      codes.add(code);
    }
  }

  void _clearCodes() {
    setState(() {
      codes = [];
      offset = null;
    });
  }
}

class ConfirmPatternScreen extends StatefulWidget {
  final List<int> initialPattern;
  final String useremail;

  ConfirmPatternScreen({required this.initialPattern, required this.useremail});

  @override
  _ConfirmPatternScreenState createState() => _ConfirmPatternScreenState();
}

class _ConfirmPatternScreenState extends State<ConfirmPatternScreen>
    with TickerProviderStateMixin {
  Offset? offset;
  List<int> codes = [];
  final GlobalKey _paintKey = GlobalKey();
  late AnimationController _controller;
  late Animation<double> _animation;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _sizePainter = Size.square(_width);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Draw Pattern to confirm Lock",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(223, 4, 4, 4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                child: CustomPaint(
                  key: _paintKey,
                  painter: _LockScreenPainter(
                    codes: codes,
                    offset: offset,
                    onSelect: _onSelect,
                    animation: _animation,
                  ),
                  size: _sizePainter,
                ),
                onPanStart: (details) {
                  _clearCodes();
                  _onPanUpdate(DragUpdateDetails(
                      globalPosition: details.globalPosition));
                },
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails event) {
    RenderBox box = _paintKey.currentContext!.findRenderObject() as RenderBox;
    setState(() => offset = box.globalToLocal(event.globalPosition));
  }

  void _onPanEnd(DragEndDetails event) {
    setState(() => offset = null);
    _confirm();
    print("Generated code: ${codes.join()}"); // Print the confirmation pattern
  }

  void _onSelect(int code) {
    if (!codes.contains(code)) {
      codes.add(code);
    }
  }

  void _clearCodes() {
    setState(() {
      codes = [];
      offset = null;
    });
  }

  void _confirm() async {
    if (codes.join() == widget.initialPattern.join()) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/setpattern'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'pattern': codes.join(),
          'useremail': widget.useremail,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                responseBody['message'] ?? 'Pattern confirmed successfully!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppsScreen()),
        );
      } else {
        setState(() {
          errorMessage =
              responseBody['message'] ?? 'An error occurred. Please try again.';
          _clearCodes();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      setState(() {
        errorMessage = "Patterns do not match! Try again.";
        _clearCodes();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _LockScreenPainter extends CustomPainter {
  final int _total = 9;
  final int _col = 3;
  Size? size;

  final List<int> codes;
  final Offset? offset;
  final Function(int code) onSelect;
  final Animation<double> animation;

  _LockScreenPainter({
    required this.codes,
    required this.offset,
    required this.onSelect,
    required this.animation,
  }) : super(repaint: animation);

  double get _sizeCode => size != null ? size!.width / _col : 0;

  Paint get _painter => Paint()
    ..color = Colors.black
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;

    for (var i = 0; i < _total; i++) {
      var _offset = _getOffsetByIndex(i);
      var _color = _getColorByIndex(i);

      var _radiusIn = _sizeCode / 2.0 * 0.2;
      _drawCircle(canvas, _offset, _radiusIn, _color, true);

      var _pathGesture = _getCirclePath(_offset, _radiusIn);
      if (offset != null && _pathGesture.contains(offset!)) onSelect(i);
    }

    for (var i = 0; i < codes.length; i++) {
      var _start = _getOffsetByIndex(codes[i]);
      if (i + 1 < codes.length) {
        var _end = _getOffsetByIndex(codes[i + 1]);
        _drawLine(canvas, _start, _end);
      } else if (offset != null) {
        var _end = offset!;
        _drawLine(canvas, _start, _end);
      }
    }
  }

  Path _getCirclePath(Offset offset, double radius) {
    var _rect = Rect.fromCircle(radius: radius, center: offset);
    return Path()..addOval(_rect);
  }

  void _drawCircle(Canvas canvas, Offset offset, double radius, Color color,
      [bool isDot = false]) {
    var _path = _getCirclePath(offset, radius);
    var _painter = this._painter
      ..color = color
          .withOpacity(isDot && codes.contains(offset) ? animation.value : 1.0)
      ..style = isDot ? PaintingStyle.fill : PaintingStyle.stroke;
    canvas.drawPath(_path, _painter);
  }

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    var _painter = this._painter
      ..color = Color(0xFF00358C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    var _path = Path();
    _path.moveTo(start.dx, start.dy);
    _path.lineTo(end.dx, end.dy);
    canvas.drawPath(_path, _painter);
  }

  Color _getColorByIndex(int i) {
    return codes.contains(i) ? Color(0xFF00358C) : Colors.black;
  }

  Offset _getOffsetByIndex(int i) {
    var _dxCode = _sizeCode * (i % _col + .5);
    var _dyCode = _sizeCode * ((i / _col).floor() + .5);
    var _offsetCode = Offset(_dxCode, _dyCode);
    return _offsetCode;
  }

  @override
  bool shouldRepaint(_LockScreenPainter oldDelegate) {
    return offset != oldDelegate.offset || codes != oldDelegate.codes;
  }
}

class AppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apps'),
      ),
      body: Center(
        child: Text('Welcome to the Apps Screen!'),
      ),
    );
  }
}
