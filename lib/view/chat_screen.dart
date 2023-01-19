import 'package:chat_ai/constants.dart';
import 'package:chat_ai/model/chat_message.dart';
import 'package:chat_ai/model/network_helper.dart';
import 'package:chat_ai/view/widgets/chat_message_widget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  NetWorkHelper networkHelper = NetWorkHelper();

  late bool isLoading;
  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(
        title: const Text('OpenAI\'s ChatGpt'),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //ChatBody
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: kWhite,
                ),
              ),
            ),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  TextField _buildInput() {
    return TextField(
      controller: _textController,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(color: kWhite),
      decoration: InputDecoration(
        suffixIcon: _buildSummit(),
        fillColor: botBackgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0,
            color: botBackgroundColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0,
            color: botBackgroundColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildSummit() {
    return Visibility(
      visible: !isLoading,
      child: GestureDetector(
        onTap: () async {
          // display user input
          setState(() {
            final chat = ChatMessage(
                text: _textController.text.trim(), type: ChatMessageType.user);
            _messages.add(chat);
            isLoading = true;
          });
          var input = _textController.text.trim();
          _textController.clear();
          await Future.delayed(const Duration(milliseconds: 50))
              .then((value) => _scollDown());
          // call chatbot api
          await networkHelper.getResponse(input).then((value) {
            setState(() {
              isLoading = false;
              final chat = ChatMessage(text: value, type: ChatMessageType.bot);
              // display chatbot response
              _messages.add(chat);
            });
          });
          _textController.clear();
          await Future.delayed(const Duration(milliseconds: 50))
              .then((value) => _scollDown());
        },
        child: const Icon(
          Icons.send_rounded,
          color: Color.fromRGBO(142, 142, 160, 1),
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final chatMessage = _messages[index];
        return ChatMessageWidget(
          chatMessage: chatMessage,
        );
      },
    );
  }

  void _scollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
