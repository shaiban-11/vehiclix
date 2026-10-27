import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_bloc.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_event.dart';
import 'package:rootysysproject/bloc/customer/bloc/customer_state.dart';
import 'package:rootysysproject/repositories/models/customer_model.dart';
import 'package:rootysysproject/screens/CreatenewCutomer_screen.dart';
import 'package:rootysysproject/screens/Customer_profile.dart';

class SelectCustomerScreen extends StatefulWidget {
  const SelectCustomerScreen({super.key});

  @override
  State<SelectCustomerScreen> createState() => _SelectCustomerScreenState();
}

class _SelectCustomerScreenState extends State<SelectCustomerScreen> {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color rContainerColor = Color(0x2693FF26);
  static const Color companyTextColor = Color(0x7D000000);
  static const Color arrowContainerColor = Color(0xFFF0F0F0);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomerBloc>().add(
        const CustomerFetchRequested(page: 1, limit: 100),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Reads a field from the customer object while supporting common API
  // naming variations (for example, name/full_name/customer_name).
  String _readText(dynamic object, List<String> keys, {String fallback = ''}) {
    if (object == null) return fallback;
    for (final key in keys) {
      try {
        dynamic value;
        if (object is Map) {
          value = object[key];
        } else {
          switch (key) {
            case 'id':
            case '_id':
            case 'customerId':
            case 'customer_id':
              value = object.id;
              if (key == '_id') value = object.id;
              break;
            case 'name':
            case 'full_name':
            case 'customer_name':
            case 'fullName':
              value = object.name;
              break;
            case 'email':
              value = object.email;
              break;
            case 'company':
            case 'company_name':
            case 'companyName':
              value = object.company;
              break;
            case 'type':
            case 'customer_type':
              value = object.type;
              break;
          }
        }
        if (value != null && value.toString().trim().isNotEmpty) {
          if (value is Map) {
            value = value['name'] ?? value['title'] ?? value['company_name'];
          }
          if (value != null && value.toString().trim().isNotEmpty) {
            return value.toString();
          }
        }
      } catch (_) {
        // Try the next supported field name.
      }
    }
    return fallback;
  }

  List<CustomerData> _readCustomers(CustomerState state) {
    if (state is CustomerSuccess) {
      return state.customerResponse.data ?? <CustomerData>[];
    }

    return <CustomerData>[];
  }

  bool _isLoading(dynamic state) {
    try {
      final dynamic status = state.status;
      final value = status.toString().toLowerCase();
      return value.contains('loading');
    } catch (_) {
      return false;
    }
  }

  String _errorMessage(dynamic state) {
    for (final key in ['errorMessage', 'error', 'message']) {
      try {
        dynamic value;
        switch (key) {
          case 'errorMessage':
            value = state.errorMessage;
            break;
          case 'error':
            value = state.error;
            break;
          case 'message':
            value = state.message;
            break;
        }
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      } catch (_) {
        // Try the next possible error field.
      }
    }
    return 'Unable to load customers.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 28.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: black,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Select Customer',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: black,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 28.h, left: 16.w, right: 16.w),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.trim().toLowerCase()),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE9E9E9),
                    hintText: 'Search Customer...',
                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF888888),
                    ),
                    prefixIcon: Icon(Icons.search, size: 24.sp, color: black),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, color: black),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewCustomerScreen(isEdit: false),
                    ),
                  ).then((_) {
                    if (!mounted) return;
                    context.read<CustomerBloc>().add(
                      const CustomerFetchRequested(page: 1, limit: 100),
                    );
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 54.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7FFF00),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, color: black, size: 25.sp),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Create New Customer',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: black,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),
            Expanded(
              child: BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  final dynamic dynamicState = state;
                  if (_isLoading(dynamicState)) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customers = _readCustomers(dynamicState);
                  final filteredCustomers = customers.where((customer) {
                    final name = _readText(customer, [
                      'name',
                      'full_name',
                      'customer_name',
                      'fullName',
                    ]).toLowerCase();
                    final company = _readText(customer, [
                      'company',
                      'company_name',
                      'companyName',
                      'type',
                    ]).toLowerCase();
                    final email = _readText(customer, ['email']).toLowerCase();
                    return _searchQuery.isEmpty ||
                        name.contains(_searchQuery) ||
                        company.contains(_searchQuery) ||
                        email.contains(_searchQuery);
                  }).toList();

                  if (filteredCustomers.isEmpty) {
                    final error = _errorMessage(dynamicState);
                    final hasError = error != 'Unable to load customers.';
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _searchQuery.isNotEmpty
                                  ? Icons.search_off
                                  : Icons.people_outline,
                              size: 42.sp,
                              color: const Color(0xFF888888),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No matching customers found'
                                  : (hasError ? error : 'No customers found'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14.sp,
                                color: const Color(0xFF737373),
                              ),
                            ),
                            if (_searchQuery.isEmpty) ...[
                              SizedBox(height: 12.h),
                              TextButton(
                                onPressed: () =>
                                    context.read<CustomerBloc>().add(
                                      const CustomerFetchRequested(
                                        page: 1,
                                        limit: 100,
                                      ),
                                    ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                    itemCount: filteredCustomers.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      final customerId = _readText(customer, [
                        'id',
                        '_id',
                        'customerId',
                        'customer_id',
                      ]);
                      final customerName = _readText(customer, [
                        'name',
                        'full_name',
                        'customer_name',
                        'fullName',
                      ], fallback: 'Unnamed Customer');
                      final company = _readText(customer, [
                        'company',
                        'company_name',
                        'companyName',
                        'type',
                      ], fallback: 'Customer');
                      final initial = customerName.trim().isNotEmpty
                          ? customerName.trim()[0].toUpperCase()
                          : 'C';

                      return GestureDetector(
                        onTap: () {
                          if (customerId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Customer ID is missing in the API response.',
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CustomerProfileScreen(customerId: customerId),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56.h,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(11.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38.w,
                                height: 38.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: rContainerColor,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Text(
                                  initial,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customerName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: black,
                                        height: 1.0,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      company,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: companyTextColor,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: BoxDecoration(
                                  color: arrowContainerColor,
                                  borderRadius: BorderRadius.circular(28.8.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.chevron_right,
                                    size: 18.sp,
                                    color: black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
