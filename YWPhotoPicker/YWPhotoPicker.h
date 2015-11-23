//
//  PickerView.h
//  YWPhotoPicker
//
//  Created by ChouGii on 15/9/2.
//  Copyright (c) 2015年 zyw. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum
    {YWPickerViewSlideDirectionHorizontal,
     YWPickerViewSlideDirectionVertical
    } YWPickerViewSlideDirection;
typedef void (^YWPickerViewFinishedBlock) (NSArray *imageArray);

@interface YWPhotoPicker : UIView
@property (nonatomic,weak) UIView * pickerView;
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,assign)YWPickerViewSlideDirection YWPickerViewSlideDirection;
@property (nonatomic,copy) YWPickerViewFinishedBlock YWPickerViewFinishedBlock;
@end
