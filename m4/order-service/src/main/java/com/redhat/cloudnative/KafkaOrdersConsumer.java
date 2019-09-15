package com.redhat.cloudnative;

import java.io.IOException;
import java.util.concurrent.CompletionStage;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.smallrye.reactive.messaging.kafka.KafkaMessage;
import io.vertx.core.json.JsonObject;

@ApplicationScoped
public class KafkaOrdersConsumer {

    private static final Logger LOG = LoggerFactory.getLogger(KafkaOrdersConsumer.class);

    @Inject
    OrderService orderService;

    @Incoming("orders")
    public CompletionStage<Void> onMessage(KafkaMessage<String, String> message)
            throws IOException {

        /* example message to the Kafka Orders topic
        {
            "orderId": "12321",
            "total": "232.23",
            "creditCard":
                {
                    "number": "4232454678667866",
                    "expiration": "04/22",
                    "nameOnCard": "Jane G Doe"
                },
            "billingAddress": "123 Anystreet, Pueblo, CO 32213",
            "name": "Jane G Doe"
        }
        */

        LOG.info("Kafka orders message with value = {} arrived", message.getPayload());

        // TODO: Add to Orders
        JsonObject orders = new JsonObject(message.getPayload());
        Order order = new Order();
        order.setId(orders.getString("orderId"));
        order.setName(orders.getString("name"));
        order.setTotal(orders.getString("total"));
        order.setCcNumber(orders.getJsonObject("creditCard").getString("number"));
        order.setCcExp(orders.getJsonObject("creditCard").getString("expiration"));
        order.setBillingAddress(orders.getString("billingAddress"));
        order.setStatus("PROCESSING");
        orderService.add(order);

        return message.ack();
    }


}
