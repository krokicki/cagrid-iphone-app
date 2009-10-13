//
//  QueryRequestController.m
//  CaGrid
//
//  Created by Konrad Rokicki on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QueryRequestController.h"
#import "QueryServicesController.h"
#import "QueryRequestCell.h"
#import "ServiceMetadata.h"
#import "UserPreferences.h"
#import "QueryService.h"

@implementation QueryRequestController
@synthesize requestsTable;
@synthesize navController;
@synthesize serviceResultsController;
@synthesize requestToRetry;
@synthesize requestLastAdded;

#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
    self.requestsTable = nil;
    self.navController = nil;
    self.serviceResultsController = nil;
    self.requestToRetry = nil;
    self.requestLastAdded = nil;
    [super dealloc];
}



#pragma mark -
#pragma mark Search Bar Methods

- (void)searchFor:(NSString *)searchString inDataType:(DataType)dataType {
	
    NSString *scope = [Util getNameForDataType:dataType];
    
    NSLog(@"Search %@ for %@",scope,searchString);
    
    NSMutableDictionary *queryRequest = [NSMutableDictionary dictionary];
    [queryRequest setObject:searchString forKey:@"searchString"];
    
    ServiceMetadata *sm = [ServiceMetadata sharedSingleton];
    
    NSMutableArray *services = [sm getServicesOfType:dataType];
    NSMutableDictionary *selectedService = nil;
    
    int c = 0;
    for(NSMutableDictionary *service in services) {
    	if ([[UserPreferences sharedSingleton] isSelectedForSearch:[service objectForKey:@"id"]]) {
        	selectedService = service;
            c++;
        }
    }
    
    if (!c) {
    	// alert user
        return;
    }
    
    if (c > 1) {
        // search all
		[queryRequest setObject:scope forKey:@"scope"];
    }
    else {
        [queryRequest setObject:[selectedService objectForKey:@"url"] forKey:@"serviceUrl"];
        [queryRequest setObject:[selectedService objectForKey:@"name"] forKey:@"service_name"];
        [queryRequest setObject:[selectedService objectForKey:@"host_short_name"] forKey:@"host_short_name"];        
    }
    
    self.requestLastAdded = queryRequest;
    [[QueryService sharedSingleton] executeQuery:queryRequest];
    
    [self.requestsTable reloadData];
}

#pragma mark -
#pragma mark Search Result Delegate Methods

- (void)requestCompleted:(NSMutableDictionary *)request {
    [self.requestsTable reloadData];
}

- (void)requestHadError:(NSMutableDictionary *)request {
    NSMutableDictionary *error = [request objectForKey:@"error"];
    NSString *errorType = [error objectForKey:@"error"];
    NSString *message = [error objectForKey:@"message"];
    NSLog(@"%@: %@",errorType,message);
    [self.requestsTable reloadData];
}


#pragma mark -
#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Retry"]) {
        [requestToRetry removeObjectForKey:@"results"];
        [requestToRetry removeObjectForKey:@"error"];        
        [[QueryService sharedSingleton] executeQuery:requestToRetry];
        [self.requestsTable reloadData];
    }
    self.requestToRetry = nil;
}


#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView 
 		numberOfRowsInSection:(NSInteger)section {
    QueryService *rc = [QueryService sharedSingleton];
	return [rc.queryRequests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    QueryService *rc = [QueryService sharedSingleton];
    NSMutableDictionary *queryRequest = [rc.queryRequests objectAtIndex:[indexPath row]];
    
	// Get a cell
	static NSString *cellIdentifier = @"QueryRequestCell";	
	QueryRequestCell *cell = (QueryRequestCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
    
    cell.alertImageView.hidden = YES;
        
    if ([queryRequest objectForKey:@"results"] != nil) {
	    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    	[cell.indicator stopAnimating];
    }
    else if ([queryRequest objectForKey:@"error"] != nil) {
    	[cell.indicator stopAnimating];
	    cell.alertImageView.hidden = NO;
    }
    else {
    	[cell.indicator startAnimating];
    }

    cell.titleLabel.text = [NSString stringWithFormat:@"\"%@\"", [queryRequest objectForKey:@"searchString"]];
    
    NSString *locationList = nil;
    NSString *serviceName = [queryRequest objectForKey:@"service_name"];
    if (serviceName != nil) {
        locationList = [queryRequest objectForKey:@"host_short_name"];
    }
    else {
        locationList = @"all";
    }
    
    NSString *scope = [queryRequest objectForKey:@"scope"];
    if (scope == nil) scope = @"Microarray";
    // TODO: get the real scope
    
    cell.descLabel.text = [NSString stringWithFormat:@"%@ search on 09/20/2009 at 2:30pm", scope];
    cell.locations = [NSString stringWithFormat:@"Locations: %@",locationList];
    cell.highlightView.alpha = 0.0;
    
    if (queryRequest == self.requestLastAdded) {
        self.requestLastAdded = nil;        
		cell.highlightView.alpha = 1.0;        
		[UIView beginAnimations:@"frame" context:nil];
		[UIView setAnimationDuration:2.0];
        cell.highlightView.alpha = 0.0;
		[UIView commitAnimations];
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView
		didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    QueryService *rc = [QueryService sharedSingleton];
    NSMutableDictionary *queryRequest = [rc.queryRequests objectAtIndex:[indexPath row]];
    if ([queryRequest objectForKey:@"results"] == nil) {
    	NSMutableDictionary *error = [queryRequest objectForKey:@"error"];
        if (error != nil) {
            self.requestToRetry = queryRequest;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error objectForKey:@"error"] 
                                                            message:[error objectForKey:@"message"] 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" 
                                                  otherButtonTitles:@"Retry",nil];
            [alert show];
            [alert autorelease];
        }
    	return;
    }
    
	if (serviceResultsController == nil) {
		self.serviceResultsController = [[QueryServicesController alloc] init];
		serviceResultsController.navController = navController;
	}
    serviceResultsController.request = queryRequest;
	[navController pushViewController:serviceResultsController animated:YES];	
}

- (CGFloat)tableView:(UITableView *)tableView
		heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return QUERY_REQUEST_CELL_HEIGHT;
}

@end

