//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import "WAHAppData.h"

@implementation WAHAppData

@synthesize playerID, gameID, tabBar;

+ (id)sharedAppData {
    static WAHAppData *sharedAppData = nil;
    @synchronized(self) {
        if (sharedAppData == nil)
            sharedAppData = [[self alloc] init];
    }
    return sharedAppData;
}

-(id) init{
    self = [super init];
    
    if(self){
        playerID = 0;
        gameID = nil;
        tabBar = nil;
    }
    return self;
}

@end
