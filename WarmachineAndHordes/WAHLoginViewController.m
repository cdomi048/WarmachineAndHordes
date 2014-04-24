//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import "WAHLoginViewController.h"
#import "WAHSearchViewController.h"
#import "WAHFactionSearchViewController.h"
#import "WAHGameViewController.h"
#import "WAHProfileViewController.h"
#import "WAHAppData.h"
#import "WAHInactiveGameViewController.h"
#import "WAHRegisterViewController.h"
#import "WAHGameSwitchViewController.h"

@implementation WAHLoginViewController{
    NSDictionary *playerData;
    NSURLConnection *connection;
    NSMutableData *jsonData;
}

@synthesize usernameField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)clickLogin:(id)sender {
    [self fetchPlayer];
}

// Starts up application with all needed viewcontrollers
-(void)startApplication{
    WAHAppData* appData = [WAHAppData sharedAppData];
    appData.playerID = [[playerData objectForKey:@"PlayerID"] integerValue];
    if([playerData objectForKey:@"Games"] != nil && [[playerData objectForKey:@"Games"] count] > 0){
        appData.gameID = [[[playerData objectForKey:@"Games"] objectAtIndex:0] objectForKey:@"GameID"];
    }
    
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    appData.tabBar = tabBarController;
    
    UIViewController *playerController = [[WAHSearchViewController alloc] initWithNibName:@"WAHSearchViewController" bundle:nil];
    UINavigationController *playerNavController = [[UINavigationController alloc] initWithRootViewController:playerController];
    [playerNavController.navigationBar setTintColor:[UIColor blackColor]];
    UIViewController *factionController = [[WAHFactionSearchViewController alloc] initWithNibName:@"WAHFactionSearchViewController" bundle:nil];
    UINavigationController *factionNavController = [[UINavigationController alloc] initWithRootViewController:factionController];
    [factionNavController.navigationBar setTintColor:[UIColor blackColor]];
    UIViewController *profileController = [[WAHProfileViewController alloc] initWithNibName:@"WAHProfileViewController" bundle:nil];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileController];
    [profileNavController.navigationBar setTintColor:[UIColor blackColor]];
    
    WAHGameSwitchViewController *gameController = [[WAHGameSwitchViewController alloc] initWithNibName:@"WAHGameSwitchViewController" bundle:nil];
    
    
    
    tabBarController.viewControllers = @[playerNavController, factionNavController, gameController, profileNavController];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}

-(void)fetchPlayer{
    NSString *post;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Players/PostPlayerLogin"]];
    NSString *method = @"POST";
    
    post = [NSString stringWithFormat:@"{'Username':'%@', 'Password':'%@'}", usernameField.text, passwordField.text];
    
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

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection*) conn{
    playerData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
    
    if(playerData != nil){
//        playerName.text = [playerData objectForKey:@"Username"];
        [self startApplication];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Failed Login"
                              message:@"Please verify your credentials."
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        
        [alert show];
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


- (IBAction)clickSignUp:(id)sender {
    UIViewController *registerController = [[WAHRegisterViewController alloc] initWithNibName:@"WAHRegisterViewController" bundle:nil];
    
    registerController.navigationItem.title = @"Register";
    
    [self.navigationController
     pushViewController:registerController
     animated:YES];
}
@end
