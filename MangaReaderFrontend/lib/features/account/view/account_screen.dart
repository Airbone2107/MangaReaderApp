import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';
import '../logic/account_logic.dart';

/// Màn hình quản lý tài khoản người dùng.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountScreenLogic _logic = AccountScreenLogic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logic.init(context, () {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản của bạn')),
      body: _buildBody(),
    );
  }

  /// Xây dựng phần thân theo trạng thái đăng nhập và tải dữ liệu.
  Widget _buildBody() {
    if (_logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_logic.user == null) {
      return Center(
        child: ElevatedButton(
          onPressed: _logic.handleSignIn,
          child: const Text('Đăng nhập bằng Google'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _logic.refreshUserData,
      child: _buildUserContent(),
    );
  }

  /// Nội dung khi người dùng đã đăng nhập.
  Widget _buildUserContent() {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(_logic.user!.displayName),
          accountEmail: Text(_logic.user!.email),
          currentAccountPicture:
              _logic.user!.photoURL != null && _logic.user!.photoURL!.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(_logic.user!.photoURL!),
                )
              : CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    _logic.user!.displayName.isNotEmpty
                        ? _logic.user!.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              _logic.buildMangaListView(
                'Truyện Theo Dõi',
                _logic.user!.following,
                isFollowing: true,
              ),
              const SizedBox(height: 16),
              _logic.buildMangaListView(
                'Lịch Sử Đọc Truyện',
                _logic.user!.readingProgress
                    .map((ReadingProgress p) => p.mangaId)
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _logic.handleSignOut,
                  child: const Text('Đăng xuất'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
