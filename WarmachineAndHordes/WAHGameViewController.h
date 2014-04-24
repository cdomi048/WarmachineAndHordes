//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface WAHGameViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    IBOutlet UILabel *score1;
    IBOutlet UILabel *score2;
}

@property (strong, nonatomic) IBOutlet UILabel *firstPlayerName;
@property (strong, nonatomic) IBOutlet UILabel *secondPlayerName;

-(IBAction)vsCounter1:(UIStepper*)sender;
-(IBAction)vsCounter2:(UIStepper*)sender;
-(IBAction)clickConfirm:(id)sender;
-(IBAction)clickCancel:(id)sender;
-(IBAction)takePic:(id)sender;

@end
