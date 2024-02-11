import 'dart:async';
import 'dart:io';

import 'package:base_station_simulation/gui/rgbo_color.dart';
import 'package:base_station_simulation/gui/text_handler.dart';
import 'package:base_station_simulation/models/channelData.dart';
import 'package:base_station_simulation/models/live_data.dart';
import 'package:base_station_simulation/models/packet.dart';
import 'package:base_station_simulation/gui/channel_widget.dart';
import 'package:base_station_simulation/gui/text_field.dart';
import 'package:base_station_simulation/gui/validator_operations.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

class SimulationWidget extends StatefulWidget {
  const SimulationWidget({super.key});

  @override
  State<SimulationWidget> createState() => _SimulationWidgetState();
}

class _SimulationWidgetState extends State<SimulationWidget> {
  List<String> activitiy_list = List<String>.empty(growable: true);
  List<packet> channelManager = List<packet>.empty(growable: true);
  List<packet> waitQueue = List<packet>.empty(growable: true);
  List<ChannelData> channelstates =
      List.filled(36, ChannelData(state: false, megabyte: 0));
  TextEditingController maxController = TextEditingController();
  TextEditingController pricePerMbController = TextEditingController();
  TextEditingController pricePerMbControllerParisMetro2 =
      TextEditingController();
  TextEditingController pricePerMbControllerParisMetro3 =
      TextEditingController();
  TextEditingController congestionPricePerMbController =
      TextEditingController();
  TextEditingController currentPricePerMbController = TextEditingController();
  TextEditingController shadowPrice2Controller = TextEditingController();
  TextEditingController videoMinController = TextEditingController();
  TextEditingController videoMaxController = TextEditingController();
  TextEditingController audioMinController = TextEditingController();
  TextEditingController audioMaxController = TextEditingController();
  TextEditingController textMinController = TextEditingController();
  TextEditingController textMaxController = TextEditingController();

  int channelUsed = 0;
  int maxChannel = 36;
  double revenue = 0;
  double dataSent = 0;
  double price = 4;
  double currentPrice = 4;
  double parisMetroPrice2 = 8;
  double parisMetroPrice3 = 16;
  double shadowPrice2 = 10;
  double channelUsedBandWidth = 0;
  double congestionPrice = 3;
  double defaultPrice = 1;
  double defaultCongestedPrice = 3;
  double maxBandwidth = 2000;
  double videoData = 0;
  double textData = 0;
  double audioData = 0;
  int videoMin = 100;
  int videoMax = 400;
  int audioMin = 3;
  int audioMax = 10;
  int textMin = 2;
  int textMax = 5;
  bool isPaused = false;
  bool isParisMetro = false;
  double paris2ActivatePercent = 30;
  double paris3ActivatePercent = 60;
  double shadowPriceActivatePercent = 80;
  int currentRuntime = 0;
  late Timer timer1;
  late Timer timer2;
  final ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<File> getFile() async {
    Directory directory = await getApplicationDocumentsDirectory();

    var path = directory.path;
    return File('$path/base_station_data.txt');
  }

  void clearData() {
    processPackets();
    currentRuntime = 0;
    waitQueue.clear();
    videoData = 0;
    audioData = 0;
    textData = 0;
    revenue = 0;
    dataSent = 0;
  }

  void writeData() async {
    try {
      var file = await getFile();
      file.writeAsString(
          "$maxBandwidth\n$price\n$parisMetroPrice2\n$parisMetroPrice3\n$shadowPrice2\n$paris2ActivatePercent\n$paris3ActivatePercent\n$shadowPriceActivatePercent\n$videoMin\n$videoMax\n$audioMin\n$audioMax\n$textMin\n$textMax");
    } catch (e) {}
  }

