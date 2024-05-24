import 'package:flutter/material.dart';

class TransitionData {
  final Fade? fade;

  const TransitionData({
    this.fade,
  });
}

class Fade {
  final Animatable<double> animation;
  const Fade(this.animation);
}

abstract class EnterTransition {
  TransitionData get data;
  EnterTransition operator +(EnterTransition enter) {
    return EnterTransitionImpl(
      TransitionData(
        fade: data.fade ?? enter.data.fade,
      ),
    );
  }
}

class EnterTransitionImpl extends EnterTransition {
  @override
  final TransitionData data;
  EnterTransitionImpl(this.data);
}

abstract class ExitTransition {
  TransitionData get data;

  ExitTransition operator +(ExitTransition exit) {
    return ExitTransitionImpl(
      TransitionData(
        fade: data.fade ?? exit.data.fade,
      ),
    );
  }
}

class ExitTransitionImpl extends ExitTransition {
  @override
  final TransitionData data;
  ExitTransitionImpl(this.data);
}

EnterTransition fadeIn({
  double initialAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeInTransition = Tween<double>(
    begin: initialAlpha,
    end: 1.0,
  ).chain(CurveTween(curve: curve));

  return EnterTransitionImpl(
    TransitionData(fade: Fade(fadeInTransition)),
  );
}

ExitTransition fadeOut({
  double targetAlpha = 0.0,
  Curve curve = Curves.linear,
}) {
  final Animatable<double> fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: targetAlpha,
  ).chain(CurveTween(curve: curve));

  return ExitTransitionImpl(
    TransitionData(fade: Fade(fadeOutTransition)),
  );
}
