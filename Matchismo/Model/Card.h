//
//  Card.h
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSAttributedString * contents;
@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *) otherCards;

@end
