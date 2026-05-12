import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/server.dart';
import '../../../presentation/components/server_sidebar.dart';
import '../../../core/theme/app_theme.dart';

enum RightPageType { welcome, createWorld, settings, theme, mainContent }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Server> _servers = [];
  int? _selectedServerIndex;
  String? _selectedChannelId;
  RightPageType _rightPageType = RightPageType.welcome;
  String? _backgroundImage;
  String? _previewWallpaper;
  Uint8List? _previewWallpaperImage;
  Uint8List? _backgroundImageBytes;
  final _imagePicker = ImagePicker();

  Server? get _selectedServer =>
      _selectedServerIndex != null ? _servers[_selectedServerIndex!] : null;

  Channel? get _selectedChannel => _selectedServer?.channels.firstWhere(
    (c) => c.id == _selectedChannelId,
    orElse: () => _selectedServer!.channels.first,
  );

  void _onServerSelected(int index) {
    setState(() {
      _selectedServerIndex = index;
      _selectedChannelId = null;
      _rightPageType = RightPageType.mainContent;
    });
  }

  void _onHomeTap() {
    setState(() {
      _selectedServerIndex = null;
      _selectedChannelId = null;
      _rightPageType = RightPageType.welcome;
    });
  }

  void _onAddServer() {
    setState(() {
      _rightPageType = RightPageType.createWorld;
    });
  }

  void _onSettingsTap() {
    setState(() {
      _rightPageType = RightPageType.settings;
    });
  }

  void _createWorld(
    String name,
    String description,
    String avatarColor,
    Uint8List? avatarImageBytes,
  ) {
    setState(() {
      final newServer = Server(
        name: name,
        description: description,
        avatarColor: avatarColor,
        avatarImageBytes: avatarImageBytes,
        channels: [],
      );
      _servers.add(newServer);
      _selectedServerIndex = _servers.length - 1;
      _rightPageType = RightPageType.mainContent;
    });
  }

  void _onChannelSelected(Channel channel) {
    setState(() {
      _selectedChannelId = channel.id;
    });
  }

  void _openThemeSettings() {
    setState(() {
      _rightPageType = RightPageType.theme;
    });
  }

  void _setPreviewWallpaper(String? colorKey) {
    setState(() {
      _previewWallpaper = colorKey;
      _previewWallpaperImage = null;
    });
  }

  void _setPreviewWallpaperImage(Uint8List bytes) {
    setState(() {
      _previewWallpaperImage = bytes;
      _previewWallpaper = null;
    });
  }

  void _applyWallpaper() {
    setState(() {
      _backgroundImage = _previewWallpaper;
      _backgroundImageBytes = _previewWallpaperImage;
      // 应用壁纸后返回主页面
      if (_servers.isNotEmpty) {
        _rightPageType = RightPageType.mainContent;
      }
    });
  }

  void _clearWallpaper() {
    setState(() {
      _backgroundImage = null;
      _previewWallpaper = null;
      _backgroundImageBytes = null;
      _previewWallpaperImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          ServerSidebar(
            servers: _servers,
            selectedServerIndex: _selectedServerIndex,
            onServerSelected: _onServerSelected,
            onHomeTap: _onHomeTap,
            onAddServer: _onAddServer,
            onSettingsTap: _onSettingsTap,
          ),
          Expanded(child: _buildRightContent()),
        ],
      ),
    );
  }

  Widget _buildRightContent() {
    switch (_rightPageType) {
      case RightPageType.welcome:
        return _buildWelcomeScreen();
      case RightPageType.createWorld:
        return _CreateWorldPage(
          onCreate: _createWorld,
          onCancel: () =>
              setState(() => _rightPageType = RightPageType.welcome),
        );
      case RightPageType.settings:
        return _buildSettingsScreen();
      case RightPageType.theme:
        return _buildThemeScreen();
      case RightPageType.mainContent:
        return _buildMainContent();
    }
  }

  Widget _buildWelcomeScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.chat_bubble_outline, size: 80, color: AppColors.primary),
            SizedBox(height: 24),
            Text(
              '欢迎',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '点击左侧 + 创建一个新世界',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(
            '设置',
            onBack: () =>
                setState(() => _rightPageType = RightPageType.welcome),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingsItem(
                  icon: Icons.palette_outlined,
                  title: '主题与外观',
                  subtitle: '更换壁纸和主题颜色',
                  onTap: _openThemeSettings,
                ),
                const SizedBox(height: 12),
                _buildSettingsItem(
                  icon: Icons.api_outlined,
                  title: 'API 设置',
                  subtitle: '配置 API 连接',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(
            '主题与外观',
            onBack: () =>
                setState(() => _rightPageType = RightPageType.settings),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '壁纸预览',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showWallpaperOptions(),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _previewWallpaper != null
                              ? _getWallpaperColor(_previewWallpaper)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFEEEEEE),
                            width: 1,
                          ),
                          image: _previewWallpaperImage != null
                              ? DecorationImage(
                                  image: MemoryImage(_previewWallpaperImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            (_previewWallpaper == null &&
                                _previewWallpaperImage == null)
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      '点击上传壁纸',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '点击更换壁纸',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              (_previewWallpaper != null ||
                                  _previewWallpaperImage != null)
                              ? () {
                                  _clearWallpaper();
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFEEEEEE)),
                          ),
                          child: const Text(
                            '清除',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (_previewWallpaper != null ||
                                  _previewWallpaperImage != null)
                              ? () {
                                  _applyWallpaper();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            '应用壁纸',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWallpaperOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择壁纸',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _pickWallpaperImage();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEEEEEE),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 24, color: Colors.grey),
                            SizedBox(height: 4),
                            Text(
                              '上传图片',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildWallpaperOption(null),
                      _buildWallpaperOption('blue'),
                      _buildWallpaperOption('purple'),
                      _buildWallpaperOption('green'),
                      _buildWallpaperOption('orange'),
                      _buildWallpaperOption('pink'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickWallpaperImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _setPreviewWallpaperImage(bytes);
      });
    }
  }

  Widget _buildWallpaperOption(String? colorKey) {
    final isSelected = _previewWallpaper == colorKey;
    final color = _getWallpaperColor(colorKey);
    return GestureDetector(
      onTap: () {
        _setPreviewWallpaper(colorKey);
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3)
              : Border.all(color: const Color(0xFFEEEEEE), width: 1),
        ),
        child: isSelected
            ? const Center(
                child: Icon(Icons.check, color: Colors.white, size: 24),
              )
            : null,
      ),
    );
  }

  Color _getWallpaperColor(String? colorKey) {
    switch (colorKey) {
      case 'blue':
        return const Color(0xFF1E88E5);
      case 'purple':
        return const Color(0xFF9C27B0);
      case 'green':
        return const Color(0xFF43A047);
      case 'orange':
        return const Color(0xFFFF9800);
      case 'pink':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Widget _buildHeader(String title, {required VoidCallback onBack}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: _getBackgroundDecoration(),
      child: Column(
        children: [
          _buildChatHeader(),
          Expanded(
            child: _selectedChannelId == null
                ? _buildChannelSelector()
                : _buildChatArea(),
          ),
        ],
      ),
    );
  }

  LinearGradient? _getWallpaperGradient() {
    if (_backgroundImage == null) return null;
    final color = _getWallpaperColor(_backgroundImage);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
    );
  }

  BoxDecoration _getBackgroundDecoration() {
    if (_backgroundImageBytes != null) {
      return BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(_backgroundImageBytes!),
          fit: BoxFit.cover,
        ),
      );
    } else if (_backgroundImage != null) {
      final gradient = _getWallpaperGradient();
      if (gradient != null) {
        return BoxDecoration(gradient: gradient);
      }
    }
    return const BoxDecoration(color: Colors.white);
  }

  Widget _buildChatHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.tag, color: Colors.black54, size: 24),
          const SizedBox(width: 8),
          Text(
            _selectedServer?.name ?? '',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (_selectedServer != null && _selectedServer!.channels.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
              onPressed: () => _showChannelSelector(context),
            ),
        ],
      ),
    );
  }

  Widget _buildChannelSelector() {
    if (_selectedServer == null) return const Center(child: Text('选择服务器'));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _selectedServer!.avatarColor.isNotEmpty
                  ? _getColorFromHex(_selectedServer!.avatarColor)
                  : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _selectedServer!.name.isNotEmpty
                    ? _selectedServer!.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedServer!.name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (_selectedServer!.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _selectedServer!.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            '选择一个频道开始聊天',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ...(_selectedServer!.channels.map(
            (channel) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextButton(
                onPressed: () => _onChannelSelected(channel),
                child: Text(
                  '# ${channel.name}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )),
        ],
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

  void _showChannelSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '在 ${_selectedServer!.name} 中选择频道',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...(_selectedServer!.channels.map(
              (channel) => ListTile(
                leading: Icon(
                  channel.type == ChannelType.voice
                      ? Icons.volume_up
                      : Icons.tag,
                  color: Colors.black54,
                ),
                title: Text(channel.name),
                onTap: () {
                  Navigator.pop(context);
                  _onChannelSelected(channel);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    final channel = _selectedChannel;
    return Column(
      children: [
        Expanded(child: _buildMessageList(channel)),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageList(Channel? channel) {
    if (channel == null || channel.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              channel?.type == ChannelType.voice ? Icons.volume_up : Icons.tag,
              size: 48,
              color: Colors.black26,
            ),
            const SizedBox(height: 16),
            Text(
              '欢迎来到 #${channel?.name ?? 'unknown'}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '这是频道的开始。发送一条消息吧！',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: channel.messages.length,
      itemBuilder: (context, index) =>
          _buildMessageItem(channel.messages[index]),
    );
  }

  Widget _buildMessageItem(Message message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Text(
              message.authorName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.authorName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(message.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message.text,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black45),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  hintText: '发送消息',
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (text) {
                  if (text.isNotEmpty &&
                      _selectedServerIndex != null &&
                      _selectedChannelId != null) {
                    _sendMessage(text);
                  }
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.black45,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.gif_box_outlined,
                    color: Colors.black45,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'You',
      text: text,
      timestamp: DateTime.now(),
    );
    setState(() {
      final server = _selectedServer!;
      final channelIndex = server.channels.indexWhere(
        (c) => c.id == _selectedChannelId,
      );
      if (channelIndex != -1) {
        final channel = server.channels[channelIndex];
        final updatedChannel = Channel(
          id: channel.id,
          name: channel.name,
          type: channel.type,
          messages: [...channel.messages, newMessage],
        );
        final updatedChannels = List<Channel>.from(server.channels);
        updatedChannels[channelIndex] = updatedChannel;
        _servers[_selectedServerIndex!] = server.copyWith(
          channels: updatedChannels,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${time.month}/${time.day}/${time.year}';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _CreateWorldPage extends StatefulWidget {
  final Function(
    String name,
    String description,
    String avatarColor,
    Uint8List? avatarImageBytes,
  )
  onCreate;
  final VoidCallback onCancel;

  const _CreateWorldPage({required this.onCreate, required this.onCancel});

  @override
  State<_CreateWorldPage> createState() => _CreateWorldPageState();
}

class _CreateWorldPageState extends State<_CreateWorldPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imagePicker = ImagePicker();
  final String _selectedColor = '#FFB6C1';
  bool _isLoading = false;
  Uint8List? _selectedImageBytes;

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _selectedImageBytes = bytes);
    }
  }

  void _createWorld() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onCreate(
      _nameController.text,
      _descController.text,
      _selectedColor,
      _selectedImageBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildAvatarSection(),
                        const SizedBox(height: 32),
                        _buildInputSection(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: widget.onCancel,
          ),
          const SizedBox(width: 8),
          const Text(
            '创建新世界',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _nameController.text.isNotEmpty ? _createWorld : null,
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: _selectedImageBytes == null
                  ? _getColorFromHex(_selectedColor)
                  : null,
              borderRadius: BorderRadius.circular(16),
              image: _selectedImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(_selectedImageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _selectedImageBytes == null
                ? Stack(
                    children: [
                      Center(
                        child: Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '点击更换头像',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '世界名称',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: '输入世界名称',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 24),
        const Text(
          '世界简介',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '这个世界是什么样的...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '世界书',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: '编写这个世界的故事、历史...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
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
