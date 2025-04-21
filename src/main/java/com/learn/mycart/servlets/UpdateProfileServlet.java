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

public class UpdateProfileServlet extends HttpServlet {

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
            
            // Get updated profile information
            String userName = request.getParameter("userName");
            String userPhone = request.getParameter("userPhone");
            String userAddress = request.getParameter("userAddress");
            
            // Update user object
            user.setUserName(userName);
            user.setUserPhone(userPhone);
            user.setUserAddress(userAddress);
            
            // Update in database
            UserDao userDao = new UserDao(FactoryProvider.getFactory());
            boolean updated = userDao.updateUser(user);
            
            if (updated) {
                session.setAttribute("message", "Profile updated successfully!");
                session.setAttribute("current-user", user);
            } else {
                session.setAttribute("message", "Failed to update profile!");
            }
            
            response.sendRedirect("profile");
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("message", "Error: " + e.getMessage());
            response.sendRedirect("profile");
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