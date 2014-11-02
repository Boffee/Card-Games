//
//  CardView.h
//  Matchismo
//
//  Created by Brian Li on 8/11/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL inASet;
@property (strong, nonatomic) Card *card;

- (CGFloat) scaleFactor;
- (CGFloat) cornerRadius;
- (CGFloat) cornerOffset;

- (void) drawContent; // abstract method

@end
