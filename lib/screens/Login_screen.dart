import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/login/bloc/login_bloc.dart';
import 'package:rootysysproject/bloc/login/bloc/login_event.dart';
import 'package:rootysysproject/bloc/login/bloc/login_state.dart';

import 'package:rootysysproject/screens/Home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = usernameController.text.trim();
    final password = passwordController.text;

    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: email,
        password: password,
        // Replace these values if your backend requires the real client IP
        // or a specific device name/format.
        ip: '127.0.0.1',
        device: 'mobile',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Login failed. Please try again.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;
        final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: keyboardVisible ? 180.h : 554.h,
                      child: Image.asset(
                        'assets/images/car23.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 95.h,
                      left: 20.w,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          'assets/images/Layer_1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 11.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 17.h),
                            Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF111111),
                                fontFamily: 'Manrope',
                              ),
                            ),
                            SizedBox(height: 18.h),
                            _InputField(
                              controller: usernameController,
                              keyboardType: TextInputType.text,

                              hintText: 'User name',
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your username/email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 9.h),
                            _InputField(
                              controller: passwordController,
                              hintText: 'Password',
                              keyboardType: TextInputType.visiblePassword,

                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) {
                                if (!isLoading) _submitLogin();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20.sp,
                                  color: const Color(0xFF5C5C5C),
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            SizedBox(
                              width: 362.w,
                              height: 52.h,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _submitLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF73F700),
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: const Color(
                                    0xFF73F700,
                                  ).withValues(alpha: 0.65),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.w,
                                        height: 22.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          fontFamily: 'Source Code Pro',
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InputField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  const _InputField({
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.suffixIcon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370.w,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        textInputAction: textInputAction,
        validator: validator,
        onFieldSubmitted: onSubmitted,

        autocorrect: false,
        enableSuggestions: false,
        spellCheckConfiguration: const SpellCheckConfiguration.disabled(),

        keyboardType: keyboardType,

        style: TextStyle(fontSize: 13.sp, color: const Color(0xff222222)),
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF000000),
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
          ),
          filled: true,
          fillColor: const Color(0xffF5F5F5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 17.w,
            vertical: 10.h,
          ),
          suffixIcon: suffixIcon,
          errorMaxLines: 2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xffE4E4E4), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xff5CFF00), width: 1.3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.3),
          ),
        ),
      ),
    );
  }
}
