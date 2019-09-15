package com.redhat.coolstore;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

@QuarkusTest
public class InventoryEndpointTest {

    @Test
    public void testListAllInventory() {
        //List all, should have all 8 cities inventory the database has initially:
       
        //List a certain city(Seoul), 256 should be returned:
       
    }

}
