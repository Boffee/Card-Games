//
//  setCard.h
//  Matchismo
//
//  Created by Brian Li on 8/7/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "Card.h"

@interface setCard : Card

@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger copies;
@property (nonatomic) NSUInteger pattern;
@property (strong, nonatomic) NSMutableString * multiShape;

-(UIColor *) getColor;
-(NSString *) getShape;
-(NSString *) getPattern;
-(NSUInteger) getCopies;
+(NSUInteger) maxAmount;

@end
