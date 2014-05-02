LvHttpClient
============

A lightweight iOS HTTP Client framework.

    LvHttpClient *httpClient = [[LvHttpClient alloc]initWithBaseURL:[NSURL URLWithString:@"http://test.com/api/"]];
    httpClient.jsonCompatible = TRUE;
    [httpClient getMethod:@"/apple" withParams:@{@"appleId": @"1"} response:^(id object, NSError *error) {
        if (!error) {
            NSLog(@"Response: %@", object);
        }
    }];
