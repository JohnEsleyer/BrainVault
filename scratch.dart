import 'dart:core';

bool isUrl(String input) {
  final regex = RegExp(
      r"^(?:http|https):\/\/(?:(?:[A-Z0-9][A-Z0-9_-]*)(?:\.[A-Z0-9][A-Z0-9_-]*)+)(?::\d{1,5})?(?:\/[^\s]*)?$",
      caseSensitive: false);
  return regex.hasMatch(input);
}

void main(){
  print(isUrl('https://images7.alphacoders.com/131/1316242.jpg'));

}