# Walkthrough - Fixing FilePicker usage

I have fixed the issues with file picking in the shared whiteboard feature.

## Changes Made

### Shared Whiteboard

#### [shared_whiteboard_widget.dart](file:///C:/Users/Lenovo/StudioProjects/coretech/livekit_projects/livekit_manager/lib/features/shared_whiteboard/ui/widget/shared_whiteboard_widget.dart)

- Changed `FilePicker.pickFiles` to `FilePicker.platform.pickFiles` for better platform compatibility.
- Added `withData: true` to ensure file bytes are loaded into memory, which is required for the upload process.
- Improved null checks to safely handle cases where picking is canceled or bytes are not available.

## Verification Results

### Code Review
- The code now correctly requests bytes from the platform.
- The use of `FilePicker.platform` avoids potential JS interop issues on Web.
- The check `result.files.isNotEmpty` prevents potential crashes if `files` list is empty despite `result` not being null.
