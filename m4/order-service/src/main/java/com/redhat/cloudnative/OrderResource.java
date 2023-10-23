package com.redhat.cloudnative;

import java.util.List;

import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.PathParam;

// TODO: Add JAX-RS annotations here
@Path("/api/orders")
public class OrderResource {

    // TODO: Add list(), add(), updateStatus() methods here
    @GET
    public List<Order> list() {
        return Order.listAll();
    }

    @POST
    public List<Order> add(Order order) {
        order.persist();
        return list();
    }

    @GET
    @Path("/{orderId}/{status}")
    public Order updateStatus(String orderId, String status) {
        Order newOrder = Order.findByOrderId(orderId);
        newOrder.status = status;
        newOrder.update();
        return newOrder;

    }

       
}