//
//  JKMainGameViewController.h
//  JKGameJam2k12
//
//  Created by Karl Becker on 9/11/12.
//  Copyright (c) 2012 LMNOP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKMainGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *treeStartView;
@property (weak, nonatomic) IBOutlet UIImageView *cowStartView;
@property (weak, nonatomic) IBOutlet UIImageView *factoryStartView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *plotViews;


//methods to 

@end
