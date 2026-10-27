import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rootysysproject/repositories/Api/api_client.dart';
import 'package:rootysysproject/screens/customer_screen.dart';

class CreateNewCustomerScreen extends StatefulWidget {
  final bool isEdit;
  final String? customerId;

  const CreateNewCustomerScreen({
    super.key,
    this.isEdit = false,

    this.customerId,
  });

  @override
  State<CreateNewCustomerScreen> createState() =>
      _CreateNewCustomerScreenState();
}

class _CreateNewCustomerScreenState extends State<CreateNewCustomerScreen> {
  bool isCustomerTypeExpanded = false;
  bool isLoading = false;
  bool isFetchingCustomer = false;

  String? selectedCustomerType;

  String address = '123 Main St, Apartment 4B';
  String country = 'India';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      _loadCustomerDetails();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    cityController.dispose();

    apiClient.close();

    super.dispose();
  }

  // --------------------------------------------------
  // GET CUSTOMER DETAILS FOR EDITING
  // --------------------------------------------------

  Future<void> _loadCustomerDetails() async {
    final customerId = widget.customerId;

    if (customerId == null || customerId.trim().isEmpty) {
      _showMessage('Customer ID is missing');
      return;
    }

    setState(() {
      isFetchingCustomer = true;
    });

    try {
      final response = await apiClient.getCustomerById(customerId);

      if (!mounted) return;

      if (response is! Map) {
        _showMessage('Invalid customer response from server');
        return;
      }

      if (response['success'] == false) {
        _showMessage(
          response['message']?.toString() ?? 'Failed to load customer',
        );
        return;
      }

      // Expected structure:
      // {
      //   "success": true,
      //   "data": {
      //     "_id": "...",
      //     "user_id": {
      //       "name": "...",
      //       "email": "...",
      //       "phone": "..."
      //     },
      //     "customer_type": "customer",
      //     "city": "...",
      //     "phone_number": "...",
      //     "whatsapp_number": "..."
      //   }
      // }

      final dynamic rawData = response['data'];

      if (rawData is! Map) {
        _showMessage('Customer details not found');
        return;
      }

      final customerData = Map<String, dynamic>.from(rawData);

      final dynamic rawUser = customerData['user_id'];

      final Map<String, dynamic> userData = rawUser is Map
          ? Map<String, dynamic>.from(rawUser)
          : <String, dynamic>{};

      nameController.text =
          (userData['name'] ??
                  customerData['name'] ??
                  customerData['customer_name'] ??
                  '')
              .toString();

      emailController.text = (userData['email'] ?? customerData['email'] ?? '')
          .toString();

      contactController.text =
          (customerData['phone_number'] ??
                  userData['phone'] ??
                  customerData['phone'] ??
                  '')
              .toString();

      whatsappController.text =
          (customerData['whatsapp_number'] ??
                  customerData['whatsappNumber'] ??
                  '')
              .toString();

      cityController.text = (customerData['city'] ?? '').toString();

      address = (customerData['address'] ?? address).toString();
      country = (customerData['country'] ?? country).toString();

      final type =
          (customerData['customer_type'] ?? customerData['customerType'] ?? '')
              .toString()
              .toLowerCase();

      if (type == 'company' || type == 'business') {
        selectedCustomerType = 'Business';
      } else if (type == 'other') {
        selectedCustomerType = 'Other';
      } else if (type == 'customer' || type == 'individual') {
        selectedCustomerType = 'Individual';
      } else {
        selectedCustomerType = null;
      }

      setState(() {});

      debugPrint('CUSTOMER DETAILS LOADED: $customerData');
    } on ApiException catch (e) {
      debugPrint('GET CUSTOMER ERROR: ${e.message}');
      debugPrint('STATUS CODE: ${e.statusCode}');
      debugPrint('RESPONSE DATA: ${e.responseData}');

      if (mounted) {
        _showMessage('Failed to load customer: ${e.message}');
      }
    } catch (e) {
      debugPrint('UNEXPECTED GET CUSTOMER ERROR: $e');

      if (mounted) {
        _showMessage('Something went wrong while loading customer');
      }
    } finally {
      if (mounted) {
        setState(() {
          isFetchingCustomer = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isFetchingCustomer
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 90.h),

                    // HEADER
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 28.w,
                            height: 28.w,
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
                        Expanded(
                          child: Text(
                            widget.isEdit
                                ? 'Edit Customer'
                                : 'Create New Customer',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              height: 1.0,
                              color: const Color(0xFF111111),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // CUSTOMER TYPE
                    _buildLabel('Customer Type'),
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
                                  selectedCustomerType ??
                                      'Select Customer Type',
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

                    // CUSTOMER NAME
                    _buildLabel('Customer Name'),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: nameController,
                      hintText: 'Enter customer name',
                    ),

                    SizedBox(height: 20.h),

                    // CONTACT NUMBER
                    _buildLabel('Contact Number'),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: contactController,
                      hintText: '0000 0000 00',
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 20.h),

                    // WHATSAPP NUMBER
                    _buildLabel('WhatsApp Number'),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: whatsappController,
                      hintText: '0000 0000 00',
                      keyboardType: TextInputType.phone,
                    ),

                    SizedBox(height: 20.h),

                    // EMAIL
                    _buildLabel('Customer Email ID'),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: emailController,
                      hintText: 'rahul@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 20.h),

                    // CITY
                    _buildLabel('City'),
                    SizedBox(height: 10.h),
                    _buildTextField(
                      controller: cityController,
                      hintText: 'Enter city',
                    ),

                    SizedBox(height: 40.h),

                    // CREATE / UPDATE BUTTON
                    Center(
                      child: GestureDetector(
                        onTap: isLoading ? null : _saveCustomer,
                        child: Container(
                          width: 362.w,
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF73F700),
                            borderRadius: BorderRadius.circular(46.r),
                          ),
                          alignment: Alignment.center,
                          child: isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  widget.isEdit
                                      ? 'Update Customer'
                                      : 'Create and Continue',
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

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
    );
  }

  // --------------------------------------------------
  // SAVE CUSTOMER: CREATE OR UPDATE
  // --------------------------------------------------

  Future<void> _saveCustomer() async {
    if (selectedCustomerType == null) {
      _showMessage('Please select customer type');
      return;
    }

    if (nameController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      _showMessage('Please fill name, contact number and email');
      return;
    }

    if (widget.isEdit &&
        (widget.customerId == null || widget.customerId!.trim().isEmpty)) {
      _showMessage('Customer ID is missing. Cannot update customer.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String customerType = selectedCustomerType == 'Business'
          ? 'company'
          : selectedCustomerType == 'Other'
          ? 'other'
          : 'customer';

      // NOTE:
      // These field names should match your backend's accepted request body.
      // Your existing create request uses "phone" for the WhatsApp number.
      // This update request uses "whatsapp_number" to match the response field.

      final Map<String, dynamic> customerData = {
        'customer_type': customerType,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'city': cityController.text.trim(),
        'address': address,
        'country': country,
        'phone_number': contactController.text.trim(),
        'whatsapp_number': whatsappController.text.trim(),
      };

      debugPrint(
        widget.isEdit
            ? 'UPDATE CUSTOMER REQUEST: $customerData'
            : 'CREATE CUSTOMER REQUEST: $customerData',
      );

      final dynamic response;

      if (widget.isEdit) {
        response = await apiClient.updateCustomer(
          customerId: widget.customerId!.trim(),
          customerData: customerData,
        );
      } else {
        // Keep the existing create API payload format.
        final Map<String, dynamic> createData = {
          'customer_type': customerType,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'city': cityController.text.trim().isEmpty
              ? 'Mumbai'
              : cityController.text.trim(),
          'address': address,
          'country': country,
          'phone_number': contactController.text.trim(),
          'phone': whatsappController.text.trim(),
        };

        response = await apiClient.createCustomer(body: createData);
      }

      if (!mounted) return;

      if (response is Map && response['success'] == true) {
        final message =
            response['message']?.toString() ??
            (widget.isEdit
                ? 'Customer updated successfully'
                : 'Customer created successfully');

        _showMessage(message);

        if (widget.isEdit) {
          // Return to CustomerProfileScreen after a successful update.
          Navigator.pop(context, true);
        } else {
          // Preserve the existing create flow.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SelectCustomerScreen()),
          );
        }
      } else {
        _showMessage(
          response is Map
              ? response['message']?.toString() ??
                    (widget.isEdit
                        ? 'Failed to update customer'
                        : 'Failed to create customer')
              : 'Invalid server response',
        );
      }
    } on ApiException catch (e) {
      debugPrint('CUSTOMER SAVE API ERROR: ${e.message}');
      debugPrint('STATUS CODE: ${e.statusCode}');
      debugPrint('RESPONSE DATA: ${e.responseData}');

      if (!mounted) return;

      _showMessage('Failed to save customer: ${e.message}');
    } catch (e) {
      debugPrint('UNEXPECTED CUSTOMER SAVE ERROR: $e');

      if (!mounted) return;

      _showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // LABEL
  // --------------------------------------------------

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

  // --------------------------------------------------
  // TEXT FIELD
  // --------------------------------------------------

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

  // --------------------------------------------------
  // CUSTOMER TYPE DROPDOWN OPTION
  // --------------------------------------------------

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

  // --------------------------------------------------
  // SNACKBAR MESSAGE
  // --------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
