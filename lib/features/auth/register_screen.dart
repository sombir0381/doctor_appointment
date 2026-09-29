import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../services/auth_session_service.dart';
import '../doctor/doctor_main_screen.dart';
import '../patient/patient_main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController
  confirmPasswordController =
  TextEditingController();

  String selectedRole = 'patient';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
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
                  'Passwords do not match.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    await AuthSessionService.saveSession(
      role: selectedRole,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (selectedRole == 'doctor') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const DoctorMainScreen(),
        ),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const PatientMainScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),

              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  24,
                ),
                child: _buildRegisterCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
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
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 2),

          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.person_add_alt_1_rounded,
              color: AppTheme.primaryColor,
              size: 34,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Create your account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Join DoctorEase and manage your healthcare easily',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterCard() {
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
                'Personal details',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Tell us a little about yourself',
                style: TextStyle(
                  fontSize: 13.5,
                  color:
                  AppTheme.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 22),

              _fieldLabel('I want to register as'),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _roleCard(
                      title: 'Patient',
                      subtitle:
                      'Book appointments',
                      icon:
                      Icons.person_outline_rounded,
                      value: 'patient',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _roleCard(
                      title: 'Doctor',
                      subtitle:
                      'Manage patients',
                      icon: Icons
                          .medical_services_outlined,
                      value: 'doctor',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _fieldLabel('Full name'),

              const SizedBox(height: 8),

              TextFormField(
                controller: nameController,
                textCapitalization:
                TextCapitalization.words,
                textInputAction:
                TextInputAction.next,
                decoration: _inputDecoration(
                  hint: 'Enter your full name',
                  icon: Icons
                      .person_outline_rounded,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your name';
                  }

                  if (value.trim().length < 2) {
                    return 'Please enter a valid name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

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
                  icon:
                  Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  if (!value.contains('@') ||
                      !value.contains('.')) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Phone number'),

              const SizedBox(height: 8),

              TextFormField(
                controller: phoneController,
                keyboardType:
                TextInputType.phone,
                textInputAction:
                TextInputAction.next,
                decoration: _inputDecoration(
                  hint: '+91 98765 43210',
                  icon:
                  Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }

                  if (value.trim().length < 10) {
                    return 'Please enter a valid phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Password'),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                passwordController,
                obscureText:
                !isPasswordVisible,
                textInputAction:
                TextInputAction.next,
                decoration: _inputDecoration(
                  hint: 'Create a password',
                  icon:
                  Icons.lock_outline_rounded,
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
                      color:
                      Colors.grey.shade600,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter a password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              _fieldLabel('Confirm password'),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                confirmPasswordController,
                obscureText:
                !isConfirmPasswordVisible,
                textInputAction:
                TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (!isLoading) {
                    _register();
                  }
                },
                decoration: _inputDecoration(
                  hint: 'Re-enter your password',
                  icon:
                  Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible =
                        !isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                      color:
                      Colors.grey.shade600,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (value !=
                      passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 22),

              Container(
                padding:
                const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFF5F8FC),
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: const Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 19,
                      color:
                      AppTheme.primaryColor,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Your information is kept secure and used only to provide healthcare services.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color:
                          AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed:
                  isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppTheme.primaryColor,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
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
                        'Create Account',
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
                        'Already have an account? ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign in',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final bool selected =
        selectedRole == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(16),
      onTap: () {
        setState(() {
          selectedRole = value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor
              .withOpacity(0.07)
              : const Color(0xFFF8FAFC),
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppTheme.primaryColor
                : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor
                    .withOpacity(0.12)
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected
                    ? AppTheme.primaryColor
                    : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontWeight:
                FontWeight.w700,
                color: selected
                    ? AppTheme.primaryColor
                    : AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                color:
                AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
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
      fillColor:
      const Color(0xFFF8FAFC),
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