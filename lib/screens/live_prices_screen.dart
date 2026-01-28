import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class LivePricesScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const LivePricesScreen({super.key, required this.onNavigate});

  @override
  State<LivePricesScreen> createState() => _LivePricesScreenState();
}

class _LivePricesScreenState extends State<LivePricesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> prices = [];
  bool isLoading = true;
  bool isApiConnected = false;

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() => isLoading = true);
    
    // ตรวจสอบการเชื่อมต่อ API
    isApiConnected = await _apiService.checkApiStatus();
    
    // ดึงข้อมูลราคา
    final data = await _apiService.fetchLivePrices();
    
    setState(() {
      prices = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CommonWidgets.buildHeader(
              title: 'ราคาล่าสุด',
              onBack: () => widget.onNavigate('home'),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadPrices,
              ),
            ),

            // API Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
              child: CommonWidgets.buildStatusBadge(
                text: isApiConnected ? 'เชื่อมต่อ API สำเร็จ' : 'ใช้ข้อมูลแบบ Offline',
                color: isApiConnected ? AppTheme.successColor : AppTheme.warningColor,
                icon: isApiConnected ? Icons.cloud_done : Icons.cloud_off,
              ),
            ),

            // Price List
            Expanded(
              child: isLoading
                  ? CommonWidgets.buildLoadingIndicator(text: 'กำลังโหลดราคา...')
                  : prices.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.cloud_off_outlined,
                                    size: 64,
                                    color: AppTheme.primaryColor.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'ไม่สามารถโหลดข้อมูลได้',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'กรุณาตรวจสอบการเชื่อมต่อ API\nและให้แน่ใจว่า Backend ทำงานอยู่',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: _loadPrices,
                                  icon: const Icon(Icons.refresh, size: 20),
                                  label: const Text(
                                    'ลองอีกครั้ง',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPrices,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: prices.length,
                            itemBuilder: (context, index) {
                              final price = prices[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange.shade200,
                                              Colors.orange.shade400,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/${price['id'] ?? 'oranges'}.png',
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Text(
                                                  '🍊',
                                                  style: TextStyle(fontSize: 24),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              price['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'อัพเดทล่าสุด: ${price['updated_at'] ?? '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} น.'}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            if (price['source'] != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                'ที่มา: ${price['source']}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${price['price']} บาท/กก.',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
