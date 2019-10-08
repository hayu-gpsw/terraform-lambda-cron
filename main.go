package main

import (
	"context"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

//{
//  "id": "53dc4d37-cffa-4f76-80c9-8b7d4a4d2eaa",
//  "detail-type": "Scheduled Event",
//  "source": "aws.events",
//  "account": "123456789012",
//  "time": "2015-10-08T16:53:06Z",
//  "region": "us-east-1",
//  "resources": [ "arn:aws:events:us-east-1:123456789012:rule/MyScheduledRule" ],
//  "detail": {}
//}
func handleEvent(_ context.Context, e events.CloudWatchEvent) {
	log.Printf("AYU Handling event: %s", e)
}

func main() {
	lambda.Start(handleEvent)
}