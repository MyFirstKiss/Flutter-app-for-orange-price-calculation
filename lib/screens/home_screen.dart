import 'package:flutter/material.dart';
import '../models/orange_type.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.spacingXL),
                
                const Text(
                  'ข้อมูลผลส้ม',
                  style: AppTheme.heading1,
                ),
                const SizedBox(height: AppTheme.spacingS),
                const Text(
                  'ระบบจัดการข้อมูลและคำนวณราคาผลส้ม',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                
                // Orange Image with Emoji
                Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade100,
                        Colors.orange.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/oranges.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Info Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${orangeTypes.length}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'ชนิด',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'A+',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'เกรด',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Menu Buttons
                _buildMenuButton(
                  context: context,
                  title: 'ข้อมูลที่จัดเก็บ',
                  subtitle: 'ดูขนาดและมิติของผลส้ม',
                  emoji: '📊',
                  colors: [Colors.orange.shade500, Colors.orange.shade600],
                  onTap: () => onNavigate('data'),
                ),
                const SizedBox(height: 12),
                _buildMenuButton(
                  context: context,
                  title: 'คำนวณราคา',
                  subtitle: 'กรอกน้ำหนักเพื่อคำนวณราคา',
                  emoji: '🧮',
                  colors: [Colors.green.shade500, Colors.green.shade600],
                  onTap: () => onNavigate('calculator'),
                ),
                const SizedBox(height: 12),
                _buildMenuButton(
                  context: context,
                  title: 'ราคาล่าสุด',
                  subtitle: 'ดูราคาแบบ Real-time จาก API',
                  emoji: '💰',
                  colors: [Colors.blue.shade500, Colors.blue.shade600],
                  onTap: () => onNavigate('liveprices'),
                ),
                const SizedBox(height: 12),
                _buildMenuButton(
                  context: context,
                  title: 'ประวัติการคำนวณ',
                  subtitle: 'ดูประวัติและสถิติการคำนวณราคา',
                  emoji: '📜',
                  colors: [Colors.purple.shade500, Colors.purple.shade600],
                  onTap: () => onNavigate('history'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String emoji,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors[0].withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
