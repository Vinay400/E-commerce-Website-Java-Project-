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
        this.factory = factory;
    }

    public double getTotalSpentByUser(int userId) {
        double totalSpent = 0.0;
        try {
            String query = "Select sum(o.totalAmount) from Order o where o.user.userId = :uid";
            Session session = this.factory.openSession();
            Query q = session.createQuery(query);
            q.setParameter("uid", userId);
            Object result = q.uniqueResult();
            if (result != null) {
                totalSpent = (Double) result;
            }
            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalSpent;
    }

    public int getOrderCountByUser(int userId) {
        int count = 0;
        try {
            String query = "Select count(*) from Order o where o.user.userId = :uid";
            Session session = this.factory.openSession();
            Query q = session.createQuery(query);
            q.setParameter("uid", userId);
            Object result = q.uniqueResult();
            if (result != null) {
                count = ((Long) result).intValue();
            }
            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Order> getRecentOrdersByUser(int userId, int limit) {
        List<Order> orders = null;
        try {
            String query = "from Order o where o.user.userId = :uid order by o.orderDate desc";
            Session session = this.factory.openSession();
            Query<Order> q = session.createQuery(query, Order.class);
            q.setParameter("uid", userId);
            q.setMaxResults(limit);
            orders = q.list();
            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean saveOrder(Order order) {
        boolean success = false;
        try {
            Session session = this.factory.openSession();
            Transaction tx = session.beginTransaction();
            session.save(order);
            tx.commit();
            session.close();
            success = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
} 