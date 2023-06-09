import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:enfp/util/classifier.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateData {
  late CameraImage cameraImage;
  late int interpreterAddress;
  late Orientation orientation;
  SendPort? responsePort;

  IsolateData({
    required this.cameraImage,
    required this.interpreterAddress,
    required this.orientation,
    this.responsePort,
  });
}

class IsolateUtils {
  static const String debugName = 'InferenceIsolate';

  late Isolate isolate;
  SendPort? sendPort;
  ReceivePort receivePort = ReceivePort();

  Future start() async {
    isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      receivePort.sendPort,
      debugName: debugName,
    );
    sendPort = await receivePort.first;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      Classifier classifier = Classifier(
        Interpreter.fromAddress(isolateData.interpreterAddress),
      );
      classifier.performOperations(isolateData.cameraImage);
      classifier.runModel();
      List<dynamic> results = classifier.parseLandmarkData(isolateData);
      isolateData.responsePort!.send(results);
    }
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    if (sendPort == null) return [];
    sendPort!.send(isolateData..responsePort = responsePort.sendPort);
    return await responsePort.first;
  }
}