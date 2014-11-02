//
//  GameHistoryViewController.m
//  Matchismo
//
//  Created by Brian Li on 8/10/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (strong, nonatomic) IBOutlet UITextView *historyText;

@end

@implementation GameHistoryViewController

- (void) setPlayHistory:(NSArray *)playHistory {
    _playHistory = playHistory;
}

- (void) setScoreHistory:(NSArray *)scoreHistory {
    _scoreHistory = scoreHistory;
    if (self.view.window) [self updateUI];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (NSAttributedString *) constructText {
    NSMutableAttributedString * historyText = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < [self.playHistory count]; i++) {
        NSLog(@"score for match: %@", self.scoreHistory[i]);
        NSAttributedString * score = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"  %@\n", self.scoreHistory[i]] attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
        [historyText appendAttributedString:self.playHistory[i]];
        [historyText appendAttributedString:score];
    }
    return historyText;
}

- (void) updateUI {
    self.historyText.attributedText = [self constructText];
}
@end
