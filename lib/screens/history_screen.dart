import 'package:flutter/material.dart';
import '../models/price_calculation.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Function(String) onNavigate;
  
  const HistoryScreen({super.key, required this.onNavigate});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  List<PriceCalculation> _calculations = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final calculations = await _apiService.fetchCalculations(limit: 100);
      final stats = await _apiService.fetchStatistics();
      
      setState(() {
        _calculations = calculations;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'ไม่สามารถโหลดข้อมูลได้: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCalculation(PriceCalculation calc) async {
    // เก็บ index เดิมเพื่อกู้คืนตำแหน่งเดิม
    final int originalIndex = _calculations.indexOf(calc);
    
    if (!mounted) return;
    
    setState(() {
      _calculations.remove(calc);
    });

    // แสดง Snackbar พร้อมรายละเอียดข้อมูลที่ลบ
    final snackBar = SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ลบประวัติสำเร็จ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${calc.orangeName} • ${calc.weightKg.toStringAsFixed(2)} กก. • ฿${calc.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            _formatDate(calc.date),
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade600,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'เลิกทำ',
        textColor: Colors.white,
        onPressed: () {
          if (!mounted) return;
          setState(() {
            // คืนค่ากลับไปที่ตำแหน่งเดิม
            _calculations.insert(originalIndex, calc);
          });
        },
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // หลังจาก 1 วินาที ถ้าไม่กด undo จะลบถาวรจาก database
    Future.delayed(const Duration(seconds: 1), () async {
      // ตรวจสอบว่ายังถูกลบอยู่หรือไม่ (ไม่ได้กด undo)
      if (mounted && !_calculations.contains(calc)) {
        debugPrint('🔄 กำลังลบจาก database: ${calc.orangeName} (ID: ${calc.id})');
        
        // เรียก API เพื่อลบจาก database ถาวร
        try {
          final success = await _apiService.deleteCalculation(calc.id);
          if (success) {
            debugPrint('✅ ลบจาก database สำเร็จ: ${calc.orangeName} (ID: ${calc.id})');
          } else {
            debugPrint('❌ ลบจาก database ล้มเหลว: ${calc.orangeName} (ID: ${calc.id})');
          }
        } catch (e) {
          debugPrint('❌ เกิดข้อผิดพลาดในการลบ: $e');
        }
      } else {
        debugPrint('⏭️ ข้ามการลบ (กด undo แล้ว): ${calc.orangeName}');
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'วันนี้ ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'เมื่อวาน ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  Color _getOrangeColor(String orangeType) {
    switch (orangeType) {
      case 'tangerine':
        return Colors.orange;
      case 'green-sweet':
        return Colors.green;
      case 'mandarin':
        return Colors.amber;
      default:
        return Colors.orange;
    }
  }

  IconData _getOrangeIcon(String orangeType) {
    switch (orangeType) {
      case 'tangerine':
        return Icons.circle;
      case 'green-sweet':
        return Icons.circle;
      case 'mandarin':
        return Icons.circle;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.onNavigate('home'),
          tooltip: 'กลับหน้าหลัก',
        ),
        title: const Text(
          'ประวัติการคำนวณ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
            tooltip: 'รีเฟรช',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('ลองอีกครั้ง'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Statistics Card
                    if (_stats != null)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.calculate,
                              label: 'ทั้งหมด',
                              value: '${_stats!['total_calculations'] ?? 0}',
                            ),
                            Container(
                              height: 40,
                              width: 1,
                            color: Colors.white.withValues(alpha: 0.3),
                            ),
                            _buildStatItem(
                              icon: Icons.star,
                              label: 'ยอดนิยม',
                              value: _stats!['most_popular_count']?.toString() ?? '0',
                            ),
                          ],
                        ),
                      ),

                    // History List
                    Expanded(
                      child: _calculations.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 80,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'ยังไม่มีประวัติการคำนวณ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _calculations.length,
                              itemBuilder: (context, index) {
                                final calc = _calculations[index];
                                return _buildHistoryCard(calc);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(PriceCalculation calc) {
    final color = _getOrangeColor(calc.orangeType);
    
    return Dismissible(
      key: Key(calc.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'ลบ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _deleteCalculation(calc);
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Text('ยืนยันการลบ'),
                ],
              ),
              content: Text(
                'คุณต้องการลบประวัติ "${calc.orangeName}" หรือไม่?',
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('ลบ', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _showDetailsDialog(calc);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.7), color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/${calc.orangeType}.png',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getOrangeIcon(calc.orangeType),
                            color: Colors.white,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          calc.orangeName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${calc.weightKg.toStringAsFixed(2)} กก. × ${calc.pricePerKg.toStringAsFixed(0)} บาท/กก.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(calc.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '฿${calc.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(PriceCalculation calc) {
    final color = _getOrangeColor(calc.orangeType);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.7), color],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getOrangeIcon(calc.orangeType),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                calc.orangeName,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('น้ำหนัก', '${calc.weightKg.toStringAsFixed(2)} กก.'),
            const Divider(),
            _buildDetailRow('ราคาต่อกิโลกรัม', '฿${calc.pricePerKg.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetailRow(
              'ราคารวม',
              '฿${calc.totalPrice.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const Divider(),
            _buildDetailRow(
              'วันที่',
              DateFormat('dd/MM/yyyy HH:mm:ss').format(calc.date),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? AppTheme.primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
