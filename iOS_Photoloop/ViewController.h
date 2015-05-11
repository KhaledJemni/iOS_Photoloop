//
//  ViewController.h
//  iOS_Photoloop
//
//  Created by Khaled Jemni on 11/05/15.
//  Copyright (c) 2015 Khaled Jemni. All rights reserved.
//

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


@property (strong, nonatomic) IBOutlet AVCamPreviewView *previewViewVideo;
@property (weak, nonatomic) IBOutlet UIButton *takePic;
@property (nonatomic, strong) id runtimeErrorHandlingObserver;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic) BOOL lockInterfaceRotation;

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position;

@end


