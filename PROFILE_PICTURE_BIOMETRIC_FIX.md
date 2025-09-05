# Profile Picture Biometric Authentication Fix

## Problem
When users changed their profile picture, the app would navigate to the photo library, causing the app to enter a paused state. This triggered the biometric authentication system, which would redirect users to the dashboard instead of allowing them to complete the profile picture update flow.

**Additional Issue**: After pressing 'done' when cropping the profile picture, biometric authentication would initiate and the photo would never get uploaded.

## Root Cause
The BiometricSecurityService monitors app lifecycle changes and triggers biometric authentication when the app transitions from `paused` to `resumed` states. When accessing the photo library through ImagePicker, the app goes to `paused` state, and upon returning, the biometric authentication would be triggered, interrupting the profile picture selection workflow.

The second issue occurred because the biometric authentication protection flag was being cleared too early in the flow, before the upload process completed.

## Solution
Implemented a comprehensive state flag mechanism to disable biometric authentication during the entire profile picture workflow:

### 1. Updated AuthState (`lib/utils/app_state.dart`)
- Added `_isImagePickingInProgress` boolean flag
- Added getter `isImagePickingInProgress`
- Added setter `setImagePickingInProgress(bool value)`

### 2. Updated BiometricSecurityService (`lib/services/biometric_security_service.dart`)
- Modified `_handleAppBackgrounded()` to check if image picking is in progress
- Modified `_shouldShowBiometricAuthentication()` to return false when image picking is active
- Added logging to track when biometric auth is skipped due to image picking

### 3. Updated Profile Picture Component (`lib/screens/profile/components/name_cid.dart`)
- **Complete workflow protection**: Flag is set at the start of image selection and maintained through the entire process
- **Proper flag lifecycle management**: Flag is only cleared when upload completes OR user cancels
- **Multiple interaction support**: Edit/crop operations within the modal don't interfere with flag state

## Complete Flow Protection

### Image Selection Flow
```dart
_selectAndPreviewImage() {
  // 1. Set flag at start of image selection
  authState.setImagePickingInProgress(true);
  
  // 2. Pick image from gallery
  // 3. Crop image  
  // 4. Show preview modal
  // 5. Flag remains active until user takes final action
}
```

### Preview Modal Actions
```dart
// Edit Button - Re-crop without clearing flag
onPressed: () async {
  File? croppedFile = await _cropImage(imageFile);
  // Flag remains active
}

// Upload Button - Complete upload then clear flag
onPressed: () async {
  try {
    await _uploadProfilePicture(context, cid, imageFile);
  } finally {
    authState.setImagePickingInProgress(false); // Clear flag after upload
  }
}

// Cancel Button - Clear flag immediately
onPressed: () {
  authState.setImagePickingInProgress(false); // Clear flag on cancel
  Navigator.pop(modalContext);
}
```

## Implementation Details

### AuthState Changes
```dart
// New field
bool _isImagePickingInProgress = false;

// New getter
bool get isImagePickingInProgress => _isImagePickingInProgress;

// New setter
void setImagePickingInProgress(bool value) {
  _isImagePickingInProgress = value;
  notifyListeners();
}
```

### BiometricSecurityService Changes
```dart
// In _handleAppBackgrounded()
if (authState.isImagePickingInProgress) {
  log('BiometricSecurityService: Image picking in progress, skipping biometric auth');
  return;
}

// In _shouldShowBiometricAuthentication()
if (isImagePickingInProgress) {
  return false;
}
```

### Key Improvements in v2
- **Extended protection period**: Flag now covers the entire workflow from image selection to upload completion
- **Proper cancel handling**: Flag is cleared when user cancels the operation
- **Multiple crop support**: Users can crop multiple times within the same session without flag interference
- **Robust error handling**: Flag is always cleared in finally blocks to prevent stuck states

## Testing Scenarios
The fix ensures that:
1. ✅ Users can select images from photo library without biometric auth interruption
2. ✅ Users can crop images multiple times without biometric auth interruption  
3. ✅ Users can complete the full upload process without biometric auth interruption
4. ✅ Biometric auth is properly re-enabled after upload completes
5. ✅ Biometric auth is properly re-enabled if user cancels
6. ✅ Normal biometric authentication behavior continues for all other app transitions
7. ✅ No stuck states if errors occur during the process

## Files Modified
- `lib/utils/app_state.dart`
- `lib/services/biometric_security_service.dart`  
- `lib/screens/profile/components/name_cid.dart`

## Impact
- ✅ Users can successfully change their profile pictures without any biometric authentication interruption
- ✅ Upload process completes successfully after cropping
- ✅ Normal biometric security behavior is preserved for all other scenarios
- ✅ Backward compatibility maintained
- ✅ Clean error handling with proper flag cleanup
- ✅ Support for multiple edit/crop operations within the same session
