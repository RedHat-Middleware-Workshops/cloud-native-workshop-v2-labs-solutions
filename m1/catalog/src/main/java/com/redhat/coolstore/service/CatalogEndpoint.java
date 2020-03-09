package com.redhat.coolstore.service;

import java.util.List;
import com.redhat.coolstore.model.Product;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/services")
public class CatalogEndpoint {

    private final CatalogService catalogService;

    public CatalogEndpoint(CatalogService catalogService) {
      this.catalogService = catalogService;
    }

    @GetMapping("/products")
    public List<Product> readAll() {
      return this.catalogService.readAll();
    }

    @GetMapping("/product/{id}")
    public Product read(@PathVariable("id") String id) {
      return this.catalogService.read(id);
    }

}