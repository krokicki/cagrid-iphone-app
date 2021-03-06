//
//  QueryExecutionController.m
//  CaGrid
//
//  Created by Konrad Rokicki on 10/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QueryExecutionController.h"
#import "ServicePickerController.h"
#import "ServiceMetadata.h"
#import "CaGridAppDelegate.h"
#import "QueryRequestController.h"
#import "UserPreferences.h"

@implementation QueryExecutionController
@synthesize navController;
@synthesize servicePickerController;
@synthesize dataTypeLabel;
@synthesize locationsLabel;
@synthesize searchButton;
@synthesize searchBox;
@synthesize savedSearches;
@synthesize dataType;

- (void)dealloc {
    self.navController = nil;
    self.servicePickerController = nil;
    self.dataTypeLabel = nil;
    self.locationsLabel = nil;
    self.searchBox = nil;
    [super dealloc];
}

- (void)viewDidLoad {
	
	self.savedSearches = [NSMutableArray array];
	for(NSString *groupName in [[ServiceMetadata sharedSingleton] getGroups]) {
		[savedSearches addObject:@""];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.dataTypeLabel.text = [Util getLabelForDataType:self.dataType];
    self.title = [NSString stringWithFormat:@"%@ Search",self.dataTypeLabel.text];
	
	ServiceMetadata *sm = [ServiceMetadata sharedSingleton];
    NSMutableArray *services = [sm getServicesOfType:dataType];
    NSString *locations = @"";
    for(NSMutableDictionary *service in services) {
    	if ([[UserPreferences sharedSingleton] isSelectedForSearch:[service objectForKey:@"id"]]) {
            NSString *host = [service objectForKey:@"host_short_name"];
            if (host != nil) {
	            if ([locations length] > 0) locations = [locations stringByAppendingString:@", "];
    	    	locations = [locations stringByAppendingString:host];
            }
        }            
    }
    locationsLabel.text = locations;
    
	NSString *dataTypeName = [Util getNameForDataType:self.dataType];
	NSMutableDictionary *group = [sm getGroupByName:dataTypeName];
	if (group != nil) {
		NSArray *exemplars = [group objectForKey:@"exemplars"];
		if ([exemplars count] > 0) {
			[self.searchBox setPlaceholder:[NSString stringWithFormat:@"(e.g. %@)",[exemplars objectAtIndex:0]]];
		}
	}
	else {
		NSLog(@"WARNING: No metadata for group with name %@",dataTypeName);
	}
	
	[self.searchBox setText:[savedSearches objectAtIndex:[sm getIndexForGroup:self.dataType]]];
	
	// Start keyboard open
	//[self.searchBox becomeFirstResponder];

	[self.searchButton setEnabled:([searchBox.text length] > 0)];
	
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.searchBox resignFirstResponder];	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	ServiceMetadata *sm = [ServiceMetadata sharedSingleton];
	[savedSearches replaceObjectAtIndex:[sm getIndexForGroup:self.dataType] withObject:textField.text];
}

- (void)textFieldDidChange:(UITextField *)textField {
	[self.searchButton setEnabled:([searchBox.text length] > 0)];
}

- (IBAction) clickEditDatatypeButton:(id)sender {
    [self.navController popViewControllerAnimated:YES];
}

- (IBAction) clickEditLocationsButton:(id)sender {
    
	if (servicePickerController == nil) {
        self.servicePickerController = [[ServicePickerController alloc] initWithNibName:@"ServicePickerView" bundle:nil];
        servicePickerController.navController = navController;
	}
    
    servicePickerController.dataType = self.dataType;
    [navController pushViewController:servicePickerController animated:YES];
}

- (IBAction) clickSearchButton:(id)sender {
    
    if ([locationsLabel.text isEqualToString:@""]) {
		[Util displayCustomError:@"" withMessage:@"Select one or more locations to search."];
    	return;
    }
    
    CaGridAppDelegate *delegate = (CaGridAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.queryRequestController searchFor:self.searchBox.text inDataType:self.dataType];    
    [delegate.queryRequestController.navController popToRootViewControllerAnimated:NO];
    delegate.tabBarController.selectedIndex = 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self clickSearchButton:textField];
	// Close the keyboard
    return YES;
}

- (IBAction) clickBackground:(id)sender {
	[self.searchBox resignFirstResponder];
}



@end
