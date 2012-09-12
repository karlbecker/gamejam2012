//
//  JKGameManager.m
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-11.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import "JKGameManager.h"

@interface JKGameManager ()

@property (readwrite) float pollutionLevel;	// ranges from 0-1
@property (readwrite) unsigned int cash;
@property NSArray* plots;	// with JKPlot objects

@end

@implementation JKGameManager

@synthesize pollutionLevel = _pollutionLevel;
@synthesize cash = _cash;
@synthesize plots = _plots;

-(void)updateState {
	
}

-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlot:(JKPlot*)plot {
	return NO;
}

-(void)remove:(int)numberToRemove fromPlot:(JKPlot*)plot {
	
}

@end
