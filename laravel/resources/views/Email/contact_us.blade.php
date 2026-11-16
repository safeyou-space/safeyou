<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Help ME</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
    <style>
        .wrapper {
            width: 100%;
            min-height: 100vh;
            background-color: #fff;
        }
        .header-image {
            width: 100%;
            max-width: 300px;
            height: 310px;
            object-fit: cover;
        }
        .header-title {
            color: #a650c1;
            font-size: 36px;
            font-family: 'Roboto', Bold;
            margin: 5px 0px;
        }
        .header-text {
            margin-bottom: 25px;
            max-width: 70%;
            line-height: 39px;
            font-size: 17px;
            font-family: 'Roboto', Regular;
            margin: 5px 0px;
        }
        .download-block {
            margin-bottom: 15px
        }
        .download-block > a {
            text-decoration: none;
            color: #000;
            font-family: 'Roboto', Bold;
        }
        .download-image {
            width: 30px
        }
        .download-text {
            font-size: 20px;
            margin-left: 5px;
            font-family: 'Roboto', Bold;
        }
        @media only screen and (max-width: 768px) {
            .header-title {
                font-size: 28px;
            }
            .header-text {
                max-width: 100%;
                line-height: 25px;
                font-size: 15px;
            }
            .download-image {
                width: 20px;
            }
            .download-text {
                font-size: 20px;
            }
        }
    </style>
</head>
<body style="background-color: #cfcfcf;">
<div class="wrapper">
    <div style="margin: 0 auto; width: 90%; padding-bottom: 1px;">
        <img src="{{ env('APP_URL') }}/mail_images/Logo.png" class="header-image" alt="logo">
        <h1 class="header-title">Contact Us</h1>
        <p class="header-text">
            NAME : {{ $name  }}
        </p>
        @isset($email)
        <p class="header-text">
        EMAIL ADDRESS : {{ $email }}
        </p>
        @endisset
        @isset($message_text)
            <p class="header-text">
                {{ $message_text }}
            </p>
        @endisset
    </div>
</div>
</body>
</html>
