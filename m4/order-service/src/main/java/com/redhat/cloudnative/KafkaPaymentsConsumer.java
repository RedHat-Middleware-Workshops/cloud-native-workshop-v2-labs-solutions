package com.redhat.cloudnative;

import io.smallrye.reactive.messaging.kafka.KafkaMessage;
import org.eclipse.microprofile.reactive.messaging.Incoming;

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

        /* example message back to the payments topic:
        {
        "orderId": "12321",
        "paymentId": "2342323",
        "remarks": "Payment of $232.23 succeeded for Jane G Doe CC details: ...",
        "status": "COMPLETED" (or possibly "FAILED")
        }
        */
        JsonObject payments = new JsonObject(message.getPayload());
        orderService.updateStatus(payments.getString("orderId"), payments.getString("status"));

        LOG.info("Kafka message with value = {} arrived", message.getPayload());
        return message.ack();
    }

}
