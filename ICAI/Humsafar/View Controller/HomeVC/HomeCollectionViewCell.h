//
//  HomeCollectionViewCell.h
//  ICAI
//
//  Created by Pardeep on 02/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHome;
@property (weak, nonatomic) IBOutlet UILabel *labelHome;

-(void)configCellWithImage:(NSString*)imageName labelText:(NSString*)labelText;

@end
