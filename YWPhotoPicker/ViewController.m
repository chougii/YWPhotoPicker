//
//  ViewController.m
//  YWPhotoPicker
//
//  Created by ChouGii on 15/9/2.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "ViewController.h"
#import "YWPhotoPicker.h"

@interface ViewController (){
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIButton * btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0,screenHeight-30,screenWidth,30);
    [btn setTitle:@"picker" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadPicker) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn= btn;
    [self.view addSubview:btn];


}
-(void)loadPicker
{
    YWPhotoPicker * picker = [[YWPhotoPicker alloc] initWithSlideDirection:YWPickerViewSlideDirectionHorizontal];
    picker.YWPickerViewFinishedBlock = ^(NSArray * imageArray){
        [self imageinfo:imageArray];
    };
    [self.view addSubview:picker];
}

-(void)imageinfo:(NSArray *)imageArray
{
    NSString * ids = [[NSString alloc] init];
    for (UIImage * img in imageArray) {
       ids= [ids stringByAppendingString:[NSString stringWithFormat:@"%p,",&img]];
    }
    UILabel * lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 80, screenWidth,200);
    lbl.font = [UIFont systemFontOfSize:11];
    lbl.text= ids;
    [self.view addSubview:lbl];
    [self.view bringSubviewToFront:self.btn];
    
}

@end
