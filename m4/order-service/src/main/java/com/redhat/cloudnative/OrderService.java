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
                order.setCustomerName(document.getString("customerName"));
                order.setCustomerEmail(document.getString("customerEmail"));
                order.setOrderValue(document.getDouble("orderValue"));
                order.setRetailPrice(document.getDouble("retailPrice"));
                order.setDiscount(document.getDouble("discount"));
                order.setShippingFee(document.getDouble("shippingFee"));
                order.setShippingDiscount(document.getDouble("shippingDiscount"));
                order.setOrderStatus(document.getString("orderStatus"));
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
                .append("customerName", order.getCustomerName())
                .append("customerEmail", order.getCustomerEmail())
                .append("orderValue", order.getOrderValue())
                .append("retailPrice", order.getRetailPrice())
                .append("discount", order.getDiscount())
                .append("shippingFee", order.getShippingFee())
                .append("shippingDiscount", order.getShippingDiscount())
                .append("orderStatus", order.getOrderStatus());
        getCollection().insertOne(document);
        
    }

    public void updateStatus(String orderId){

        Document searchQuery = new Document().append("id", orderId);
        MongoCursor<Document> cursor = getCollection().find().iterator();
        try {
            while (cursor.hasNext()) {
                Document document = cursor.next();
                Order order = new Order();
                if ( document.getString("id").equals(orderId) ) {
                    Document newDocument = new Document();
                    newDocument.append("id", orderId);
                    newDocument.append("customerName", document.getString("customerName"));
                    newDocument.append("customerEmail", document.getString("customerEmail"));
                    newDocument.append("orderValue", document.getDouble("orderValue"));
                    newDocument.append("retailPrice", document.getDouble("retailPrice"));
                    newDocument.append("discount", document.getDouble("discount"));
                    newDocument.append("shippingFee", document.getDouble("shippingFee"));
                    newDocument.append("shippingDiscount", document.getDouble("shippingDiscount"));
                    newDocument.append("orderStatus", "Completed");
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