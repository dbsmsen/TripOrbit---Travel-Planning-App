import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageTranslatorScreen extends ConsumerStatefulWidget {
  const LanguageTranslatorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LanguageTranslatorScreen> createState() =>
      _LanguageTranslatorScreenState();
}

class _LanguageTranslatorScreenState
    extends ConsumerState<LanguageTranslatorScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  String _sourceLang = 'English';
  String _targetLang = 'French';
  bool _isTranslating = false;
  bool _isSpeaking = false;

  final List<String> _languages = [
    'English',
    'French',
    'Spanish',
    'German',
    'Italian',
    'Japanese',
    'Korean',
    'Chinese',
    'Russian',
    'Arabic',
  ];

  final List<String> _recentTranslations = [
    'Hello → Bonjour',
    'Thank you → Merci',
    'Good morning → Bonjour',
    'Please → S\'il vous plaît',
    'You\'re welcome → De rien',
  ];

  final List<String> _commonPhrases = [
    'Hello',
    'Thank you',
    'Please',
    'Excuse me',
    'Where is...',
    'How much?',
    'Good morning',
    'Good evening',
    'Yes',
    'No',
  ];

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Translator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _translateFromImage,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showTranslationHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            _buildTranslationArea(),
            const SizedBox(height: 24),
            _buildCommonPhrases(),
            const SizedBox(height: 24),
            _buildRecentTranslations(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'From',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              DropdownButton<String>(
                value: _sourceLang,
                isExpanded: true,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _sourceLang = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _swapLanguages,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              DropdownButton<String>(
                value: _targetLang,
                isExpanded: true,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _targetLang = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationArea() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextField(
                controller: _sourceController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter text to translate',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: _startVoiceInput,
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _sourceController.clear();
                          _targetController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _translateText();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextField(
                controller: _targetController,
                maxLines: 4,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Translation',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.volume_up,
                          color: _isSpeaking ? Colors.blue : null,
                        ),
                        onPressed: _speakTranslation,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          // TODO: Copy translation to clipboard
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommonPhrases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Common Phrases',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonPhrases.map((phrase) {
            return ActionChip(
              label: Text(phrase),
              onPressed: () {
                _sourceController.text = phrase;
                _translateText();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentTranslations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Translations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentTranslations.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_recentTranslations[index]),
              trailing: IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  final parts = _recentTranslations[index].split(' → ');
                  if (parts.length == 2) {
                    _sourceController.text = parts[0];
                    _translateText();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;

      final tempText = _sourceController.text;
      _sourceController.text = _targetController.text;
      _targetController.text = tempText;
    });
  }

  Future<void> _translateText() async {
    if (_sourceController.text.isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    // TODO: Implement actual translation using a translation API
    await Future.delayed(const Duration(milliseconds: 500));
    _targetController.text = 'Translated text will appear here';

    setState(() {
      _isTranslating = false;
    });
  }

  void _translateFromImage() {
    // TODO: Implement image-based translation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Translation'),
        content: const Text('Coming soon: Translate text from images!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTranslationHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Translation History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _recentTranslations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_recentTranslations[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // TODO: Implement delete functionality
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startVoiceInput() {
    // TODO: Implement voice input
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Input'),
        content: const Text('Coming soon: Speak to translate!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _speakTranslation() {
    if (_targetController.text.isEmpty) return;

    setState(() {
      _isSpeaking = !_isSpeaking;
    });

    // TODO: Implement text-to-speech
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSpeaking = false;
      });
    });
  }
}
