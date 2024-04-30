import 'package:flutter/material.dart';
import 'package:pocekt_teacher/resources/TransitionData.dart';

class AnimatedVisibility extends StatefulWidget {
  static final defaultEnterTransition = fadeIn();
  static final defualtExitTransition = fadeOut();
  static const defaultEnterDuration = Duration(milliseconds: 500);
  static const defaultExitDuration = defaultEnterDuration;

  AnimatedVisibility({
    super.key,
    this.visible = true,
    this.child = const SizedBox.shrink(),
    EnterTransition? enter,
    ExitTransition? exit,
    Duration? enterDuration,
    Duration? exitDuration,
  })  : enter = enter ?? defaultEnterTransition,
        exit = exit ?? defualtExitTransition,
        enterDuration = enterDuration ?? defaultEnterDuration,
        exitDuration = exitDuration ?? defaultExitDuration;

  final bool visible;
  final Widget child;
  final EnterTransition enter;
  final ExitTransition exit;
  final Duration enterDuration;
  final Duration exitDuration;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: widget.visible ? 1.0 : 0.0,
      duration: widget.enterDuration,
      reverseDuration: widget.exitDuration,
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.visible && widget.visible) {
      _controller.forward();
    } else if (oldWidget.visible && !widget.visible) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: _controller,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, widget.enter.data) ??
            const SizedBox.shrink();
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _build(context, child, animation, widget.exit.data) ??
            const SizedBox.shrink();
      },
      child: Visibility(
        visible: _controller.status != AnimationStatus.dismissed,
        child: widget.child,
      ),
    );
  }
}

Widget? _build(BuildContext context, Widget? child, Animation<double> animation,
    TransitionData data) {
  Widget? animatedChild = child;
  if (data.fade != null) {
    animatedChild = FadeTransition(
      opacity: data.fade!.animation.animate(animation),
      child: animatedChild,
    );
  }

  return animatedChild;
}
