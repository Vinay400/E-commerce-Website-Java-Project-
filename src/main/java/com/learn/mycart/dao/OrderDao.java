package com.learn.mycart.dao;

import com.learn.mycart.entities.Order;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.hibernate.Transaction;

public class OrderDao {
    private SessionFactory factory;

    public OrderDao(SessionFactory factory) {
        System.out.println("OrderDao constructor - Initializing with factory: " + (factory != null ? "valid" : "null"));
        this.factory = factory;
        if (factory == null) {
            throw new IllegalArgumentException("SessionFactory cannot be null");
        }
    }

    public boolean saveOrder(Order order) {
        System.out.println("\n=== Saving Order ===");
        if (order == null) {
            System.out.println("Error: Order is null");
            throw new IllegalArgumentException("Order cannot be null");
        }
        
        boolean f = false;
        Session session = null;
        try {
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            Transaction tx = session.beginTransaction();
            System.out.println("Transaction begun");
            
            session.save(order);
            System.out.println("Order saved with ID: " + order.getOrderId());
            
            tx.commit();
            System.out.println("Transaction committed");
            f = true;
        } catch (Exception e) {
            System.out.println("Error saving order: " + e.getMessage());
            e.printStackTrace();
            if (session != null && session.getTransaction() != null) {
                System.out.println("Rolling back transaction");
                session.getTransaction().rollback();
            }
            f = false;
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return f;
    }

    public double getTotalSpentByUser(int userId) {
        System.out.println("\n=== Getting Total Spent for User " + userId + " ===");
        if (userId <= 0) {
            System.out.println("Error: Invalid user ID: " + userId);
            throw new IllegalArgumentException("Invalid user ID");
        }
        
        double totalSpent = 0.0;
        Session session = null;
        try {
            String query = "Select sum(o.totalAmount) from Order o where o.user.userId = :uid";
            System.out.println("Query: " + query);
            
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            Query q = session.createQuery(query);
            q.setParameter("uid", userId);
            System.out.println("Query parameters set");
            
            Object result = q.uniqueResult();
            System.out.println("Query executed, result: " + result);
            
            if (result != null) {
                totalSpent = (Double) result;
                System.out.println("Total spent calculated: " + totalSpent);
            }
        } catch (Exception e) {
            System.out.println("Error getting total spent for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return totalSpent;
    }

    public int getOrderCountByUser(int userId) {
        System.out.println("\n=== Getting Order Count for User " + userId + " ===");
        if (userId <= 0) {
            System.out.println("Error: Invalid user ID: " + userId);
            throw new IllegalArgumentException("Invalid user ID");
        }
        
        int count = 0;
        Session session = null;
        try {
            String query = "Select count(*) from Order o where o.user.userId = :uid";
            System.out.println("Query: " + query);
            
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            Query q = session.createQuery(query);
            q.setParameter("uid", userId);
            System.out.println("Query parameters set");
            
            Object result = q.uniqueResult();
            System.out.println("Query executed, result: " + result);
            
            if (result != null) {
                count = ((Long) result).intValue();
                System.out.println("Order count calculated: " + count);
            }
        } catch (Exception e) {
            System.out.println("Error getting order count for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return count;
    }

    public List<Order> getRecentOrdersByUser(int userId, int limit) {
        System.out.println("\n=== Getting Recent Orders for User " + userId + " ===");
        if (userId <= 0) {
            System.out.println("Error: Invalid user ID: " + userId);
            throw new IllegalArgumentException("Invalid user ID");
        }
        
        List<Order> orders = null;
        Session session = null;
        try {
            String query = "SELECT DISTINCT o FROM Order o LEFT JOIN FETCH o.items WHERE o.user.userId = :uid ORDER BY o.orderDate DESC";
            System.out.println("Query: " + query);
            
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            Query q = session.createQuery(query);
            q.setParameter("uid", userId);
            q.setMaxResults(limit);
            System.out.println("Query parameters set");
            
            orders = q.getResultList();
            System.out.println("Query executed, orders found: " + (orders != null ? orders.size() : 0));
            
            // Log each order's details
            if (orders != null) {
                for (Order order : orders) {
                    System.out.println("Order loaded - ID: " + order.getOrderId() + 
                                     ", Date: " + order.getOrderDate() + 
                                     ", Status: " + order.getOrderStatus());
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting recent orders for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return orders;
    }

    public Order getOrderById(Long orderId) {
        System.out.println("\n=== Getting Order by ID " + orderId + " ===");
        if (orderId == null || orderId <= 0) {
            System.out.println("Error: Invalid order ID: " + orderId);
            throw new IllegalArgumentException("Invalid order ID");
        }
        
        Order order = null;
        Session session = null;
        try {
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            order = session.get(Order.class, orderId);
            System.out.println("Order retrieved: " + (order != null ? "ID=" + order.getOrderId() : "null"));
        } catch (Exception e) {
            System.out.println("Error getting order by ID " + orderId + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return order;
    }

    public boolean updateOrder(Order order) {
        System.out.println("\n=== Updating Order ===");
        if (order == null) {
            System.out.println("Error: Order is null");
            throw new IllegalArgumentException("Order cannot be null");
        }
        
        boolean f = false;
        Session session = null;
        try {
            session = this.factory.openSession();
            System.out.println("Session opened successfully");
            
            Transaction tx = session.beginTransaction();
            System.out.println("Transaction begun");
            
            session.update(order);
            System.out.println("Order updated - ID: " + order.getOrderId());
            
            tx.commit();
            System.out.println("Transaction committed");
            f = true;
        } catch (Exception e) {
            System.out.println("Error updating order: " + e.getMessage());
            e.printStackTrace();
            if (session != null && session.getTransaction() != null) {
                System.out.println("Rolling back transaction");
                session.getTransaction().rollback();
            }
            f = false;
        } finally {
            if (session != null) {
                System.out.println("Closing session");
                session.close();
            }
        }
        return f;
    }
} 