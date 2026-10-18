import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/syntax_highlighter.dart';

class CodeEditorWidget extends StatefulWidget {
  final String code;
  final String languageId;
  final double fontSize;
  final bool showLineNumbers;
  final bool isLineWrap;
  final ValueChanged<String> onCodeChanged;

  const CodeEditorWidget({
    super.key,
    required this.code,
    required this.languageId,
    required this.fontSize,
    required this.showLineNumbers,
    required this.isLineWrap,
    required this.onCodeChanged,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _controller;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.code);
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.code,
        selection: TextSelection.collapsed(offset: widget.code.length.clamp(0, widget.code.length)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = '\n'.allMatches(_controller.text).length + 1;
    final highlightLang = SyntaxHighlighterUtils.mapLanguageToHighlight(widget.languageId);
    final themeMap = SyntaxHighlighterUtils.getTheme('atomonedark', isDark: true);

    return Container(
      color: AppColors.editorBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line Number Gutter
          if (widget.showLineNumbers)
            Container(
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.editorGutter,
              child: SingleChildScrollView(
                controller: _verticalScrollController,
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: List.generate(
                    lineCount,
                    (index) => Text(
                      '${index + 1}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: widget.fontSize,
                        color: AppColors.editorLineNumber,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

          // Code Text Area
          Expanded(
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: widget.isLineWrap ? Axis.vertical : Axis.horizontal,
                controller: _horizontalScrollController,
                child: Stack(
                  children: [
                    // Highlighted Code Layer
                    HighlightView(
                      _controller.text.isEmpty ? ' ' : _controller.text,
                      language: highlightLang,
                      theme: themeMap,
                      padding: EdgeInsets.zero,
                      textStyle: GoogleFonts.jetBrainsMono(
                        fontSize: widget.fontSize,
                        height: 1.4,
                      ),
                    ),

                    // Transparent Editable Input Overlay
                    Positioned.fill(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: widget.fontSize,
                          color: Colors.transparent, // Hide plain text, display syntax highlight
                          height: 1.4,
                        ),
                        cursorColor: AppColors.primaryBlue,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          fillColor: Colors.transparent,
                        ),
                        onChanged: (val) {
                          setState(() {});
                          widget.onCodeChanged(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
