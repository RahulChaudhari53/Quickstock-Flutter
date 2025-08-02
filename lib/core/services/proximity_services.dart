import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  // A ValueNotifier is a simple, lightweight way to broadcast state changes.
  // Our UI will listen to this notifier.
  final ValueNotifier<bool> isNearNotifier = ValueNotifier(false);

  late final StreamSubscription<dynamic> _streamSubscription;
  Timer? _debounce;

  // This method will be called once when the app starts.
  void init() {
    debugPrint("[ProximityService] Initializing...");
    _streamSubscription = ProximitySensor.events.listen((int event) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();

      _debounce = Timer(const Duration(milliseconds: 250), () {
        final bool newState = (event == 1);
        // Only notify listeners if the state has actually changed.
        if (newState != isNearNotifier.value) {
          debugPrint(
            "[ProximityService] Debounced event: $event. Notifying listeners.",
          );
          isNearNotifier.value = newState;
          HapticFeedback.lightImpact();
        }
      });
    });
  }

  // This should be called if the app is ever completely disposed.
  void dispose() {
    debugPrint("[ProximityService] Disposing...");
    _streamSubscription.cancel();
    _debounce?.cancel();
    isNearNotifier.dispose();
  }
}
