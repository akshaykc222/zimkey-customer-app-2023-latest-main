import 'package:flutter/material.dart';

class ElasticScrollPhysics extends ScrollPhysics {
  const ElasticScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ElasticScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ElasticScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() >= tolerance.velocity) {
      return ScrollSpringSimulation(spring, position.pixels, position.pixels + velocity * 0.2, velocity, tolerance: tolerance);
    }
    return super.createBallisticSimulation(position, velocity);
  }
}