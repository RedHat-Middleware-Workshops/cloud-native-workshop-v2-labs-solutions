package com.redhat.cloudnative.model;

import java.io.Serializable;

public class Product implements Serializable {

	private static final long serialVersionUID = -7304814269819778382L;
	private String itemId;
	private String name;
	private String desc;
	private double price;
	private int quantity;

	public Product() {

	}

	public Product(String itemId, String name, String desc, double price) {
		super();
		this.itemId = itemId;
		this.name = name;
		this.desc = desc;
		this.price = price;
	}
	public String getItemId() {
		return itemId;
	}
	public void setItemId(String itemId) {
		this.itemId = itemId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
	public String toString() {
		return "Product [itemId=" + itemId + ", name=" + name + ", desc="
				+ desc + ", price=" + price + ", quantity=" + quantity + "]";
	}



}
