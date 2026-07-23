# Fix FilePicker usage in SharedWhiteboardWidget

The user is experiencing a `NoSuchMethodError: 'result'` and `Bytes available: false` when picking files in the `SharedWhiteboardWidget`.

## Analysis of the issues

### 1. `Bytes available: false`
In the current code, `FilePicker.pickFiles` is called without `withData: true`. According to the `file_picker` documentation, the `bytes` property of `PlatformFile` is `null` by default on mobile platforms (Android/iOS) to save memory. Since the code immediately attempts to use `file.bytes!`, this causes a crash or failure in the logic.

### 2. `NoSuchMethodError: 'result'`
This error (referencing `Instance of 'Window'`) is often seen in Flutter Web when there is a mismatch between the plugin version and the Flutter environment, or when a static method is called in a way that conflicts with something in the JS interop.

## Proposed Changes

### [Component] [shared_whiteboard](file:///C:/Users/Lenovo/StudioProjects/coretech/livekit_projects/livekit_manager/lib/features/shared_whiteboard)

#### [MODIFY] [shared_whiteboard_widget.dart](file:///C:/Users/Lenovo/StudioProjects/coretech/livekit_projects/livekit_manager/lib/features/shared_whiteboard/ui/widget/shared_whiteboard_widget.dart)

1.  **Switch to `FilePicker.platform.pickFiles()`**: This is the recommended way to invoke the picker and is more robust across platforms.
2.  **Add `withData: true`**: This ensures that `bytes` are available even on mobile platforms.
3.  **Add safety checks**: Verify `result.files` is not empty before accessing `.first`.

```dart
// Suggested change:
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
  allowMultiple: false,
  withData: true, // Required for bytes on mobile
);

if (result != null && result.files.isNotEmpty) {
  final file = result.files.first;
  if (file.bytes != null) {
    cubit.uploadAndSetBackground(file.bytes!, file.extension ?? 'jpg');
  }
}
```

## Verification Plan

### Manual Verification
- Test the "Add Background" button on both Web and Mobile (Android) if possible.
- Verify that the image is correctly picked and uploaded to the whiteboard.
