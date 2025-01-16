// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';

typedef CameraCallback = void Function(dynamic result);

// Non exported class
class CameraChannel {
  static final _onSurfaceCreatedEmitter = StreamController.broadcast();
  static Stream<dynamic> get onSurfaceCreatedEvents =>
      _onSurfaceCreatedEmitter.stream;
  static final Map<int, dynamic> callbacks = <int, CameraCallback>{};

  static final MethodChannel channel = const MethodChannel(
    'flutter.plugins.io/rtmp_publisher',
  )..setMethodCallHandler(
      (MethodCall call) async {
        if (call.method == 'handleCallback') {
          final int? handle = call.arguments['handle'];
          if (callbacks[handle] != null) callbacks[handle](call.arguments);
        } else if (call.method == "onSurfaceCreated") {
          _onSurfaceCreatedEmitter.add(0);
        }
      },
    );

  static int nextHandle = 0;

  static void registerCallback(int handle, CameraCallback callback) {
    assert(!callbacks.containsKey(handle));
    callbacks[handle] = callback;
  }

  static void unregisterCallback(int handle) {
    callbacks.remove(handle);
  }
}
