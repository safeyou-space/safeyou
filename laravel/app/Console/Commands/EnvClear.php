<?php

/*
|--------------------------------------------------------------------------
|      /|    //| |     // | |     //   ) )  //   / /                  _____
|     //|   // | |    //__| |    //___/ /  //__ / /   ___   //___/ / //
|    // |  //  | |   / ___  |   / ___ (   //__  /    ____  /____  / //__
|   //  | //   | |  //    | |  //   | |  //   \ \              / / //   ) )
|  //   |//    | | //     | | //    | | //     \ \            / / ((___/ /
|--------------------------------------------------------------------------
| One of the famous people said, "We create our own demons." What did he
| mean Who said that? Never mind. I join, and now this statement was made
| from the lips of two famous guys. [Skype: mark.38.98]
|--------------------------------------------------------------------------
*/

namespace App\Console\Commands;

use Illuminate\Console\Command;

use Artisan;
use Symfony\Component\Console\Formatter\OutputFormatterStyle;

class EnvClear extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'clear';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Clear config:cache, config:clear, cache:clear, view:clear, route:clear';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $output = new \Symfony\Component\Console\Output\ConsoleOutput();

        $output->writeln("<question>->  Started of artisan clear commands...</question>");

        for ($i = 0; $i < 50; $i++) {
            Artisan::call('config:cache');
        }
        $output->writeln("> <options=bold,underscore>php artisan config:cache</>");

        for ($i = 0; $i < 50; $i++) {
            Artisan::call('config:clear');
        }
        $output->writeln("> <options=bold,underscore>php artisan config:clear</>");

        for ($i = 0; $i < 50; $i++) {
            Artisan::call('cache:clear');
        }
        $output->writeln("> <options=bold,underscore>php artisan cache:clear</>");

        for ($i = 0; $i < 50; $i++) {
            Artisan::call('view:clear');
        }
        $output->writeln("> <options=bold,underscore>php artisan view:clear</>");

        for ($i = 0; $i < 50; $i++) {
            Artisan::call('route:clear');
        }
        $output->writeln("> <options=bold,underscore>php artisan route:clear</>");
        
        $output->writeln("\n<question>->  Reading: .ENV</question>");
        foreach ($_ENV as $key => $value) {
            $output->writeln("+ <fg=cyan>$key - $value</>");
        }
        $output->writeln("<question>->  Cleaned end!</question>");
    }
}

