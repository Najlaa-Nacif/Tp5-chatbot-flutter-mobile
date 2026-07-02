import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/groq_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? userName;

  const ChatScreen({super.key, this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final GroqService _groqService = GroqService();
  final ScrollController _scrollController = ScrollController();

  late final List<ChatMessage> _messages = [
    ChatMessage(
      text:
      'Bonjour ${widget.userName ?? "Amal"} 👋 Je suis votre assistant IA. Comment puis-je vous aider ?',
      isUser: false,
      createdAt: DateTime.now(),
    ),
  ];

  bool _isLoading = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        createdAt: DateTime.now(),
      ));
      _isLoading = true;
      _messageController.clear();
    });

    _scrollToBottom();

    final response = await _groqService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        createdAt: DateTime.now(),
      ));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  Future<void> _clearChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la conversation"),
        content: const Text(
          "Voulez-vous vraiment supprimer toute la conversation ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _messages.clear();
        _messages.add(ChatMessage(
          text:
          'Bonjour ${widget.userName ?? "Amal"} 👋 Je suis votre assistant IA. Comment puis-je vous aider ?',
          isUser: false,
          createdAt: DateTime.now(),
        ));
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleName = widget.userName ?? 'Amal';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        title: Text('ChatBot - $titleName'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _clearChat,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('🤖 ChatBot est en train d’écrire...'),
                    ),
                  );
                }

                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Écrire un message...',
                        filled: true,
                        fillColor: const Color(0xFFF0EAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6750A4),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}