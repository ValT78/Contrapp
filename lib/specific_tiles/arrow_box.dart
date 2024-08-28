
import 'package:contrapp/main.dart';
import 'package:flutter/material.dart';

class ArrowBox extends StatefulWidget {
  final int index;
  final double width;
  final double height;
  final double overlapFactor;
  final String texte;
  final String link;

  const ArrowBox({super.key, required this.index, required this.width, required this.height, required this.overlapFactor, required this.texte, required this.link});

  @override
  ArrowBoxState createState() => ArrowBoxState();
}


class ArrowBoxState extends State<ArrowBox> with RouteAware {
  bool _hovering = false;
  bool _isActivePage = false;

  ArrowBoxState();

@override
Widget build(BuildContext context) {
  Color? color = Colors.blue[(widget.index) * 200 + 100];
    double widthFactor = (1 + (MediaQuery.of(context).size.width - 1920) / 1920 / 0.8);
 return MouseRegion(
      onHover: (event) => setState(() => _hovering = true),
      onExit: (event) => setState(() => _hovering = false),
      child: Stack(
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  color = const Color.fromARGB(255, 10, 46, 74);
                  Navigator.pushNamed(context, '/${widget.link}');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  transform: Matrix4.translationValues(_hovering ? -20 : 0, 0, 0),
                  child: Ink.image(
                    image: const AssetImage('assets/arrow.png'),
                    colorFilter: ColorFilter.mode(color!, BlendMode.modulate),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB((widget.width+50) * (1-widget.overlapFactor), 0, 0, 0),
                    child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: widget.width/10,
                      backgroundColor: _isActivePage ? const Color.fromARGB(255, 122, 184, 255) : Colors.white,
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 40 * widthFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(
                      widget.texte, 
                      style: TextStyle(color: const Color.fromRGBO(0, 0, 0, 1), 
                        fontSize: 28 * widthFactor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
}

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _checkActivePage();
  }

  @override
  void didPopNext() {
    _checkActivePage();
  }

  void _checkActivePage() {
    final isActive = ModalRoute.of(context)!.settings.name == '/${widget.link}';
    setState(() => _isActivePage = isActive);
  }
  
}