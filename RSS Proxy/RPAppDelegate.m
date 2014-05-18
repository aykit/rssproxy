//
//  RPAppDelegate.m
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import "RPAppDelegate.h"

#import "RPMasterViewController.h"
#import "RPFeedViewController.h"

#import "MWFeedParser.h"
#import "Feed.h"
#import "FeedItem.h"
#import "NSString+HTML.h"

@implementation RPAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize current_feed;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UITabBarController *tabBarController = [splitViewController.viewControllers lastObject];
//        UINavigationController * navigationController = [tabBarController.viewControllers objectAtIndex:0];
//        splitViewController.delegate = (id)navigationController.topViewController;
//        
//        UITabBarController *masterTabbarController = splitViewController.viewControllers[0];
//        UINavigationController * masterNavigationController = [tabBarController.viewControllers objectAtIndex:0];
//        RPMasterViewController *controller = (RPMasterViewController *)masterNavigationController.topViewController;
//        controller.managedObjectContext = self.managedObjectContext;
    } else {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        UINavigationController * navigationController = [tabBarController.viewControllers objectAtIndex:0];
        RPMasterViewController *controller = (RPMasterViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.managedObjectContext;
        
        UINavigationController * feedNavigationController = [tabBarController.viewControllers objectAtIndex:1];
        RPFeedViewController *feedController = (RPFeedViewController *)feedNavigationController.topViewController;
        feedController.managedObjectContext = self.managedObjectContext;
        
        [self updateFeeds];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSave)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_managedObjectContext];
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RSS_Proxy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RSS_Proxy.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) contextDidSave
{
    [self updateApplicationBadge];
}

- (void) updateFeeds {
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^ {
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Feed" inManagedObjectContext:moc];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSError *error;
        NSArray *feeds = [moc executeFetchRequest:request error:&error];
        
        MWFeedParser* feedParser;
        
        for (Feed* feed in feeds) {
            current_feed = feed;
            NSURL *feedURL = [NSURL URLWithString:feed.link];
            feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
            feedParser.delegate = self;
            feedParser.feedParseType = ParseTypeFull;
            feedParser.connectionType = ConnectionTypeSynchronously;
            [feedParser parse];
        }
    });
}

- (void) updateApplicationBadge
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"FeedItem" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(unread == %@)", @YES];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entityDescription];
    
    NSArray *unreadFeedItems = [context executeFetchRequest:request error:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadFeedItems.count;
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"FeedItem" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title LIKE %@) AND (timestamp == %@)", item.title, item.date];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entityDescription];
    
    NSArray *feedItems = [context executeFetchRequest:request error:nil];
    if (feedItems.count == 0){
        
        FeedItem* newFeedItem = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"FeedItem"
                                 inManagedObjectContext:context];
        
        
        NSString* desc = [item.summary stringByConvertingHTMLToPlainText];
        if (item.content) {
            desc = [item.content stringByConvertingHTMLToPlainText];
        }
        
        newFeedItem.title = item.title;
        newFeedItem.desc = desc;
        newFeedItem.timestamp = item.date;
        newFeedItem.unread = @YES;
        
        [current_feed addItemsObject:newFeedItem];
        
    }
}

- (void) feedParserDidFinish:(MWFeedParser *)parser {
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (![context save:&error]) {
        if (error)
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
}

@end
