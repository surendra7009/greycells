# GreyCells App

A Flutter application for school management system with query resolution, attendance tracking, payment processing, and more.

## Features

### Query Resolution System
- **Query Management**: Create, view, and manage queries with filtering options
- **Export Functionality**: Export query data to CSV format or copy to clipboard
- **Pull-to-Refresh**: Swipe down to refresh query lists
- **Statistics Dashboard**: View total, resolved, and pending query statistics
- **Advanced Filtering**: Filter by date range, nature, category, and priority
- **Search**: Search queries by reference number, subject, or status

### Recent Updates

#### Version 3.0.5+21 - New Features Added
- ✅ **CSV Export**: Export query data tables to CSV format
- ✅ **Copy to Clipboard**: Quick copy functionality for data tables
- ✅ **Pull-to-Refresh**: Swipe down gesture to refresh data
- ✅ **Query Statistics Cards**: Visual dashboard showing query metrics
- ✅ **Enhanced Data Table Widget**: Improved GCDataTableCard with export options

## Getting Started

This project is a Flutter application built with:
- Flutter SDK: >=2.12.0 <3.0.0
- State Management: Scoped Model
- HTTP Client: http package
- Payment Gateway: Razorpay
- Database: SQLite (sqflite)

### Prerequisites

- Flutter SDK installed
- Dart SDK installed
- Android Studio / Xcode for mobile development
- Git for version control

### Installation

1. Clone the repository:
```bash
git clone https://github.com/surendra7009/greycells.git
cd greycells
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── src/
│   ├── app/                  # App configuration and routing
│   ├── commons/              # Common widgets and utilities
│   ├── config/               # Configuration files
│   ├── manager/              # State management
│   ├── models/               # Data models
│   ├── services/             # API services
│   ├── utils/                # Utility functions
│   └── views/                # UI screens
│       └── queryResolutionViews/
│           ├── query_resolution_view.dart
│           └── widgets/
│               └── gc_data_table_card.dart
```

## Key Components

### GCDataTableCard Widget
A reusable data table widget with export capabilities:
- CSV export functionality
- Copy to clipboard
- Customizable column widths
- Empty state handling

### QueryResolutionView
Main view for managing queries:
- Filter queries by multiple criteria
- Search functionality
- Statistics dashboard
- Pull-to-refresh support

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is proprietary software.

## Support

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
