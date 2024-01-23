import 'dart:async';

import 'package:base_station_simulation/functions/live_data.dart';
import 'package:base_station_simulation/functions/packet.dart';
import 'package:base_station_simulation/gui/app_config_provider.dart';
import 'package:base_station_simulation/gui/channel_widget.dart';
import 'package:base_station_simulation/gui/custom_toggle.dart';
import 'package:base_station_simulation/gui/text_field.dart';
import 'package:base_station_simulation/gui/validator_operations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

class SimulationWidget extends StatefulWidget {
  const SimulationWidget({super.key});

  @override
  State<SimulationWidget> createState() => _SimulationWidgetState();
}

class _SimulationWidgetState extends State<SimulationWidget> {
  List<packet> packetManager = List<packet>.empty(growable: true);
  List<packet> waitQueue = List<packet>.empty(growable: true);
  List<bool> channelstates = List.filled(36, false);
  TextEditingController maxController = TextEditingController();
  TextEditingController pricePerMbController = TextEditingController();
  TextEditingController congestionPricePerMbController =
      TextEditingController();
  TextEditingController currentPricePerMbController = TextEditingController();
  double revenue = 0;
  double bandwidth = 0;
  double congestedData = 0;
  double price = 1;
  double currentPrice = 0;
  double congestionPrice = 3;
  double defaultMax = 20000000;
  double defaultPrice = 1;
  double defaultCongestedPrice = 3;
  double maxBandwidth = 20000000;
  double videoData = 0;
  double textData = 0;
  double audioData = 0;
  bool isCongested = false;
  bool isParisMetro = false;
  @override
  void initState() {
    chartData = getChartData();
    maxController.text = defaultMax.toString();
    pricePerMbController.text = defaultPrice.toString();
    congestionPricePerMbController.text = defaultCongestedPrice.toString();
    currentPricePerMbController.text = defaultPrice.toString();
    Timer.periodic(const Duration(seconds: 1), updateData);
    Timer.periodic(const Duration(milliseconds: 50), createPackets);
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    Timer.periodic(const Duration(seconds: 1), manageQueue);
    super.initState();
  }

  List<LiveData> getChartData() {
    return List<LiveData>.filled(18, LiveData(0, 0), growable: true);
  }

