package com.redhat.cloudnative;

import java.util.ArrayList;
import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

@ApplicationScoped
public class OrderService {

    // TODO: Inject MongoClient here
    @Inject MongoClient mongoClient;

    public List<Order> list(){

        List<Order> list = new ArrayList<>();

        // TODO: Add a while loop to make an order lists using MongoCursor here
        MongoCursor<Document> cursor = getCollection().find().iterator();

        try {
            while (cursor.hasNext()) {
                Document document = cursor.next();
                Order order = new Order();
                order.setOrderId(document.getString("orderId"));
                order.setName(document.getString("name"));
                order.setTotal(document.getString("total"));
                order.setCcNumber(document.getString("ccNumber"));
                order.setCcExp(document.getString("ccExp"));
                order.setBillingAddress(document.getString("billingAddress"));
                order.setStatus(document.getString("status"));
                list.add(order);
            }
        } finally {
            cursor.close();
        }
        return list;
    }

    public void add(Order order){

        // TODO: Add to create a Document based order here
        Document document = new Document()
            .append("orderId", order.getOrderId())
            .append("name", order.getName())
            .append("total", order.getTotal())
            .append("ccNumber", order.getCcNumber())
            .append("ccExp", order.getCcExp())
            .append("billingAddress", order.getBillingAddress())
            .append("status", order.getStatus());
        getCollection().insertOne(document);

    }

    public void updateStatus(String orderId, String status){
        Document searchQuery = new Document("orderId", orderId);
        Document newValue = new Document("status", status);
        Document updateOperationDoc = new Document("$set", newValue);
        getCollection().updateOne(searchQuery, updateOperationDoc);
    }

    private MongoCollection<Document> getCollection(){
        return mongoClient.getDatabase("order").getCollection("order");
    }
}