<%@page import="com.learn.mycart.helper.Helper"%>
<%@page import="com.learn.mycart.entities.Category"%>
<%@page import="com.learn.mycart.dao.CategoryDao"%>
<%@page import="com.learn.mycart.entities.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.learn.mycart.dao.ProductDao"%>
<%@page import="com.learn.mycart.helper.FactoryProvider"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MyCart - Home </title>
        <%@include file="components/common_css_js.jsp" %>

    </head>
    <body>

        <%@include  file="components/navbar.jsp" %>

        <div class="container-fluid">
            <div class="row mt-3 mx-2">

                <% String cat = request.getParameter("category");
                    //out.println(cat);

                    ProductDao dao = new ProductDao(FactoryProvider.getFactory());
                    List<Product> list = null;

                    if (cat == null || cat.trim().equals("all")) {
                        list = dao.getAllProducts();

                    } else {

                        int cid = Integer.parseInt(cat.trim());
                        list = dao.getAllProductsById(cid);

                    }

                    CategoryDao cdao = new CategoryDao(FactoryProvider.getFactory());
                    List<Category> clist = cdao.getCategories();

                %>



                <!--show categories-->
                <div class="col-md-2">


                    <div class="list-group mt-4">

                        <a href="index.jsp?category=all" class="list-group-item list-group-item-action active">
                            All Products
                        </a>




                        <% for (Category c : clist) {
                        %>



                        <a href="index.jsp?category=<%= c.getCategoryId()%>" class="list-group-item list-group-item-action"><%= c.getCategoryTitle()%></a>


                        <%    }
                        %>



                    </div>


                </div>

                <!--show products-->
                <div class="col-md-10">


                    <!--row-->
                    <div class="row mt-4">

                        <!--col:12-->
                        <div class="col-md-12">

                            <div class="card-columns">

                                <!--traversing products-->

                                <%
                                    for (Product p : list) {

                                %>


                                <!--product card-->
                                <div class="card product-card">

                                    <div class="container text-center">
                                        <img src="img/products/<%= p.getpPhoto()%>" style="max-height: 200px;max-width: 100%;width: auto; " class="card-img-top m-2" alt="...">

                                    </div>

                                    <div class="card-body">

                                        <h5 class="card-title"><%= p.getpName()%></h5>

                                        <p class="card-text">
                                            <%= Helper.get10Words(p.getpDesc())%>

                                        </p>

                                    </div>

                                    <div class="card-footer text-center">
                                        <!-- Quantity controls (hidden by default) -->
                                        <div class="quantity-controls d-none" id="quantity-controls-<%=p.getpId()%>">
                                            <div class="d-flex justify-content-center align-items-center mb-2">
                                                <div class="input-group" style="width: 120px;">
                                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="decrementQuantity(<%=p.getpId()%>)">
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="number" class="form-control form-control-sm text-center quantity-input" 
                                                           id="quantity-<%=p.getpId()%>" value="1" min="1" max="<%=p.getpQuantity()%>" 
                                                           onchange="validateQuantity(<%=p.getpId()%>, <%=p.getpQuantity()%>)">
                                                    <button class="btn btn-outline-secondary btn-sm" type="button" onclick="incrementQuantity(<%=p.getpId()%>, <%=p.getpQuantity()%>)">
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                                <button class="btn btn-primary btn-sm ms-2" onclick="confirmAddToCart(<%=p.getpId()%>, '<%=Helper.escapeJavaScript(p.getpName())%>', <%=p.getPriceAfterApplyingDiscount()%>)">
                                                    Add
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <!-- Initial Add to Cart button -->
                                        <button class="btn btn-primary add-to-cart-btn" id="add-to-cart-<%=p.getpId()%>" 
                                                data-pid="<%=p.getpId()%>" 
                                                onclick="showQuantityControls(<%=p.getpId()%>)">
                                            <i class="fa fa-shopping-cart"></i> Add to Cart
                                        </button>
                                        
                                        <!-- Price display -->
                                        <div class="price-info mt-2">
                                            <span class="current-price">₹<%=p.getFormattedPrice()%></span>
                                            <% if (p.getpDiscount() > 0) { %>
                                                <span class="original-price text-muted text-decoration-line-through">
                                                    <small>₹<%=p.getpPrice()%></small>
                                                </span>
                                                <span class="discount-badge ms-1">
                                                    <small class="text-success"><%=p.getpDiscount()%>% off</small>
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>



                                </div>






                                <%}

                                    if (list.size() == 0) {
                                        out.println("<h3>No item in this category</h3>");
                                    }


                                %>


                            </div>                     



                        </div>                   

                    </div>



                </div>

            </div>
        </div>



        <%@include  file="components/common_modals.jsp" %>

        <script>
            // Function to show quantity controls and hide Add to Cart button
            function showQuantityControls(productId) {
                document.getElementById('quantity-controls-' + productId).classList.remove('d-none');
                document.getElementById('add-to-cart-' + productId).classList.add('d-none');
            }
            
            // Quantity control functions
            function decrementQuantity(productId) {
                const input = document.getElementById('quantity-' + productId);
                const currentValue = parseInt(input.value);
                if (currentValue > 1) {
                    input.value = currentValue - 1;
                }
            }

            function incrementQuantity(productId, maxQuantity) {
                const input = document.getElementById('quantity-' + productId);
                const currentValue = parseInt(input.value);
                if (currentValue < parseInt(maxQuantity)) {
                    input.value = currentValue + 1;
                }
            }

            function validateQuantity(productId, maxQuantity) {
                const input = document.getElementById('quantity-' + productId);
                let value = parseInt(input.value);
                maxQuantity = parseInt(maxQuantity);
                
                if (isNaN(value) || value < 1) {
                    value = 1;
                } else if (value > maxQuantity) {
                    value = maxQuantity;
                }
                
                input.value = value;
            }

            // Function to add to cart with selected quantity
            function confirmAddToCart(pid, pname, price) {
                const quantity = parseInt(document.getElementById('quantity-' + pid).value);
                let cart = JSON.parse(localStorage.getItem('cart')) || [];
                
                // Check if product already exists in cart
                let existingProduct = cart.find(item => item.productId === parseInt(pid));
                
                if (existingProduct) {
                    existingProduct.quantity = quantity;
                } else {
                    cart.push({
                        productId: parseInt(pid),
                        productName: pname,
                        price: parseFloat(price),
                        quantity: quantity
                    });
                }
                
                localStorage.setItem('cart', JSON.stringify(cart));
                updateCart();
                
                // Show success message
                showToast('Added ' + quantity + (quantity === 1 ? ' item' : ' items') + ' to cart');
                
                // Hide quantity controls and show Add to Cart button again
                document.getElementById('quantity-controls-' + pid).classList.add('d-none');
                document.getElementById('add-to-cart-' + pid).classList.remove('d-none');
            }

            function showToast(message) {
                const toast = document.createElement('div');
                toast.className = 'position-fixed bottom-0 end-0 p-3';
                toast.style.zIndex = '11';
                
                toast.innerHTML = 
                    '<div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">' +
                        '<div class="toast-header">' +
                            '<strong class="me-auto">MyCart</strong>' +
                            '<button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>' +
                        '</div>' +
                        '<div class="toast-body">' +
                            message +
                        '</div>' +
                    '</div>';
                
                document.body.appendChild(toast);
                
                setTimeout(() => {
                    toast.remove();
                }, 3000);
            }
        </script>
    </body>
</html>
