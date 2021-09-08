import 'package:flutter/material.dart';
import 'package:oursms/our_sms/services/our_sms_service.dart';
import 'package:provider/provider.dart';

class ConfigurationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuration"),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    var provider = Provider.of<OurSMSService>(context);

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Filter by phone number",
            ),
            keyboardType: TextInputType.phone,
            autocorrect: false,
            initialValue: provider.getCellphoneNumberFilter,
            onFieldSubmitted: (value) {
              provider.setCellphoneNumberFilter = value;
              final snackBar = SnackBar(content: Text('Filter by phone number was saved.'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Filter by contains text",
            ),
            initialValue: provider.getTextFilter,
            onFieldSubmitted: (value) {
              provider.setTextFilter = value;
              final snackBar = SnackBar(content: Text('Filter by text was saved.'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }
}
