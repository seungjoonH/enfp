import 'package:camera/camera.dart';
import 'package:enfp/global/theme.dart';
import 'package:enfp/model/class/painter/inference.dart';
import 'package:enfp/model/enum/part.dart';
import 'package:enfp/presenter/page/camera.dart';
import 'package:enfp/util/handler.dart';
import 'package:enfp/util/isolate.dart';
import 'package:enfp/util/painter.dart';
import 'package:enfp/view/widget/scale_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  bool doPredict = false;
  double widthRatio = 1.0;
  double heightRatio = 1.0;

  Map<Part, Inference>? inferences;
  late ExerciseHandler handler;

  late LimbPainter painter;
  int frameCount = 0;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    super.dispose();

    final cameraP = Get.find<CameraP>();
    cameraP.init();
    cameraP.cameraController!.dispose();
  }

  void initAsync() async {
    final cameraP = Get.find<CameraP>();
    await cameraP.init();
    await cameraP.cameraController!
        .startImageStream(createIsolate);
    ExerciseHandler.squat();
    setState(() {});
  }

  void createIsolate(CameraImage imageStream) async {
    final cameraP = Get.find<CameraP>();

    if (doPredict) return;
    doPredict = true;

    IsolateData isolateData = IsolateData(
      cameraImage: imageStream,
      interpreterAddress: CameraP.classifier.interpreter.address,
      orientation: CameraP.orientation!,
    );

    List inferenceList = await CameraP
        .isolate.inference(isolateData);

    CameraP.presetSize = Size(
      imageStream.width.toDouble(),
      imageStream.height.toDouble(),
    );

    if (CameraP.canvasSize != null) {
      widthRatio = CameraP.canvasSize!.width / CameraP.presetSize!.width;
      heightRatio = CameraP.canvasSize!.height / CameraP.presetSize!.height;
    }

    inferences = {
      for (int i = 0; i < inferenceList.length; i++)
        Part.values[i]: Inference.list(inferenceList[i])
          ..adjustRatio(widthRatio, heightRatio)
    };

    Inference.saveHistory(inferences!);
    cameraP.staging();

    if (!mounted) return;

    doPredict = false;
    ExerciseHandler.checkLimbs(Inference.refinedInferences);

    painter = LimbPainter(
      inferences: Inference.refinedInferences,
      limbs: ExerciseHandler.limbs,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (inferences == null) return const Scaffold();

    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: Get.back,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: GetBuilder<CameraP>(
            builder: (cameraP) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: CameraP.horizontalError, right: CameraP.horizontalError,
                      top: CameraP.verticalError, bottom: CameraP.verticalError,
                      child: CameraPainterView(painter: painter),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          CameraP.screenSize!.width * .05, 80.0,
                          CameraP.screenSize!.width * .05, 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FloatingMessageWidget(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ScoreBoxWidget(
                                  score: cameraP.score,
                                  onPressed: cameraP.submitButtonPressed,
                                  pressable: true,
                                ),
                                CameraToggleButton(initAsync: initAsync),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CameraPainterView extends StatelessWidget {
  const CameraPainterView({
    Key? key,
    required this.painter,
  }) : super(key: key);

  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return GestureDetector(
          onScaleStart: (details) => cameraP.setInitZoom(),
          onScaleUpdate: cameraP.setZoomLevel,
          child: CustomPaint(
            foregroundPainter: painter,
            child: CameraPreview(
              cameraP.cameraController!,
            ),
          ),
        );
      },
    );
  }
}


class FloatingMessageWidget extends StatelessWidget {
  const FloatingMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    EdgeInsets padding = EdgeInsets.all(screenSize.width * .05);

    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return Container(
          width: double.infinity,
          height: 110.0,
          padding: padding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(.6),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cameraP.message,
                style: textTheme.headlineSmall,
              ),
              Text(
                cameraP.postureMessage,
                style: textTheme.headlineSmall?.copyWith(
                  color: cameraP.posture.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScoreBoxWidget extends StatefulWidget {
  const ScoreBoxWidget({
    Key? key,
    required this.score,
    this.onPressed,
    this.pressable = false,
  }) : super(key: key);

  final int score;
  final VoidCallback? onPressed;
  final bool pressable;

  @override
  State<ScoreBoxWidget> createState() => _ScoreBoxWidgetState();
}

class _ScoreBoxWidgetState extends State<ScoreBoxWidget> {

  @override
  void didUpdateWidget(covariant ScoreBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleWidget(
      onPressed: widget.onPressed,
      child: Container(
        width: 120.0, height: 80.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            '${widget.score}',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

class CameraToggleButton extends StatelessWidget {
  const CameraToggleButton({
    Key? key,
    required this.initAsync,
  }) : super(key: key);

  final VoidCallback initAsync;

  void onPressed() {
    final cameraP = Get.find<CameraP>();
    cameraP.toggleDirection();
    initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraP>(
      builder: (cameraP) {
        return ScaleWidget(
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Material(
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(.6),
                borderRadius: BorderRadius.circular(40.0),
                child: const SizedBox(width: 80.0, height: 80.0),
              ),
              Icon(
                Icons.cameraswitch_rounded, size: 40.0,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        );
      }
    );
  }
}
