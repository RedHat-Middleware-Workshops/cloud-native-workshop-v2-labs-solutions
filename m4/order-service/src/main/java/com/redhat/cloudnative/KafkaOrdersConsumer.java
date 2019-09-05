package com.redhat.cloudnative;

import io.smallrye.reactive.messaging.kafka.KafkaMessage;
import io.vertx.core.json.Json;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import java.io.IOException;
import java.util.concurrent.CompletionStage;

import io.vertx.core.json.JsonObject;

public class KafkaOrdersConsumer {

    private static final Logger LOG = LoggerFactory.getLogger(KafkaOrdersConsumer.class);
    private static final String[] RANDOM_NAMES = {"Sven Karlsson","Johan Andersson","Karl Svensson","Anders Johansson","Stefan Olson","Martin Ericsson"};
    private static final String[] RANDOM_EMAILS = {"sven@gmail.com","johan@gmail.com","karl@gmail.com","anders@gmail.com","stefan@gmail.com","martin@gmail.com"};

    @Inject 
    OrderService orderService;

    @Incoming("orders")
    public CompletionStage<Void> onMessage(KafkaMessage<String, String> message)
            throws IOException {

        // TODO: Add to Orders        
        JsonObject payload = message.getPayload();
        int randomNameAndEmailIndex = ThreadLocalRandom.current().nextInt(RANDOM_NAMES.length);

        Order order = new Order();
        order.setCustomerName(RANDOM_NAMES[randomNameAndEmailIndex]);
        order.setCustomerEmail(RANDOM_EMAILS[randomNameAndEmailIndex]);
        order.setId(payload.getString("key"));
        order.setOrderValue(payload.getDouble("total"));
        order.setRetailPrice(payload.getString("retailPrice"));
        order.setDiscount(payload.getString("cartItemPromoSavings"));
        order.setShippingFee(payload.getString("shippingTotal"));
        order.setShippingDiscount(payload.getString("shippingPromoSavings"));
        order.setOrderStatus("Processing");

        orderService.add(order);
        
        LOG.info("Kafka message with value = {} arrived", message.getPayload());
        return message.ack();
    }


}
