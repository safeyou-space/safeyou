<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class ResponseLetter extends Mailable
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
        $this->emails = [env('SUPPORT_EMAIL_ADDRESS')];
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $send = $this->from(env('MAIL_USERNAME'), env('MAIL_FROM_NAME'))->view('Email.response_letter')
            ->subject('Safe YOU : Response Letter')
            ->to($this->email)
            ->replyTo(env('SUPPORT_EMAIL_ADDRESS'), "SafeYou Support")
            ->bcc([env('MAIL_USERNAME')]);
        return  $send;
    }
}
