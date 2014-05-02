//
//  LvUrlConnection.m
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

#import "LvUrlConnection.h"

@interface LvUrlConnection () {
    NSURLRequest *localRequest;
    NSURLConnection *connection;
    NSMutableData *responseData;
    NSMutableArray *listOfConnections;
}

@end

@implementation LvUrlConnection

- (id)initWithRequest:(NSURLRequest *)request {
	self = [super init];
    if (self) {
        localRequest = request;
		if(!listOfConnections)
			listOfConnections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startRequest:(LvReturnBlock)returnBlock {
	responseData = [[NSMutableData alloc]init];
	_returnBlock = returnBlock;
    connection = [[NSURLConnection alloc]initWithRequest:localRequest delegate:self startImmediately:YES];
    [listOfConnections addObject:self];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [listOfConnections removeObject:self];
    
    if (_returnBlock) {
        _returnBlock(responseData, nil);
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [listOfConnections removeObject:self];
    
    if (_returnBlock) {
        _returnBlock(nil, error);
    }
	
}

@end
