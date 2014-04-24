//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHGameHistoryViewController.h"
#import "WAHAppData.h"
@implementation WAHGameHistoryViewController
{
    NSMutableArray *tableData;
    NSArray *searchResult;
    NSURLConnection *connection;
    NSMutableData *jsonData;
}

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Game History", @"Game History");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize table data
    [self fetchEntries];
}

// Retrieve Game history from database
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    
    NSURL *url;
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Games/GetGameHistoryByPlayerID/%d", [[WAHAppData sharedAppData] playerID]]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection*) conn{
    tableData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:NSJSONReadingMutableContainers
                                                  error:nil];
    
    [[self tableView] reloadData];
    
    jsonData = nil;
    connection = nil;
}

// This table contain the information from the game history such as the two players, the outcome of their match and the date that the game took place
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.numberOfLines  = 0;
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 12.0 ];
    cell.textLabel.font  = myFont;

    NSDictionary* game = [tableData objectAtIndex:indexPath.row];
    NSString* player1 = [[game objectForKey:@"Player"] objectForKey:@"Username"];
    NSString* player2 = [[game objectForKey:@"Player1"] objectForKey:@"Username"];
    NSString* score1 = [game objectForKey:@"FirstPlayerScore"];
    NSString* score2 = [game objectForKey:@"SecondPlayerScore"];
    NSString* gameDate = [game objectForKey:@"GameDate"];
    NSString*gameResult = [NSString stringWithFormat:@"Player1: %@ Player2: %@ \nScore1: %@ Score2: %@ \nDate: %@",
                           player1, player2, score1, score2, gameDate];
    cell.textLabel.text = gameResult;
    return cell;
}

// Left empty all details are on the row no selection needed
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

// Displays if error while retrieve game history data
-(void)connection: (NSURLConnection*) conn didFailWithError:(NSError *)error{
    connection = nil;
    jsonData = nil;
    
    NSString* errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Returns all rows on table 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

@end
