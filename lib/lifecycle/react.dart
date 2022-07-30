part of 'lifecycle.dart';

///
/// Widget para observar as mudanças dos LiveData
///
class React extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  const React(this.builder, {Key? key}) : super(key: key);

  @override
  State<React> createState() => _ReactState();
}

class _ReactState extends State<React> implements Observer {
  late ObserverController<Widget, BuildContext> _controller;

  @override
  void onChange() => setState(() {});

  @override
  void initState() {
    _controller = ObserverController<Widget, BuildContext>(
      widget.builder,
      this,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant React oldWidget) {
    if (oldWidget.builder != widget.builder) {
      _controller.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _controller.get(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ObserverController>('controller', _controller),
    );
    _controller.debugFillProperties(properties);
  }
}
