//
//  RPAppDelegate.h
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "Feed.h"

@interface RPAppDelegate : UIResponder <UIApplicationDelegate, MWFeedParserDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) Feed *current_feed;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateFeeds;


@end
