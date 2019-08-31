package com.redhat.cloudnative;

import java.util.List;

import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

// TODO: Add JAX-RS annotations here
@Path("/orders")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class OrderResource {

    // TODO: Inject OrderService here
    @Inject OrderService orderService;

    // TODO: Add list(), add() methods here
    @GET
    public List<Order> list() {
        return orderService.list();
    }

    @POST
    public List<Order> add(Order order) {
        orderService.add(order);
        return list();
    }

}