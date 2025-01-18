# Flutter Localization Sync Script

Bu script, JSON dil dosyalarını otomatik olarak senkronize eder ve Flutter projeleri için bir çeviri sınıfı oluşturur.

## Nasıl Çalıştırılır?

### Manuel Çalıştırma
1. Terminali açın ve script'in bulunduğu dizine gidin.
2. Aşağıdaki komutu çalıştırın:
   ```bash
   dart localization_checker.dart

---

### Kaydedildiğinde Otomatik Çalıştırma (Opsiyonel)

Script'i, bir dosyayı kaydettiğinizde otomatik olarak çalışacak şekilde yapılandırabilirsiniz. Bu, dil dosyalarınızı ve çeviri sınıfınızı güncel tutmak için faydalıdır.

Ancak, tercihinize bağlı olarak script'i manuel olarak terminalden çalıştırmaya devam edebilirsiniz (aşağıya bakınız).

#### Run on Save Kurulum Adımları
1. Kod düzenleyicinizde (örneğin, Visual Studio Code) **Run on Save** uzantısını yükleyin.
2. `.vscode/settings.json` dosyanızı açın.
3. Aşağıdaki yapılandırmayı ekleyin:
   ```json
   {
     "emeraldwalk.runonsave": {
       "commands": [
         {
           "match": ".*\\.json$", // Tüm JSON dosyalarını eşleştir
           "cmd": "dart localization_checker.dart" // Script'i çalıştıran komut
         }
       ]
     }
   }
   ```

---

## Config Açıklaması
Script'in davranışını `config` değişkenini düzenleyerek kontrol edebilirsiniz.

### Örnek Config
```dart
const Map<String, dynamic> config = {
  "languagePath": "assets/langs",
  "mainJsonFile": "assets/langs/en.json",
  "multiLanguageStringsFile": "lib/core/constants/app_multi_language_strings.dart",
  "processJsonFiles": true,
  "processClassFile": true,
};
```

### Config Parametreleri (Detaylı)

1. **`languagePath`**
   - **Açıklama**: JSON dil dosyalarının bulunduğu dizin.
   - **Beklenen Değer**: JSON dosyalarını içeren klasöre göreli bir yol.
   - **Örnek**: 
     - `assets/langs`: Eğer JSON dosyalarınız `assets/langs` dizininde bulunuyorsa.
     - `lib/localization`: JSON dosyalarınız özel bir dizindeyse.
   - **Notlar**: Bu yolun script çalıştırılmadan önce var olduğundan emin olun.

2. **`mainJsonFile`**
   - **Açıklama**: Senkronizasyon için referans alınacak ana JSON dosyasının tam yolu.
   - **Beklenen Değer**: Ana JSON dosyasının tam yolu (ör. `en.json`).
   - **Örnek**:
     - `assets/langs/en.json`
   - **Notlar**: Bu dosya her zaman var olmalıdır çünkü senkronizasyonun ana kaynağıdır.

3. **`multiLanguageStringsFile`**
   - **Açıklama**: Üretilen `MultiLanguageStrings` sınıfının kaydedileceği dosyanın yolu.
   - **Beklenen Değer**: `.dart` dosyasının tam yolu.
   - **Örnek**:
     - `lib/core/constants/app_multi_language_strings.dart`
   - **Notlar**: Script çalıştırılmadan önce bu dizinin var olduğundan emin olun.

4. **`processJsonFiles`**
   - **Açıklama**: Script'in JSON dosyalarını işleyip işlemeyeceğini kontrol eder.
   - **Kabul Edilen Değerler**:
     - `true`: JSON dosyalarını senkronize eder (eksik anahtarları ekler ve kullanılmayanları kaldırır).
     - `false`: JSON dosyaları işlenmez.
   - **Varsayılan Değer**: `true`
   - **Notlar**: Yalnızca `MultiLanguageStrings` sınıfını oluşturmak istiyorsanız `false` olarak ayarlayın.

5. **`processClassFile`**
   - **Açıklama**: Çeviri sınıfının oluşturulup oluşturulmayacağını kontrol eder.
   - **Kabul Edilen Değerler**:
     - `true`: Sınıfı oluşturur.
     - `false`: Sınıf oluşturma işlemi yapılmaz.
   - **Varsayılan Değer**: `true`
   - **Notlar**: Yalnızca JSON dosyalarını işlemek istiyorsanız `false` olarak ayarlayın.

---

## Config Özeti Tablosu

| Parametre                | Açıklama                                           | Örnek Değer                              |
|--------------------------|----------------------------------------------------|------------------------------------------|
| `languagePath`           | JSON dil dosyalarının bulunduğu dizin              | `assets/langs`                           |
| `mainJsonFile`           | Ana JSON dosyasının tam yolu (referans dosyası)    | `assets/langs/en.json`                   |
| `multiLanguageStringsFile` | Üretilen sınıf dosyasının kaydedileceği yol       | `lib/core/constants/app_multi_language_strings.dart` |
| `processJsonFiles`       | JSON dosyalarının işlenip işlenmeyeceği            | `true` veya `false`                      |
| `processClassFile`       | Çeviri sınıfının oluşturulup oluşturulmayacağı     | `true` veya `false`                      |

---
