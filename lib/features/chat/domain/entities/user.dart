/// Domain entity for user
/// Pure Dart class - no Firebase dependencies
class ChatUser {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? profileImageUrl;

  const ChatUser({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.profileImageUrl,
  });
}

