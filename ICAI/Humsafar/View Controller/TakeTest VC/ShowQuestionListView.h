//
//  ShowQuestionListView.h
//  ICAI
//
//  Created by Rahul on 12/17/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizViewController.h"

@interface ShowQuestionListView : UIView

@property (weak,nonatomic) QuizViewController *vc;
@property (weak, nonatomic) IBOutlet UIButton *btn;

-(void)reloadList:(NSArray*)questionList;

@end
