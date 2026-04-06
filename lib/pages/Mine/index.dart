import 'package:flutter/material.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)?.animation;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, size: 32, color: Colors.white),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'checky',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '在线',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: const [
                        _MenuItem(icon: Icons.settings, label: '设置'),
                        _MenuItem(icon: Icons.help_outline, label: '帮助'),
                        _MenuItem(icon: Icons.info_outline, label: '关于'),
                        Divider(height: 1),
                        _MenuItem(icon: Icons.logout, label: '退出登录', isDestructive: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: AnimatedBuilder(
                animation: animation ?? AlwaysStoppedAnimation(0.0),
                builder: (context, child) {
                  return Container(
                    color: Colors.black.withValues(alpha: (animation?.value ?? 0.0) * 0.5),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.black87,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      onTap: () {},
    );
  }
}

class MinePageRoute extends PageRouteBuilder {
  MinePageRoute()
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => const MinePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
              child: child,
            );
          },
          opaque: false,
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}
