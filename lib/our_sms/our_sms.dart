import 'package:flutter/material.dart';
import 'package:oursms/our_sms/services/our_sms_service.dart';
import 'package:oursms/our_sms/views/configuration_view.dart';
import 'package:oursms/our_sms/views/home_view.dart';
import 'package:oursms/routes/routes.dart';
import 'package:provider/provider.dart';

class OurSMS extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OurSMSService()),
      ],
      child: MaterialApp(
        title: 'OurSMS',
        routes: <String, WidgetBuilder>{
          Routes.HOME: (_) => HomeView(),
          Routes.CONFIGURATION: (_) => ConfigurationView(),
        },
        theme: ThemeData.light().copyWith(
          primaryColor: Color.fromRGBO(243, 51, 201, 1),
        ),
      ),
    );
  }
}
