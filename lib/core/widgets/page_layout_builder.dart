import 'package:flutter/material.dart';

class PageLayoutBuilder extends StatelessWidget {
  final Widget child;
  final bool withPadding;

  const PageLayoutBuilder({
    super.key,
    required this.child,
    this.withPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            )),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(DateTime.now()),
        child: Padding(
          padding: withPadding ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}