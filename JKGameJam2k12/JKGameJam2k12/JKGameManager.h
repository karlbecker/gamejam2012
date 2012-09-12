//
//  JKGameManager.h
//  JKGameJam2k12
//
//  Created by James Bell on 2012-09-11.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKGrowthType.h"
#import "JKPlot.h"

@interface JKGameManager : NSObject

@property (readonly) float pollutionLevel;	// ranges from 0-1
@property (readonly) unsigned int cash;

// Once per second, update the pollution level and cash. Then fire a notification NOTIFY_GAME_STATE_UPDATE.
-(void)updateState;

// Returns true if the add was successful (i.e. the user had enough cash). Otherwise returns false.
-(BOOL)addGrowthType:(JKGrowthType*)growthType toPlot:(JKPlot*)plot;

-(void)remove:(int)numberToRemove fromPlot:(JKPlot*)plot;

@end
