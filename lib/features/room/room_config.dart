import 'package:livekit_client/livekit_client.dart';

class RoomConfig {
  RoomConfig._internal();

  static final RoomConfig _instance = RoomConfig._internal();

  static RoomConfig get instance => _instance;

  final connectionOption = ConnectOptions(
    // الإصدار 16 يدعم ميزات النقل الكامل للمشاركين وتحسين استقرار الجلسة
    protocolVersion: ProtocolVersion.v16,
    rtcConfiguration: const RTCConfiguration(
      // يسمح بجمع مرشحي الاتصال مسبقاً لتسريع عملية الربط عند ضعف الشبكة
      iceCandidatePoolSize: 2,
      // يفضل تركها فارغة ليعتمد التطبيق على السيرفر (إلا إذا كان لديك TURN Server خاص)
      // iceServers: [],
      // 'all' تسمح بالاتصال المباشر أو عبر Relay لضمان أقصى توافقية
      iceTransportPolicy: RTCIceTransportPolicy.all,
      // تفعيل QoS على مستوى الشبكة لإعطاء أولوية لحزم بيانات الصوت والفيديو
      isDscpEnabled: true,
      encodedInsertableStreams: false, // لا تحتاجه إلا إذا كنت تشفر البيانات يدوياً
    ),
    timeouts: const Timeouts(
      // مهلة كافية للاتصال الأولي قبل اعتبار العملية فاشلة
      connection: Duration(seconds: 15),
      // لتقليل الضغط الناتج عن تغيرات الشبكة السريعة
      debounce: Duration(milliseconds: 100),
      // مهلة نشر المسار (صوت/فيديو)
      publish: Duration(seconds: 10),
      // مهلة الاشتراك في مسارات الآخرين
      subscribe: Duration(seconds: 10),
      // أهم قيمة لاستقرار الـ WebRTC؛ تمنح وقت للشبكة المتعثرة قبل الفصل
      peerConnection: Duration(seconds: 15),
      // إعادة تشغيل الـ ICE فور حدوث فشل لمحاولة إيجاد مسار جديد دون قطع الجلسة
      iceRestart: Duration(seconds: 10),
    ),
  );

  final roomOptions = RoomOptions(
    adaptiveStream: true,
    // يقوم السيرفر بإرسال الجودة التي تناسب حجم الـ Widget فقط
    dynacast: true,
    // يوقف بث طبقات الفيديو التي لا يشاهدها أحد حالياً (توفير للناشر)
    defaultVideoPublishOptions: VideoPublishOptions(
      videoCodec: 'vp9',
      // تفعيل VP9 لدعم SVC
      scalabilityMode: 'L3T3',
      // نمط SVC: 3 طبقات دقة و3 طبقات فريمات
      simulcast: false,
      // SVC يغني عن الـ Simulcast ويوفر الباندويث
      videoEncoding: VideoEncoding(
        maxBitrate: 1500000, // حد أقصى للجودة العالية
        maxFramerate: 23,
      ),
      screenShareEncoding: VideoEncoding(
        maxFramerate: 15,
        maxBitrate: 1500000,
      ),
    ),
    // ---------------------------------------------------------
    // 2. خيارات التقاط الكاميرا (Camera Capture Options)
    // ---------------------------------------------------------
    defaultCameraCaptureOptions: CameraCaptureOptions(
      // الكاميرا الافتراضية (أمامية/خلفية)
      cameraPosition: CameraPosition.front,
      // وضع التركيز (تلقائي/مغلق)
      focusMode: CameraFocusMode.auto,
      // وضع التعرض للضوء (تلقائي/مغلق)
      exposureMode: CameraExposureMode.auto,
      // إيقاف الكاميرا فعلياً عند الكتم بدلاً من إرسال إطارات سوداء
      stopCameraCaptureOnMute: true,
      // الحد الأقصى لمعدل الإطارات
      maxFrameRate: 23.0,
      // لتحديد كاميرا معينة عبر الـ ID الخاص بها
      deviceId: null,
      params: VideoParametersPresets.h540_169,
    ),

    // ---------------------------------------------------------
    // 3. خيارات التقاط الشاشة (Screen Share Capture Options)
    // ---------------------------------------------------------
    defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(
      useiOSBroadcastExtension: true,
      // استخدام إضافة البث الخاصة بـ iOS لمشاركة الشاشة
      captureScreenAudio: false,
      // التقاط صوت النظام (للويب فقط)
      preferCurrentTab: false,
      // تفضيل التقاط التبويب الحالي (للويب فقط)
      // selfBrowserSurface: 'exclude', // استبعاد تبويب المتصفح الحالي من المشاركة لمنع تكرار الشاشة
      maxFrameRate: 12.0,
      // معدل إطارات منخفض يكفي لمشاركة الشاشة
      params: VideoParametersPresets.screenShareH1080FPS15, // دقة مشاركة الشاشة
    ),

    // ---------------------------------------------------------
    // 4. خيارات التقاط الصوت المايكروفون (Audio Capture Options)
    // ---------------------------------------------------------
    defaultAudioCaptureOptions: AudioCaptureOptions(
      echoCancellation: true,
      // تفعيل إلغاء الصدى
      noiseSuppression: true,
      // تفعيل عزل الضوضاء
      autoGainControl: true,
      // التحكم التلقائي بمستوى الصوت (AGC)
      voiceIsolation: true,
      // عزل الصوت البشري (ميزة متقدمة)
      typingNoiseDetection: true,
      // اكتشاف وعزل صوت الكتابة على الكيبورد
      highPassFilter: false,
      // فلتر تمرير الترددات العالية
      stopAudioCaptureOnMute: true,
      // إيقاف المايكروفون فعلياً من النظام عند الكتم
      deviceId: null, // تحديد مايكروفون معين
      // processor: null, // إضافة معالجة صوتية مخصصة
    ),

    // ---------------------------------------------------------
    // 6. خيارات نشر الصوت (Audio Publish Options)
    // ---------------------------------------------------------
    defaultAudioPublishOptions: AudioPublishOptions(
      name: AudioPublishOptions.defaultMicrophoneName,
      // اسم المسار الافتراضي (microphone)
      stream: null,
      // يُترك فارغاً أو يُوحد مع الفيديو للمزامنة
      dtx: true,
      // إيقاف إرسال الحزم أثناء الصمت لتوفير الباندويث (Discontinuous Transmission)
      red: false,
      // تعطيل الحزم الصوتية المكررة لتخفيف استهلاك الشبكة (Redundant Audio)
      preConnect: false, // تحديد ما إذا كان الصوت قادماً من الـ pre-connect buffer
      // encoding: AudioEncoding.presetMusic, // تشفير مخصص (مثلاً presetMusic لدقة صوت عالية)
    ),
    // ---------------------------------------------------------
    // 7. خيارات مخرجات الصوت (Audio Output Options)
    // ---------------------------------------------------------
    defaultAudioOutputOptions: AudioOutputOptions(
      deviceId: null, // تحديد سماعة أو جهاز إخراج معين
      speakerOn: true, // تشغيل السبيكر الخارجي كوضع افتراضي في الموبايل
    ),
  );
}
