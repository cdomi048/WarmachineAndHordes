//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//

#import "WAHGameSwitchViewController.h"

#import "WAHGameViewController.h"
#import "WAHInactiveGameViewController.h"
#import "WAHAppData.h"

@implementation WAHGameSwitchViewController{
    WAHAppData *appData;
}

@synthesize activeViewController, inactiveViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Versus", @"Versus");
        appData = [WAHAppData sharedAppData];
    }
    return self;
}

// Displays an inactive screen if page is select and no one to playing. Must select a player to play with in order to retrieve active screen.
- (void)viewDidLoad
{
     WAHGameViewController *activeController = [[WAHGameViewController alloc]
										  initWithNibName:@"WAHGameViewController" bundle:nil];
    WAHInactiveGameViewController *inactiveController = [[WAHInactiveGameViewController alloc]
                                    initWithNibName:@"WAHInactiveGameViewController" bundle:nil];
    self.activeViewController = activeController;
    self.inactiveViewController = inactiveController;
    if([appData gameID]){
        [self.view insertSubview:activeController.view atIndex:0];
    }else{
        [self.view insertSubview:inactiveController.view atIndex:0];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    if([appData gameID]){
        if(self.activeViewController.view.superview == nil){
            [inactiveViewController.view removeFromSuperview];
        }else{
            [activeViewController.view removeFromSuperview];
        }
        activeViewController = [[WAHGameViewController alloc]
                                initWithNibName:@"WAHGameViewController" bundle:nil];
        [self.view insertSubview:self.activeViewController.view atIndex:0];
    }else{
        if(self.inactiveViewController.view.superview == nil){
            [activeViewController.view removeFromSuperview];
        }else{
            [inactiveViewController.view removeFromSuperview];
        }
        inactiveViewController = [[WAHInactiveGameViewController alloc]
                              initWithNibName:@"WAHInactiveGameViewController" bundle:nil];
        [self.view insertSubview:self.inactiveViewController.view atIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
