<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERROR 500 - Internal Server Error</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #ffffff; /* White background */
        }

        .error-container {
            text-align: center;
        }

        .red-circle {
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background-color: #ff0000; /* Red color */
            display: flex;
            justify-content: center;
            align-items: center;
            color: #ffffff; /* White text color */
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="red-circle">
            ERROR 500
        </div>
        <p>Internal Server Error</p>
        <p style="font-weight : bold">Coin Market</p>
    </div>
</body>
</html>
