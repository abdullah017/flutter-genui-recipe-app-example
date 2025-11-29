import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';
import 'package:recipe_genui_app_example/widget/message_buble.dart';

import '../catalog/recipe_catalog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final GenUiManager _genUiManager;
  late final GoogleGenerativeAiContentGenerator _contentGenerator;
  late final GenUiConversation _conversation;

  final List<_ChatMessage> _messages = [];
  final List<String> _surfaceIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGenUI();
  }

  void _initializeGenUI() {
    // 1. GenUiManager oluştur - Widget kataloğumuzu ver
    _genUiManager = GenUiManager(catalog: RecipeCatalog.catalog);

    // 2. ContentGenerator oluştur - Gemini ile iletişim kurar
    _contentGenerator = GoogleGenerativeAiContentGenerator(
      catalog: RecipeCatalog.catalog,
      systemInstruction: RecipeCatalog.systemInstruction,
      modelName: 'models/gemini-2.5-flash',
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
    );

    // 3. GenUiConversation oluştur - Her şeyi koordine eder
    _conversation = GenUiConversation(
      genUiManager: _genUiManager,
      contentGenerator: _contentGenerator,
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
    );

    // Text response stream'i dinle
    _contentGenerator.textResponseStream.listen((text) {
      if (text.isNotEmpty) {
        setState(() {
          _messages.add(
            _ChatMessage(text: text, isUser: false, timestamp: DateTime.now()),
          );
        });
        _scrollToBottom();
      }
    });

    // Error stream'i dinle
    _contentGenerator.errorStream.listen((error) {
      setState(() {
        _isLoading = false;
        _messages.add(
          _ChatMessage(
            text: 'Hata: ${error.error}',
            isUser: false,
            isError: true,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  void _onSurfaceAdded(SurfaceAdded update) {
    setState(() {
      _surfaceIds.add(update.surfaceId);
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _onSurfaceDeleted(SurfaceRemoved update) {
    setState(() {
      _surfaceIds.remove(update.surfaceId);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(
        _ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
      // Önceki surface'ları temizle
      _surfaceIds.clear();
    });

    _scrollToBottom();

    // Mesajı AI'a gönder
    _conversation.sendRequest(UserMessage.text(text));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _conversation.dispose();
    _genUiManager.dispose();
    _contentGenerator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🍳', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('AI Tarif Asistanı'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _surfaceIds.clear();
              });
            },
            tooltip: 'Sohbeti Temizle',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sohbet alanı
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount:
                  _messages.length + _surfaceIds.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // Mesajlar
                if (index < _messages.length) {
                  final message = _messages[index];
                  return MessageBubble(
                    text: message.text,
                    isUser: message.isUser,
                    isError: message.isError,
                    timestamp: message.timestamp,
                  );
                }

                // Loading indicator
                if (_isLoading && index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Tarif hazırlanıyor...',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // GenUI Surface'ları
                final surfaceIndex =
                    index - _messages.length - (_isLoading ? 1 : 0);
                if (surfaceIndex >= 0 && surfaceIndex < _surfaceIds.length) {
                  final surfaceId = _surfaceIds[surfaceIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GenUiSurface(
                      host: _genUiManager,
                      surfaceId: surfaceId,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Örnek sorgular
          if (_messages.isEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _SuggestionChip(
                    text: 'Elimde tavuk, patates ve soğan var',
                    onTap: () => _sendMessage(
                      'Elimde tavuk, patates ve soğan var. Akşam yemeği önerir misin?',
                    ),
                  ),
                  _SuggestionChip(
                    text: 'Hızlı kahvaltı',
                    onTap: () => _sendMessage(
                      '15 dakikada hazırlayabileceğim hızlı bir kahvaltı tarifi ver',
                    ),
                  ),
                  _SuggestionChip(
                    text: 'Tatlı tarifi',
                    onTap: () => _sendMessage(
                      'Kolay bir çikolatalı tatlı tarifi önerir misin?',
                    ),
                  ),
                ],
              ),
            ),

          // Mesaj gönderme alanı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Elindeki malzemeleri yaz...',
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    onPressed: _isLoading
                        ? null
                        : () => _sendMessage(_textController.text),
                    elevation: 0,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
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

/// Öneri chip'i
class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: onTap,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        side: BorderSide.none,
      ),
    );
  }
}

/// Chat mesaj modeli
class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
    required this.timestamp,
  });
}
