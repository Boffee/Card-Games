//
//  setCard.m
//  Matchismo
//
//  Created by Brian Li on 8/7/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "setCard.h"

@implementation setCard

-(int) match:(NSArray *)otherCards {
    int score = 0;
    BOOL color = false;
    BOOL shape = false;
    BOOL copies = false;
    BOOL pattern = false;
    if ([otherCards count] == 2) {
        setCard *first = self;
        setCard *second = otherCards[0];
        setCard *third = otherCards[1];
        if ((first.color == second.color && first.color == third.color) || (first.color != second.color && first.color != third.color && second.color != third.color))
            color = true;
        if ((first.pattern == second.pattern && first.pattern == third.pattern) || (first.pattern != second.pattern && first.pattern != third.pattern && second.pattern != third.pattern))
            pattern = true;
        if ((first.shape == second.shape && first.shape == third.shape) || (first.shape != second.shape && first.shape != third.shape && second.shape != third.shape))
            shape = true;
        if ((first.copies == second.copies && first.copies == third.copies) || (first.copies != second.copies && first.copies != third.copies && second.copies != third.copies))
            copies = true;

    }
    if (color && shape && copies && pattern) {
        score = 25;
    }
    return score;
}

-(NSAttributedString *)contents {
    UIColor *strokeColor = ([[self getPattern] integerValue] < 0) ? [UIColor blackColor]:[self getColor];
    return [[NSAttributedString alloc] initWithString:self.multiShape attributes:@{NSForegroundColorAttributeName:[self getColor],NSStrokeColorAttributeName:strokeColor,NSStrokeWidthAttributeName:[self getPattern]}];
}

-(NSString *)multiShape {
    if (!_multiShape) {
        _multiShape = [[NSMutableString alloc] init];
        for (int i = 0; i < self.copies; i++) {
            [_multiShape appendString:[self getShape]];
        }
    }
    return _multiShape;
}

-(UIColor *) getColor {
    return @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor]][self.color];
}

-(NSString *) getShape {
    return @[@"▲",@"●",@"■"][self.shape];
}

-(NSString *) getPattern {
    return @[@"-10",@"0",@"10"][self.pattern];
}

-(NSUInteger) getCopies {
    return self.copies;
}

+(NSUInteger) maxAmount {
    return 3;
}


@end
