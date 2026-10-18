import 'package:flutter/material.dart';
import '../pages/home_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hinh anh logo vi tien
                    Image.asset(
                      'assets/images/logo.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3FF),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 70,
                            color: Color(0xFF1E6BEB),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Expense Manager',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Nut Bat dau xanh duong theo anh man 1
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Chuyen sang man hinh chinh bang pushReplacement theo quyet dinh mac dinh 4
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6BEB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Tuong thich kiem thu
              const Opacity(
                opacity: 0.0,
                child: SizedBox(
                  width: 0,
                  height: 0,
                  child: Text('Quản lý thu chi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
