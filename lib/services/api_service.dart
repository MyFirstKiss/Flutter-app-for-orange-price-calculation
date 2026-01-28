import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/orange_type.dart';
import '../models/price_calculation.dart';

class ApiService {
  // URL ของ backend API
  static String get baseUrl {
    // สำหรับ Android Emulator ต้องใช้ 10.0.2.2
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8001';
    }
    return 'http://localhost:8001';
  }
  
  // ดึงข้อมูลส้มทั้งหมดจาก API
  Future<List<OrangeType>> fetchOranges() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/oranges'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => OrangeType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load oranges');
      }
    } catch (e) {
      debugPrint('Error fetching oranges: $e');
      // Return local data as fallback
      return orangeTypes;
    }
  }
  
  // ดึงข้อมูลส้มตาม ID
  Future<OrangeType?> fetchOrangeById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/oranges/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return OrangeType.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching orange by id: $e');
      return orangeTypes.firstWhere((o) => o.id == id);
    }
  }
  
  // คำนวณราคาผ่าน API
  Future<Map<String, dynamic>?> calculatePrice(String orangeId, double weight) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/calculate?orange_id=$orangeId&weight=$weight'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error calculating price: $e');
      // Calculate locally as fallback
      final orange = orangeTypes.firstWhere((o) => o.id == orangeId);
      return {
        'orange_id': orangeId,
        'orange_name': orange.name,
        'weight': weight,
        'price_per_kg': orange.pricePerKg,
        'total_price': weight * orange.pricePerKg,
      };
    }
  }
  
  // ดึงราคาล่าสุด
  Future<List<Map<String, dynamic>>> fetchLivePrices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/prices'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load prices');
      }
    } catch (e) {
      debugPrint('Error fetching prices: $e');
      return [];
    }
  }
  
  // ตรวจสอบว่า API ทำงานหรือไม่
  Future<bool> checkApiStatus() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API is not available: $e');
      return false;
    }
  }

  // ดึงประวัติการคำนวณราคา
  Future<List<PriceCalculation>> fetchCalculations({int limit = 50}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/calculations?limit=$limit'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => PriceCalculation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load calculations');
      }
    } catch (e) {
      debugPrint('Error fetching calculations: $e');
      return [];
    }
  }

  // ดึงสถิติ
  Future<Map<String, dynamic>?> fetchStatistics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/stats'));
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
      return null;
    }
  }

  // ลบประวัติการคำนวณราคา
  Future<bool> deleteCalculation(int calculationId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/calculations/$calculationId'),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to delete calculation: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting calculation: $e');
      return false;
    }
  }
}
