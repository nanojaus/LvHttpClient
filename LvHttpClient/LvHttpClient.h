//
//  LvHttpClient.h
//  LvHttpClientSample
//
//  Copyright (c) 2013-2014 Juan Manuel Abrigo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

typedef void(^LVResponseBlock)(id object, NSError* error);

@interface LvHttpClient : NSObject

@property (nonatomic, strong) NSURL *baseUrl;
@property (nonatomic) double timeout;
@property (nonatomic, assign) BOOL compression;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, assign) BOOL jsonCompatible;


- (id)initWithBaseURL:(NSURL *)url;
- (void)setHeader:(NSString*)header withValue:(NSString*)value;
- (void)postMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response;
- (void)getMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response;
- (void)putMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response;
- (void)deleteMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response;

@end
