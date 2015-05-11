

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCamPreviewView.h"

@interface ViewController : UIViewController< AVCaptureVideoDataOutputSampleBufferDelegate>
{
    bool shouldTakePicture;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoDataOutput *videoDataOutput;
    dispatch_queue_t videoDataOutputQueue;
    AVCaptureDevice * videoDevice;
    AVCaptureConnection *videoConnection;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray * pictures;
}

@property (nonatomic, strong) IBOutlet AVCamPreviewView *previewViewVideo;
@property (nonatomic, strong) IBOutlet UIButton * takePict;
@property (nonatomic, strong) id runtimeErrorHandlingObserver;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchCamera;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position;

@end

