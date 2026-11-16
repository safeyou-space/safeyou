<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendEmail extends Mailable
{
    use Queueable, SerializesModels;


    /**
     * @var
     */
    public $user;
    public $emails;
    public $file;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($user, $emails, $file)
    {
        $this->user = $user;
        $this->file = $file;
        $this->emails = $emails;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $send = $this->from(env('MAIL_USERNAME'), env('MAIL_FROM_NAME'))->view('Email.help')
            ->subject('Safe You Help me')
            ->cc($this->emails)
            ->attach(public_path($this->file));
            return  $send;
    }
}
