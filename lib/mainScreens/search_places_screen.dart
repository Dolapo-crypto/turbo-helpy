import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget {
  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  List<PredictedPlaces> placesPredictedList = [];
  TextEditingController fromLocation = TextEditingController();
  TextEditingController toLocation = TextEditingController();

  void findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:GH";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        //search place UI
        Container(
          height: 181,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(
                    0.7,
                    0.7,
                  )),
            ],
          ),
          child: Column(children: [
            const SizedBox(
              height: 35,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Select destination",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Colors.blueAccent,
                    size: 15,
                  ),
                ),
                const SizedBox(
                  width: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // height: 50,
                    width: 250,
                    child: Stack(
                      children: [
                        TextFormField(
                          // controller: fromLocation,
                          // textInputAction: TextInputAction.next,

                          onChanged: (valuetyped) {
                            findPlaceAutoCompleteSearch(valuetyped);
                          },
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1), fontSize: 16),
                          initialValue: Provider.of<AppInfo>(context)
                                      .userPickUpLocation !=
                                  null
                              ? (Provider.of<AppInfo>(context)
                                      .userPickUpLocation!
                                      .locationName!) +
                                  "."
                              : "not getting address",
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(156, 66, 66, 66)),
                            hintText: "PickUp Location",
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                              bottom: 10,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8),
                  child: Icon(
                    Icons.share_location_rounded,
                    color: Colors.green,
                    size: 15,
                  ),
                ),
                const SizedBox(
                  width: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // height: 50,
                    width: 250,
                    child: TextFormField(
                      // controller: toLocation,
                      autofocus: true,
                      // textInputAction: TextInputAction.search,
                      onChanged: (valuetyped) {
                        findPlaceAutoCompleteSearch(valuetyped);
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Destination",
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(156, 66, 66, 66)),
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
        const SizedBox(
          height: 7,
        ),

        //display place predictions result
        (placesPredictedList.length > 0)
            ? Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.separated(
                    itemCount: placesPredictedList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 1,
                        color: Colors.grey,
                        thickness: 0.5,
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }
}
