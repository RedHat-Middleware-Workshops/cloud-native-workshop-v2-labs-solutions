package com.redhat.coolstore;

import java.util.List;
import java.util.stream.Collectors;

import javax.json.Json;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.jboss.resteasy.annotations.jaxrs.PathParam;

import java.util.concurrent.TimeUnit;
import io.micrometer.core.instrument.MeterRegistry;

@Path("/services/inventory")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class InventoryResource {

    private final MeterRegistry registry;

    InventoryResource(MeterRegistry registry) {
        this.registry = registry;
    }

    @GET
    @Path("/lastletter/{itemId}")
    @Produces("application/text-plain")
    public String lastLetter(@PathParam("itemId") String itemId) {
        Inventory item = Inventory.find("itemId", itemId).firstResult();
        String location = item.location;
        int len = location.length();
        String lastLetter = location.substring(len-1);
        return lastLetter;
    }

    @GET
    public List<Inventory> getAll() {
        registry.counter("inventory.performedChecksAll.counter").increment();
        registry.timer("inventory.performedChecksAll.timer").record(3000, TimeUnit.MILLISECONDS);
        return Inventory.listAll();
    }

    @GET
    @Path("{itemId}")
    public List<Inventory> getAvailability(@PathParam String itemId) {
        registry.counter("inventory.performedChecksAvail.counter").increment();
        registry.timer("inventory.checksTimerAvail.timer").record(3000, TimeUnit.MILLISECONDS);
        return Inventory.<Inventory>streamAll()
        .filter(p -> p.itemId.equals(itemId))
        .collect(Collectors.toList());
    }

    @Provider
    public static class ErrorMapper implements ExceptionMapper<Exception> {

        @Override
        public Response toResponse(Exception exception) {
            int code = 500;
            if (exception instanceof WebApplicationException) {
                code = ((WebApplicationException) exception).getResponse().getStatus();
            }
            return Response.status(code)
                    .entity(Json.createObjectBuilder().add("error", exception.getMessage()).add("code", code).build())
                    .build();
        }

    }
}