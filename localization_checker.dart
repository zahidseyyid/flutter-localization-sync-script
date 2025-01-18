import 'dart:convert';
import 'dart:io';
//import 'package:flutter/foundation.dart'; // For debugPrint //TODO: Uncomment this line

/// Main function to execute the localization checker script
void main() async {
  const Map<String, dynamic> config = {
    "languagePath": "assets/langs", // Directory containing JSON localization files
    "mainJsonFile": "assets/langs/en.json", // Main JSON file (reference file)
    "multiLanguageStringsFile":
        "lib/core/constants/app_multi_language_strings.dart", // File path for the generated translation class
    "processJsonFiles": true, // Flag to process and synchronize JSON files
    "processClassFile": true, // Flag to generate the translation class
  };

  // Extract configuration parameters
  final String languagePath = config["languagePath"];
  final String mainJsonFile = config["mainJsonFile"];
  final String appMultiLanguageStringsFile = config["multiLanguageStringsFile"];
  final bool processJsonFiles = config["processJsonFiles"];
  final bool processClassFile = config["processClassFile"];

  try {
    // Load main JSON file (en.json)
    final mainJson = File(mainJsonFile);
    if (!await mainJson.exists()) {
      logDebug("Main JSON file (en.json) not found at $mainJsonFile");
      return;
    }

    final mainJsonContent = jsonDecode(await mainJson.readAsString());
    final mainKeys = mainJsonContent.keys.toSet();

    // Process JSON files if enabled
    if (processJsonFiles) {
      await _processJsonFiles(
          languagePath, mainJsonFile, mainKeys, mainJsonContent);
    }

    // Generate translation class if enabled
    if (processClassFile) {
      await _generateMultiLanguageStringsClass(
          appMultiLanguageStringsFile, mainKeys);
    }
  } catch (e) {
    logDebug("An unexpected error occurred: $e");
  }
}

/// Process JSON localization files to synchronize with the main JSON file
Future<void> _processJsonFiles(
  String languagePath,
  String mainJsonFile,
  Set<String> mainKeys,
  Map<String, dynamic> mainJsonContent,
) async {
  final langDir = Directory(languagePath);
  if (!await langDir.exists()) {
    logDebug("Language directory not found at $languagePath");
    return;
  }

  await for (final entity in langDir.list()) {
    if (entity is File &&
        entity.path.endsWith('.json') &&
        entity.path != mainJsonFile) {
      await _processLanguageFile(entity, mainKeys, mainJsonContent);
    }
  }

  logDebug("All language files synchronized with en.json.");
}

/// Synchronize a specific language file with the main JSON file
Future<void> _processLanguageFile(
  File file,
  Set<String> mainKeys,
  Map<String, dynamic> mainJsonContent,
) async {
  try {
    final rawContent = await file.readAsString();
    final content = rawContent.trim().isEmpty
        ? <String, dynamic>{}
        : jsonDecode(rawContent) as Map<String, dynamic>;

    final fileKeys = content.keys.toSet();

    // Remove keys that are not in the main JSON file
    final keysToRemove = fileKeys.difference(mainKeys);
    for (final key in keysToRemove) {
      content.remove(key);
    }
    if (keysToRemove.isNotEmpty) {
      logDebug("Removed keys from ${file.path}: ${keysToRemove.join(', ')}");
    }

    // Add missing keys from the main JSON file
    final keysToAdd = mainKeys.difference(fileKeys);
    for (final key in keysToAdd) {
      content[key] = mainJsonContent[key];
    }
    if (keysToAdd.isNotEmpty) {
      logDebug("Added keys to ${file.path}: ${keysToAdd.join(', ')}");
    }

    // Write the updated file in a readable JSON format
    const encoder =
        JsonEncoder.withIndent('  '); // Pretty JSON formatting
    final formattedJson = encoder.convert(content);
    await file.writeAsString(formattedJson);
    logDebug("Updated ${file.path}.");
  } catch (e) {
    logDebug("Failed to process ${file.path}: $e");
  }
}

/// Generate a translation class for easy_localization integration
Future<void> _generateMultiLanguageStringsClass(
  String filePath,
  Set<String> keys,
) async {
  try {
    final appMultiLanguageStrings = StringBuffer();
    appMultiLanguageStrings
        .writeln("import 'package:easy_localization/easy_localization.dart';");
    appMultiLanguageStrings.writeln();
    appMultiLanguageStrings.writeln("class AppMultiLanguageStrings {");

    for (final key in keys) {
      final camelCaseKey = _toCamelCase(key);
      appMultiLanguageStrings
          .writeln("  static String get $camelCaseKey => \"$key\".tr();");
    }

    appMultiLanguageStrings.writeln("}");

    final file = File(filePath);
    await file.writeAsString(appMultiLanguageStrings.toString());
    logDebug("AppMultiLanguageStrings.dart updated at $filePath.");
  } catch (e) {
    logDebug("Failed to generate AppMultiLanguageStrings: $e");
  }
}

/// Convert a string to camelCase format
String _toCamelCase(String input) {
  return input.replaceAllMapped(RegExp(r'_(.)'), (match) {
    return match.group(1)!.toUpperCase();
  });
}

/// Debug logger for conditional printing
void logDebug(String message) {
//  if (kDebugMode) { // For debugPrint //TODO: Uncomment this line
    print(message);
 // }
}
