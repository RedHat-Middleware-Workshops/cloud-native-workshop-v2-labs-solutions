package com.redhat.cloudnative.client;

import com.redhat.cloudnative.model.Inventory;
import feign.hystrix.FallbackFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import feign.hystrix.FallbackFactory;

@FeignClient(name="inventory",fallbackFactory = InventoryClient.InventoryClientFallbackFactory.class)
public interface InventoryClient {

    @RequestMapping(method = RequestMethod.GET, value = "/api/inventory/{itemId}", consumes = {MediaType.APPLICATION_JSON_VALUE})
    String getInventoryStatus(@PathVariable("itemId") String itemId);

//TODO: Add Fallback factory here
    @Component
    static class InventoryClientFallbackFactory implements FallbackFactory<InventoryClient> {
        @Override
        public InventoryClient create(Throwable cause) {
            return new InventoryClient() {
                @Override
                public String getInventoryStatus(@PathVariable("itemId") String itemId) {
                    JSONObject obj = new JSONObject();
                    obj.put("quantity", 0);
                    obj.put("itemId", itemId);
                    obj.put("location", "unknown");
                    obj.put("link", "http://redhat.com");
                    JSONArray inv = new JSONArray();
                    inv.put(obj);
                    System.out.println("returning inv: " + inv.toString());
                    return inv.toString();

                }
            };
        }
    }
}