import 'package:app/core/app_image.dart'; // 👈 Pastikan mengimpor AppImage
import 'package:app/data/services/state/state_heart_attack.dart';
import 'package:app/data/services/state/state_stress.dart';
import 'package:app/presentation/layouts/screen_layout.dart';
import 'package:flutter/material.dart';

import '../widgets/chats/chat_input.dart';
import '../widgets/chats/chat_list.dart';
import '../widgets/notification/popup_toast.dart';
import '../../data/services/base_chat_state.dart';
import '../../data/services/state/state_diabetes.dart';
import '../../data/services/state/state_obesitas.dart';

class ChatScreen extends StatefulWidget {
  final String category;
  final String title;

  const ChatScreen({super.key, required this.category, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late BaseChatState _chatState;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  bool _canUndo = true;
  bool _canSend = true; 

  @override
  void initState() {
    super.initState();
    if (widget.category.toLowerCase() == 'diabetes') {
      _chatState = DiabetesChatState();
    } else if (widget.category.toLowerCase() == 'obesitas') {
      _chatState = ObesitasChatState();
    } else if (widget.category.toLowerCase() == 'jantung') {
      _chatState = StateHeartAttack();
    } else if (widget.category.toLowerCase() == 'stress') {
      _chatState = StateStress();
    } else {
      _chatState = DiabetesChatState();
    }
  }

  @override
  void dispose() {
    _chatState.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: widget.title,
      child: ListenableBuilder(
        listenable: _chatState,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImage.backGroundChat), // 👈 Gambar background khusus chat kamu
                fit: BoxFit.cover, // 👈 Memenuhi area chat dengan proporsional
              ),
            ),
            child: Column(
              children: [
                // 2. ChatList dibiarkan expanded agar mendominasi area ber-background
                Expanded(
                  child: ChatList(
                    messages: _chatState.messages,
                    scrollController: _scrollController,
                  ),
                ),
                
                // 3. ChatInput berada di paling bawah
                ChatInput(
                  controller: _controller,
                  onSend: () async {
                    if (_chatState.isLoading || !_canSend || _controller.text.trim().isEmpty) return;

                    _canSend = false;
                    final input = _controller.text;
                    _controller.clear();
                    final error = await _chatState.sendMessage(input);

                    if (error != null) {
                      if (!context.mounted) return;
                      AppToast.showError(context, error);
                      _canSend = true; 
                      return;
                    }

                    Future.delayed(const Duration(milliseconds: 1000), () {
                      _canSend = true;
                    });
                  },
                  onBack: () async {
                    if (_chatState.isLoading ||
                        _chatState.currentQuestion >= _chatState.questions.length) {
                      return;
                    }
                    if (!_canUndo) return;

                    _canUndo = false;
                    await _chatState.undo();

                    if (!context.mounted) return;
                    AppToast.showUndo(context);

                    Future.delayed(const Duration(milliseconds: 2000), () {
                      _canUndo = true;
                    });
                  },
                  enabled: !_chatState.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}