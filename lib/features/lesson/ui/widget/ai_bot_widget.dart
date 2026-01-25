import 'dart:math';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/widgets/my_text_form_widget.dart';
import 'package:livekit_manager/features/lesson/bloc/ask_bot_cubit/ask_bot_cubit.dart';
import 'package:m_cubit/m_cubit.dart';

class AiBotWidget extends StatelessWidget {
  final String lessonId;

  const AiBotWidget({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return _AiBotFloatingButton(lessonId: lessonId);
  }
}

class _AiBotFloatingButton extends StatefulWidget {
  final String lessonId;

  const _AiBotFloatingButton({required this.lessonId});

  @override
  State<_AiBotFloatingButton> createState() => _AiBotFloatingButtonState();
}

class _AiBotFloatingButtonState extends State<_AiBotFloatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (context) => AskBotCubit(),
        child: AskBotBottomSheet(lessonId: widget.lessonId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4facfe).withOpacity(0.4),
                blurRadius: 15 + 10 * sin(_controller.value * 2 * pi),
                spreadRadius: 2 + 5 * sin(_controller.value * 2 * pi),
              ),
              BoxShadow(
                color: const Color(0xFF00f2fe).withOpacity(0.4),
                blurRadius: 15 + 10 * cos(_controller.value * 2 * pi),
                spreadRadius: 2 + 5 * cos(_controller.value * 2 * pi),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _showAskDialog(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Ink(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28.r,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AskBotBottomSheet extends StatefulWidget {
  final String lessonId;

  const AskBotBottomSheet({super.key, required this.lessonId});

  @override
  State<AskBotBottomSheet> createState() => _AskBotBottomSheetState();
}

class _AskBotBottomSheetState extends State<AskBotBottomSheet> {
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 20.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF4facfe)),
                10.horizontalSpace,
                DrawableText(
                  text: "AI Assistant",
                  size: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            20.verticalSpace,
            MyTextFormWidget(
              controller: _promptController,
              hint: "Ask me anything about this lesson...",
              maxLines: 4,
            ),
            20.verticalSpace,
            BlocBuilder<AskBotCubit, AskBotInitial>(
              builder: (context, state) {
                if (state.statuses == CubitStatuses.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    if (state.result.answer.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DrawableText(
                            text: "Answer:",
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4facfe),
                          ),
                          10.verticalSpace,
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4facfe).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: const Color(0xFF4facfe).withOpacity(0.1)),
                            ),
                            child: DrawableText(
                              text: state.result.answer,
                              size: 16.sp,
                            ),
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    ],
                    InkWell(
                      onTap: () {
                        if (_promptController.text.trim().isNotEmpty) {
                          context.read<AskBotCubit>().askBot(
                            lessonId: widget.lessonId,
                            prompt: _promptController.text.trim(),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: DrawableText(
                          text: state.result.answer.isEmpty ? "Ask AI" : "Ask Again",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
