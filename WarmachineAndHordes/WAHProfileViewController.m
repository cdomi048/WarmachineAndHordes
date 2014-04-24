//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHProfileViewController.h"
#import "WAHAppData.h"
#import "WAHGameHistoryViewController.h"

@implementation WAHProfileViewController
{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableString *apiAction;
    WAHAppData *appData;
    NSDictionary *playerData;
}

@synthesize playerName, factionName, winLoss;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Profile", @"Profile");
        playerName.text = @"";
        factionName.text = @"";
        winLoss.text = @"";
        apiAction = [NSMutableString stringWithString:@""];
        appData = [WAHAppData sharedAppData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchEntries];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Retrieve players that have option to add notes which is used in table views
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Players/GetPlayerWithNote/%d", [appData playerID]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}
// DIsplays player information such as displays username, faction, and win/loss ration
-(void)connectionDidFinishLoading:(NSURLConnection*) conn{
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];

        playerData = [data objectForKey:@"Player"];
        playerName.text = [playerData objectForKey:@"Username"];
        if([playerData objectForKey:@"Faction"] != nil && [[playerData objectForKey:@"Faction"] count]){
            factionName.text = [[playerData objectForKey:@"Faction"] objectForKey:@"FactionName"];
        }else{
            factionName.text = @"N/A";
        }
        winLoss.text = [data objectForKey:@"WinLoss"];

    jsonData = nil;
    connection = nil;
}

// Displays if error while retrieving player data
-(void)connection: (NSURLConnection*) conn didFailWithError:(NSError *)error{
    connection = nil;
    jsonData = nil;
    
    NSString* errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

//-(IBAction)options:(id)sender
//{
//    NSString *actionSheetTitle = @"Player Info"; //Action Sheet Title
//    NSString *destructiveTitle = @"Delete"; //Action Sheet Button Titles
//    NSString *other1 = @"Detailed Stats";
//    NSString *other2 = @"Game History";
//    NSString *other3 = @"Notes";
//    NSString *cancelTitle = @"Cancel Button";
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:actionSheetTitle
//                                  delegate:self
//                                  cancelButtonTitle:cancelTitle
//                                  destructiveButtonTitle:destructiveTitle
//                                  otherButtonTitles:other1, other2, other3, nil];
//    
//    [actionSheet showInView:self.view];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//    
//    if  ([buttonTitle isEqualToString:@"Destructive Button"]) {
//        NSLog(@"Destructive pressed --> Delete Something");
//    }
//    if ([buttonTitle isEqualToString:@"Other Button 1"]) {
//        NSLog(@"Other 1 pressed");
//    }
//    if ([buttonTitle isEqualToString:@"Other Button 2"]) {
//        NSLog(@"Other 2 pressed");
//    }
//    if ([buttonTitle isEqualToString:@"Other Button 3"]) {
//        NSLog(@"Other 3 pressed");
//    }
//    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
//        NSLog(@"Cancel pressed --> Cancel ActionSheet");
//    }
//}

// Game History Button 
- (IBAction)clickGameHistory:(id)sender {    WAHGameHistoryViewController *detailViewController =
    [[WAHGameHistoryViewController alloc]
     initWithNibName:@"WAHGameHistoryViewController"
     bundle:nil];
    
    detailViewController.navigationItem.title = @"Game History";
    
    [self.navigationController
     pushViewController:detailViewController
     animated:YES];
}
@end
