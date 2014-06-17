//
//  RPFeedViewController.h
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "MWFeedParser.h"

@interface RPFeedViewController : UITableViewController <NSFetchedResultsControllerDelegate, MWFeedParserDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction) addNewFeed;
- (void) addFeedNamedFromSource: (NSString*) source;

@end
