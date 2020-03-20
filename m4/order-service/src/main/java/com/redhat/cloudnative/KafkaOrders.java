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

    @Inject
    OrderService orderService;

    @Incoming("orders")
    public CompletionStage<Void> onMessage(KafkaRecord<String, String> message)
            throws IOException {

        LOG.info("Kafka order message with value = {} arrived", message.getPayload());

        JsonObject orders = new JsonObject(message.getPayload());
        Order order = new Order();
        order.setOrderId(orders.getString("orderId"));
        order.setName(orders.getString("name"));
        order.setTotal(orders.getString("total"));
        order.setCcNumber(orders.getJsonObject("creditCard").getString("number"));
        order.setCcExp(orders.getJsonObject("creditCard").getString("expiration"));
        order.setBillingAddress(orders.getString("billingAddress"));
        order.setStatus("PROCESSING");
        orderService.add(order);

        return message.ack();
    }

    @Incoming("payments")
    public CompletionStage<Void> onMessagePayments(KafkaRecord<String, String> message)
            throws IOException {

        LOG.info("Kafka payment message with value = {} arrived", message.getPayload());

        JsonObject payments = new JsonObject(message.getPayload());
        orderService.updateStatus(payments.getString("orderId"), payments.getString("status"));

        return message.ack();
    }

}