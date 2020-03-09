package com.redhat.coolstore;

import java.util.List;
import java.util.stream.Collectors;

import javax.enterprise.context.ApplicationScoped;
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

import org.eclipse.microprofile.metrics.MetricUnits;
import org.eclipse.microprofile.metrics.annotation.Counted;
import org.eclipse.microprofile.metrics.annotation.Timed;

@Path("/services/inventory")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class InventoryResource {

    @GET
    @Path("/lastletter/{itemId}")
    @Produces("application/text-plain")
    public String lastLetter(@PathParam("itemId") String itemId) {
        Inventory item = Inventory.find("itemId", itemId).firstResult();
        String location = item.location;
        int len = location.length();
        String lastLetter = location.substring(len - 1);
        return lastLetter;
    }

    @GET
    @Counted(name = "performedChecksAll", description = "How many getAll() have been performed.")
    @Timed(name = "checksTimerAll", description = "A measure of how long it takes to perform the getAll().", unit = MetricUnits.MILLISECONDS)
    public List<Inventory> getAll() {
        return Inventory.listAll();
    }

    @GET
    @Counted(name = "performedChecksAvail", description = "How many getAvailability() have been performed.")
    @Timed(name = "checksTimerAvail", description = "A measure of how long it takes to perform the getAvailability().", unit = MetricUnits.MILLISECONDS)
    @Path("{itemId}")
    public List<Inventory> getAvailability(@PathParam String itemId) {
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