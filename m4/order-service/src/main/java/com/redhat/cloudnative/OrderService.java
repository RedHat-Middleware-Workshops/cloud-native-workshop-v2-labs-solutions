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
                order.setId(document.getString("id"));
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
                .append("id", order.getId())
                .append("name", order.getName())
                .append("total", order.getTotal())
                .append("ccNumber", order.getCcNumber())
                .append("ccExp", order.getCcExp())
                .append("billingAddress", order.getBillingAddress())
                .append("status", order.getStatus());
        getCollection().insertOne(document);
        
    }

    public void updateStatus(String orderId, String status){

        Document searchQuery = new Document().append("id", orderId);
        MongoCursor<Document> cursor = getCollection().find().iterator();
        try {
            while (cursor.hasNext()) {
                Document document = cursor.next();
                if ( document.getString("id").equals(orderId) ) {
                    Document newDocument = new Document();
                    newDocument.append("id", orderId);
                    newDocument.append("name", document.getString("name"));
                    newDocument.append("total", document.getString("total"));
                    newDocument.append("ccNumber", document.getString("ccNumber"));
                    newDocument.append("ccExp", document.getString("ccExp"));
                    newDocument.append("billingAddress", document.getString("billingAddress"));
                    newDocument.append("status", document.getString("status"));
                    Document update = new Document();
                    update.append("$set", newDocument);
                    getCollection().updateOne(searchQuery, update);
                    break;
                }
            }
        } finally {
            cursor.close();
        }
    }

    private MongoCollection getCollection(){
        return mongoClient.getDatabase("order").getCollection("order");
    }
}