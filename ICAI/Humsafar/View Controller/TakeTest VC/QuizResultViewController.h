//
//  QuizResultViewController.h
//  ICAI
//
//  Created by Pankaj Yadav on 16/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizResultViewController : UIViewController

@property (strong, nonatomic) NSDictionary *quizDict;

@property (weak, nonatomic) IBOutlet UILabel *lblname;

@property (weak, nonatomic) IBOutlet UILabel *lblCorrect;
@property (weak, nonatomic) IBOutlet UILabel *lblIncorrect;
@property (weak, nonatomic) IBOutlet UILabel *lblUnattempted;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;

- (IBAction)viewAttempDetails:(id)sender;

@end
