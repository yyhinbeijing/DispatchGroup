//
//  ViewController.m
//  DispatchGroup
//
//  Created by 阳永辉 on 16/3/2.
//  Copyright © 2016年 HuiDe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self operation1];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)operation1 {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 450, 0, 0)];
    textLabel.text = @"正在下载图片";
    [textLabel sizeToFit];
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
    [self group];
    
}

- (void)group
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("cn.gcd-group.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        NSData*data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://images2015.cnblogs.com/blog/471463/201509/471463-20150912213125372-589808688.png"]];
        self.imageOne = [UIImage imageWithData:data];
    });
    
    dispatch_group_async(group, queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://images2015.cnblogs.com/blog/471463/201509/471463-20150912212457684-585830854.png"]];
        self.imageTwo = [UIImage imageWithData:data];
        
    });
    
    dispatch_group_notify(group, queue, ^{
        UIGraphicsBeginImageContext(CGSizeMake(300, 400));
        [self.imageOne drawInRect:CGRectMake(0, 0, 150, 400)];
        [self.imageTwo drawInRect:CGRectMake(150, 0, 150, 400)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
            [self.view addSubview:imageView];
            self.textLabel.text = @"图片合并完毕";
        });
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
