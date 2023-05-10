import 'package:enfp/global/theme.dart';
import 'package:flutter/material.dart';

class ECard extends StatefulWidget {
  const ECard({
    Key? key,
    this.title,
    this.width,
    this.height,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final String? title;
  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  @override
  State<ECard> createState() => _ECardState();
}

class _ECardState extends State<ECard> {
  Function(TapDownDetails)? onTapDown;
  Function(TapUpDetails)? onTapUp;

  double scale = 1.0;
  double opacity = .0;
  Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    onTapDown = widget.onPressed == null ? null : (_) {
      setState(() {
        scale = .9; opacity = .2;
      });
    };
    onTapUp = widget.onPressed == null ? null : (_) async {
      await Future.delayed(duration, () {
        if (!mounted) return;
        setState(() {
          scale = 1.0; opacity = .0;
        });
      });
      widget.onPressed!();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: Material(
        child: GestureDetector(
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onTapCancel: () => setState(() => scale = 1.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: widget.width,
              height: widget.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                  Column(
                    children: [
                      Text(widget.title!,
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ), widget.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
