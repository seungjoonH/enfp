import 'dart:math';

import 'package:camera/camera.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/util/classifier.dart';
import 'package:enfp/util/handler.dart';
import 'package:enfp/util/isolate.dart';
import 'package:enfp/util/painter.dart';
import 'package:flutter/material.dart';

// 카메라 방향 (전면/후면)
enum CameraDirection {
  front, back;
  get opposite => values[1 - index];
}

// 사용가능한 카메라 리스트
List<CameraDescription>? descriptions;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // 카메라 컨트롤러
  late CameraController _cameraController;
  // 카메라 방향
  CameraDirection direction = CameraDirection.front;
  // 카메라 줌 초깃값
  double initZoom = .0;
  // 카메라 줌
  double zoom = 1.0;
  // Classifier
  late Classifier _classifier;
  // Isolate
  late IsolateUtils _isolate;
  // Inferences
  Map<Part, Inference>? inferences;

  // Painter
  late LimbPainter _painter;
  // 예상값 측정 컨트롤 변수
  bool doPredict = true;

  // 캔버스 크기
  Size? canvasSize;
  // 가로 비율
  double _widthRatio = 1.0;
  // 세로 비율
  double _heightRatio = 1.0;

  @override
  void initState() {
    super.initState();
    // 비동기 함수 호출
    initAsync();
  }

  void initAsync() async {
    // 카메라 컨트롤러 초기화
    _cameraController = CameraController(
      descriptions![direction.index],
      ResolutionPreset.medium,
    );

    // isolate 선언/실행
    _isolate = IsolateUtils();
    await _isolate.start();

    // classifier 선언/실행
    _classifier = Classifier();
    _classifier.loadModel();

    // 카메라 컨트롤러 초기화
    await _cameraController.initialize();

    // 이미지 스트리밍 시작
    await _cameraController.startImageStream(createIsolate);
    doPredict = true;

    // Handler 초기화
    ExerciseHandler.init();

    setState(() {});
  }

  // 카메라 방향 전환
  void toggleCameraDirection() {
    doPredict = false;
    direction = direction.opposite;
    initAsync();
  }

  void createIsolate(CameraImage imageStream) async {
    // flag 값에 따른 함수 실행 제어
    if (!doPredict) return;
    doPredict = false;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: _classifier.interpreter.address,
    );

    // 추정치 반환
    List inferenceList = await _isolate.inference(isolateData);
    // 처리하기 편한 방향으로 변경
    inferences = {
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i] : Inference.list(inferenceList[i])
          ..adjustRatio(_widthRatio, _heightRatio)
    };

    if (!mounted) return;
    _widthRatio = canvasSize!.width / imageStream.width;
    _heightRatio = canvasSize!.height / imageStream.height;

    doPredict = true;
    _painter = LimbPainter(inferences: inferences!);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    // 카메라 컨트롤러 dispose
    _cameraController.dispose();
  }

  // 카메라 줌 레벨 설정
  Future setZoomLevel(ScaleUpdateDetails details) async {
    // 줌 범위 (1.0 ~ 189.0)
    zoom = max(1.0, min(details.scale * initZoom, 189.0));
    await _cameraController.setZoomLevel(zoom);
  }

  @override
  Widget build(BuildContext context) {
    canvasSize = MediaQuery.of(context).size;
    canvasSize = Size(canvasSize!.width, canvasSize!.height * .7);
    if (inferences == null) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        actions: [
          // 카메라 전환 버튼
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: toggleCameraDirection,
          ),
        ],
      ),
      // 줌인/줌아웃 제스쳐 감지 위젯
      body: SizedBox(
        width: canvasSize!.width,
        height: canvasSize!.height,
        child: GestureDetector(
          onScaleStart: (_) => initZoom = zoom,
          onScaleUpdate: setZoomLevel,
          child: CustomPaint(
            // 카메라 위 Painter 장착
            foregroundPainter: _painter,
            child: CameraPreview(_cameraController),
          ),
        ),
      ),
    );
  }
}