  int time = 19;
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, bandwidth));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  void createPackets(timer) {
    setState(() {
      int num = 1 + math.Random().nextInt(3) + 1;
      late packet newPacket;
      // audio has a minimum size of 1mb and max of 3 mb
      // text has a minimum of 0.5mb  and a max of 1mb
      // video has a minimum of 100mb to max of 300mb
      double mb = 0;
      if (num == 1) {
        mb = math.Random().nextInt(1) + 10;
        newPacket = packet(
            packetType: num,
            megabyte: mb,
            disposeTime: 2,
            price: price,
            queueWaitTime: 3);
      } else if (num == 2) {
        mb = math.Random().nextDouble() * 1.5;
        newPacket = packet(
            packetType: num,
            megabyte: mb,
            disposeTime: 1,
            price: price,
            queueWaitTime: 5);
      } else {
        mb = math.Random().nextInt(300) * 700;
        newPacket = packet(
            packetType: num,
            megabyte: mb,
            disposeTime: 7,
            price: price,
            queueWaitTime: 2);
      }
      if (isCongested) {
        //Handle pricing
        congestedData += mb;
        double usedPercentage = (bandwidth / maxBandwidth);
        bool response = math.Random().nextBool();
        if (isParisMetro) {
          if (usedPercentage > 30) {
            price = congestionPrice;
          } else {
            price = defaultPrice;
          }
          if (response) {
            newPacket.price = price;
            waitQueue.add(newPacket);
          }
        } else {
          //Shadow Pricing
          if (usedPercentage > 80) {
            price = congestionPrice;
          } else {
            price = defaultPrice;
          }
          if (response) {
            newPacket.price = price;
            waitQueue.add(newPacket);
          }
        }
      } else {
        bandwidth += mb;
        price = defaultPrice;
        newPacket.price = defaultPrice;
        if (waitQueue.isNotEmpty) {
          waitQueue.add(newPacket);
        } else {
          packetManager.add(newPacket);
        }
      }
    });
  }

  void manageQueue(timer) {
    for (int i = 0; i < waitQueue.length; i++) {
      if (waitQueue[i].megabyte + bandwidth <= maxBandwidth) {
        packetManager.add(waitQueue[i]);
        bandwidth += waitQueue[i].megabyte;
        waitQueue.removeAt(i);
      } else {
        waitQueue[i].queueWaitTime -= 1;
        if (waitQueue[i].queueWaitTime == 0) {
          waitQueue.removeAt(i);
        }
      }
    }
  }

  void updateData(timer) {
    setState(() {
      for (int i = 0; i < packetManager.length; i++) {
        if (packetManager[i].disposeTime == 0) {
          bandwidth = (bandwidth - packetManager[i].megabyte);
          if (packetManager[i].packetType == 1) {
            audioData += packetManager[i].megabyte;
          } else if (packetManager[i].packetType == 2) {
            textData += packetManager[i].megabyte;
          } else {
            videoData += packetManager[i].megabyte;
          }
          revenue += packetManager[i].megabyte * packetManager[i].price;
          packetManager.removeAt(i);
        } else {
          packetManager[i].disposeTime = packetManager[i].disposeTime - 1;
        }
      }
      double percent = (bandwidth / maxBandwidth);
      int used = (percent * 36).toInt();
      if (isParisMetro) {
        if (percent * 100 > 30) {
          isCongested = true;
          price = congestionPrice;
        } else {
          isCongested = false;
          price = defaultPrice;
        }
      } else {
        if (percent * 100 > 80) {
          isCongested = true;
          price = congestionPrice;
        } else {
          isCongested = false;
          price = defaultPrice;
        }
      }

      currentPrice = price;
      for (int i = 0; i < 36; i++) {
        if (i < used) {
          channelstates[i] = true;
        } else {
          channelstates[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 36; i++) {}
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
                                  title: AxisTitle(
                                      text: 'BandWidth Used (MBps)'))),
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
                                child: Text(
                                  "Available Channels(${isCongested ? "Network Congested" : "Not Congested"})",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
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
                                      child: ChannelWidget(status: item),
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
                          child: const Text(
                            "Simulation Data",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                            "Used BandWidth: ${bandwidth.toStringAsFixed(2)} MBps",
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
                            "Available: ${(maxBandwidth - bandwidth).toStringAsFixed(2)} MBps",
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
                            "Used Percentage Used: ${((bandwidth / maxBandwidth) * 100).round()}%",
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
                            "Video Data Sent: ${videoData / 1000000}TB",
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
                          child: const Text(
                            "Control Data",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: IconTextField(
                              textHint: "must be numbers only",
                              controller: maxController,
                              isSecure: false,
                              label: "Max BandWidth",
                              inputType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.always,
                              changedHandler: (value) {
                                try {
                                  double newValue = double.parse(value!);
                                  if (newValue == 0 || newValue < -1) {
                                    maxController.text = defaultMax.toString();
                                    maxBandwidth = defaultMax;
                                  } else if (newValue > 0) {
                                    maxBandwidth = double.parse(value);
                                  } else {
                                    maxController.text = defaultMax.toString();
                                  }
                                } catch (e) {}
                              },
                              validatorHandler: ValidatorOperations.isDouble),
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
                            "Current Price: \$${(currentPrice).toStringAsFixed(2)}/MBps",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: IconTextField(
                              textHint: "must be numbers only",
                              controller: pricePerMbController,
                              isSecure: false,
                              isEnabled: false,
                              inputType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.always,
                              label: "Price Per MB(\$)",
                              validatorHandler: ValidatorOperations.isDouble),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: IconTextField(
                              textHint: "must be numbers only",
                              controller: congestionPricePerMbController,
                              isSecure: false,
                              isEnabled: false,
                              inputType: TextInputType.number,
                              autovalidateMode: AutovalidateMode.always,
                              label: "Congested Price Per MB(\$)",
                              validatorHandler: ValidatorOperations.isDouble),
                        ),
                        CustomToggle(
                            state: isParisMetro,
                            function: () {
                              setState(() {
                                isParisMetro = !isParisMetro;
                              });
                            }),
                        Text(
                          isParisMetro ? "Paris-Metro" : "Shadow",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
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
