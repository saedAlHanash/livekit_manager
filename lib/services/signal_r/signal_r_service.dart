// // Import the library.
// import 'dart:convert';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:procter_web/core/api_manager/api_service.dart';
// import 'package:procter_web/core/app/app_provider.dart';
// import 'package:procter_web/services/signal_r/record.dart';
// import 'package:procter_web/services/signal_r/signal_message.dart';
// import 'package:signalr_core_new/signalr_core_new.dart';
//
// import '../../core/app/app_widget.dart';
// import '../../core/strings/enum_manager.dart';
// import '../../features/exam_run/bloc/signal_students_cubit/signal_students_cubit.dart';
//
// String serverUrl(String id) => "https://signalr.coretech-mena.com/hub/$id";
//
// class SignalRService {
//   HubConnection? hubConnection;
//
//   Future<void> deConnect() async {
//     await hubConnection?.stop();
//     hubConnection = null;
//   }
//
//   Future<void> initialSignalR(String id) async {
//     if (hubConnection != null && hubConnection!.state == HubConnectionState.connected) {
//       await deConnect();
//     }
//
//     hubConnection = HubConnectionBuilder()
//         .withUrl(
//           serverUrl(id),
//         )
//         .withAutomaticReconnect()
//         .build();
//
//     hubConnection?.onreconnected(
//       (connectionId) {
//         loggerObject.i('onReconnected: $connectionId');
//       },
//     );
//
//     hubConnection?.onreconnecting(
//       (error) {
//         loggerObject.i('onReconnecting: $error');
//       },
//     );
//
//     hubConnection?.onclose(
//       (error) {
//         loggerObject.e('onClose: $error');
//       },
//     );
//
//     hubConnection?.on(
//       'ReceiveMessage',
//       (arguments) {
//         var x = jsonDecode(arguments?.firstOrNull.toString() ?? "{}");
//         try {
//           ctx?.read<SignalStudentsCubit>().checkAndAddStudent(
//                 SignalStudent(
//                   message: SignalRecord.fromJson(x),
//                   id: arguments?[1]?.toString() ?? '',
//                   connectionId: arguments?.lastOrNull?.toString() ?? '',
//                 ),
//               );
//         } catch (e) {
//           loggerObject.e(e);
//         }
//       },
//     );
//
//     hubConnection?.on(
//       'UserLeft',
//       (arguments) {
//         ctx?.read<SignalStudentsCubit>().removeStudent((arguments ?? []).cast());
//         loggerObject.d('UserLeft: $arguments');
//       },
//     );
//
//     await hubConnection?.start();
//
//     await hubConnection?.invoke("JoinTopic", args: [
//       "monitor",
//       AppProvider.myId,
//     ]).then(
//       (value) {

//       },
//     );
//   }
//
//
//
//   Future<void> sendMessageToTopic(SignalMessage message) async {
//     hubConnection?.invoke('SendMessageToTopic', args: [jsonEncode(message), 'user', false]).then(
//       (value) {

//       },
//     );
//   }
//
//   void startExam() => sendMessageToTopic(SignalMessage(type: SignalMessageType.startExam));
//
//   void endExam() => sendMessageToTopic(SignalMessage(type: SignalMessageType.closedExam));
// }
