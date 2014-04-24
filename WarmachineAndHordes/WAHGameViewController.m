//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHGameViewController.h"
#import "WAHInactiveGameViewController.h"
#import "WAHGameSwitchViewController.h"
#import "WAHAppData.h"

@implementation WAHGameViewController{
    NSDictionary *gameData;
    NSURLConnection *connection;
    NSMutableData *jsonData;
    NSMutableString *apiAction;
    WAHAppData* appData;
}

@synthesize firstPlayerName, secondPlayerName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Versus", @"Versus");
        firstPlayerName.text = @"";
        secondPlayerName.text = @"";
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

-(void) viewWillAppear:(BOOL)animated{
    [self fetchEntries];
}

// Retrieve game that was made when player chose an opponent
-(void)fetchEntries
{
    jsonData = [[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Games/GetGame/%@",[appData gameID]]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    [apiAction setString:@"GetGame"];
}

-(void)connection:(NSURLConnection*)conn didReceiveData:(NSData *)data{
    [jsonData appendData:data];
}

// Pop up alerts are created when if game is completed or if game is cancelled. Bring up game and scores to be updated.
-(void)connectionDidFinishLoading:(NSURLConnection*) conn{
    gameData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
    
    if([apiAction isEqual: @"PutGame"])
    {
        NSString *winner = [self returnWinner];
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"The Winner is"
                              message:winner
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        appData.gameID = nil;
        [alert show];
        [appData.tabBar setSelectedIndex:0];
        
    }
    else if([apiAction isEqual: @"CancelGame"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Canceled"
                              message:@"Your game has been canceled."
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        appData.gameID = nil;
        [alert show];
        [appData.tabBar setSelectedIndex:0];
    }
    else if([apiAction isEqual: @"GetGame"]){
        NSString*firstScore = [gameData objectForKey:@"FirstPlayerScore"];
        NSString*secondScore = [gameData objectForKey:@"SecondPlayerScore"];
        [score1 setText:[NSString stringWithFormat:@"%@",firstScore]];
        [score2 setText:[NSString stringWithFormat:@"%@",secondScore]];
        firstPlayerName.text = [[gameData objectForKey:@"Player"] objectForKey:@"Username"];
        secondPlayerName.text = [[gameData objectForKey:@"Player1"] objectForKey:@"Username"];
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

//Takes result from game and send back to database
-(void)pushGameChange: (NSString*) action{
    NSString *post;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://deliriouscoderwh.azurewebsites.net/api/Games/PutGameState/%@", [appData gameID]]];
    NSString *method = @"PUT";
    
    if ([action isEqual: @"SUBMIT"]) {
        post = [NSString stringWithFormat:@"{'GameID':'%@', 'FirstPlayerScore':'%@', 'SecondPlayerScore':'%@', 'GameStateID':'%d'}", [appData gameID], score1.text, score2.text, 2];
        [apiAction setString:@"PutGame"];
    }else if ([action isEqual: @"CANCEL"]){
        post = [NSString stringWithFormat:@"{'GameID':'%@', 'FirstPlayerScore':'%d', 'SecondPlayerScore':'%d', 'GameStateID':'%d'}", [appData gameID], 0, 0, 3];
        [apiAction setString:@"CancelGame"];
    }else{
        return;
    }
    
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

// First counter to add or subtract points from each player
-(IBAction)vsCounter1:(UIStepper*)sender
{
    double value = [sender value];
    [score1 setText:[NSString stringWithFormat:@"%d",(int)value]];
}

// Second counter to add or subtract points from each player
-(IBAction)vsCounter2:(UIStepper*)sender
{
    double value = [sender value];
    [score2 setText:[NSString stringWithFormat:@"%d",(int)value]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 - (void) buttonAction
 {
 if(score1 < score2)
 {
 NSLog(@"Player 1 Wins");
 }
 
 else
 {
 NSLog(@"Player 2 Wins");
 }
 
 }
 */

// Uses counter scores to display who is the winner or if it is tied game
-(NSString *)returnWinner
{
    NSString *winner;
    
    int player1score = [score1.text intValue];
    int player2score = [score2.text intValue];
    
    if(player1score > player2score)
    {
        winner = @"Player 1";
    }
    else if (player1score == player2score)
    {
        winner = @"Tie Game";
    }
    else
    {
        winner = @"Player 2";
    }
    
    return winner;
}


// Confirm button to confirm game
-(IBAction)clickConfirm:(id)sender
{
    [self pushGameChange:@"SUBMIT"];
}

// Cancel button to cancel game
-(IBAction)clickCancel:(id)sender
{
    [self pushGameChange:@"CANCEL"];
}

//Camera button to take pictues 
-(IBAction)takePic:(id)sender
{
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}


#pragma mark - Camera Image Interface
// Cameria interface to use camera
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    // Does hardware support a camera
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    // Create the picker object
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    // Specify the types of camera features available
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // Displays a control that allows the user to take pictures only.
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    // Specify which object contains the picker's methods
    cameraUI.delegate = delegate;
    
    // Picker object view is attached to view hierarchy and displayed.
    [controller presentViewController: cameraUI animated: YES completion: nil ];
    return YES;
}

#pragma mark - Camera Delegate Methods

//Camera delegate method
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

// For responding to the user accepting a newly-captured picture
// Picker passes a NSDictionary with acquired camera data

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    // Create an image and store the acquired picture
    UIImage  *imageToSave;
    imageToSave = (UIImage *) [info objectForKey:
                               UIImagePickerControllerOriginalImage];
    
    // Save the new image to the Camera Roll
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    
    // View the image on screen
    //viewPicture.image = imageToSave;
    
    // Tell controller to remove the picker from the view hierarchy and release object.
    [self dismissViewControllerAnimated: YES completion:nil ];
}




@end
