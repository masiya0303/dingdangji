import 'package:flutter/material.dart';

import 'tabs/home_tab.dart';
import 'tabs/category_tab.dart';
import 'tabs/stats_tab.dart';
import 'tabs/achievement_tab.dart';
import '../Mine/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeTab(),
    CategoryTab(),
    StatsTab(),
    AchievementTab(),
  ];

  final List<_TabItem> _tabItems = const [
    _TabItem(icon: Icons.home, label: '首页'),
    _TabItem(icon: Icons.category, label: '分类'),
    _TabItem(icon: Icons.bar_chart, label: '统计'),
    _TabItem(icon: Icons.emoji_events, label: '成就'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加新项目')),
    );
  }

  void _onAvatarPressed() {
    Navigator.of(context).push(MinePageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _onAvatarPressed,
              child: Stack(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'checky',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: _onAddPressed,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: _buildIOSTabBar(),
    );
  }

  Widget _buildIOSTabBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_tabItems.length, (index) {
            final isSelected = index == _currentIndex;
            return _buildTabItem(_tabItems[index], index, isSelected);
          }),
        ),
      ),
    );
  }

  Widget _buildTabItem(_TabItem item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? const Color(0xFFFFECF2) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFFFFECF2) : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;

  const _TabItem({required this.icon, required this.label});
}
