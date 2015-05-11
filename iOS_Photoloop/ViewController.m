//
//  ViewController.m
//  iOS_Photoloop
//
//  Created by Khaled Jemni on 11/05/15.
//  Copyright (c) 2015 Khaled Jemni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pictures = [NSMutableArray new];
    [self setupAVCapture];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async([self sessionQueue], ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
        [self addObserver:self forKeyPath:@"movieFileOutput.recording" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:RecordingContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:[[self videoDeviceInput] device]];
        
        __weak ViewController *weakSelf = self;
        [self setRuntimeErrorHandlingObserver:[[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:[self session] queue:nil usingBlock:^(NSNotification *note) {
            ViewController *strongSelf = weakSelf;
            dispatch_async([strongSelf sessionQueue], ^{
                // Manually restarting the session since it must have been stopped due to an error.
                
                [[strongSelf session] startRunning];
                
            });
        }]];
        
        [[self session] startRunning];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) takePicture:(id)sender
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                      target:self selector:@selector(takePicture:) userInfo:nil repeats:NO];
    
    
    
    shouldTakePicture = YES;
    
    if (pictures.count==20) {
        
        [timer invalidate];
        timer = nil;
        [self performSegueWithIdentifier:@"tsawer" sender:self];
    }
    
}


-(void)setupAVCapture{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    [[self previewViewVideo] setSession:session];
    ((AVCaptureVideoPreviewLayer*)self.previewViewVideo.layer).videoGravity = AVLayerVideoGravityResize;
    
    [session setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setSessionQueue:sessionQueue];
    dispatch_async(sessionQueue, ^{
        [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
        
        NSError *error = nil;
        
        videoDevice = [ViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        
        if ([session canAddInput:videoDeviceInput])
        {
            [session addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[(AVCaptureVideoPreviewLayer *)[[self previewViewVideo] layer] connection] setVideoOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
            });
        }
        
        
        
        
        
        AVCaptureVideoDataOutput * videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [videoOutput setVideoSettings:videoSettings];
        videoOutput.alwaysDiscardsLateVideoFrames = NO;
        if ([videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [videoDevice lockForConfiguration:&error]) {
            [videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [videoDevice unlockForConfiguration];
        }
        if ([session canAddOutput:videoOutput])
        {
            [session addOutput:videoOutput];
            videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
            [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            
        }
    });
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (shouldTakePicture) {
        
        shouldTakePicture = NO;
        
        @autoreleasepool {
            
            UIImage * image = [self getUIImageFromBuffer:sampleBuffer];
            
            [pictures addObject:image];
            [self.takePic setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)pictures.count] forState:UIControlStateNormal];
        }
        
        
        
    }
    
}

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
    
}







-(UIImage*) getUIImageFromBuffer:(CMSampleBufferRef) sampleBuffer{
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if (imageBuffer==NULL) {
        NSLog(@"No buffer");
    }
    
    // Lock the base address of the pixel buffer
    if((CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly))==kCVReturnSuccess){
        
    }
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image= [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,kCVPixelBufferLock_ReadOnly);
    
    
    return (image );
    
}



@end
