//
//  TsawerViewController.h
//

#import <UIKit/UIKit.h>

@interface TsawerViewController : UIViewController
{
    int index;
}

@property (nonatomic, strong) NSMutableArray * pics;
@property (nonatomic, strong) IBOutlet UIImageView * image;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@end
