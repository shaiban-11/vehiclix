import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/screens/Vehicleinfo_screen.dart';

class CreateNewCustomerScreen extends StatefulWidget {
  const CreateNewCustomerScreen({super.key});

  @override
  State<CreateNewCustomerScreen> createState() =>
      _CreateNewCustomerScreenState();
}

class _CreateNewCustomerScreenState extends State<CreateNewCustomerScreen> {
  bool isCustomerTypeExpanded = false;
  String? selectedCustomerType;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController whatsappController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 90.h),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Text(
                    'Create New Customer',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      height: 1.0,
                      color: const Color(0xFF111111),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // ------------------------------------------------
              // CUSTOMER TYPE
              // ------------------------------------------------
              Text(
                'Customer Type',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: const Color(0xFF222222),
                ),
              ),

              SizedBox(height: 12.h),

              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCustomerTypeExpanded = !isCustomerTypeExpanded;
                      });
                    },
                    child: Container(
                      width: 370.w,
                      height: 57.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                          bottomLeft: Radius.circular(
                            isCustomerTypeExpanded ? 0 : 12.r,
                          ),
                          bottomRight: Radius.circular(
                            isCustomerTypeExpanded ? 0 : 12.r,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCustomerType ?? 'Select Customer Type',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: const Color(0xFF222222),
                            ),
                          ),

                          Icon(
                            isCustomerTypeExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 22.sp,
                            color: const Color(0xFF222222),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isCustomerTypeExpanded)
                    Container(
                      width: 370.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          _customerTypeOption('Individual'),
                          _customerTypeOption('Business'),
                          _customerTypeOption('Other'),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 28.h),

              // ------------------------------------------------
              // CUSTOMER NAME
              // ------------------------------------------------
              _buildLabel('Customer Name'),

              SizedBox(height: 10.h),

              _buildTextField(
                controller: nameController,
                hintText: 'Enter customer name',
              ),

              SizedBox(height: 20.h),

              // ------------------------------------------------
              // CONTACT NUMBER
              // ------------------------------------------------
              _buildLabel('Contact Number'),

              SizedBox(height: 10.h),

              _buildTextField(
                controller: contactController,
                hintText: '0000 0000 00',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20.h),

              _buildLabel('WhatsApp Number'),

              SizedBox(height: 10.h),

              _buildTextField(
                controller: whatsappController,
                hintText: '0000 0000 00',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 20.h),

              _buildLabel('Customer Email ID'),

              SizedBox(height: 10.h),

              _buildTextField(
                controller: emailController,
                hintText: 'rahul@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 150.h),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleInformationScreen(),
                      ),
                    );
                    _createAndContinue();
                  },
                  child: Container(
                    width: 362.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF73F700),
                      borderRadius: BorderRadius.circular(46.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Create and Continue',
                      style: TextStyle(
                        fontFamily: 'Source Code Pro',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        height: 1.0,
        color: const Color(0xFF222222),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      width: 370.w,
      height: 57.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xFF222222),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: const Color(0xFF808080),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 18.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _customerTypeOption(String value) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCustomerType = value;
          isCustomerTypeExpanded = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
        child: Text(
          value,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  void _createAndContinue() {
    debugPrint('Customer Type: $selectedCustomerType');
    debugPrint('Name: ${nameController.text}');
    debugPrint('Contact: ${contactController.text}');
    debugPrint('WhatsApp: ${whatsappController.text}');
    debugPrint('Email: ${emailController.text}');
  }
}
