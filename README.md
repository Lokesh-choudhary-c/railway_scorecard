## Railway Score Card App ##
 A Flutter application to digitize the Clean Train Station (CTS) Inspection Score Card used by Indian Railways. The app replicates the structure of the official PDF score card (1_SCORE CARD.pdf) and provides a mobile-friendly interface for inspectors to log cleanliness scores, remarks, and export or submit the data.

## Features ##
1. Digital Scorecard Form

 Fields for:
 Station Name
 Supervisor Name
 Train Number
 Coach Number (Dropdown: C1–C13)
 Toilet Number (Dropdown: T1–T4)
 Doorway Number (Dropdown: D1–D2)
 Date of Inspection
 Parameters section with:
 Dropdown score selector (0–10)
 Optional remarks input

2. PDF Export
 All filled metadata and parameters are exported to a clean PDF file.

 Filename is based on station and inspection date.

 Saved locally to device's documents directory.

3. View Saved PDFs
 A dedicated screen to view all previously saved PDF scorecards.

4. Summary Screen
 Before submission, a summary screen displays all entered data for confirmation.

 Save as PDF or Finish & Clear options available.

5. Webhook Submission
 Automatically submits the form data as JSON to a mock endpoint (https://webhook.site/0565a1cc-9af7-49b1-adf9-01da1493adc6) when the PDF is saved.

6. Offline Support
 Works fully offline. Data and PDF are stored locally.

 Webhook call will attempt if internet is available.

## Getting Started ##
 Prerequisites
 Flutter SDK
 Dart SDK

## Installation ##

 git clone https://github.com/Lokesh-choudhary-c/railway_scorecard.git
 cd railway_scorecard
 flutter pub get
 flutter run

## Project Structure ##

/lib
 ├── main.dart
 ├── models/
 │    └── parameter_model.dart
 ├── providers/
 │    └── form_provider.dart
 ├── screens/
 │    ├── metadata_screen.dart
 │    ├── parameter_screen.dart
 │    ├── summary_screen.dart
 │    └── pdf_list_screen.dart
 ├── services/
 │     └── pdf_service.dart
 ├── widgets/
 │     └── parameter_widget.dart     

## Known Limitations ##
 PDFs are saved only locally and not uploaded anywhere.

 No login or user session feature yet.

 Webhook is static and used for demo/testing only.

 No backend integration or Firebase for now.

# railway_scorecard
