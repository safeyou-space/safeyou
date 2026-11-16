<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class ContactUsEmail extends Mailable
{
    use Queueable, SerializesModels;


    /**
     * @var
     */
    public $name;
    public $emails;
    public $message_text;
    public $email;
    public $type;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($message, $name, $email)
    {
        $this->name = $name;
        $this->message_text = $message;
        $this->email = $email;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $send = $this->from(env('MAIL_USERNAME'), env('MAIL_FROM_NAME'))
            ->view('Email.contact_us')
            ->to(env('SUPPORT_EMAIL_ADDRESS'), env('REPLY_NAME'))
            ->replyTo($this->email, $this->name)
            ->subject('Safe YOU : Contact Us');
        return  $send;
    }
}
