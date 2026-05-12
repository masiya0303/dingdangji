import 'dart:typed_data';

class Server {
  final String name;
  final String description;
  final String avatarColor;
  final Uint8List? avatarImageBytes;
  final List<Channel> channels;
  final bool hasNotification;

  Server({
    required this.name,
    this.description = '',
    this.avatarColor = '#5865F2',
    this.avatarImageBytes,
    this.channels = const [],
    this.hasNotification = false,
  });

  Server copyWith({
    String? name,
    String? description,
    String? avatarColor,
    Uint8List? avatarImageBytes,
    List<Channel>? channels,
    bool? hasNotification,
  }) {
    return Server(
      name: name ?? this.name,
      description: description ?? this.description,
      avatarColor: avatarColor ?? this.avatarColor,
      avatarImageBytes: avatarImageBytes ?? this.avatarImageBytes,
      channels: channels ?? this.channels,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }
}

class Channel {
  final String id;
  final String name;
  final ChannelType type;
  final List<Message> messages;

  Channel({
    required this.id,
    required this.name,
    this.type = ChannelType.text,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

enum ChannelType { text, voice }

class Message {
  final String id;
  final String authorName;
  final String? authorAvatar;
  final String text;
  final DateTime timestamp;
  final bool isBot;

  Message({
    required this.id,
    required this.authorName,
    this.authorAvatar,
    required this.text,
    required this.timestamp,
    this.isBot = false,
  });
}
