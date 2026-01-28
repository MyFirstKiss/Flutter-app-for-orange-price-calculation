# Orange Calculator SDK

[![pub package](https://img.shields.io/badge/pub-1.0.0-blue)](https://pub.dev/packages/orange_calculator_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter SDK for calculating orange prices with real-time data from Talaadthai.com. This package provides easy-to-use APIs for:

- 🍊 Fetching orange types and prices
- 🧮 Calculating prices based on weight
- 💰 Getting real-time market prices
- 📊 Managing calculation history
- 📈 Viewing statistics

## Supported Orange Types

- **ส้มสายน้ำผึ้ง (Tangerine)** - Sweet and juicy
- **ส้มเขียวหวาน (Green Sweet Orange)** - Crispy and refreshing
- **ส้มแมนดาริน (Mandarin)** - Sweet aroma, easy to peel

## Features

✅ Real-time price updates from Talaadthai.com  
✅ Automatic price calculation  
✅ History management with CRUD operations  
✅ Statistics and analytics  
✅ Clean and simple API  
✅ Full TypeScript-style documentation  
✅ Cross-platform (iOS, Android, Web, Desktop)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  orange_calculator_sdk: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Backend Setup (Required)

This SDK requires a backend server to fetch and calculate prices. Clone and run the backend:

```bash
git clone https://github.com/MyFirstKiss/Flutter-app-for-orange-price-calculation.git
cd Flutter-app-for-orange-price-calculation/backend
pip install -r requirements.txt
python seed_db.py
python main.py
```

Backend will run on `http://localhost:8001`

## Quick Start

### Basic Usage

```dart
import 'package:orange_calculator_sdk/orange_calculator_sdk.dart';

void main() async {
  // Initialize SDK
  final sdk = OrangeCalculatorSDK();
  
  // Check if backend is available
  final isOnline = await sdk.checkApiStatus();
  print('Backend status: ${isOnline ? "Online" : "Offline"}');
  
  // Fetch all orange types
  final oranges = await sdk.getOranges();
  for (var orange in oranges) {
    print('${orange.name}: ${orange.pricePerKg}฿/kg');
  }
  
  // Calculate price
  final result = await sdk.calculatePrice('tangerine', 2.5);
  if (result != null) {
    print('Total price: ${result.totalPrice}฿');
  }
}
```

### Flutter Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:orange_calculator_sdk/orange_calculator_sdk.dart';

class OrangePriceScreen extends StatefulWidget {
  @override
  _OrangePriceScreenState createState() => _OrangePriceScreenState();
}

class _OrangePriceScreenState extends State<OrangePriceScreen> {
  final sdk = OrangeCalculatorSDK();
  List<OrangeType> oranges = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    loadOranges();
  }
  
  Future<void> loadOranges() async {
    final data = await sdk.getOranges();
    setState(() {
      oranges = data;
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      itemCount: oranges.length,
      itemBuilder: (context, index) {
        final orange = oranges[index];
        return ListTile(
          title: Text(orange.name),
          subtitle: Text('${orange.pricePerKg}฿/kg'),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}
```

### Price Calculator Example

```dart
import 'package:orange_calculator_sdk/orange_calculator_sdk.dart';

class PriceCalculator {
  final sdk = OrangeCalculatorSDK();
  
  Future<void> calculateAndSave(String orangeId, double weight) async {
    // Calculate price
    final result = await sdk.calculatePrice(orangeId, weight);
    
    if (result != null) {
      print('Orange: ${result.orangeName}');
      print('Weight: ${result.weight} kg');
      print('Price per kg: ${result.pricePerKg}฿');
      print('Total: ${result.totalPrice}฿');
      
      // Calculation is automatically saved to history
      // You can fetch it later
      final history = await sdk.getHistory(limit: 10);
      print('Total calculations: ${history.length}');
    }
  }
  
  Future<void> viewStatistics() async {
    final stats = await sdk.getStatistics();
    if (stats != null) {
      print('Total calculations: ${stats['total_calculations']}');
      print('Most popular: ${stats['most_popular']}');
    }
  }
}
```

## API Reference

### OrangeCalculatorSDK

Main SDK class for orange price calculations.

#### Methods

- `getOranges()` - Fetch all available orange types
- `getOrangeById(String id)` - Get specific orange by ID
- `calculatePrice(String orangeId, double weight)` - Calculate price
- `getLivePrices()` - Get real-time market prices
- `getHistory({int limit})` - Get calculation history
- `deleteCalculation(int id)` - Delete a calculation
- `getStatistics()` - Get usage statistics
- `checkApiStatus()` - Check backend availability

### Models

#### OrangeType
```dart
class OrangeType {
  final String id;           // 'tangerine', 'green-sweet', 'mandarin'
  final String name;         // Display name in Thai
  final double pricePerKg;   // Price per kilogram (฿)
  final double height;       // Height in cm
  final double radius;       // Radius in cm
  final double diameter;     // Diameter in cm
  final List<Color> colors;  // UI gradient colors
  final String description;  // Description text
}
```

#### PriceCalculation
```dart
class PriceCalculation {
  final int id;
  final String orangeType;
  final String orangeName;
  final double weightKg;
  final double pricePerKg;
  final double totalPrice;
  final DateTime date;
}
```

#### PriceCalculationResult
```dart
class PriceCalculationResult {
  final String orangeId;
  final String orangeName;
  final double weight;
  final double pricePerKg;
  final double totalPrice;
}
```

## Configuration

### Custom Backend URL

By default, the SDK connects to `localhost:8001` (or `10.0.2.2:8001` on Android Emulator).

To use a custom backend URL, modify `lib/services/api_service.dart`:

```dart
static String get baseUrl {
  return 'https://your-backend-url.com';
}
```

## Backend API Endpoints

The SDK uses these backend endpoints:

- `GET /api/oranges` - Get all oranges
- `GET /api/oranges/{id}` - Get orange by ID
- `POST /api/calculate` - Calculate price
- `GET /api/prices` - Live prices
- `GET /api/calculations` - History
- `DELETE /api/calculations/{id}` - Delete calculation
- `GET /api/stats` - Statistics

## Platform Support

| Platform | Support |
|----------|---------|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| Windows  | ✅ |
| macOS    | ✅ |
| Linux    | ✅ |

## Example App

See the `/example` folder for a complete Flutter application using this SDK, including:

- Home screen with orange selection
- Price calculator
- Live price updates
- History management with swipe-to-delete
- Statistics dashboard

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors

- **MyFirstKiss** - [GitHub](https://github.com/MyFirstKiss)

## Acknowledgments

- Price data from [Talaadthai.com](https://talaadthai.com)
- Built with [Flutter](https://flutter.dev)
- Backend powered by [FastAPI](https://fastapi.tiangolo.com)

## Support

For issues and feature requests, please use the [GitHub issue tracker](https://github.com/MyFirstKiss/Flutter-app-for-orange-price-calculation/issues).

## Changelog

### 1.0.0 (2026-01-29)

- Initial release
- Orange type management
- Price calculation
- History tracking
- Real-time price updates
- Statistics
