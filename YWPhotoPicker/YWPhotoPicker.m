//
//  PickerView.m
//  YWPhotoPicker
//
//  Created by ChouGii on 15/9/2.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "YWPhotoPicker.h"
@interface YWPhotoPicker()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    CGRect sbd;
}
@property (nonatomic,weak) UIView * headerView;
@property (nonatomic,weak) UIView * imageContent;
@property (nonatomic,weak) UIView * mainView;
@property (nonatomic,strong) UIActionSheet * sheet;
@property (nonatomic,weak) UIButton * btnAdd;
@property (nonatomic,weak) UIImagePickerController * picker;
@property (nonatomic) CGRect  oldframe;

@end

@implementation YWPhotoPicker
-(NSMutableArray *)imageArray
{
    if (_imageArray==nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(instancetype)initWithSlideDirection:(YWPickerViewSlideDirection)direction
{
    
    if (self=[super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.YWPickerViewSlideDirection = direction;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupPickerview];
    }
    return self;
    
}

-(void)setupPickerview
{
    sbd = [UIScreen mainScreen].bounds;
    UIView * view = [[UIView alloc] init];
    self.mainView = view;
    if (self.YWPickerViewSlideDirection == YWPickerViewSlideDirectionHorizontal) {
        view.frame = CGRectMake(sbd.size.width, 0, sbd.size.width, sbd.size.height);
    }else{
        view.frame = CGRectMake(0,sbd.size.height, sbd.size.width, sbd.size.height);
    }
    //hide navigationbar
    NSLog(@"%@",self.superview);
    //header action view
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 20, sbd.size.width, 44);
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:headerView];
    //actions
    //save
    UIButton * btnSave = [[UIButton alloc] init];
    btnSave.frame = CGRectMake(sbd.size.width-70, 0, 70, 40);
    [btnSave setTitle:@"确定" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnSave];
    
    
    //content view
    UIView * contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), sbd.size.width, sbd.size.height-44
                                   );
    //load the first add button
    UIButton * btnAdd = [[UIButton alloc] init];
    btnAdd.frame = CGRectMake(10, 10, 70, 70);
    [btnAdd setTitle:@"add" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    self.imageContent = contentView;
    [contentView addSubview:btnAdd];
    self.btnAdd = btnAdd;
    [view addSubview:contentView];
    
    
    //[self addSubview:view];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = sbd;
    }];
    self.userInteractionEnabled = YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
-(void)showPickerWithType:(NSInteger)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    picker.delegate = self;
    
    picker.allowsEditing = NO;
    
    picker.sourceType = type;
    
    [picker becomeFirstResponder];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:^{
        self.mainView.frame = CGRectMake(0, sbd.size.height, sbd.size.width, sbd.size.height);
    }];
    //    [[self activityViewController] presentViewController:picker animated:YES completion:^{
    //
    //    }];
    
    self.picker = picker;
}
-(void)btnAddClick
{
    self.sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    self.sheet.tag = 1212;
    [self.sheet showInView:self];
    
}
-(void)btnEditClick
{
    
    [self drawImageContent];
}
-(void)btnSaveClick
{
    self.YWPickerViewFinishedBlock(self.imageArray);
    [UIView animateWithDuration:0.3 animations:^{
        if (self.YWPickerViewSlideDirection == YWPickerViewSlideDirectionHorizontal) {
            self.mainView.frame = CGRectMake(sbd.size.width, 0, sbd.size.width, sbd.size.height);
        }else{
            self.mainView.frame = CGRectMake(0,sbd.size.height, sbd.size.width, sbd.size.height);
        }
    } completion:^(BOOL finished) {
        NSLog(@"%@",self.mainView.superview);
        [self removeFromSuperview];
    }];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.mainView.frame = CGRectMake(0, 0, sbd.size.width, sbd.size.height);
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString * imgName = [NSString stringWithFormat:@"%@.png",[NSDate date]];
    [self saveImage:image withName:imgName];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imgName];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    //isFullScreen = NO;
    [self.imageArray addObject:savedImage];
    [self drawImageContent];
    
}

/**
 *
 *
 */
-(void)drawImageContent
{
    for (UIButton *subview in self.imageContent.subviews) {
        
        [subview removeFromSuperview];
    }
    
    int btnCnt = sbd.size.width/70;
    int margin = (sbd.size.width - btnCnt*70)/(btnCnt+1);
    CGFloat btnW = 70;
    CGFloat btnH = btnW;
    
    for (int i = 0; i<self.imageArray.count; i++) {
        UIButton * btnImg = [[UIButton alloc] init];
        [btnImg setImage:self.imageArray[i] forState:UIControlStateNormal];
        CGFloat btnX = margin*((i%btnCnt)+1)+i%btnCnt*70;
        CGFloat btnY = margin*((i/btnCnt)+1)+i/btnCnt*70;
        btnImg.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btnImg addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageContent addSubview:btnImg];
        //delete button
        
        UIButton * delete = [[UIButton alloc] init];
        delete.tag = i;
        delete.frame = CGRectMake(btnX+btnW-18, btnY, 18, 18);
        [delete setBackgroundImage:[UIImage imageNamed:@"deletecst"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageContent addSubview:delete];
        
        
    }
    //add button
    
    NSInteger temp = self.imageArray.count;
    CGFloat btnWadd = 70;
    CGFloat btnHadd = 70;
    CGFloat btnXadd = margin*((temp%btnCnt)+1)+temp%btnCnt*70;
    CGFloat btnYadd = margin*((temp/btnCnt)+1)+temp/btnCnt*70;
    self.btnAdd.frame = CGRectMake(btnXadd, btnYadd, btnWadd, btnHadd);
    [self.imageContent addSubview:self.btnAdd];
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1212) {
        NSInteger sourceType = 0;
        switch (buttonIndex) {
            case 0:
                return;
                break;
            case 1:
                sourceType =1;
                break;
            case 2:
                sourceType =2;
                break;
        }
        
        [self showPickerWithType:sourceType];
    }
    
}


-(void)deleteImage:(UIButton*)sender
{
    NSLog(@"%ld",(long)sender.tag);
    [self.imageArray removeObjectAtIndex:sender.tag];
    [self drawImageContent];
}

-(void)imageButtonClick:(UIButton *)sender
{
    [self showImage:sender];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self activityViewController] dismissViewControllerAnimated:YES completion:^{}];
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

-(void)showImage:(UIButton *)avatarImageView{
    UIImage *image=avatarImageView.imageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0.5;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=self.oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}
@end
