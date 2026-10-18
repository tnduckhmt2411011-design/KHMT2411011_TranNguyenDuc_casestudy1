import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Cá nhân',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              // Khu vực hồ sơ người dùng theo ảnh màn 7
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBF3FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF1E6BEB),
                      size: 38,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Nguyễn Văn A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'nguyenvana@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Danh sách menu cài đặt
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Thông tin cá nhân',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Cài đặt ngân sách',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.format_list_bulleted,
                title: 'Danh mục chi tiêu',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.cloud_upload_outlined,
                title: 'Sao lưu dữ liệu',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: 'Đổi mật khẩu',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Đăng xuất',
                textColor: const Color(0xFFE53935),
                iconColor: const Color(0xFFE53935),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = const Color(0xFF0F172A),
    Color iconColor = const Color(0xFF64748B),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
