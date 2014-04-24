//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import <UIKit/UIKit.h>

@interface WAHPlayerViewController : UIViewController <UITextViewDelegate>

@property (nonatomic) NSNumber *playerID;
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UILabel *factionName;
@property (strong, nonatomic) IBOutlet UILabel *winLoss;
@property (strong, nonatomic) IBOutlet UITextView *playerNote;

- (IBAction)clickStartGame:(id)sender;
@end
