//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//
#import <UIKit/UIKit.h>
@class WAHGameViewController;
@class WAHInactiveGameViewController;

@interface WAHGameSwitchViewController : UIViewController

@property (strong, nonatomic) WAHGameViewController *activeViewController;
@property (strong, nonatomic) WAHInactiveGameViewController *inactiveViewController;

@end
