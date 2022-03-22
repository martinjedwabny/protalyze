import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

class GifHandler {
  static const String GIPHY_API_KEY = 'g0zW2U9RG9EYWmAM2TrcNO0k8znneRQe';
  static Future<String> searchGif(BuildContext context) async {
    GiphyGif gif = await GiphyPicker.pickGif(
      context: context, //Required
      apiKey: GIPHY_API_KEY,
      showAttributionMark: true,
      attributionMarkDarkMode: false,
      showPreviewPage: false,
      // lang: GiphyLanguage.english, //Optional - Language for query.
      // randomID: "abcd", // Optional - An ID/proxy for a specific user.
      // searchText :"Search GIPHY",//Optional - AppBar search hint text.
      // tabColor:Colors.teal, // Optional- default accent color.
    );
    return gif == null ? '' : gif.images.original.url;
  }

  static Widget createGifImage(String gifUrl, {double height, double width}) {
    if (height == null)
      return GiphyImage(
          url: gifUrl,
          width: width,
          placeholder: SizedBox(width: 1, height: 1));
    return GiphyImage(
        url: gifUrl,
        height: height,
        placeholder: SizedBox(width: 1, height: 1));
  }
}
