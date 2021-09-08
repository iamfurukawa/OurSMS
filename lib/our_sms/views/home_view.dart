import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:oursms/our_sms/components/timeline_step_process.dart';
import 'package:oursms/our_sms/services/our_sms_service.dart';
import 'package:oursms/routes/routes.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OurSMSService>(context);

    var ActionButton = Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: ElevatedButton(
        style: provider.isRunning
            ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(209, 66, 66, 1)))
            : ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(82, 127, 243, 1))),
        onPressed: provider.getCellphoneNumber == null || provider.getCellphoneNumber == ""
            ? null
            : () {
                if (provider.isRunning) {
                  provider.stopRunning();
                } else {
                  provider.startRunning();
                }
              },
        child: provider.isRunning
            ? Text(
                "Stop",
                style: TextStyle(fontSize: 18),
              )
            : Text(
                "Restart",
                style: TextStyle(fontSize: 18),
              ),
      ),
    );

    var boxDecoration = BoxDecoration(
      border: Border.all(
        color: Colors.pink,
        width: 1,
      ),
      color: Colors.pink,
      borderRadius: BorderRadius.circular(5),
    );

    var filterSection = Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 5,
        spacing: 5,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: boxDecoration,
            child: Text(
              [
                "Phone: ",
                provider.getCellphoneNumberFilter == null || provider.getCellphoneNumberFilter == ""
                    ? "not applied."
                    : provider.getCellphoneNumberFilter,
              ].join(""),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            decoration: boxDecoration,
            child: Text(
              [
                "Text: ",
                provider.getTextFilter == null || provider.getTextFilter == "" ? "not applied." : provider.getTextFilter
              ].join(""),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    var CardHeader = Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Cellphone Number",
                ),
                keyboardType: TextInputType.phone,
                autocorrect: false,
                inputFormatters: [MaskedInputFormatter('(##)#####-####')],
                initialValue: provider.getCellphoneNumber,
                onFieldSubmitted: (value) {
                  provider.setCellphoneNumber = value;
                  final snackBar = SnackBar(content: Text('Phone number was saved.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              SizedBox(height: 10),
              filterSection,
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("OurSMS"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.CONFIGURATION);
        },
        child: const Icon(Icons.settings),
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardHeader,
              TimelineStepProgress(data: provider.status),
              ActionButton,
            ],
          ),
        ),
      ),
    );
  }
}
