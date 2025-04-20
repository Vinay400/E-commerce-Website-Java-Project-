package com.learn.mycart.entities;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long orderId;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    @Column(name = "shipping_address")
    private String shippingAddress;
    
    @Column(name = "order_date", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date orderDate;
    
    @Column(name = "order_status")
    private String orderStatus;
    
    @Column(name = "payment_method")
    private String paymentMethod;
    
    @Column(name = "total_amount")
    private double totalAmount;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items;
    
    public Order() {
        this.orderDate = new Date();
        this.orderStatus = "PENDING";
        this.totalAmount = 0.0;
        this.items = new ArrayList<>();
    }
    
    public Order(User user) {
        this();
        this.user = user;
    }
    
    public Order(User user, String shippingAddress, String orderStatus, String paymentMethod, double totalAmount) {
        this.user = user;
        this.shippingAddress = shippingAddress;
        this.orderDate = new Date();
        this.orderStatus = orderStatus;
        this.paymentMethod = paymentMethod;
        this.totalAmount = totalAmount;
    }
    
    // Getters and setters
    public Long getOrderId() {
        return orderId;
    }
    
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }
    
    public String getOrderStatus() {
        return orderStatus;
    }
    
    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }
    
    // Alias for setOrderStatus to maintain compatibility
    public void setStatus(String status) {
        this.orderStatus = status;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public List<OrderItem> getItems() {
        return items;
    }
    
    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
    
    // Convenience methods for managing order items
    public void addItem(OrderItem item) {
        if (items == null) {
            items = new ArrayList<>();
        }
        items.add(item);
        item.setOrder(this);
        // Update total amount
        this.totalAmount += item.getSubtotal();
    }
    
    public void removeItem(OrderItem item) {
        if (items != null && items.remove(item)) {
            item.setOrder(null);
            // Update total amount
            this.totalAmount -= item.getSubtotal();
        }
    }
    
    // Helper method to get total number of items
    public int getTotalItems() {
        return items.stream().mapToInt(OrderItem::getQuantity).sum();
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + (user != null ? user.getUserId() : "null") +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", orderDate=" + orderDate +
                ", orderStatus='" + orderStatus + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", totalAmount=" + totalAmount +
                ", items=" + (items != null ? items.size() : 0) +
                '}';
    }
} 