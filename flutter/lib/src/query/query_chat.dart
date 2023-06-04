import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kb_ui/src/api/server_api.dart';
import 'package:kb_ui/src/file_system/file_system_item.dart';

enum ChatType {
  query,
  response,
}

class ChatMessage {
  final ChatType type;
  final String content;

  ChatMessage({required this.type, required this.content});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isQuery = message.type == ChatType.query;
    return Row(
      mainAxisAlignment:
          isQuery ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isQuery ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(message.content),
          ),
        ),
      ],
    );
  }
}

class QueryChatView extends HookWidget {
  final ValueNotifier<List<FileSystemItem>> selectedItems;

  const QueryChatView({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final messages = useState(<ChatMessage>[]);
    final loading = useState(false);
    final scrollController = useScrollController();

    void addToMessages(String message, ChatType type) {
      messages.value = [
        ...messages.value,
        ChatMessage(content: message, type: type)
      ];
      Future.delayed(Duration(milliseconds: 200), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }

    void postQuery() {
      loading.value = true;
      final ids = selectedItems.value.map((e) => e.id).toList();

      addToMessages(controller.text, ChatType.query);

      ServerApiMethods.postQuery(controller.text, ids).then((value) {
        addToMessages(value, ChatType.response);
        loading.value = false;
      }).catchError((error) {
        addToMessages(error.toString(), ChatType.response);
        loading.value = false;
      });

      controller.clear();
    }

    void onSubmitted(String value) {
      postQuery();
    }

    return Expanded(
      child: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages.value[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                    onSubmitted: onSubmitted, // Add onSubmitted callback
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: postQuery,
                ),
              ],
            ),
          ),
          if (loading.value)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
  }
}
