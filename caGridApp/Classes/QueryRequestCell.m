//
//  QueryRequestCell.m
//  CaGrid
//
//  Created by Konrad Rokicki on 9/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QueryRequestCell.h"


@implementation QueryRequestCell

@synthesize locations;
@synthesize indicator;
@synthesize alertImageView;

- (void)dealloc {
    self.locations = nil;
	self.indicator = nil;
    self.alertImageView = nil;
    [super dealloc];
}


@end
