//
//  JKGameManager.h
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-11.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKGrowthType.h"

#define MAXIMUM_NUMBER_OF_PLOTS 6

@interface JKGameManager : NSObject

@property (readonly) float pollutionPercent;	// ranges from 0-1
@property (readonly) unsigned int cash;
@property (readonly) BOOL isGameOver;
@property (readonly) int elapsedRounds;			// This is the user's score

// Begins the game timer and starts updating the pollution level and cash.
-(void)start;

// Returns true if the add was successful (i.e. the user had enough cash). Otherwise returns false.
-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlotIndex:(int)index;

-(BOOL)remove:(int)numberToRemove fromPlotIndex:(int)index;

@end
