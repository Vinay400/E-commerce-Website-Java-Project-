<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.learn.mycart.entities.User"%>
<%
    User user = (User) session.getAttribute("current-user");
    if (user == null) {
        session.setAttribute("message", "You are not logged in!");
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Profile - MyCart</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
            }
            
            body {
                background-color: #f8f9fc;
                font-family: 'Nunito', sans-serif;
            }
            
            .card {
                border: none;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,.15);
            }
            
            .profile-header {
                background: linear-gradient(180deg, var(--primary-color) 10%, #224abe 100%);
                color: white;
                padding: 2rem;
                border-radius: 0.35rem 0.35rem 0 0;
            }
            
            .profile-img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                border: 5px solid white;
                object-fit: cover;
            }
            
            .nav-pills .nav-link {
                color: var(--secondary-color);
                border-radius: 0.35rem;
                padding: 0.75rem 1rem;
            }
            
            .nav-pills .nav-link.active {
                background-color: var(--primary-color);
                color: white;
            }
            
            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            }
        </style>
    </head>
    <body>
        <div class="container py-5">
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="profile-header">
                            <div class="text-center">
                                <img src="img/user.png" alt="Profile" class="profile-img mb-3">
                                <h3><%= user.getUserName() %></h3>
                                <p class="text-white-50"><%= user.getUserEmail() %></p>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist">
                                        <a class="nav-link active" id="v-pills-profile-tab" data-bs-toggle="pill" href="#v-pills-profile" role="tab">
                                            <i class="fas fa-user me-2"></i>Profile
                                        </a>
                                        <a class="nav-link" id="v-pills-orders-tab" data-bs-toggle="pill" href="#v-pills-orders" role="tab">
                                            <i class="fas fa-box me-2"></i>Orders
                                        </a>
                                        <a class="nav-link" id="v-pills-security-tab" data-bs-toggle="pill" href="#v-pills-security" role="tab">
                                            <i class="fas fa-lock me-2"></i>Security
                                        </a>
                                    </div>
                                </div>
                                <div class="col-md-9">
                                    <div class="tab-content" id="v-pills-tabContent">
                                        <!-- Profile Tab -->
                                        <div class="tab-pane fade show active" id="v-pills-profile" role="tabpanel">
                                            <h4 class="mb-4">Profile Information</h4>
                                            <form action="UpdateProfileServlet" method="post">
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label class="form-label">Name</label>
                                                        <input type="text" class="form-control" name="userName" value="<%= user.getUserName() %>">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label">Email</label>
                                                        <input type="email" class="form-control" value="<%= user.getUserEmail() %>" disabled>
                                                    </div>
                                                </div>
                                                <div class="row mb-3">
                                                    <div class="col-md-6">
                                                        <label class="form-label">Phone</label>
                                                        <input type="text" class="form-control" name="userPhone" value="<%= user.getUserPhone() %>">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="form-label">Address</label>
                                                        <textarea class="form-control" name="userAddress" rows="2"><%= user.getUserAddress() %></textarea>
                                                    </div>
                                                </div>
                                                <button type="submit" class="btn btn-primary">Update Profile</button>
                                            </form>
                                        </div>
                                        
                                        <!-- Orders Tab -->
                                        <div class="tab-pane fade" id="v-pills-orders" role="tabpanel">
                                            <h4 class="mb-4">Recent Orders</h4>
                                            <div class="table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Order ID</th>
                                                            <th>Date</th>
                                                            <th>Total</th>
                                                            <th>Status</th>
                                                            <th>Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="5" class="text-center">
                                                                <a href="my-orders" class="btn btn-primary">View All Orders</a>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        
                                        <!-- Security Tab -->
                                        <div class="tab-pane fade" id="v-pills-security" role="tabpanel">
                                            <h4 class="mb-4">Change Password</h4>
                                            <form action="UpdatePasswordServlet" method="post">
                                                <div class="mb-3">
                                                    <label class="form-label">Current Password</label>
                                                    <input type="password" class="form-control" name="currentPassword" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">New Password</label>
                                                    <input type="password" class="form-control" name="newPassword" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Confirm New Password</label>
                                                    <input type="password" class="form-control" name="confirmPassword" required>
                                                </div>
                                                <button type="submit" class="btn btn-primary">Change Password</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS and dependencies -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
        <!-- Font Awesome -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    </body>
</html> 