//
//  SetCardView.h
//  Matchismo
//
//  Created by Brian Li on 8/12/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "CardView.h"
#import "setCard.h"

@interface SetCardView : CardView

@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger pattern;
@property (nonatomic) NSUInteger copies;
@property (nonatomic) NSUInteger shape;

@end
