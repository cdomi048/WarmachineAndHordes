//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import "WAHInactiveGameViewController.h"

@implementation WAHInactiveGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Versus", @"Versus");
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

@end
