import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/services/user_api_service.dart';

enum ForgotPasswordStage { enterEmail, enterCode, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _userApiService = UserApiService();
  
  bool _isLoading = false;
  ForgotPasswordStage _stage = ForgotPasswordStage.enterEmail;

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      final message = await _userApiService.forgotPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        setState(() {
          _stage = ForgotPasswordStage.enterCode;
        });
      }
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _userApiService.resetPassword(
        _codeController.text.trim(),
        _newPasswordController.text.trim(),
      );
      if (mounted) setState(() => _stage = ForgotPasswordStage.success);
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _userApiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên Mật Khẩu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: _buildStageContent(),
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    switch (_stage) {
      case ForgotPasswordStage.enterEmail:
        return _buildEnterEmailStage();
      case ForgotPasswordStage.enterCode:
        return _buildEnterCodeStage();
      case ForgotPasswordStage.success:
        return _buildSuccessStage();
    }
  }

  Widget _buildEnterEmailStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nhập email của bạn để nhận mã đặt lại mật khẩu.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || !value.contains('@')) ? 'Email không hợp lệ' : null,
        ),
        const SizedBox(height: 24),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _sendCode, child: const Text('GỬI MÃ')),
      ],
    );
  }

  Widget _buildEnterCodeStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Một mã 6 chữ số đã được gửi đến ${_emailController.text}. Vui lòng nhập mã và mật khẩu mới của bạn.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: 'Mã 6 chữ số'),
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || value.length != 6) ? 'Mã phải có 6 chữ số' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
          obscureText: true,
          validator: (value) => (value == null || value.length < 6) ? 'Mật khẩu phải có ít nhất 6 ký tự' : null,
        ),
        const SizedBox(height: 24),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _resetPassword, child: const Text('ĐẶT LẠI MẬT KHẨU')),
      ],
    );
  }

  Widget _buildSuccessStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 16),
        Text(
          'Thành công!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Mật khẩu của bạn đã được đặt lại. Vui lòng đăng nhập lại.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('TRỞ VỀ ĐĂNG NHẬP'),
        ),
      ],
    );
  }
}


