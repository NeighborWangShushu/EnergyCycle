//
//  UIImage+Category.m
//  EnergyCycles
//
//  Created by 王斌 on 16/7/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+ (UIImage *)image:(UIImage *)image scaleToSize:(CGSize)size {
    
    // 得到图片的上下文,指定绘制图片的范围
    UIGraphicsBeginImageContext(size);
    
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回缩放后的图片
    return  scaledImage;
    
}

+ (UIImage *)imageFromImage:(UIImage *)image Rect:(CGRect)rect {
    
    // 将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    // 按照给定的矩形区域进行裁剪
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    // 将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 返回裁剪后的图片
    return newImage;
    
}

+ (UIImage *)clipImage:(UIImage *)image Rect:(CGSize)size {
    
    // 被切图片宽的比例比高的比例小,或者相等,以图片的宽进行放大
    if (image.size.width * size.height <= image.size.height * size.width) {
        
        // 以被裁剪图片的宽度为基准,得到剪切范围的大小
        CGFloat width = image.size.width;
        CGFloat height = image.size.height * size.height / size.width;
        
        // 调用剪切方法
        // 这里是以中心位置剪切,也可以通过改变rect的x,y值调整剪切位置
        return [UIImage imageFromImage:image Rect:CGRectMake(0, (image.size.height - height) / 2, width, height)];
        
    } else { // 被切图片宽的比例比高的比例大,以图片高进行裁剪
        
        // 以被剪切的图片的高度为基准,得到剪切范围的大小
        CGFloat width = image.size.height * size.width / size.height;
        CGFloat height = image.size.height;
        
        // 调用剪切方法
        // 这里是以中心位置剪切,也可以通过改变rect的x,y值调整剪切位置
        return [UIImage imageFromImage:image Rect:CGRectMake((image.size.width - width) / 2, 0, width, height)];
        
    }
    
    return nil;
    
}

+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur {
    //博客园-FlyElephant
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage  *inputImage=[CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
