package com.learn.mycart.servlets;

import com.learn.mycart.dao.UserDao;
import com.learn.mycart.entities.User;
import com.learn.mycart.helper.FactoryProvider;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdatePasswordServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("current-user");
            
            if (user == null) {
                session.setAttribute("message", "You are not logged in!");
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get password information
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Verify current password
            if (!user.getUserPassword().equals(currentPassword)) {
                session.setAttribute("message", "Current password is incorrect!");
                response.sendRedirect("profile.jsp");
                return;
            }
            
            // Verify new passwords match
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("message", "New passwords do not match!");
                response.sendRedirect("profile.jsp");
                return;
            }
            
            // Update password
            user.setUserPassword(newPassword);
            
            // Update in database
            UserDao userDao = new UserDao(FactoryProvider.getFactory());
            boolean updated = userDao.updateUser(user);
            
            if (updated) {
                session.setAttribute("message", "Password updated successfully!");
                session.setAttribute("current-user", user);
            } else {
                session.setAttribute("message", "Failed to update password!");
            }
            
            response.sendRedirect("profile.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("message", "Error: " + e.getMessage());
            response.sendRedirect("profile.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
} 