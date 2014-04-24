//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHSearchViewController.h"

#import "WAHPlayerViewController.h"

#import <Foundation/NSJSONSerialization.h>


@implementation WAHSearchViewController{
    NSMutableArray *tableData;
    NSArray *searchResult;
    NSURLConnection *connection;
    NSMutableData *jsonData;
}

@synthesize tableView = _tableView;
@synthesize factionID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Players", @"Players");
        
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

// Fetch players from database. First checks for players in faction and than players that arent in a faction.
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    
    NSURL *url;
    
    if(factionID != NULL){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Players/GetPlayersByFactionID/%d", [factionID integerValue]]];
    }else{
        url = [NSURL URLWithString:@"http://deliriouscoderwh.azurewebsites.net/api/Players/GetPlayers"];
    }
    
    
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
// Displays players in table view and allows to check player details when selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     WAHPlayerViewController *detailViewController =
     [[WAHPlayerViewController alloc]
     initWithNibName:@"WAHPlayerViewController"
     bundle:nil];
    
    NSNumber* playerID = nil;
    NSString * playerName = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        playerID = [[searchResult objectAtIndex:indexPath.row] objectForKey:@"PlayerID"];
        playerName = [[searchResult objectAtIndex:indexPath.row] objectForKey:@"Username"];
    } else {
        playerID = [[tableData objectAtIndex:indexPath.row] objectForKey:@"PlayerID"];
        playerName = [[tableData objectAtIndex:indexPath.row] objectForKey:@"Username"];
    }
    
    detailViewController.navigationItem.title = playerName;
    detailViewController.playerID = playerID;
    
     [self.navigationController
     pushViewController:detailViewController
     animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Returns search results to apple to table data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [searchResult count];
    }
    else {
        return [tableData count];
    }
}

// Allows the search to reuse cells in order to constant display results
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResult objectAtIndex:indexPath.row] objectForKey:@"Username"];
    } else {
        cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"Username"];
    }
    return cell;
}

// Filters through all facion to displays in the search when user types.
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Username contains[cd] %@", searchText];
    
    searchResult = [tableData filteredArrayUsingPredicate:resultPredicate];
}

// Search bar delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



@end
