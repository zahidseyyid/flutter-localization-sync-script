

# Flutter Localization Sync Script

This script automatically synchronizes JSON localization files and generates a translation class for Flutter projects.


## How to Run

### Run Manually
1. Open a terminal and navigate to the directory where the script is located.
2. Execute the following command:
   ```bash
   dart localization_checker.dart

---

### Automate with Run on Save (Optional)

You can configure the script to run automatically whenever you save a file. This is useful for keeping your localization files and translation class up-to-date without manually running the script.

However, if you prefer, you can also run the script manually from the terminal (see below).

### Steps to Set Up Run on Save
1. Install the **Run on Save** extension in your code editor (e.g., Visual Studio Code).
2. Open your `.vscode/settings.json` file.
3. Add the following configuration:
   ```json
   {
     "emeraldwalk.runonsave": {
       "commands": [
         {
           "match": ".*\\.json$", // Match all JSON files
           "cmd": "dart localization_checker.dart" // Command to run the script
         }
       ]
     }
   }

---

## Config Explanation
The script's behavior can be customized by editing the `config` variable.

### Example Config
```dart
const Map<String, dynamic> config = {
  "languagePath": "assets/langs",
  "mainJsonFile": "assets/langs/en.json",
  "multiLanguageStringsFile": "lib/core/constants/app_multi_language_strings.dart",
  "processJsonFiles": true,
  "processClassFile": true,
};
```

### Config Parameters (Detailed)

1. **`languagePath`**
   - **What it does**: Specifies the directory where JSON localization files are stored.
   - **Expected Value**: A relative path to the folder containing the language files.
   - **Example**: 
     - `assets/langs`: If your JSON files are located in the `assets/langs` directory.
     - `lib/localization`: If your JSON files are in a custom directory.
   - **Notes**: Ensure that this path exists in your project before running the script.

2. **`mainJsonFile`**
   - **What it does**: Specifies the main JSON file that acts as the reference for synchronization.
   - **Expected Value**: The full path to the primary JSON file (e.g., `en.json`).
   - **Example**:
     - `assets/langs/en.json`
   - **Notes**: This file should always exist as it serves as the source of truth for synchronization.

3. **`multiLanguageStringsFile`**
   - **What it does**: Specifies where the generated `MultiLanguageStrings` class will be saved.
   - **Expected Value**: A full path to the `.dart` file where the class will be generated.
   - **Example**:
     - `lib/core/constants/app_multi_language_strings.dart`
   - **Notes**: Ensure that the directory exists before running the script.

4. **`processJsonFiles`**
   - **What it does**: Controls whether the script processes and synchronizes JSON files.
   - **Accepted Values**:
     - `true`: Synchronizes JSON files (adds missing keys and removes unused ones).
     - `false`: Skips JSON file processing.
   - **Default Value**: `true`
   - **Notes**: Set to `false` if you only want to generate the `MultiLanguageStrings` class.

5. **`processClassFile`**
   - **What it does**: Controls whether the script generates the `MultiLanguageStrings` class.
   - **Accepted Values**:
     - `true`: Generates the class.
     - `false`: Skips class generation.
   - **Default Value**: `true`
   - **Notes**: Set to `false` if you only want to process JSON files without generating the class.

---

### Usage Example
1. If you want to process only JSON files (skip class generation):
   ```dart
   const Map<String, dynamic> config = {
     "languagePath": "assets/langs",
     "mainJsonFile": "assets/langs/en.json",
     "multiLanguageStringsFile": "lib/core/constants/app_multi_language_strings.dart",
     "processJsonFiles": true,
     "processClassFile": false,
   };
   ```

2. If you want to generate only the `MultiLanguageStrings` class:
   ```dart
   const Map<String, dynamic> config = {
     "languagePath": "assets/langs",
     "mainJsonFile": "assets/langs/en.json",
     "multiLanguageStringsFile": "lib/core/constants/app_multi_language_strings.dart",
     "processJsonFiles": false,
     "processClassFile": true,
   };
   ```

---

## Config Summary Table

| Parameter                | Description                                        | Example Value                             |
|--------------------------|----------------------------------------------------|-------------------------------------------|
| `languagePath`           | Path to the folder with localization JSON files    | `assets/langs`                            |
| `mainJsonFile`           | Path to the main JSON file (reference file)        | `assets/langs/en.json`                    |
| `multiLanguageStringsFile` | Path to save the generated class file            | `lib/core/constants/app_multi_language_strings.dart` |
| `processJsonFiles`       | Whether to process JSON files                      | `true` or `false`                         |
| `processClassFile`       | Whether to generate the `MultiLanguageStrings` class | `true` or `false`                        |

---
