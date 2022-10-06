import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../app/modules/Login/views/OtpSubmitPage.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = SchedulerBinding.instance.window.locale;
  int selectedlangauageIndex = 0;
  int previouslySelectedlangauageIndex = 0;
  LanguageModel previouslySelectedlangauage = LanguageModel('English', 'English', 'en');
  LanguageModel selectedLanguageModel = LanguageModel('English', 'English', 'en');

  Locale get locale => _locale;
  toogleLocale(Locale loc) {
    _locale = loc;
    notifyListeners();
  }
  updateLang() {
    previouslySelectedlangauage = selectedLanguageModel;
    notifyListeners();
  }


  List<LanguageModel> languages = [
    LanguageModel('English', 'English', 'en'),
    LanguageModel('Hindi', 'हिंदी', 'hi'),
    LanguageModel('Hinglish', 'Hinglish', 'en'),
    LanguageModel('Marathi', 'मराठी', 'mr'),
    LanguageModel('Gujarati', 'ગુજરાતી ', 'gu'),
    LanguageModel('Bengali', 'বাংলা', 'bn'),
  ];
}

class ShowLangaugeBottomSheet extends StatefulWidget {
  @override
  State<ShowLangaugeBottomSheet> createState() =>
      _ShowLangaugeBottomSheetState();
}

class _ShowLangaugeBottomSheetState extends State<ShowLangaugeBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LanguageProvider>(context, listen: false)
        .selectedlangauageIndex =
        Provider.of<LanguageProvider>(context, listen: false)
            .previouslySelectedlangauageIndex;
  }

  @override
  Widget build(BuildContext context) {
    double bottomCorner = 15;
    return BottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bottomCorner),
              topRight: Radius.circular(bottomCorner))),
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<LanguageProvider>(
          builder: (context, lang, child) {
            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.clear,
                        color: Get.theme.textTheme.headline6!.color,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Select Your Language',
                      style: Get.theme.textTheme.headline6,
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: lang.languages.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                          // childAspectRatio: 2,
                          mainAxisExtent: 70,
                        ),
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                lang.selectedlangauageIndex = i;
                                lang.selectedLanguageModel = lang.languages[i];
                              });
                              print(lang.selectedLanguageModel.caption);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: lang.selectedlangauageIndex == i
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.15),
                                border: Border.all(
                                    color: lang.selectedlangauageIndex == i
                                        ? Colors.green
                                        : Colors.transparent),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(lang.languages[i].caption,
                                            style:
                                            lang.selectedlangauageIndex == i
                                                ? Get.theme.textTheme
                                                .bodyText2!
                                                .copyWith(
                                                color: Colors.green)
                                                : Get.theme.textTheme
                                                .bodyText2!),
                                        if (lang.selectedlangauageIndex == i)
                                          Icon(
                                            Icons.offline_pin_rounded,
                                            color: Colors.green,
                                          )
                                      ],
                                    ),
                                    Spacer(),
                                    Text(lang.languages[i].name,
                                        style: lang.selectedlangauageIndex == i
                                            ? Get.theme.textTheme.headline6!
                                            .copyWith(color: Colors.green)
                                            : Get.theme.textTheme.headline6!),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'More languages are coming soon!',
                        style: Get.theme.textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: lang.previouslySelectedlangauageIndex !=
                        lang.selectedlangauageIndex
                        ? () {
                      lang.previouslySelectedlangauageIndex =
                          lang.selectedlangauageIndex;
                      // lang.previouslySelectedlangauage =
                      //     lang.selectedLanguageModel;
                      lang.updateLang();
                      print(lang.selectedLanguageModel.code);
                      Navigator.pop(context);
                    }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('UPDATE'),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
