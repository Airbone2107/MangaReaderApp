import 'package:flutter/material.dart';
import 'package:manga_reader_app/features/auth/view/login_screen.dart';
import 'package:manga_reader_app/features/auth/view/register_screen.dart';
import '../logic/account_logic.dart';

/// Màn hình quản lý tài khoản người dùng.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  final AccountScreenLogic _logic = AccountScreenLogic();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    _tabController.dispose();
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
      return _buildLoginOptions();
    }
    return RefreshIndicator(
      onRefresh: _logic.refreshUserData,
      child: _buildUserContent(),
    );
  }

  /// Hiển thị các lựa chọn đăng nhập/đăng ký.
  Widget _buildLoginOptions() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double topSpacing = constraints.maxHeight * 0.12; // đẩy logo lên ~12% màn hình
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: topSpacing),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final bool? success = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    if (success == true) {
                      _logic.refreshUserData();
                    }
                  },
                  child: const Text('Đăng nhập bằng Email'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('Đăng ký tài khoản mới'),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('HOẶC'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Image.asset('assets/google_logo.png', height: 24.0),
                  label: const Text('Đăng nhập bằng Google'),
                  onPressed: _logic.handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Nội dung khi người dùng đã đăng nhập.
  Widget _buildUserContent() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: UserAccountsDrawerHeader(
              accountName: Text(_logic.user!.displayName),
              accountEmail: Text(_logic.user!.email),
              currentAccountPicture:
                  _logic.user!.photoURL != null && _logic.user!.photoURL!.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(_logic.user!.photoURL!),
                    )
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        _logic.user!.displayName.isNotEmpty
                            ? _logic.user!.displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
              margin: EdgeInsets.zero,
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Theo dõi'),
                  Tab(text: 'Lịch sử'),
                ],
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _logic.buildFollowingTab(),
          _logic.buildHistoryTab(),
        ],
      ),
    );
  }

}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
