//
//  LCTPhotoViewController.m
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTPhotoViewController.h"

@interface LCTPhotoViewController ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UISlider *sliderSepiaTone;
@property(nonatomic, strong) UISlider *sliderColorMonochrome;
@property(nonatomic, strong) UISlider *sliderHueAdjust;
@property(nonatomic, strong) UILabel *labelSepiaTone;
@property(nonatomic, strong) UILabel *labelColorMonochrome;
@property(nonatomic, strong) UILabel *labelHueAdjust;
@property(nonatomic, strong) CIContext *context;

@end

@implementation LCTPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.imageView.backgroundColor = [UIColor yellowColor];
    self.imageView.image = self.photo;
    [self.view addSubview:self.imageView];
    
    self.context = [CIContext contextWithOptions:nil];
    
    self.labelSepiaTone = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 15)];
    self.labelSepiaTone.text = @"Sepia tone filter";
    self.labelSepiaTone.textColor = [UIColor orangeColor];
    [self.view addSubview:self.labelSepiaTone];
    
    self.sliderSepiaTone = [[UISlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelSepiaTone.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 20)];
    self.sliderSepiaTone.minimumTrackTintColor = [UIColor redColor];
    self.sliderSepiaTone.maximumTrackTintColor = [UIColor greenColor];
    self.sliderSepiaTone.thumbTintColor = [UIColor blueColor];
    self.sliderSepiaTone.value = 0.5;
    [self.sliderSepiaTone addTarget:self action:@selector(sliderDragged) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.sliderSepiaTone];
    
    self.labelColorMonochrome = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sliderSepiaTone.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 15)];
    self.labelColorMonochrome.text = @"Color monochrome filter";
    self.labelColorMonochrome.textColor = [UIColor orangeColor];
    [self.view addSubview:self.labelColorMonochrome];
    
    self.sliderColorMonochrome = [[UISlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelColorMonochrome.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 20)];
    self.sliderColorMonochrome.minimumTrackTintColor = [UIColor redColor];
    self.sliderColorMonochrome.maximumTrackTintColor = [UIColor greenColor];
    self.sliderColorMonochrome.thumbTintColor = [UIColor blueColor];
    self.sliderColorMonochrome.value = 0;
    [self.sliderColorMonochrome addTarget:self action:@selector(sliderDragged) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.sliderColorMonochrome];
    
    self.labelHueAdjust = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sliderColorMonochrome.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 15)];
    self.labelHueAdjust.text = @"Hue adjust filter";
    self.labelHueAdjust.textColor = [UIColor orangeColor];
    [self.view addSubview:self.labelHueAdjust];
    
    self.sliderHueAdjust = [[UISlider alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelHueAdjust.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 20)];
    self.sliderHueAdjust.minimumTrackTintColor = [UIColor redColor];
    self.sliderHueAdjust.maximumTrackTintColor = [UIColor greenColor];
    self.sliderHueAdjust.thumbTintColor = [UIColor blueColor];
    self.sliderHueAdjust.value = 0.5;
    [self.sliderHueAdjust addTarget:self action:@selector(sliderDragged) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:self.sliderHueAdjust];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sliderDragged
{
    CGFloat intensitySepiaTone = self.sliderSepiaTone.value * 2 - 1;
    CGFloat intensityColorMonochrome = self.sliderColorMonochrome.value;
    CGFloat intensityHueAdjust = self.sliderHueAdjust.value * 2 - 1;
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.photo.CGImage];
    
    CIFilter *filterSepiaTone = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, kCIInputIntensityKey, @(intensitySepiaTone), nil];
    CIImage *outputImageSepiaTone = [filterSepiaTone outputImage];
    
    CIFilter *filterColorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: kCIInputImageKey, outputImageSepiaTone, kCIInputColorKey, [CIColor grayColor], kCIInputIntensityKey, @(intensityColorMonochrome), nil];
    CIImage *outputImageColorMonochrome = [filterColorMonochrome outputImage];
    
    CIFilter *filterHueAdjust = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues: kCIInputImageKey, outputImageColorMonochrome, kCIInputAngleKey, @(intensityHueAdjust), nil];
    CIImage *outputImage = [filterHueAdjust outputImage];
    
    // Создаем Bitmap
    CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    // Создаем изображение
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    self.imageView.image = newImage;
    // Релизим ImageRef, потому как там старое C API, нужно ручками
    CGImageRelease(cgimg);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.output addEditingPhoto:self.imageView.image forIndex:self.indexPath];
}

@end
