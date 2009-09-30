//
//  QueryServicesController.h
//  CaGrid
//
//  Created by Konrad Rokicki on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryResultsController;

@interface QueryServicesController : UITableViewController {
	UINavigationController *navController;
    QueryResultsController *detailController;
	NSMutableDictionary *request;
    NSMutableArray *urls;
    NSMutableArray *failedUrls;

}

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) QueryResultsController *detailController;
@property (nonatomic, retain) NSMutableDictionary *request;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) NSMutableArray *failedUrls;

- (void)displayRequest:(NSMutableDictionary *)requestDict;

@end
