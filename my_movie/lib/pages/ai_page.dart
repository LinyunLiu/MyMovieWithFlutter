import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/utils/alert_helper.dart';
import 'package:flutter_animate/flutter_animate.dart';


class AiPage extends StatefulWidget {
  const AiPage({super.key});
  @override
  AiPageState createState() => AiPageState();
}

class AiPageState extends State<AiPage>{
  final TextEditingController _controller = TextEditingController();
  String? _aiResponse; // To store the result
  bool _isLoading = false;
  var ai = Hive.box('ai');

  @override
  void initState() {
    super.initState();
    // Convert entire box to a typed Map
    if (ai.get('input') != null && ai.get('response') != null){
        setState(() {
          _aiResponse = ai.get('response');
          _controller.text = ai.get('input');
        });
    }
  }

  // FUNCTIONS TO FETCH AI RESPONSE
  Future<Map<String, dynamic>?> getLlamaResponse(String text) async {
    final Uri uri = Uri.parse(dotenv.env['ORIGIN_AI']!);
    final requestData = {
      "messages": [
        {
          "role": "user",
          "content": text,
        }
      ],
      "stream": false,
      "include_functions_info": false,
      "include_retrieval_info": false,
      "include_guardrails_info": false,
    };
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['LLAMA_ACCESS_KEY']!}',
        },
        body: jsonEncode(requestData),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
        return null;
      }
  }
  String? extractAiContent(Map<String, dynamic> json) {
    try {
      return json['choices'][0]['message']['content'] as String?;
    } catch (e) {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false, // remove default back if any
              backgroundColor: Colors.deepOrange[200],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_sharp, color: Color(0xFF222222)), // or Icons.close
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Inspiration',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontFamily: 'Anton',
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async {
              
                  if (value.trim() != ""){
                    setState(() {
                      _isLoading = true;
                      _aiResponse = null;
                    });
                    ai.put('input', _controller.text);
                    final result = await getLlamaResponse(value);
                    final responseText = extractAiContent(result ?? {});
                    setState(() {
                      _aiResponse = responseText ?? "Something went wrong ...";
                      _isLoading = false;
                    });
                    if (_aiResponse != null && _aiResponse != "" && _aiResponse != "Something went wrong ..."){
                      ai.put('response', _aiResponse);
                    }
                  }
                  else{
                    AlertHelper.showTopFlushbar(context, "Input is empty");
                  }
                },
                decoration: InputDecoration(
                  hintText: 'What is on your mind?',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.smart_toy_sharp, color: Colors.grey[600]),
                  filled: true,
                  fillColor: Color(0xFFFAEBD7),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide.none, // remove outline
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(duration: 400.ms),
            ),

            SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MarkdownBody(
                            data: _aiResponse ?? "Don't know what to watch?",
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'San Francisco',
                                color: Color(0xFF222222),
                              ),
                            ),
                          ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}