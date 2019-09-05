package com.redhat.cloudnative;

import io.smallrye.reactive.messaging.kafka.KafkaMessage;
import io.vertx.core.json.Json;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import java.io.IOException;
import java.util.concurrent.CompletionStage;

public class KafkaOrdersConsumer {

    private static final Logger LOG = LoggerFactory.getLogger(KafkaOrdersConsumer.class);
    @Inject
    OrderService orderService;

    @Incoming("payments")
    public CompletionStage<Void> onMessage(KafkaMessage<String, String> message)
            throws IOException {
        //orderService.add(Json.decodeValue(message.getPayload(), Order.class));
        // TODO: Add to Orders

        LOG.info("Kafka message with value = {} arrived", message.getPayload());
        return message.ack();
    }


}
