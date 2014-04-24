//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHPlayerViewController.h"

#import "WAHGameViewController.h"

#import "WAHGameSwitchViewController.h"

#import "WAHAppData.h"

@implementation WAHPlayerViewController{
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableString *apiAction;
    WAHAppData *appData;
    NSDictionary *playerData;
}

@synthesize playerID, playerName, factionName, winLoss,  playerNote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        playerName.text = @"";
        factionName.text = @"";
        winLoss.text = @"";
        playerNote.text = @"";
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

// Fetches each players page and stats from online database
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Players/GetPlayerWithNote/%d/%d", [playerID integerValue], [appData playerID]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    [apiAction setString:@"GetPlayer"];
}

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}

// Users can choose to start a game with each player avaial
-(void)connectionDidFinishLoading:(NSURLConnection*) conn{
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    if([apiAction isEqual: @"AddGame"])
    {
        appData.gameID = [data objectForKey:@"GameID"];
        [[appData tabBar] setSelectedIndex:2];
    }
    else if([apiAction isEqual: @"GetPlayer"]){
        playerData = [data objectForKey:@"Player"];
        playerName.text = [playerData objectForKey:@"Username"];
        if([playerData objectForKey:@"Faction"] != nil && [[playerData objectForKey:@"Faction"] count]){
            factionName.text = [[playerData objectForKey:@"Faction"] objectForKey:@"FactionName"];
        }else{
            factionName.text = @"N/A";
        }
        NSArray *notes = [playerData objectForKey:@"PlayerNotes"];
        if (notes.count > 0) {
            playerNote.text = [[notes objectAtIndex:0] objectForKey:@"Note"];
        }else{
            playerNote.text = @"";
        }
        winLoss.text = [data objectForKey:@"WinLoss"];
    }else{
            return;
    }
    
    jsonData = nil;
    connection = nil;
}

-(void)connection: (NSURLConnection*) conn didFailWithError:(NSError *)error{
    connection = nil;
    jsonData = nil;
    
    NSString* errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{

}
    
- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    [self pushNoteChanges:textView.text];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

// Checks if player has note to display. If new note is created or old note is change it is sent back to database to be avaiable on return  viewing player.
-(void)pushNoteChanges: (NSString*) note{
    NSString *post;
    NSURL *url;
    NSMutableString *method;
    NSArray *notes = [playerData objectForKey:@"PlayerNotes"];
    if (notes.count > 0) {
        int noteID = [[[notes objectAtIndex:0] objectForKey:@"PlayerNoteID"] integerValue];
        method = [NSMutableString stringWithString:@"PUT"];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/PlayerNotes/PutPlayerNote/%d", noteID]];
        post = [NSString stringWithFormat:@"{'PlayerNoteID':'%d', 'CreatorPlayerID':'%d', 'SubjectPlayerID':'%@', 'Note':'%@'}", noteID, [appData playerID], playerID, note];
    }else{
         method = [NSMutableString stringWithString:@"POST"];
        url = [NSURL URLWithString:@"http://deliriouscoderwh.azurewebsites.net/api/PlayerNotes/PostPlayerNote"];
        post = [NSString stringWithFormat:@"{'CreatorPlayerID':'%d', 'SubjectPlayerID':'%@', 'Note':'%@'}", [appData playerID], playerID, note];
    }
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:method];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:nil];
    if (connection) {
        jsonData = [NSMutableData data];
    }
}

// Creates game for two players sets the delegate with an action
-(void)addGame{
    NSString *post;
    NSURL *url;
    NSMutableString *method;

    method = [NSMutableString stringWithString:@"POST"];
    url = [NSURL URLWithString:@"http://deliriouscoderwh.azurewebsites.net/api/Games/PostGame"];
    post = [NSString stringWithFormat:@"{'FirstPlayerID':'%d', 'SecondPlayerID':'%@', 'GameStateID':'1'}", [appData playerID], playerID];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:method];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        jsonData = [NSMutableData data];
    }
}

// Start a game button to create a game
- (IBAction)clickStartGame:(id)sender {
    [apiAction setString:@"AddGame"];
    [self addGame];
}
@end
