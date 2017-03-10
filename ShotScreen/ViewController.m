//
//  ViewController.m
//  ShotScreen
//
//  Created by 窦心东 on 2017/3/10.
//  Copyright © 2017年 窦心东. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIActionSheetDelegate>
/** 头部 */
@property (nonatomic,strong) UIImageView *headerImageView;
/** 中部 */
@property (nonatomic,strong) UIView *midView;
/** 下部 */
@property (nonatomic,strong) UIImageView *footerImageView;

@end

@implementation ViewController
-(UIImageView *)headerImageView{
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_logo@3x.png"]];
        _headerImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    }
    return _headerImageView;
}
-(UIView *)midView{
    if (_midView == nil) {
        _midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerImageView.frame), self.view.frame.size.width, 200)];
        [_midView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_01@3x.png"]]];
        
    }
    return _midView;
}
-(UIImageView *)footerImageView{
    if (_footerImageView == nil) {
        _footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1487513280.png"]];
        _footerImageView.frame = CGRectMake(0, CGRectGetMaxY(self.midView.frame), self.view.frame.size.width, 200);
    }
    return _footerImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self screenShot];
}
-(void)screenShot{
    
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"保存图片到相册?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
    [actionsheet showInView:self.view];
    
    actionsheet = nil;
    
}
//保存图片
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex] ) {
        [self.view addSubview:self.headerImageView];
        UIImage *headerImage = [self screenShotWithSize:self.headerImageView.frame.size Layer:self.headerImageView.layer];
         [self.headerImageView removeFromSuperview];
        [self.view addSubview:self.midView];
        UIImage *midImage = [self screenShotWithSize:self.midView.frame.size Layer:self.midView.layer];
        [self.midView removeFromSuperview];
        [self.view addSubview:self.footerImageView];
        UIImage *footerImage = [self screenShotWithSize:self.footerImageView.frame.size Layer:self.footerImageView.layer];
         [self.footerImageView removeFromSuperview];
        
        UIImage *saveImage = [self addSlaveHeaderImage:headerImage toMasterMidImage:midImage toMasterFootImage:footerImage];
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil);
    }
    return;
}
/* *
 * masterImage  主图片，生成的图片的宽度为masterImage的宽度
 * slaveImage   从图片，拼接在masterImage的下面
 */
- (UIImage *)addSlaveHeaderImage:(UIImage *)slaveheaderImage toMasterMidImage:(UIImage *)mastermidImage toMasterFootImage:(UIImage *)masterfootImage{
    CGSize size;
    size.width = slaveheaderImage.size.width;
    size.height = slaveheaderImage.size.height + mastermidImage.size.height + masterfootImage.size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    //Draw slaveheaderImage
    [slaveheaderImage drawInRect:CGRectMake(0, 0, slaveheaderImage.size.width, slaveheaderImage.size.height)];
    
    //Draw mastermidImage
    [mastermidImage drawInRect:CGRectMake(0, mastermidImage.size.height, mastermidImage.size.width, mastermidImage.size.height)];
    
    //Draw masterfootImage
    [masterfootImage drawInRect:CGRectMake(0, slaveheaderImage.size.height+masterfootImage.size.height, masterfootImage.size.width, masterfootImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}
//截取定点位置屏幕图片
- (UIImage *)screenShotWithSize:(CGSize)size Layer:(CALayer *)layer{
    UIImage* image = nil;
    /*
     *UIGraphicsBeginImageContextWithOptions有三个参数
     *size    bitmap上下文的大小，就是生成图片的size
     *opaque  是否不透明，当指定为YES的时候图片的质量会比较好
     *scale   缩放比例，指定为0.0表示使用手机主屏幕的缩放比例
     */
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    //此处我截取layer.
    [layer renderInContext: UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}























@end
