//
//  ForgotPassword.m
//  ICAI
//
//  Created by Pardeep on 05/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ForgotPassword.h"

@implementation ForgotPassword

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        NSArray *viewsInNib = [[NSBundle mainBundle]  loadNibNamed:@"ForgotPassword" owner:self options:nil];
        
        for (id view in viewsInNib) {
            if ([view isKindOfClass:[self class]]) {
                self = view;
                self.frame = frame;
                break;
            }
        }
    }
    
    return self;
}

- (IBAction)btnSubmitAction:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
