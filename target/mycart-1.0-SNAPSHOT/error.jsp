<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error - MyCart</title>
        <%@include file="components/common_css_js.jsp"%>
    </head>
    <body>
        <%@include file="components/navbar.jsp"%>
        
        <div class="container mt-5">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header bg-danger text-white">
                            <h4 class="mb-0">Error</h4>
                        </div>
                        <div class="card-body">
                            <h5>Sorry, an error occurred</h5>
                            
                            <% if (exception != null) { %>
                                <div class="alert alert-danger mt-3">
                                    <strong>Error Message:</strong> <%= exception.getMessage() %>
                                </div>
                                
                                <div class="mt-3">
                                    <strong>Stack Trace:</strong>
                                    <pre class="bg-light p-3 mt-2">
                                        <% exception.printStackTrace(new java.io.PrintWriter(out)); %>
                                    </pre>
                                </div>
                            <% } %>
                            
                            <div class="mt-4">
                                <a href="index.jsp" class="btn btn-primary">Go to Home</a>
                                <button onclick="window.history.back()" class="btn btn-secondary ml-2">Go Back</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html> 