import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../models/execution_result.dart';

class ExecutionConsoleWidget extends StatefulWidget {
  final ExecutionResult? result;
  final bool isExecuting;
  final String stdin;
  final ValueChanged<String> onStdinChanged;
  final VoidCallback onRunTap;
  final VoidCallback onClearTap;
  final VoidCallback onCloseTap;

  const ExecutionConsoleWidget({
    super.key,
    required this.result,
    required this.isExecuting,
    required this.stdin,
    required this.onStdinChanged,
    required this.onRunTap,
    required this.onClearTap,
    required this.onCloseTap,
  });

  @override
  State<ExecutionConsoleWidget> createState() => _ExecutionConsoleWidgetState();
}

class _ExecutionConsoleWidgetState extends State<ExecutionConsoleWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        color: AppColors.editorBackground,
        border: Border(top: BorderSide(color: AppColors.surfaceVariantDark, width: 1.5)),
      ),
      child: Column(
        children: [
          // Console Header & Tab Bar
          Container(
            color: AppColors.surfaceDark,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: AppColors.primaryBlue,
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: AppColors.textMutedDark,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'STDOUT Output'),
                      Tab(text: 'STDIN Input'),
                      Tab(text: 'Errors'),
                      Tab(text: 'Execution Info'),
                    ],
                  ),
                ),
                if (widget.result != null)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: AppColors.textSecondaryDark),
                    tooltip: 'Copy Output',
                    onPressed: () {
                      final text = widget.result!.stdout ?? widget.result!.compileOutput ?? '';
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Output copied to clipboard')),
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.clear_all, size: 18, color: AppColors.textSecondaryDark),
                  tooltip: 'Clear Console',
                  onPressed: widget.onClearTap,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textMutedDark),
                  tooltip: 'Minimize Console',
                  onPressed: widget.onCloseTap,
                ),
              ],
            ),
          ),

          // Execution Status Banner
          if (widget.isExecuting)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: AppColors.primaryBlue.withOpacity(0.15),
              child: const Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Compiling & Running Code...',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else if (widget.result != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              color: widget.result!.isSuccess
                  ? AppColors.accentGreen.withOpacity(0.15)
                  : AppColors.accentRed.withOpacity(0.15),
              child: Row(
                children: [
                  Icon(
                    widget.result!.isSuccess ? Icons.check_circle : Icons.error_outline,
                    size: 14,
                    color: widget.result!.isSuccess ? AppColors.accentGreen : AppColors.accentRed,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Status: ${widget.result!.statusDescription}',
                    style: TextStyle(
                      color: widget.result!.isSuccess ? AppColors.accentGreen : AppColors.accentRed,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (widget.result!.executionTime != null)
                    Text(
                      'Time: ${widget.result!.executionTime}',
                      style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                    ),
                ],
              ),
            ),

          // Console Tab Body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // STDOUT Tab
                _buildConsoleBody(
                  text: widget.result?.stdout ??
                      (widget.isExecuting ? 'Running program...' : 'No output produced yet. Tap "Run" to execute.'),
                  textColor: AppColors.textPrimaryDark,
                ),

                // STDIN Tab
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: TextEditingController(text: widget.stdin),
                    maxLines: null,
                    style: GoogleFonts.jetBrainsMono(fontSize: 13, color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter standard input (STDIN) here before running...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: widget.onStdinChanged,
                  ),
                ),

                // Errors Tab
                _buildConsoleBody(
                  text: widget.result?.compileOutput ?? widget.result?.stderr ?? 'No errors reported.',
                  textColor: widget.result?.hasError == true ? AppColors.accentRed : AppColors.textSecondaryDark,
                ),

                // Execution Details Tab
                _buildConsoleBody(
                  text: widget.result != null
                      ? '''Timestamp: ${widget.result!.timestamp}
Status: ${widget.result!.status.name} (${widget.result!.statusDescription})
Execution Time: ${widget.result!.executionTime ?? 'N/A'}
Memory Used: ${widget.result!.memoryUsedKb != null ? '${widget.result!.memoryUsedKb} KB' : 'N/A'}
'''
                      : 'Run code to view detailed execution metrics.',
                  textColor: AppColors.textSecondaryDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleBody({required String text, required Color textColor}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 13,
          color: textColor,
          height: 1.4,
        ),
      ),
    );
  }
}
