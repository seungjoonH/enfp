import 'package:enfp/global/theme.dart';
import 'package:enfp/view/widget/scale_widget.dart';
import 'package:flutter/material.dart';

class ECard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ScaleWidget(
      onPressed: onPressed,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: width,
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
              Column(
                children: [
                  Text(title!,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ), child,
            ],
          ),
        ),
      ),
    );
  }
}
