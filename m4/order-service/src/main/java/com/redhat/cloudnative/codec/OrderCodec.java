package com.redhat.cloudnative.codec;

import com.mongodb.MongoClientSettings;
import com.redhat.cloudnative.Order;
import org.bson.*;
import org.bson.codecs.Codec;
import org.bson.codecs.CollectibleCodec;
import org.bson.codecs.DecoderContext;
import org.bson.codecs.EncoderContext;

import java.util.UUID;

public class OrderCodec implements CollectibleCodec<Order> {

    private final Codec<Document> documentCodec;

    public OrderCodec() {
        this.documentCodec = MongoClientSettings.getDefaultCodecRegistry().get(Document.class);
    }
   
    // TODO: Add Encode & Decode contexts here
    @Override
    public void encode(BsonWriter writer, Order Order, EncoderContext encoderContext) {
        Document doc = new Document();
        doc.put("orderId", Order.getOrderId());
        doc.put("name", Order.getName());
        doc.put("total", Order.getTotal());
        doc.put("ccNumber", Order.getCcNumber());
        doc.put("ccExp", Order.getCcExp());
        doc.put("billingAddress", Order.getBillingAddress());
        doc.put("status", Order.getStatus());
        documentCodec.encode(writer, doc, encoderContext);
    }

    @Override
    public Class<Order> getEncoderClass() {
        return Order.class;
    }

    @Override
    public Order generateIdIfAbsentFromDocument(Order document) {
        if (!documentHasId(document)) {
            document.setOrderId(UUID.randomUUID().toString());
        }
        return document;
    }

    @Override
    public boolean documentHasId(Order document) {
        return document.getOrderId() != null;
    }

    @Override
    public BsonValue getDocumentId(Order document) {
        return new BsonString(document.getOrderId());
    }

    @Override
    public Order decode(BsonReader reader, DecoderContext decoderContext) {
        Document document = documentCodec.decode(reader, decoderContext);
        Order order = new Order();
        if (document.getString("orderId") != null) {
            order.setOrderId(document.getString("orderId"));
        }
        order.setName(document.getString("name"));
        order.setTotal(document.getString("total"));
        order.setCcNumber(document.getString("ccNumber"));
        order.setCcExp(document.getString("ccExp"));
        order.setBillingAddress(document.getString("billingAddress"));
        order.setStatus(document.getString("status"));
        return order;
    }   
    
}