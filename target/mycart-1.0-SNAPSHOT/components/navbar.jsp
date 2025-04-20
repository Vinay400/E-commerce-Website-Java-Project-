<%@page import="com.learn.mycart.entities.User"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%
    // Get user from session
    User user1 = (User) session.getAttribute("current-user");
    
    // Determine active page
    String currentPage = request.getRequestURI();
    String cartActive = currentPage.contains("cart.jsp") ? "active" : "";
    String dashboardActive = currentPage.contains("normal.jsp") || currentPage.contains("admin.jsp") ? "active" : "";
%>

<nav class="navbar navbar-expand-lg navbar-dark custom-bg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">MyCart</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Categories
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <a class="dropdown-item" href="#">Action</a>
                        <a class="dropdown-item" href="#">Another action</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="#">Something else here</a>
                    </div>
                </li>
            </ul>

            <ul class="navbar-nav ml-auto">
                <li class="nav-item <%= cartActive %>">
                    <a class="nav-link" href="${pageContext.request.contextPath}/cart.jsp">
                        <i class="fa fa-shopping-cart"></i> Cart
                        <span class="badge badge-danger cart-items">0</span>
                    </a>
                </li>

                <% if (user1 == null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                    </li>
                <% } else { %>
                    <li class="nav-item <%= dashboardActive %>">
                        <a class="nav-link" href="${pageContext.request.contextPath}/<%= user1.getUserType().equals("admin") ? "admin.jsp" : "normal.jsp"%>">
                            <i class="fa fa-user"></i> <%= user1.getUserName()%>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">
                            <i class="fa fa-sign-out"></i> Logout
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        try {
            updateCart();
        } catch (error) {
            console.error('Error updating cart:', error);
        }
    });
</script>