//
//  HomeCollectionViewCell.m
//  ICAI
//
//  Created by Pardeep on 02/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

-(void)configCellWithImage:(NSString*)imageName labelText:(NSString*)labelText{
    [_imageViewHome setImage:[UIImage imageNamed:imageName]];
    [_labelHome setText:labelText];
}
@end
