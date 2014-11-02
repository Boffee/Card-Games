//
//  SetCardView.m
//  Matchismo
//
//  Created by Brian Li on 8/12/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void) setColor:(NSUInteger)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void) setShape:(NSUInteger)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void) setCopies:(NSUInteger)copies {
    _copies = copies;
    [self setNeedsDisplay];
}

- (void) setPattern:(NSUInteger)pattern {
    _pattern = pattern;
    [self setNeedsDisplay];
}


- (void) drawContent {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    if (self.faceUp) {
        [[UIColor blueColor]setStroke];
        roundedRect.lineWidth *= 4;
    }
    else [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.card) {
        setCard *card = (setCard *) self.card;
        self.color = card.color;
        self.copies = card.copies;
        self.shape = card.shape;
        self.pattern = card.pattern;
        [self drawSet];
        
    }
    else [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
}

#define CENTER_DISTANCE_RATIO 1.2

- (CGFloat) patternCenterDistance {
    return [self patternWidth] * CENTER_DISTANCE_RATIO;
}

- (CGFloat) patternWidth {
    return [self patternHeight]/2;
}

- (CGFloat) patternHeight {
    return self.bounds.size.height * 0.6;
}

- (void) drawSet {
    if (self.copies == 1) {
        [self drawShape:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    }
    if (self.copies == 2) {
        [self drawShape:CGPointMake(self.bounds.size.width/2 + [self patternCenterDistance]/2, self.bounds.size.height/2)];
        [self drawShape:CGPointMake(self.bounds.size.width/2 - [self patternCenterDistance]/2, self.bounds.size.height/2)];
    }
    if (self.copies == 3) {
        [self drawShape:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        [self drawShape:CGPointMake(self.bounds.size.width/2 + [self patternCenterDistance], self.bounds.size.height/2)];
        [self drawShape:CGPointMake(self.bounds.size.width/2 - [self patternCenterDistance], self.bounds.size.height/2)];

    }
}

- (void) drawShape:(CGPoint) center {
    UIBezierPath *shape;
    if (self.shape == 0) {
        shape = [self drawSquiggleAtPoint:center];
    }
    if (self.shape == 1) {
        shape = [self drawOvalAtPoint:center];
    }
    if (self.shape == 2) {
        shape = [self drawDiamondAtPoint:center];
    }
    
    [[self getColor] setStroke];
    shape.lineWidth = [self patternWidth]/7.5;
    [shape stroke];

    [self addColorPatternThenDraw:shape];
}

- (UIBezierPath *) drawSquiggleAtPoint:(CGPoint) center {
    
    CGFloat originX = center.x - [self patternWidth]/2;
    CGFloat originY = center.y - [self patternHeight]/2;
    
    
    UIBezierPath * squiggle = [UIBezierPath bezierPath];
    [squiggle moveToPoint:CGPointMake(originX + [self patternWidth]*2/3, originY)];
    
    // big arc - top left
    [squiggle addQuadCurveToPoint:CGPointMake(originX+[self patternWidth]/8, originY+ [self patternWidth] *2/3) controlPoint:CGPointMake(originX, originY)];
    
    //start here
    // long curve - top right
    [squiggle addCurveToPoint:CGPointMake(originX + [self patternWidth]/4, originY + [self patternHeight] - [self patternWidth]/4) controlPoint1:CGPointMake(originX + [self patternWidth]/6, originY+ [self patternHeight]/2) controlPoint2:CGPointMake(center.x, center.y+[self patternWidth]/2)];
    
    // small tip - top right
    [squiggle addQuadCurveToPoint:CGPointMake(originX + [self patternWidth]/3, originY + [self patternHeight]) controlPoint:CGPointMake(originX, originY+[self patternHeight])];
    
    // big arc - bot right
    [squiggle addQuadCurveToPoint:CGPointMake(originX + [self patternWidth]*7/8, originY + [self patternHeight] - [self patternWidth] *2/3) controlPoint:CGPointMake(originX + [self patternWidth], originY + [self patternHeight])];
    
    // long curve - bot left
    [squiggle addCurveToPoint:CGPointMake(originX + [self patternWidth]* 3/4, originY + [self patternWidth]/4) controlPoint1:CGPointMake(originX+[self patternWidth]*5/6, originY + [self patternHeight]/2) controlPoint2:CGPointMake(center.x, center.y-[self patternWidth]/2)];
    
    // small tip - bot left
    [squiggle addQuadCurveToPoint:CGPointMake(originX + [self patternWidth]*2/3, originY) controlPoint:CGPointMake(originX+[self patternWidth], originY)];
    
    [squiggle closePath];
    
    return squiggle;
}


- (UIBezierPath *) drawOvalAtPoint:(CGPoint) center {
    
    CGFloat originX = center.x - [self patternWidth]/2;
    CGFloat originY = center.y - [self patternHeight]/2;
    
    CGRect Bound;
    Bound.origin = CGPointMake(originX, originY);
    Bound.size = CGSizeMake([self patternWidth]*.8, [self patternHeight]);
    
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:Bound cornerRadius:[self patternWidth]/2];

    return oval;
}
             
- (UIBezierPath *) drawDiamondAtPoint:(CGPoint) center {
    CGFloat originX = center.x - [self patternWidth]*2/5;
    CGFloat originY = center.y - [self patternHeight]/2;
    
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    [diamond moveToPoint:CGPointMake(center.x, originY)];
    [diamond addLineToPoint:CGPointMake(originX+[self patternWidth]*.8, center.y)];
    [diamond addLineToPoint:CGPointMake(center.x, originY+[self patternHeight])];
    [diamond addLineToPoint:CGPointMake(originX, center.y)];
    [diamond closePath];
    
    return diamond;

}

#define NUMBER_OF_STRIPES 10

- (void) addColorPatternThenDraw:(UIBezierPath *) shape {
    NSString * pattern = [self getPattern];
    
    if ([pattern isEqualToString:@"solid"]) { //g
        [[self getColor] setFill];
        [shape fill];
    }
    else if ([pattern isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
        [shape fill];
    }
    else if ([pattern isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [shape addClip];
        UIBezierPath *stripes = [UIBezierPath bezierPath];
        CGFloat stripeSpacing = [self patternHeight]/(NUMBER_OF_STRIPES+1);
        CGPoint startPoint = CGPointMake(self.bounds.origin.x, (self.bounds.size.height-[self patternHeight])/2+stripeSpacing);
        CGPoint endPoint = CGPointMake(self.bounds.size.width, (self.bounds.size.height-[self patternHeight])/2+stripeSpacing);
        for (int i = 0; i < NUMBER_OF_STRIPES; i++) {
            [stripes moveToPoint: startPoint];
            [stripes addLineToPoint: endPoint];
            startPoint.y += stripeSpacing;
            endPoint.y += stripeSpacing;
        }
        [[self getColor] setStroke];
        stripes.lineWidth = [self patternWidth]/15.0;
        [stripes stroke];
        CGContextRestoreGState(context);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSString *) getPattern {
    return @[@"solid",@"striped",@"open"][self.pattern];
}

- (UIColor *) getColor {
    return @[[UIColor orangeColor],[UIColor magentaColor],[UIColor greenColor]][self.color];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
