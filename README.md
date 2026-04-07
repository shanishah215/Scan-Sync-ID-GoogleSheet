# Scan-Sync-ID-GoogleSheet

A powerful Flutter application designed for seamless **OCR Scanning** and **Google Sheets Synchronization** for ID verification and data logging.

---

## 🚀 Features

*   **Smart OCR Scanning**: Uses **Google ML Kit** for high-accuracy text recognition (Optimized for Aadhaar/ID cards).
*   **Privacy Masking**: Automatically masks the last four digits of the scanned UID for security and compliance.
*   **Google Sheets Sync**: Instant data logging to any Google Spreadsheet via a robust **Google Apps Script Web Service**.
*   **Clean Architecture**: Built with a modular structure (Data, Domain, Presentation) for scalability.
*   **State Management**: Powered by **GetX** for high-performance reactive logic.

---

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev)
*   **AI Backend**: [Google ML Kit Text Recognition](https://pub.dev/packages/google_mlkit_text_recognition)
*   **State Management**: [GetX](https://pub.dev/packages/get)
*   **Networking**: [http](https://pub.dev/packages/http)
*   **Database**: [Google Sheets API (via Apps Script)](https://developers.google.com/apps-script/guides/web)

---

## 🏗️ Architecture

Following strict **Clean Architecture** principles:

```text
lib/
├── core/              # Global constants, errors, and dependency injection
├── data/              # Models, DTOs, and DataSources (API/HTTP Implementation)
├── domain/            # Entities, abstract repositories, and use cases (Business Logic)
└── presentation/      # UI components (Screens, Widgets, and Controllers)
```

---

## ⚙️ Configuration

### 1. Google Sheets Setup (The script)

To sync data, you need a Google Apps Script. Create a new sheet, go to **Extensions > Apps Script**, and paste this code:

```javascript
function doGet(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheets()[0]; 
    var name = e.parameter.name || "N/A";
    var dob = e.parameter.dob || "N/A";
    var uid = e.parameter.uid || "N/A";
    var gender = e.parameter.gender || "N/A";
    
    sheet.appendRow([new Date(), name, dob, uid, gender]);

    return ContentService.createTextOutput(JSON.stringify({"status": "Success"}))
                         .setMimeType(ContentService.MimeType.JSON);
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({"status": "Error", "message": error.toString()}))
                         .setMimeType(ContentService.MimeType.JSON);
  }
}
```

1.  Click **Deploy > New Deployment**.
2.  Select **Web App**, set access to **Anyone**, and deploy.
3.  Copy the provided **Web App URL**.

### 2. Connect Your App

Update the URL in `lib/data/datasources/aadhaar_remote_datasource.dart`:

```dart
static const String _url = "YOUR_APPS_SCRIPT_URL_HERE";
```

---

## 🛡️ Security & Privacy

*   **On-Device Processing**: OCR is performed entirely on the device; images are never sent to external servers.
*   **Masking**: The app defaults to showing and syncing the **masked ID** (e.g. `1234 5678 XXXX`) to comply with data privacy standards.

---

## 📈 Getting Started

1.  Clone the repository.
2.  Run `flutter pub get`.
3.  Configure your Google Sheet URL (see above).
4.  Run `flutter run`.