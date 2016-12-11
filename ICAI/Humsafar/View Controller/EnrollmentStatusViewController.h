//
//  EnrollmentStatusViewController.h
//  ICAI
//
//  Created by Pankaj Yadav on 11/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentsSDK.h"

@interface EnrollmentStatusViewController : UIViewController<PGTransactionDelegate>{

}
@property(nonatomic,strong)NSMutableDictionary *dictProductInfo;
- (IBAction)action_cancelPayment:(id)sender;

@end
