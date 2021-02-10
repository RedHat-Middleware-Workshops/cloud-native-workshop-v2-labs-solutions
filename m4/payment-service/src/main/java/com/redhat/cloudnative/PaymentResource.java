package com.redhat.cloudnative;

import java.io.IOException;
import java.util.Properties;
import java.util.concurrent.CompletionStage;

import javax.enterprise.event.Observes;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.quarkus.runtime.StartupEvent;
import io.smallrye.reactive.messaging.kafka.KafkaRecord;
import io.vertx.core.json.JsonObject;
import javax.inject.Singleton;

@Path("/")
@Singleton
public class PaymentResource {

    // TODO: Add Messaging ConfigProperty here
    @ConfigProperty(name = "mp.messaging.outgoing.payments.bootstrap.servers")
    public String bootstrapServers;

    @ConfigProperty(name = "mp.messaging.outgoing.payments.topic")
    public String paymentsTopic;

    @ConfigProperty(name = "mp.messaging.outgoing.payments.value.serializer")
    public String paymentsTopicValueSerializer;

    @ConfigProperty(name = "mp.messaging.outgoing.payments.key.serializer")
    public String paymentsTopicKeySerializer;

    private Producer<String, String> producer;

    public static final Logger log = LoggerFactory.getLogger(PaymentResource.class);
    // TODO: Add handleCloudEvent method here
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public void handleCloudEvent(String cloudEventJson) {
        String orderId = "unknown";
        String paymentId = "" + ((int)(Math.floor(Math.random() * 100000)));

        try {
            log.info("received event: " + cloudEventJson);
            JsonObject event = new JsonObject(cloudEventJson);
            orderId = event.getString("orderId");
            String total = event.getString("total");
            JsonObject ccDetails = event.getJsonObject("creditCard");
            String name = event.getString("name");

            // fake processing time
            Thread.sleep(5000); 
            if (!ccDetails.getString("number").startsWith("4")) {
                fail(orderId, paymentId, "Invalid Credit Card: " + ccDetails.getString("number"));
            } else {
                pass(orderId, paymentId, "Payment of " + total + " succeeded for " + name + " CC details: " + ccDetails.toString());
            }
        } catch (Exception ex) {
             fail(orderId, paymentId, "Unknown error: " + ex.getMessage() + " for payment: " + cloudEventJson);
        }
    }
    // TODO: Add pass method here
    private void pass(String orderId, String paymentId, String remarks) {

        JsonObject payload = new JsonObject();
        payload.put("orderId", orderId);
        payload.put("paymentId", paymentId);
        payload.put("remarks", remarks);
        payload.put("status", "COMPLETED");
        log.info("Sending payment success: " + payload.toString());
        producer.send(new ProducerRecord<String, String>(paymentsTopic, payload.toString()));
    }
    // TODO: Add fail method here
    private void fail(String orderId, String paymentId, String remarks) {
        JsonObject payload = new JsonObject();
        payload.put("orderId", orderId);
        payload.put("paymentId", paymentId);
        payload.put("remarks", remarks);
        payload.put("status", "FAILED");
        log.info("Sending payment failure: " + payload.toString());
        producer.send(new ProducerRecord<String, String>(paymentsTopic, payload.toString()));
    }
    // TODO: Add consumer method here
    // @Incoming("orders")
    // public CompletionStage<Void> onMessage(KafkaRecord<String, String> message)
    //         throws IOException {

    //     log.info("Kafka message with value = {} arrived", message.getPayload());
    //     handleCloudEvent(message.getPayload());
    //     return message.ack();
    // }
    // TODO: Add init method here
    public void init(@Observes StartupEvent ev) {
        Properties props = new Properties();

        props.put("bootstrap.servers", bootstrapServers);
        props.put("value.serializer", paymentsTopicValueSerializer);
        props.put("key.serializer", paymentsTopicKeySerializer);
        producer = new KafkaProducer<String, String>(props);
    }
}