

#import "TsawerViewController.h"

@interface TsawerViewController ()

@end

@implementation TsawerViewController

- (void)viewDidLoad {
    NSLog(@"tests");
    [super viewDidLoad];
    if(self.pics.count>0)
    self.image.image = [self.pics objectAtIndex:0];
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"0 pics"
                                      message:@"No pics"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok]; 
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setPics:(NSMutableArray *)pics
{
    _pics = pics;
    
    self.slider.maximumValue = self.pics.count;
    
}

- (IBAction)sliderValueChanged:(id)sender {

    if (self.slider.value>50) {
        if(index<self.pics.count-1)
        {
            self.image.image = [self.pics objectAtIndex:index+1];
            index++;
        }
    }
    
  if (self.slider.value<50) {
        if(index>0)
        {
            self.image.image = [self.pics objectAtIndex:index-1];
            index--;
        }
    }
}

-(IBAction)setNext:(id)sender
{
    if(index<self.pics.count-1)
    {
        self.image.image = [self.pics objectAtIndex:index+1];
        index++;
        
    }
    
}


-(IBAction)setPrevious:(id)sender
{
    if(index>0)
    {
        self.image.image = [self.pics objectAtIndex:index-1];
        index--;
    }
}

@end
