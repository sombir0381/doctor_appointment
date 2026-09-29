import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/auth_session_service.dart';
import '../doctor/doctor_main_screen.dart';
import '../patient/patient_main_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    final String email =
    emailController.text.trim().toLowerCase();

    final String password =
    passwordController.text.trim();

    String? role;

    if (email == 'doctor@example.com' &&
        password.length >= 6) {
      role = 'doctor';
    } else if (email == 'patient@example.com' &&
        password.length >= 6) {
      role = 'patient';
    }

    if (role == null) {
      setState(() {
        isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Invalid email or password.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      return;
    }

    await AuthSessionService.saveSession(
      role: role,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (role == 'doctor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const DoctorMainScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const PatientMainScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(size),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24,
                ),
                child: _buildLoginCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        28,
        24,
        38,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: AppTheme.primaryColor,
              size: 38,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'DoctorEase',
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Your health, our priority',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back 👋',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Sign in to continue to your account',
                style: TextStyle(
                  fontSize: 14,
                  color:
                  AppTheme.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 26),

              _fieldLabel('Email address'),

              const SizedBox(height: 8),

              TextFormField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                textInputAction:
                TextInputAction.next,
                decoration: _inputDecoration(
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  final email =
                  value.trim();

                  if (!email.contains('@') ||
                      !email.contains('.')) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              _fieldLabel('Password'),

              const SizedBox(height: 8),

              TextFormField(
                controller: passwordController,
                obscureText:
                !isPasswordVisible,
                textInputAction:
                TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (!isLoading) {
                    _login();
                  }
                },
                decoration: _inputDecoration(
                  hint: 'Enter your password',
                  icon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible =
                        !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter your password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                  isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 23,
                    width: 23,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons
                            .arrow_forward_rounded,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color:
                        Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color:
                      AppTheme.secondaryTextColor,
                      fontSize: 14,
                    ),
                    children: [
                      const TextSpan(
                        text:
                        "Don't have an account? ",
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create account',
                            style: TextStyle(
                              color:
                              AppTheme.primaryColor,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildTestAccountBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestAccountBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FC),
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Demo accounts',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Patient: patient@example.com',
            style: TextStyle(fontSize: 12.5),
          ),
          SizedBox(height: 3),
          Text(
            'Doctor: doctor@example.com',
            style: TextStyle(fontSize: 12.5),
          ),
          SizedBox(height: 3),
          Text(
            'Password: any 6+ characters',
            style: TextStyle(
              fontSize: 12.5,
              color:
              AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textColor,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: Colors.grey.shade600,
        size: 21,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}