  void loadData() async {
    try {
      var file = await getFile();
      final contents = await file.readAsLines();

      if (contents.isEmpty) {
        writeData();
      } else {
        maxBandwidth = double.parse(contents[0]);
        price = double.parse(contents[1]);
        parisMetroPrice2 = double.parse(contents[2]);
        parisMetroPrice3 = double.parse(contents[3]);
        shadowPrice2 = double.parse(contents[4]);
        paris2ActivatePercent = double.parse(contents[5]);
        paris3ActivatePercent = double.parse(contents[6]);
        shadowPriceActivatePercent = double.parse(contents[7]);
        videoMin = int.parse(contents[8]);
        videoMax = int.parse(contents[9]);
        audioMin = int.parse(contents[10]);
        audioMax = int.parse(contents[11]);
        textMin = int.parse(contents[12]);
        textMax = int.parse(contents[13]);
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void settings() {
    var dimension = MediaQuery.of(context).size;
    var textScaler = TextHanlder(size: dimension);
    maxController.text = maxBandwidth.toString();
    pricePerMbController.text = defaultPrice.toString();
    pricePerMbControllerParisMetro2.text = parisMetroPrice2.toString();
    pricePerMbControllerParisMetro3.text = parisMetroPrice3.toString();
    videoMaxController.text = videoMax.toString();
    videoMinController.text = videoMin.toString();
    audioMaxController.text = audioMax.toString();
    audioMinController.text = audioMin.toString();
    textMinController.text = textMin.toString();
    textMaxController.text = textMax.toString();
    shadowPrice2Controller.text = shadowPrice2.toString();
    congestionPricePerMbController.text = defaultCongestedPrice.toString();
    currentPricePerMbController.text = defaultPrice.toString();
    pricePerMbController.text = price.toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Text('Change Application Settings'),
                content: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: maxController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Max Bandwidth",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: pricePerMbController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Standard Price Per MB(\$)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: pricePerMbControllerParisMetro2,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Paris Metro 2nd Price Per MB(\$)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: pricePerMbControllerParisMetro3,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Paris Metro 3rd Price Per MB(\$)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: shadowPrice2Controller,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Shadow Price Per MB(\$)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: videoMinController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Minimum Video Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: videoMaxController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Maximum Video Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: audioMinController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Minimum Audio Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: audioMaxController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Maximum Audio Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: textMinController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Minimum Text Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: IconTextField(
                          textHint: "must be numbers only",
                          controller: textMaxController,
                          isSecure: false,
                          inputType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.always,
                          label: "Maximum Text Size(MB)",
                          validatorHandler: ValidatorOperations.isDouble),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Paris Metro Price Active Percent",
                            style:
                                textScaler.color16px500w(RgboColors.grey5())),
                        Slider(
                            label: paris2ActivatePercent.round().toString(),
                            value: paris2ActivatePercent,
                            min: 0,
                            max: 100,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                if (value < paris3ActivatePercent) {
                                  paris2ActivatePercent = value;
                                }
                              });
                            }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Paris Metro Price 2 Active Percent",
                            style:
                                textScaler.color16px500w(RgboColors.grey5())),
                        Slider(
                            label: paris3ActivatePercent.round().toString(),
                            min: 0,
                            max: 100,
                            divisions: 10,
                            value: paris3ActivatePercent,
                            onChanged: (value) {
                              setState(() {
                                if (value > paris2ActivatePercent) {
                                  paris3ActivatePercent = value;
                                }
                              });
                            }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shadow Price Active Percent",
                            style:
                                textScaler.color16px500w(RgboColors.grey5())),
                        Slider(
                            label:
                                shadowPriceActivatePercent.round().toString(),
                            min: 0,
                            max: 100,
                            divisions: 10,
                            value: shadowPriceActivatePercent,
                            onChanged: (value) {
                              setState(() {
                                shadowPriceActivatePercent = value;
                              });
                            }),
                      ],
                    )
                  ]),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Apply'),
                    onPressed: () {
                      double newMax = double.parse(maxController.text);
                      if (newMax > 0) {
                        maxBandwidth = newMax;
                      }
                      double newPrice = double.parse(pricePerMbController.text);
                      if (newPrice > 0) {
                        price = newPrice;
                        currentPrice = price;
                      }
                      double newParisPrice2 =
                          double.parse(pricePerMbControllerParisMetro2.text);
                      if (newParisPrice2 > 0) {
                        parisMetroPrice2 = newParisPrice2;
                      }
                      double newParisPrice3 =
                          double.parse(pricePerMbControllerParisMetro3.text);
                      if (newParisPrice3 > 0) {
                        parisMetroPrice3 = newParisPrice3;
                      }
                      double shadowPrice =
                          double.parse(shadowPrice2Controller.text);
                      if (shadowPrice > 0) {
                        shadowPrice2 = shadowPrice;
                      }

                      int newVideoMin = int.parse(videoMinController.text);
                      if (newVideoMin > 0) {
                        videoMin = newVideoMin;
                      }
                      int newVideoMax = int.parse(videoMaxController.text);
                      if (newVideoMax > 0 && newVideoMax > newVideoMin) {
                        videoMax = newVideoMax;
                      }
                      int newAudioMin = int.parse(audioMinController.text);
                      if (newAudioMin > 0) {
                        audioMin = newAudioMin;
                      }
                      int newAudioMax = int.parse(audioMaxController.text);
                      if (newAudioMax > 0 && newAudioMax > newAudioMin) {
                        audioMax = newAudioMax;
                      }
                      int newTextMin = int.parse(textMinController.text);
                      if (newTextMin > 0) {
                        textMin = newTextMin;
                      }
                      int newTextMax = int.parse(textMaxController.text);
                      if (newTextMax > 0 && newTextMax > newTextMin) {
                        textMax = newTextMax;
                      }
                      clearData();
                      writeData();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
  }

  void startTimer() {
    timer1 = Timer.periodic(const Duration(milliseconds: 600), createPackets);
    timer2 = Timer.periodic(const Duration(seconds: 1), updateDataSource);
  }

  void stopTimer() {
    timer1.cancel();
    timer2.cancel();
  }

  @override
  void initState() {
    chartData = getChartData();
    loadData();
    activitiy_list.add("Simulation started");

    //Timer.periodic(const Duration(seconds: 1), updateData);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  List<LiveData> getChartData() {
    return List<LiveData>.filled(18, LiveData(0, 0), growable: true);
  }

  String convertToDateTime(int time) {
    int hours = (time / 3600).toInt();
    int minutes = ((time / 60)).toInt() % 60;
    int seconds = time % 60;
    String hoursStr = hours.toString();
    String minutesStr = minutes.toString();
    String secondsStr = seconds.toString();
    return "${hoursStr.length == 1 ? "0$hoursStr" : hoursStr}:${minutesStr.length == 1 ? "0$minutesStr" : minutesStr}:${secondsStr.length == 1 ? "0$secondsStr" : secondsStr}";
  }

  int time = 0;
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  void updateDataSource(Timer timer) {
    currentRuntime++;
    chartData.add(LiveData(time++, channelUsedBandWidth));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  void manageQueue() {
    for (int i = 0; i < waitQueue.length; i++) {
      if (waitQueue[i].megabyte + channelUsedBandWidth <= maxBandwidth) {
        channelManager.add(waitQueue[i]);
        channelUsedBandWidth += waitQueue[i].megabyte;
        dataSent += waitQueue[i].megabyte;
        waitQueue.removeAt(i);
        i--;
        activitiy_list.add("packet removed from waiting queue.");
        activitiy_list.add("packet added to processing channel");
      }
    }
  }

  void createPackets(timer) {
    if (channelUsed == maxChannel) {
      processPackets();
    }
    int usedPercentage = ((channelUsed / maxChannel) * 100).round();
    if (isParisMetro) {
      if (usedPercentage < paris2ActivatePercent) {
        currentPrice = price;
      } else if (usedPercentage >= paris2ActivatePercent &&
          usedPercentage < paris3ActivatePercent) {
        currentPrice = parisMetroPrice2;
      } else if (usedPercentage >= paris3ActivatePercent) {
        currentPrice = parisMetroPrice3;
      }
    } else {
      //Shadow Pricing
      if (usedPercentage < shadowPriceActivatePercent) {
        currentPrice = price;
      } else {
        currentPrice = shadowPrice2;
      }
    }
    maintain20ItemsInActivityList();
    if (channelManager.isEmpty && waitQueue.isNotEmpty) {
      manageQueue();
    }
    late String createText;
    setState(() {
      int num = math.Random().nextInt(5) + 1;
      late packet newPacket;
      // audio has a minimum size of 1mb and max of 3 mb
      // text has a minimum of 0.5mb  and a max of 1mb
      // video has a minimum of 100mb to max of 300mb
      int mb = 0;
      if (num == 1) {
        mb = math.Random().nextInt(audioMax - audioMin) + audioMin;
        newPacket = packet(
            packetType: num,
            megabyte: mb,
            disposeTime: 2,
            price: currentPrice,
            queueWaitTime: 3);
        createText = "Audio Data received ${mb}MB";
      } else if (num != 1 && num != 3) {
        mb = math.Random().nextInt(textMax - textMin) + textMin;
        newPacket = packet(
            packetType: 2,
            megabyte: mb,
            disposeTime: 1,
            price: currentPrice,
            queueWaitTime: 5);
        createText = "Text Data received ${mb}MB";
      } else {
        mb = (math.Random().nextInt(videoMax - videoMin) + videoMin);
        newPacket = packet(
            packetType: num,
            megabyte: mb,
            disposeTime: 7,
            price: currentPrice,
            queueWaitTime: 2);
        createText = "Video Data received ${mb}MB";
      }

      if (mb + channelUsedBandWidth > maxBandwidth) {
        //will cause congestion
        createText += "\nCurrent packet received will cause congestion";
        activitiy_list.add(createText);
        createText =
            "Asking user if the packet should be processed at an increase price.";
        activitiy_list.add(createText);
        bool response = math.Random().nextBool();
        if (response) {
          createText = "User agreed to continue processing";
          activitiy_list.add(createText);
          waitQueue.add(newPacket);
        } else {
          createText = "User declined to proceed with processing";
          activitiy_list.add(createText);
        }
      } else {
        bool response = math.Random().nextBool();

        if (currentPrice > price) {
          createText =
              "Current Price is not the standard price, ask user if they want to proceed";
          if (response) {
            createText = "User agreed to continue processing";
            activitiy_list.add(createText);
            activitiy_list.add("Packet added to processing list");
            dataSent += newPacket.megabyte;
            channelUsedBandWidth += newPacket.megabyte;
            channelManager.add(newPacket);
            channelUsed++;
            channelstates[channelUsed - 1] =
                ChannelData(state: true, megabyte: mb);
          } else {
            createText = "User declined to proceed with processing";
          }
        } else {
          activitiy_list.add(createText);
          activitiy_list.add("Packet added to processing list");
          dataSent += newPacket.megabyte;
          channelUsedBandWidth += newPacket.megabyte;
          channelManager.add(newPacket);
          channelUsed++;
          channelstates[channelUsed - 1] =
              ChannelData(state: true, megabyte: mb);
        }
      }
    });
  }

  void processPackets() {
    setState(() {
      for (int i = 0; i < channelManager.length; i++) {
        if (channelManager[i].packetType == 1) {
          audioData += channelManager[i].megabyte;
        } else if (channelManager[i].packetType == 2) {
          textData += channelManager[i].megabyte;
        } else {
          videoData += channelManager[i].megabyte;
        }
        revenue += channelManager[i].megabyte * channelManager[i].price;
      }
      for (int i = 0; i < channelstates.length; i++) {
        channelstates[i] = ChannelData(state: false, megabyte: 0);
      }
      channelManager.clear();
      channelUsed = 0;
      channelUsedBandWidth = 0;
    });
  }

  void maintain20ItemsInActivityList() {
    while (activitiy_list.length > 20) {
      activitiy_list.removeAt(0);
    }
  }

  List<Widget> statusWidgets() {
    return [
      Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.cyanAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Max BandWidth: ${maxBandwidth.toStringAsFixed(2)} MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.purpleAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "BandWidth Used: ${channelUsedBandWidth.toStringAsFixed(2)} MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.amber,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Data Sent: ${dataSent.toStringAsFixed(2)} MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blueAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Channels Used: $channelUsed",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.deepOrangeAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Video Data Sent: ${videoData / 1000}GB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.pinkAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Audio Data Sent: ${(audioData / 1000).toStringAsFixed(2)}GB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.redAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Text Data Sent: ${(textData / 1000).toStringAsFixed(2)}GB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.green,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Revenue: \$${(revenue / 1000000).toStringAsFixed(2)}M",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.lightBlueAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Wait Queue: ${waitQueue.length}",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Current Price: \$${(currentPrice).toStringAsFixed(2)}/MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Standard Price: \$${(price).toStringAsFixed(2)}/MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Paris Metro Price: \$${(parisMetroPrice2).toStringAsFixed(2)}/MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Paris Metro Price 2: \$${(parisMetroPrice3).toStringAsFixed(2)}/MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Shadow Price: \$${(shadowPrice2).toStringAsFixed(2)}/MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Video Packet Min: ${videoMin}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Video Packet Max: ${videoMax}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Audio Packet Min: ${audioMin}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Audio Packet Max: ${audioMax}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Text Packet Min: ${textMin}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.greenAccent,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Text(
          "Text Packet Max: ${textMax}MB",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      body: SizedBox(
        width: 1200,
        height: 700,
        // color: const Color.fromRGBO(30, 30, 30, 0),
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(30, 30, 30, 1),
            child: Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: const Color.fromRGBO(30, 30, 30, 1),
                    width: 600,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.topCenter,
                          width: 600,
                          height: 335,
                          child: SfCartesianChart(
                              series: <LineSeries<LiveData, int>>[
                                LineSeries<LiveData, int>(
                                  onRendererCreated:
                                      (ChartSeriesController controller) {
                                    _chartSeriesController = controller;
                                  },
                                  dataSource: chartData,
                                  color: const Color.fromRGBO(192, 108, 132, 1),
                                  xValueMapper: (LiveData sales, _) =>
                                      sales.time,
                                  yValueMapper: (LiveData sales, _) =>
                                      sales.speed,
                                )
                              ],
                              primaryXAxis: const NumericAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(text: 'Time (seconds)')),
                              primaryYAxis: const NumericAxis(
                                  axisLine: AxisLine(width: 0),
                                  majorTickLines: MajorTickLines(size: 0),
                                  title:
                                      AxisTitle(text: 'Total Data Sent (MB)'))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 600,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Available Channels      Runtime: ${convertToDateTime(currentRuntime)}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(children: [
                                        Text(
                                          isParisMetro
                                              ? "Paris-Metro"
                                              : "Shadow",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Switch(
                                            value: isParisMetro,
                                            onChanged: (value) {
                                              clearData();
                                              setState(() {
                                                isParisMetro = !isParisMetro;
                                                if (isParisMetro) {
                                                  activitiy_list.add(
                                                      "Pricing algorithm changed to Paris-Metro");
                                                } else {
                                                  activitiy_list.add(
                                                      "Pricing algorithm changed to Shadow Pricing");
                                                }
                                                processPackets();
                                                waitQueue.clear();

                                                currentRuntime = 0;
                                                revenue = 0;
                                              });
                                            }),
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 600,
                                height: 240,
                                child: GridView.extent(
                                  maxCrossAxisExtent: 60,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  padding: const EdgeInsets.all(5.0),
                                  children: channelstates.map((item) {
                                    return SizedBox(
                                      width: 60,
                                      height: 25,
                                      child: ChannelWidget(
                                          status: item.state,
                                          text:
                                              "${item.megabyte.toString()}MB"),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    height: 645,
                    width: 260,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Simulation Data",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPaused = !isPaused;
                                      });
                                      if (isPaused) {
                                        stopTimer();
                                      } else {
                                        startTimer();
                                      }
                                    },
                                    icon: Icon(
                                      isPaused ? Icons.play_arrow : Icons.pause,
                                      color: Colors.amber,
                                    )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: 260,
                            height: 560,
                            margin: const EdgeInsets.all(5),
                            child: ListView.builder(
                                itemCount: statusWidgets().length,
                                itemBuilder: (context, index) {
                                  return statusWidgets()[index];
                                })),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    height: 645,
                    width: 260,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Activities",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: IconButton(
                                    onPressed: settings,
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.amber,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 260,
                          height: 560,
                          margin: const EdgeInsets.all(5),
                          child: ListView.builder(
                              itemCount: activitiy_list.length,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Container(
                                    color: (index + 1) % 2 == 0
                                        ? Colors.amber
                                        : Colors.cyanAccent,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(top: 3),
                                    child: Text(activitiy_list[index]));
                              }),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.all(5),
                        //   child: IconTextField(
                        //       textHint: "must be numbers only",
                        //       controller: maxController,
                        //       isSecure: false,
                        //       label: "Max BandWidth",
                        //       inputType: TextInputType.number,
                        //       autovalidateMode: AutovalidateMode.always,
                        //       changedHandler: (value) {
                        //         try {
                        //           double newValue = double.parse(value!);
                        //           if (newValue == 0 || newValue < -1) {
                        //             maxController.text = defaultMax.toString();
                        //             maxBandwidth = defaultMax;
                        //           } else if (newValue > 0) {
                        //             maxBandwidth = double.parse(value);
                        //           } else {
                        //             maxController.text = defaultMax.toString();
                        //           }
                        //         } catch (e) {}
                        //       },
                        //       validatorHandler: ValidatorOperations.isDouble),
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.all(5),
                        //   child: IconTextField(
                        //       textHint: "must be numbers only",
                        //       controller: pricePerMbController,
                        //       isSecure: false,
                        //       isEnabled: false,
                        //       inputType: TextInputType.number,
                        //       autovalidateMode: AutovalidateMode.always,
                        //       label: "Price Per MB(\$)",
                        //       validatorHandler: ValidatorOperations.isDouble),
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.all(5),
                        //   child: IconTextField(
                        //       textHint: "must be numbers only",
                        //       controller: congestionPricePerMbController,
                        //       isSecure: false,
                        //       isEnabled: false,
                        //       inputType: TextInputType.number,
                        //       autovalidateMode: AutovalidateMode.always,
                        //       label: "Congested Price Per MB(\$)",
                        //       validatorHandler: ValidatorOperations.isDouble),
                        // ),
                        // CustomToggle(
                        //     state: isParisMetro,
                        //     function: () {
                        //       setState(() {
                        //         isParisMetro = !isParisMetro;
                        //       });
                        //     }),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
