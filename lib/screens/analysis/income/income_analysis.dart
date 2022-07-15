import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/db/transaction/transaction_db.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../model/analysis/analysis_model.dart';
import '../../../model/transaction/transaction_model.dart';
import '../../transaction/transaction_screen.dart';

class IncomeAnalysis extends StatelessWidget {
  const IncomeAnalysis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
        valueListenable: TransactionScreen.selectedDropDownValue,
        builder: (BuildContext context, int? selectedDropDownValue, Widget? _) {
          return ValueListenableBuilder(
              valueListenable: selectedDropDownValue == 0
                  ? TransactionDb().incomeTransactionsListNotifer
                  : selectedDropDownValue == 1
                      ? TransactionDb().incomeTransactionsMontlyListNotifier
                      : selectedDropDownValue == 2
                          ? TransactionDb
                              .instance.incomeTransactionsYearlyListNotifier
                          : TransactionDb().incomeTransactionsListNotifer,
              builder: (BuildContext context, List<TransactionModel>? newlist,
                  Widget? _) {
                return newlist!.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/no_data.gif',
                            height: deviceHeight * 0.38,
                          ),
                          const Text(
                            'No Income Transaction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Prompt',
                            ),
                          ),
                        ],
                      )
                    : SfCircularChart(
                        legend: Legend(
                            overflowMode: LegendItemOverflowMode.scroll,
                            iconBorderWidth: 10,
                            isVisible: true,
                            toggleSeriesVisibility: true,
                            position: LegendPosition.top,
                            alignment: ChartAlignment.near,
                            iconWidth: 10,
                            isResponsive: true,
                            orientation: LegendItemOrientation.horizontal,
                            width: '${deviceWidth / 0.91}'.toString(),
                            padding: 10,
                            itemPadding: 7,
                            textStyle: const TextStyle(fontSize: 15)
                            // shouldAlwaysShowScrollbar: ,
                            ),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                        ),
                        series: <CircularSeries>[
                          DoughnutSeries<GDPdataModel, String>(
                            enableTooltip: false,
                            explode: true,
                            groupMode: CircularChartGroupMode.value,
                            radius: '${deviceWidth / 3.5}'.toString(),
                            legendIconType: LegendIconType.circle,
                            dataSource: CategoryDB().pieDataListIncome(newlist),
                            xValueMapper: (GDPdataModel data, _) =>
                                data.categoryName,
                            yValueMapper: (GDPdataModel data, _) =>
                                data.totalamount,
                            dataLabelMapper: (GDPdataModel data, _) =>
                                '${data.categoryName} ${data.totalamount / 100}%',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              // Avoid labels intersection
                              labelPosition: ChartDataLabelPosition.outside,
                              showZeroValue: false,
                              showCumulativeValues: true,
                              useSeriesColor: true,
                              connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.line,
                                length: '10%',
                              ),
                            ),
                          ),
                        ],
                      );
              });
        });
  }
}
