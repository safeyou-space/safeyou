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

        <h1 class="header-title">Please Help Me</h1>

        <p class="header-text">
            @isset($user->help_message->translation)
                {{ $user->help_message->translation }}
            @endisset
        </p>

        <p class="header-text">
           NAME : {{ $user->first_name  }} {{ " " }} {{ $user->last_name }}
        </p>
        {{--@isset($user->email)--}}
        {{--<p class="header-text">--}}
            {{--EMAIL ADDRESS :  {{ $user->email }}--}}
        {{--</p>--}}
        {{--@endisset--}}
        @isset($user->phone)
            <p class="header-text">
               Phone Number :  {{ $user->phone }}
            </p>
        @endisset

        <div class="download-block">
            <img src="{{ env('APP_URL') }}/mail_images/Location.png" class="download-image" alt="Location">
            <a href="https://www.google.com/maps/search/?api=1&query={{$user->lat}}{{ "," }} {{ $user->lng }}" target="_blank" style="font-size: 25px; margin-left: 5px;">
            <b class="download-text">Location</b></a>
        </div>

        {{--<div class="download-block">--}}
            {{--<img src="{{ env('APP_URL') }}/mail_images/Attach.png" class="download-image" alt="Attach">--}}
            {{--<a href="{{ $message->embedData($file, 'violence_record') }}" download ><b class="download-text">Download the attachment</b></a>--}}
        {{--</div>--}}
    </div>
</div>
</body>
</html>
