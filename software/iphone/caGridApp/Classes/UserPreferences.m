//
//  UserPreferences.m
//  CaGrid
//
//  Created by Konrad Rokicki on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UserPreferences.h"
#import "Util.h"

#define prefsFilename @"UserPreferences.plist"

@implementation UserPreferences
@synthesize favoriteServices;
@synthesize selectedServices;

#pragma mark -
#pragma mark Object Methods

- (id) init {
	if (self = [super init]) {
        self.favoriteServices = [NSMutableArray array]; 
        self.selectedServices = [NSMutableDictionary dictionary]; 
   	}
	return self;
}


+ (UserPreferences *)sharedSingleton {
	static UserPreferences *sharedSingleton;
	@synchronized(self) {
		if (!sharedSingleton) {
			sharedSingleton = [[UserPreferences alloc] init];         
		}
		return sharedSingleton;
	}
	return nil;
}

#pragma mark -
#pragma mark Serialization

- (void)loadFromFile {
	NSString *filePath = [Util getPathFor:prefsFilename];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSLog(@"Reading user prefs from file");
        @try {
            NSDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
            self.favoriteServices = [dict objectForKey:@"favoriteServices"];
            self.selectedServices = [dict objectForKey:@"selectedServices"];        
            [dict release];
        	NSLog(@"... Loaded %d favorites and %d selections",[self.favoriteServices count],[self.selectedServices count]);
        }
        @catch (NSException *exception) {
        	NSLog(@"Caught exception: %@, %@",exception.name, exception.reason);
            self.favoriteServices = [NSMutableArray array]; 
            self.selectedServices = [NSMutableDictionary dictionary];
        }
	}
}

- (void) saveToFile {
    NSLog(@"Saving %d favorites and %d selections",[self.favoriteServices count],[self.selectedServices count]);
    @try {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.favoriteServices forKey:@"favoriteServices"];
        [dict setObject:self.selectedServices forKey:@"selectedServices"];   
        [dict writeToFile:[Util getPathFor:prefsFilename] atomically:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Caught exception: %@, %@",exception.name, exception.reason);
    }
}

#pragma mark -
#pragma mark Public API

-(void)addFavorite:(NSString *)serviceId {
	[self.favoriteServices addObject:serviceId];
}

-(void)removeFavorite:(NSString *)serviceId {
	NSUInteger index = [self.favoriteServices indexOfObject:serviceId];
	[self.favoriteServices removeObjectAtIndex:index];
}

-(BOOL)isFavorite:(NSString *)serviceId {
	return ([self.favoriteServices containsObject:serviceId]);
}

- (void)selectForSearch:(NSString *)serviceId {
    [self.selectedServices setObject:@"" forKey:serviceId];
}

- (void)deselectForSearch:(NSString *)serviceId {
    [self.selectedServices removeObjectForKey:serviceId];    
}

- (BOOL)isSelectedForSearch:(NSString *)serviceId {
    return [self.selectedServices objectForKey:serviceId] != nil;
}

@end
