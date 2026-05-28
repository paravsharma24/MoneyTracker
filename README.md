Money Tracker

A modern offline-first expense tracking application built with Flutter. Money Tracker helps users manage daily spending, monitor financial activity, and visualize expenses through dynamic analytics and charts.

Features
User profile setup on first launch
Persistent local storage using Hive database
Add and manage expense transactions
Real-time expense tracking
Recent activity section
Daily analytics
Weekly analytics
Monthly analytics
Yearly analytics
Dynamic charts and visual spending insights
Dark mode support
Profile image upload
Delete account with confirmation dialog
Glassmorphism blur effects
Animated application background
Custom studio intro animation
Responsive modern UI
Offline functionality
Screens
Setup Screen
Home Screen
Entry Screen
History Screen
Analytics Screen
Profile Screen
Technologies Used
Flutter
Dart
Hive CE
FL Chart
Image Picker
Shared Preferences
Permission Handler
Project Structure
lib
│
├── screens
│   ├── home_screen.dart
│   ├── entry_screen.dart
│   ├── history_screen.dart
│   ├── chart_screen.dart
│   ├── profile_screen.dart
│   ├── setup_screen.dart
│   └── root_screen.dart
│
├── services
│   ├── database_service.dart
│   └── transaction_service.dart
│
├── widgets
│   └── animated_background.dart
│
└── main.dart
Installation

Clone the repository:

git clone https://github.com/yourusername/moneytracker.git

Navigate to the project:

cd moneytracker

Install dependencies:

flutter pub get

Run the application:

flutter run

Build APK:

flutter build apk --release --split-per-abi

APK output:

build/app/outputs/flutter-apk/
Future Improvements
Income tracking
Budget goals
Expense categories with icons
Export transaction history
Cloud synchronization
Multi-user support
AI-powered expense insights
Developer

PSOrigins

TheBOX Studios

"Think out of the box"