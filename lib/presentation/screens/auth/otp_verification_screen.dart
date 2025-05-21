import 'package:flutter/material.dart';
import 'package:trip_orbit/core/routes/app_routes.dart';
import 'package:trip_orbit/core/services/navigation_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final bool isPhoneVerification;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '',
    this.email = '',
    this.isPhoneVerification = true,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_isOtpComplete()) {
      _verifyOtp();
    }
  }

  bool _isOtpComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  Future<void> _verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    
    // TODO: Implement OTP verification logic
    
    // For now, just navigate to home
    await NavigationService.navigateToAndClearStack(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.goBack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification Code',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isPhoneVerification
                    ? 'Enter the 6-digit code sent to ${widget.phoneNumber}'
                    : 'Enter the 6-digit code sent to ${widget.email}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _onOtpDigitChanged(index, value),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement resend code logic
                  },
                  child: const Text('Resend Code'),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isOtpComplete() ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
