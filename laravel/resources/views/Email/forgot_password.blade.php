<!DOCTYPE html>
<html>
<head>
    <title>Welcome Email</title>
    <style>
        .button {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding:10px 18px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 11px;
            margin: 4px 2px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<h2>Welcome to the site {{$data->name}}</h2>
<br/>
Your registered email-id is {{$data->email}}
<br/>
If your email please check button <a href="{{ env('APP_URL') }}/password/email?hash={{$data->hash}}&email={{$data->email}}" class="button">Accept</a>

</body>
</html>
