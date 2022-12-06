import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/image_utils.dart';
import 'package:flutter_weather_bg_null_safety/utils/print_utils.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String key = "ef3fe5a5442e2d0a4104dc0b12ea57b7";
  Weather? weather;
  WeatherFactory? wf;
  String? cityName;
  WeatherType? weatherType;
  List<Weather> forecast = <Weather>[];
  List<String> icons = <String>[];

  @override
  initState() {
    super.initState();

    wf = WeatherFactory(key);
    cityName = "Barcelona";

    _loadRegularData();
    _loadForecastData();
  }

  Future<void> _loadRegularData() async {
    weather = await wf!.currentWeatherByCityName(cityName!);
    switch (weather!.weatherMain!) {
      case "Rain":
        weatherType = WeatherType.heavyRainy;
        break;
      case "Clear":
        weatherType = WeatherType.sunny;
        break;
      case "Thunderstorm":
        weatherType = WeatherType.thunder;
        break;
      case "Snow":
        weatherType = WeatherType.heavySnow;
        break;
      case "Drizzle":
        weatherType = WeatherType.lightRainy;
        break;
      case "Clouds":
        weatherType = WeatherType.cloudy;
        break;
      default:
        weatherType = WeatherType.sunny;
        break;
    }
    setState(() {});
  }

  Future<void> _loadForecastData() async {
    forecast = await wf!.fiveDayForecastByCityName(cityName!);
    icons = <String>[];

    for (int i = 0; i < forecast.length; i++) {
      switch (forecast[i].weatherMain!) {
        case "Rain":
          icons.add("🌧");
          break;
        case "Clear":
          icons.add("☀");
          break;
        case "Thunderstorm":
          icons.add("⛈");
          break;
        case "Snow":
          icons.add("❄");
          break;
        case "Drizzle":
          icons.add("🌦");
          break;
        case "Clouds":
          icons.add("☁");
          break;
        default:
          break;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WeatherBg(
              weatherType: weatherType ?? WeatherType.sunny,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height),
          SingleChildScrollView(
            child: weather == null
                ? SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 80),
                      Text(cityName!,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline2,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          )),
                      Text('${weather!.temperature.toString().substring(0, 4)}º',
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 60,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(
                        weather!.weatherDescription!,
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.headline2,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Max. ${weather!.tempMax.toString().substring(0, 4)}º",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline2,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(width: 12),
                          Text("Min. ${weather!.tempMin.toString().substring(0, 4)}º",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline2,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ))
                        ],
                      ),
                      SizedBox(height: 12),
                      ListView.builder(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: forecast.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 50,
                              color: Colors.white.withOpacity(0.3),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(forecast[index]
                                        .date!
                                        .toString()
                                        .substring(5, 16)),
                                    Text(icons[index]),
                                    Text(
                                        'Min: ${forecast[index].tempMin.toString().substring(0, 4)}º'),
                                    Text(
                                        'Max: ${forecast[index].tempMax.toString().substring(0, 4)}º')
                                  ]),
                            );
                          })
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
