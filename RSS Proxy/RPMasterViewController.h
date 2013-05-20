//
//  RPMasterViewController.h
//  RSS Proxy
//
//  Created by Markus Klepp on 5/20/13.
//  Copyright (c) 2013 aykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPDetailViewController;

#import <CoreData/CoreData.h>

@interface RPMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) RPDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
