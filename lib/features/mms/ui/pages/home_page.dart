import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_manager/core/extensions/extensions.dart';
import 'package:livekit_manager/core/widgets/my_button.dart';
import 'package:livekit_manager/features/mms/ui/pages/room_page.dart';

import '../../../room/bloc/room_cubit/room_cubit.dart';

class MMSPage extends StatefulWidget {
  const MMSPage({
    super.key,
    required this.link,
    required this.token,
  });

  final String link;

  final String token;

  @override
  State<StatefulWidget> createState() => _MMSPageState();
}

class _MMSPageState extends State<MMSPage> {
  RoomCubit get cubit => context.read<RoomCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomInitial>(
      builder: (context, state) {
        return state.isConnect
            ? RoomPage()
            : Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DrawableText(text: state.url),
                          20.0.verticalSpace,
                          MyButton(
                            width: 1.0.sw,
                            loading: state.loading,
                            onTap: () {
                              cubit
                                ..setUrl(widget.link)
                                ..setToken(
                                  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmNWU3ZWJmMC03MmNjLTRiYzAtODhiMi0wOGRjOGFlYmJlNTYiLCJqdGkiOiJmNWU3ZWJmMC03MmNjLTRiYzAtODhiMi0wOGRjOGFlYmJlNTYiLCJpc3MiOiJkZXZrZXkiLCJuYmYiOjE3NzMzMDczNTQsImlhdCI6MTc3MzMwNzM1NCwiZXhwIjoxNzc4NDkxMzU0LCJ2aWRlbyI6eyJhZ2VudCI6ZmFsc2UsImNhblB1Ymxpc2giOmZhbHNlLCJjYW5QdWJsaXNoRGF0YSI6dHJ1ZSwiY2FuUHVibGlzaFNvdXJjZXMiOltdLCJjYW5TdWJzY3JpYmUiOnRydWUsImNhblN1YnNjcmliZU1ldHJpY3MiOmZhbHNlLCJjYW5VcGRhdGVPd25NZXRhZGF0YSI6ZmFsc2UsImRlc3RpbmF0aW9uUm9vbSI6IiIsImhpZGRlbiI6ZmFsc2UsImluZ3Jlc3NBZG1pbiI6ZmFsc2UsInJlY29yZGVyIjpmYWxzZSwicm9vbSI6ImMzZjkzOTkwLTdlZTYtNDk4ZS00MWRkLTA4ZGU4MDE4ZGUwMSIsInJvb21BZG1pbiI6dHJ1ZSwicm9vbUNyZWF0ZSI6dHJ1ZSwicm9vbUpvaW4iOnRydWUsInJvb21MaXN0IjpmYWxzZSwicm9vbVJlY29yZCI6ZmFsc2V9LCJzaXAiOnsiYWRtaW4iOmZhbHNlLCJjYWxsIjpmYWxzZX0sIm5hbWUiOiLZhdmK2LPZhSDYo9it2YXYryDZhdit2YXYryIsIm1ldGFkYXRhIjoiIiwic2hhMjU2IjoiIiwia2luZCI6IiIsImF0dHJpYnV0ZXMiOnsiaW1hZ2VVcmwiOiJodHRwczovL21tc3YyLWJlLmNvcmV0ZWNoLW1lbmEuY29tL2RvY3VtZW50cy9wcm9maWxlNF8wZmI5ZTdmOS0wNmQ0LTQ2MmYtOGQzYS0zYTFhMTQ3YzRiODYuanBnIiwibGtVc2VyVHlwZSI6IjAifSwicm9vbUNvbmZpZyI6e319.GctLcG6oWoGF3eCKyeXZylTWg8OUitDzWmnR7FTgKLE',
                                )
                                ..connect();
                            },
                            text: 'Join',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
