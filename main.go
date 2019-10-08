package main

import (
	"context"
	"encoding/json"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handleEvent(_ context.Context, e events.CloudWatchEvent) {
	value, _ := json.MarshalIndent(e, "", "  ")
	log.Printf("Handling CloudWatchEvent: %s", string(value))
}

func main() {
	lambda.Start(handleEvent)
}
