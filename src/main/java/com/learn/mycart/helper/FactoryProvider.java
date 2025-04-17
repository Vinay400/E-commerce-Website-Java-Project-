package com.learn.mycart.helper;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class FactoryProvider {

    private static SessionFactory factory;

    public static SessionFactory getFactory() {
        try {
            if (factory == null) {
                System.out.println("Creating new SessionFactory...");
                Configuration config = new Configuration();
                config.configure("hibernate.cfg.xml");
                System.out.println("Hibernate Configuration loaded");
                factory = config.buildSessionFactory();
                System.out.println("SessionFactory created successfully");
            }
        } catch (Exception e) {
            System.err.println("Error creating SessionFactory:");
            e.printStackTrace();
            throw new RuntimeException("Failed to create SessionFactory", e);
        }

        if (factory == null) {
            throw new RuntimeException("SessionFactory is null");
        }

        return factory;
    }

    public static void closeFactory() {
        if (factory != null && !factory.isClosed()) {
            factory.close();
        }
    }
}
