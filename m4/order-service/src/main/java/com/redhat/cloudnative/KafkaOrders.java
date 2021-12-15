package com.redhat.cloudnative;

import io.smallrye.reactive.messaging.kafka.KafkaRecord;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.enterprise.context.ApplicationScoped;

import java.io.IOException;
import java.util.concurrent.CompletionStage;

import javax.inject.Inject;
import io.vertx.core.json.JsonObject;

@ApplicationScoped
public class KafkaOrders {

    private static final Logger LOG = LoggerFactory.getLogger(KafkaOrders.class);

    @Incoming("orders")
    public CompletionStage<Void> onMessage(KafkaRecord<String, String> message)
            throws IOException {

        LOG.info("Kafka order message with value = {} arrived", message.getPayload());

        JsonObject payload = new JsonObject(message.getPayload());
        Order newOrder = new Order();
        newOrder.orderId = payload.getString("orderId");
        newOrder.name = payload.getString("name");
        newOrder.total = payload.getString("total");
        newOrder.ccNumber = payload.getJsonObject("creditCard").getString("number");
        newOrder.ccExp = payload.getJsonObject("creditCard").getString("expiration");
        newOrder.billingAddress = payload.getString("billingAddress");
        newOrder.status = "PROCESSING";
        newOrder.persist();

        return message.ack();
    }

    @Incoming("payments")
    public CompletionStage<Void> onMessagePayments(KafkaRecord<String, String> message)
            throws IOException {

        LOG.info("Kafka payment message with value = {} arrived", message.getPayload());

        JsonObject payments = new JsonObject(message.getPayload());

        Order newOrder = Order.findByOrderId(payments.getString("orderId"));
        newOrder.status = payments.getString("status");
        newOrder.update();

        return message.ack();
    }

}