import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../data/models/server.dart';
import '../../core/theme/app_theme.dart';

class ServerSidebar extends StatelessWidget {
  final List<Server> servers;
  final int? selectedServerIndex;
  final Function(int) onServerSelected;
  final VoidCallback onHomeTap;
  final VoidCallback onAddServer;
  final VoidCallback onSettingsTap;

  const ServerSidebar({
    super.key,
    required this.servers,
    required this.selectedServerIndex,
    required this.onServerSelected,
    required this.onHomeTap,
    required this.onAddServer,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: AppColors.homeBg,
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildServerButton(
            icon: Icons.home,
            isSelected: selectedServerIndex == null,
            onTap: onHomeTap,
            showBadge: false,
          ),
          const SizedBox(height: 8),
          Container(width: 32, height: 2, color: Colors.black12),
          const SizedBox(height: 8),
          _buildServerButton(
            icon: Icons.add,
            isAdd: true,
            onTap: onAddServer,
            showBadge: false,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < servers.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _buildServerButton(
                        label: servers[i].name.isNotEmpty
                            ? servers[i].name[0].toUpperCase()
                            : '?',
                        isSelected: selectedServerIndex == i,
                        onTap: () => onServerSelected(i),
                        hasNotification: servers[i].hasNotification,
                        showBadge: servers[i].hasNotification,
                        avatar: servers[i].avatarColor,
                        isAvatarColor: true,
                        avatarImageBytes: servers[i].avatarImageBytes,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildServerButton(
            icon: Icons.settings,
            onTap: onSettingsTap,
            showBadge: false,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildServerButton({
    IconData? icon,
    String? label,
    bool isSelected = false,
    bool isAdd = false,
    bool showBadge = false,
    bool hasNotification = false,
    String? avatar,
    bool isAvatarColor = false,
    Uint8List? avatarImageBytes,
    VoidCallback? onTap,
  }) {
    final Color bgColor = isSelected
        ? AppColors.primary
        : (isAvatarColor && avatar != null
              ? _getColorFromHex(avatar)
              : AppColors.mediumGray);

    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: label ?? (icon == Icons.home ? 'Home' : (icon == Icons.settings ? 'Settings' : 'Add Server')),
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 500),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: avatarImageBytes != null
                      ? SizedBox(
                          width: 46,
                          height: 46,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.memory(
                              avatarImageBytes,
                              width: 46,
                              height: 46,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : (isAvatarColor && avatar != null
                            ? Text(
                                label ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              )
                            : _buildIconOrLabel(icon, label, isAdd)),
                ),
                if (showBadge && !isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.notification,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.lightGray,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconOrLabel(IconData? icon, String? label, bool isAdd) {
    if (icon != null) {
      return Icon(icon, color: Colors.black87, size: 24);
    }
    return Text(
      label ?? '',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }
}