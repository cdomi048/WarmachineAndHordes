//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import <UIKit/UIKit.h>

@interface WAHFactionSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
