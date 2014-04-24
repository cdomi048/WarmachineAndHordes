//  PROGRAMMER: Jonthan Cifuentes & Cesar Dominici
//  CLASS:          COP 4655 MW 5:00
//  INSTRUCTOR:     Steve Luis
//  ASSIGNMENT:     Warmachine and Hordes
//  DUE:            Wednesday 4/23/2014
//


#import <Foundation/Foundation.h>

@interface WAHAppData : NSObject

@property (nonatomic) int playerID;
@property (nonatomic) NSNumber* gameID;
@property (strong, nonatomic) UITabBarController* tabBar;

+ (id)sharedAppData;

@end
