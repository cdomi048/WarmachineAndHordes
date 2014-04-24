//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHFactionSearchViewController.h"

#import "WAHSearchViewController.h"

#import <Foundation/NSJSONSerialization.h> 


@implementation WAHFactionSearchViewController{
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
        self.title = NSLocalizedString(@"Factions", @"Factions");
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Retrieve faction information from the database.
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    
    NSURL *url = [NSURL URLWithString:@"http://deliriouscoderwh.azurewebsites.net/api/Factions/GetFactions"];
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

// Table used to display each faction for the search and the table view. 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WAHSearchViewController *detailViewController =
    [[WAHSearchViewController alloc]
     initWithNibName:@"WAHSearchViewController"
     bundle:nil];
    
//    NSString * factionName = [[tableData objectAtIndex:indexPath.row] objectForKey:@"FactionName"];
//    
//    detailViewController.navigationItem.title = [NSString stringWithFormat:@"%@ Members", factionName];
    
    NSNumber* factionID =nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        factionID = [[searchResult objectAtIndex:indexPath.row] objectForKey:@"FactionID"];
    } else {
        factionID = [[tableData objectAtIndex:indexPath.row] objectForKey:@"FactionID"];
    }
    
    detailViewController.navigationItem.title = @"Members";
    detailViewController.factionID = factionID;
    
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
        cell.textLabel.text = [[searchResult objectAtIndex:indexPath.row] objectForKey:@"FactionName"];
    } else {
        cell.textLabel.text = [[tableData objectAtIndex:indexPath.row] objectForKey:@"FactionName"];
    }
    
    return cell;
}

// Filters through all facion to displays in the search when user types.
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"FactionName contains[cd] %@",
                                    searchText];
    
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
