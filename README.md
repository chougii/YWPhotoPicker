# YWPhotoPicker
简单易用，实现APP内图片拾取。  
使用步骤  
1.导入头文件
```
#import "YWPhotoPicker.h"
```
2.初始化控件  
```
   //YWPickerViewSlideDirectionHorizontal 水平滑入
   //YWPickerViewSlideDirectionVertical  垂直滑入
   YWPhotoPicker * picker = [[YWPhotoPicker alloc] initWithSlideDirection:YWPickerViewSlideDirectionHorizontal];
   [self.view addSubview:picker];
```
3.编写block代码  
```
    picker.YWPickerViewFinishedBlock = ^(NSArray * imageArray){
        //imageArray:拾取的UIImage数组
    };
```
