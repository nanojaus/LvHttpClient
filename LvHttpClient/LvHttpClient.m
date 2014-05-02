//
//  LvHttpClient.m
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

#import "LvHttpClient.h"
#import "LvUrlConnection.h"

@interface LvHttpClient(){
    NSMutableDictionary *headers;
    LvUrlConnection *connection;
}

@end

@implementation LvHttpClient

- (id)initWithBaseURL:(NSURL *)url {
    if (self = [super init]) {
		_baseUrl = url;
		_timeout = 30;
        _compression = YES;
        headers = [[NSMutableDictionary alloc]init];
        [headers setObject:@"close" forKey:@"Connection"];
        [headers setObject:@"no-cache" forKey:@"Cache-Control"];
        [headers setObject:@"no-cache" forKey:@"Pragma"];
	}
	return self;
}

- (void)setHeader:(NSString*)header withValue:(NSString*)value{
    [headers setObject:value forKey:header];
}

- (void)postMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response{
	[self request:@"POST" withMethod:method withParams:params response:^(id object, NSError *error) {
        response(object, error);
    }];
}

- (void)getMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response{
	[self request:@"GET" withMethod:method withParams:params response:^(id object, NSError *error) {
        response(object, error);
    }];
}

- (void)putMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response{
	[self request:@"PUT" withMethod:method withParams:params response:^(id object, NSError *error) {
        response(object, error);
    }];
}

- (void)deleteMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response{
	[self request:@"DELETE" withMethod:method withParams:params response:^(id object, NSError *error) {
        response(object, error);
    }];
}

- (void)request:(NSString*)type withMethod:(NSString*)method withParams:(NSDictionary*)params response:(LVResponseBlock)response{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseUrl, method]];
    NSData *body;
    
    if (params) {
        if ([type isEqualToString:@"POST"]||[type isEqualToString:@"PUT"]) {
            body = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        }else{
            NSString *urlWithParams = [[url absoluteString] stringByAppendingString:[self urlParamsFromDictionary:params]];
            url = [NSURL URLWithString:urlWithParams];
        }
    }
    
    if (_userAgent){
		[headers setObject:_userAgent forKey:@"User-Agent"];
    }
    
    if (_jsonCompatible) {
        [headers setObject:@"application/json" forKey:@"Content-Type"];
        [headers setObject:@"application/json" forKey:@"Accept"];
    }else{
        if (_contentType) {
            [headers setObject:_contentType forKey:@"Content-Type"];
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:_timeout];
	[request setHTTPMethod:type];
    [request setAllHTTPHeaderFields:headers];
    
    if (params){
        [request setHTTPBody:body];
    }
    
    if (_compression){
		[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    connection = [[LvUrlConnection alloc]initWithRequest:request];
    [connection startRequest:^(id object, NSError *error) {
        if (!error) {
            if (_jsonCompatible) {
                NSLog(@"Testing Data: %@", [[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding]);
                id json = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
                response(json, nil);
            }else{
                response(object, nil);
            }
        }else{
            response(nil, error);
        }
    }];
    
}

- (NSString*)urlParamsFromDictionary:(NSDictionary*)dictionary {
    
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (NSString *key in dictionary) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, dictionary[key]];
        [list addObject:param];
    }
    
    return [NSString stringWithFormat:@"?%@",[list componentsJoinedByString:@"&"]];
}

@end
