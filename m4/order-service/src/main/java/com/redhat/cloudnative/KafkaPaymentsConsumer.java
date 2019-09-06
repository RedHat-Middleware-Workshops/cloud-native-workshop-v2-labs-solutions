package com.redhat.cloudnative;

import io.smallrye.reactive.messaging.kafka.KafkaMessage;
import org.eclipse.microprofile.reactive.messaging.Incoming;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.io.IOException;
import java.util.concurrent.CompletionStage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.vertx.core.json.JsonObject;

public class KafkaPaymentsConsumer {

    private static final Logger LOG = LoggerFactory.getLogger(KafkaPaymentsConsumer.class);

    @Inject 
    OrderService orderService;

    @Incoming("payments")
    public CompletionStage<Void> onMessage(KafkaMessage<String, String> message)
            throws IOException {

        JsonObject payload = message.getPayload();
        String orderId = payload.getString("orderId");

        if ( "COMPLETED".equals(status) ) {
            orderService.updateStatus(orderId);
        }

        LOG.info("Kafka message with value = {} arrived", message.getPayload());
        return message.ack();
    }

}
