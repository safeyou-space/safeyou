<?php

namespace Database\seeds;
use Illuminate\Database\Seeder;

class ContentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();

        \App\Models\Contents::insert([
            [
                'title' => 'terms_conditions',
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\ContentTranslations::insert([
            [
                'content_id' => 1,
                'content' => '<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
    <title>Terms & Conditions</title>
</head>
<body style="margin: 0px; padding: 0px">
    <div style="background-color: #fff; padding: 0px 30px">
        <div>
            <h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">Terms & Conditions</h1>
            <span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Nam a purus non turpis 2019</span>
            <p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
                Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
                Praesent venenatis elementum nulla ac venenatis.
                Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
                Morbi justo felis, tempus id quam in, iaculis consequat quam.
                Praesent cursus sapien eu libero fringilla varius.
                Sed vestibulum at est ut finibus.
                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
                Proin ornare enim metus, non rutrum dolor vestibulum at.
                Praesent tincidunt gravida dolor, id sodales dolor posuere ut.
                Aliquam erat volutpat.Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
                Praesent venenatis elementum nulla ac venenatis. Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
                Morbi justo felis, tempus id quam in, iaculis consequat quam.
                Praesent cursus sapien eu libero fringilla varius.
                Sed vestibulum at est ut finibus.
                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
                Proin ornare enim metus, non rutrum dolor vestibulum at.
                Praesent tincidunt gravida dolor, id sodales dolor posuere ut. Aliquam erat volutpat.
            </p>
        </div>
    </div>
</body>
</html>
',
                'language_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\ContentTranslations::insert([
            [
                'content_id' => 1,
                'content' => '<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
    <title>Terms & Conditions</title>
</head>
<body style="margin: 0px; padding: 0px">
    <div style="background-color: #fff; padding: 0px 30px">
        <div>
            <h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">Terms & Conditions Hayeren</h1>
            <span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Nam a purus non turpis 2019</span>
            <p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
                Terms & Conditions
                Praesent venenatis elementum nulla ac venenatis.
                Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
                Morbi justo felis, tempus id quam in, iaculis consequat quam.
                Praesent cursus sapien eu libero fringilla varius.
                Sed vestibulum at est ut finibus.
                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
                Proin ornare enim metus, non rutrum dolor vestibulum at.
                Praesent tincidunt gravida dolor, id sodales dolor posuere ut.
                Aliquam erat volutpat.Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
                Praesent venenatis elementum nulla ac venenatis. Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
                Morbi justo felis, tempus id quam in, iaculis consequat quam.
                Praesent cursus sapien eu libero fringilla varius.
                Sed vestibulum at est ut finibus.
                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
                Proin ornare enim metus, non rutrum dolor vestibulum at.
                Praesent tincidunt gravida dolor, id sodales dolor posuere ut. Aliquam erat volutpat.
            </p>
        </div>
    </div>
</body>
</html>
',
                'language_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
//        \App\Models\ContentTranslations::insert([
//            [
//                'content_id' => 1,
//                'content' => '<meta charset="UTF-8"><meta name="viewport"
//          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge">
//<link href="https://fonts.googleapis.com/css?family=Roboto&amp;display=swap" rel="stylesheet" />
//<title></title>
//<div style="background-color: #fff; padding: 0px 30px">
//<h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px"><b>ვადები და პირობები</b></h1>
//
//<p dir="ltr">&nbsp;</p>
//
//<p><b>გთხოვთ, წაიკითხეთ ეს წესები და პირობები (შემდგომში &rdquo;T&amp;C&rdquo;) სანამ იყენებთ &rdquo;უსაფრთხო თქვენ&rdquo; მობილური პროგრამის გამოყენებას (ერთად ან ინდივიდუალურად &rdquo;სერვისით&rdquo;). თქვენი დაშვება და სერვისით სარგებლობა განპირობებულია T&amp;C&ndash; ს მიღებით და შესაბამისობით. ეს T&amp;C ვრცელდება ყველა ვიზიტორზე, მომხმარებელზე და სხვა პირებზე, რომელთაც სურთ სერვისის წვდომა ან გამოყენება (&quot;მომხმარებელი&quot;, &quot;თქვენ&quot;, &quot;თქვენი&quot;).</b></p>
//
//<p><b>სერვისით წვდომით ან გამოყენებით, თქვენ ეთანხმებით, რომ ვალდებული ხართ იყოს T&amp;C. თუ არ ეთანხმებით T&amp;C&ndash; ს რომელიმე ნაწილს, მაშინ არ გაქვთ უფლება სერვისზე წვდომა.</b></p>
//
//<p><b>სახმელეთო წესები</b></p>
//
//<p><b>უფლებამოსილება: თქვენ მხოლოდ სერვისზე შესვლის უფლება გაქვთ, თუ თქვენს ქვეყანაში იურიდიული ასაკი ხართ, ან თუ მშობლის ან მეურვის თანხმობა გაქვთ. შეიძლება გარკვეული ასაკობრივი შეზღუდვები იყოს სპეციფიკური სერვისებისთვის.</b></p>
//
//<p><b>რეგისტრაციის წესები. როდესაც ჩვენთან დარეგისტრირდებით ანგარიშზე, შემდეგი წესები გამოიყენება:</b></p>
//
//<p><b>● იყავი მართალი: მიაწოდეთ ზუსტი და მიმდინარე რეგისტრაციის შესახებ ინფორმაცია.</b></p>
//
//<p><b>● იყავი შენ: შეინახე რეგისტრაცია პერსონალური. არ დარეგისტრირდეთ ერთზე მეტი უსაფრთხო თქვენ სხვის სახელით და არ გადარიცხეთ თქვენი ანგარიში.</b></p>
//
//<p><b>● იყავი უსაფრთხო: შეინახეთ თქვენი მომხმარებლის სახელი, პაროლი და შესვლის სხვა სერთიფიკატები და არ მისცემთ საშუალებას სხვას გამოიყენოს თქვენი ანგარიში.</b></p>
//
//<p><b>● იყავით პასუხისმგებელი: დაუყოვნებლივ აცნობეთ თქვენს უსაფრთხო თქვენი ანგარიშის უნებართვო გამოყენებას. თქვენ პასუხისმგებლობთ ყველაფერზე, რაც მოხდება თქვენი უსაფრთხო თქვენ ანგარიშის საშუალებით - თქვენი ნებართვის გარეშე. მოქმედი კანონით ნებადართული მაქსიმალურად, უსაფრთხო თქვენ არ ხართ პასუხისმგებელი ნებისმიერი ზარალის ან საქმიანობის შესახებ, რომელიც გამოწვეულია თქვენი ანგარიშის უნებართვო გამოყენებით.</b></p>
//
//<p><b>მონაცემთა დაცვა</b></p>
//
//<p><b>ნებისმიერი პირადი ინფორმაცია, რომელსაც თქვენ მიაწოდებთ უსაფრთხო თქვენ, პროგრამის გამოყენებისას გამოყენებული იქნება Safe You&ndash; ს მისი კონფიდენციალურობის პოლიტიკის შესაბამისად.</b></p>
//
//<p><b>ქსელის წვდომა და მოწყობილობები</b></p>
//
//<p><b>თქვენ პასუხისმგებელნი ხართ მონაცემთა ქსელის წვდომისათვის, რომელიც აუცილებელია სერვისების გამოსაყენებლად. თქვენი მობილური ქსელის მონაცემები და შეტყობინებების განაკვეთები და მოსაკრებლები შეიძლება გამოყენებულ იქნეს, თუ თქვენ მოწყობილობასთან წვდებით ან იყენებთ სერვისებს. თქვენ ევალებათ თავსებადი ტექნიკის ან მოწყობილობების შეძენა და განახლება, რაც აუცილებელია სერვისებისა და პროგრამების და მათში ნებისმიერი განახლების შესასვლელად. უსაფრთხო თქვენ არ გაძლევთ გარანტიას, რომ სერვისები ან მისი რომელიმე ნაწილი ფუნქციონირებს ნებისმიერ აპარატურაზე ან მოწყობილობებზე. გარდა ამისა, სერვისებს შეიძლება დაექვემდებაროს გაუმართავი ფუნქციები და შეფერხებები, რომელსაც თან ახლავს ინტერნეტი და ელექტრონული კომუნიკაციები.</b></p>
//
//<p><b>ინტელექტუალური საკუთრების</b></p>
//
//<p><b>მომსახურება და მისი ორიგინალური შინაარსი, მახასიათებლები და ფუნქციონალობა არის და დარჩება Safe You- ის და მისი ლიცენზერების ექსკლუზიური საკუთრება. &quot;უსაფრთხო თქვენ&quot; და მასთან დაკავშირებული გარკვეული სახელები და ლოგოები IP უსაფრთხოა და დაცულია როგორც სომხეთის რესპუბლიკის, ისე უცხო ქვეყნის შესაბამისი კანონებით. ჩვენი IP შეიძლება არ იქნას გამოყენებული რაიმე პროდუქტთან ან მომსახურებასთან დაკავშირებით უსაფრთხო You&ndash; ს წინასწარი წერილობითი თანხმობის გარეშე.</b></p>
//
//<p><b>თუ თქვენ აკმაყოფილებთ ამ T&amp;C- ს, თქვენ უსაფრთხო გაძლევთ თქვენ შეზღუდულ, არა-ექსკლუზიურ, არაპრესანდირებულ, გაუქმებულ და შეუცვლელ ლიცენზიას: (i) თქვენს პირად მოწყობილობაზე წვდომა და სერვისები (პროგრამები) წვდომა და გამოყენება. თქვენი სერვისების გამოყენება; და (ii) ნებისმიერი შინაარსის, ინფორმაციის და მათთან დაკავშირებული მასალების წვდომა და გამოყენება, რაც შეიძლება ხელმისაწვდომი იყოს მომსახურების საშუალებით, თითოეულ შემთხვევაში მხოლოდ თქვენი პირადი, არაკომერციული გამოყენებისთვის.</b></p>
//
//<p><b>საკუთრება</b></p>
//
//<p><b>მომსახურება და ყველა უფლება მასში არის და რჩება უსაფრთხო შენების საკუთრება ან Safe You- ის ლიცენზერების საკუთრება.</b></p>
//
//<p><b>არც ეს T&amp;C და არც თქვენი სერვისების გამოყენება არ მოგცემთ რაიმე უფლებას: (i) სერვისებთან დაკავშირებული ან დაკავშირებული, გარდა ზემოთ მოყვანილი შეზღუდული ლიცენზიისა; ან (ii) გამოიყენეთ ან ნებისმიერი ფორმით გამოიყენოთ უსაფრთხო თქვენი კომპანიის სახელები, ლოგოები, პროდუქტისა და მომსახურების სახელები, IP ან მომსახურების ნიშნები ან Safe You- ის ლიცენზიატების.</b></p>
//
//<p><b>ბმულები სხვა საიტებზე, მესამე მხარის სერვისებსა და შინაარსზე</b></p>
//
//<p><b>ჩვენი სერვისი შეიძლება შეიცავდეს ბმულებს მესამე მხარის ვებსაიტებზე ან მომსახურებებზე, ან შეიძლება სერვისების ხელმისაწვდომი იყოს წვდომა მესამე მხარის სერვისებთან და შინაარსთან (რეკლამირების ჩათვლით), რომლებიც არ არის საკუთრება ან კონტროლირებადი უსაფრთხო თქვენ მიერ.</b></p>
//
//<p><b>უსაფრთხო თქვენ არ გაქვთ კონტროლი და არ აგებს პასუხისმგებლობას მესამე მხარის ვებსაიტების ან მომსახურების შინაარსზე, კონფიდენციალურობის პოლიტიკასა თუ პრაქტიკაზე. ჩვენ არ ვიძლევთ გარანტიას რომელიმე პირთა / პირთა ან მათ ვებგვერდებზე.</b></p>
//
//<p><b>თქვენ აცნობიერებთ და ეთანხმებით, რომ უსაფრთხო თქვენ არ უნდა აგოთ პასუხისმგებლობა, პასუხისმგებლობა პირდაპირ ან არაპირდაპირი გზით, ნებისმიერი ზიანის ან ზარალის შესახებ, რომელიც გამოწვეულია ან, სავარაუდოდ, გამოწვეულმა ან გამოყენებასთან დაკავშირებით ანდა რაიმე სხვა შინაარსზე, საქონელზე ან მომსახურებებზე, რომლებიც ხელმისაწვდომია ან მეშვეობით. ნებისმიერი ასეთი მესამე მხარის ვებ &ndash; გვერდი ან მომსახურება.</b></p>
//
//<p><b>ჩვენ მტკიცედ გირჩევთ, წაიკითხოთ მესამე მხარის ვებსაიტების ან სერვისების კონფიდენციალურობა და პირობები და კონფიდენციალურობის პოლიტიკა, რომელსაც ეწვიეთ.</b></p>
//
//<p><b>შეწყვეტა</b></p>
//
//<p><b>თუ ჩვენ დავადგენთ, რომ თქვენ ან თქვენი ასოცირებულ ბავშვთა ანგარიშებს არ დაურღვევიათ ამ T&amp;C- ის ნებისმიერი ტერმინი ან უსაფრთხო თქვენ სერვისებთან დაკავშირებული ნებისმიერი სხვა ტერმინი, ჩვენ შეიძლება მიიღოთ ზომები ჩვენი ინტერესების დასაცავად, მათ შორის თქვენი ანგარიშის შეწყვეტა ან შეჩერება თქვენი შვილების ან მათთან დაკავშირებული ანგარიშები, შინაარსის ავტომატური მოხსნა ან ბლოკირება, განახლებების ან მოწყობილობების განხორციელება, რომლებიც გამიზნულია უნებართვო გამოყენების შეწყვეტის მიზნით. თქვენი ანგარიშის დასრულების შემდეგ, თქვენ ვერ შეძლებთ წვდომას უსაფრთხო თქვენ სერვისებზე.</b></p>
//
//<p><b>T&amp;C&ndash; ს ყველა დებულება, რომელიც თავისი ბუნებით უნდა გადადგეს შეწყვეტას, მათ შორის, შეზღუდვის გარეშე, საკუთრების დებულებებს, საგარანტიო პასუხისმგებლობებზე პასუხისმგებლობის შეზღუდვას, ანაზღაურებას და პასუხისმგებლობის შეზღუდვას.</b></p>
//
//<p><b>ანაზღაურება</b></p>
//
//<p><b>თქვენ ეთანხმებით, რომ დაიცავით, ანაზღაურეთ და დაიცვათ უვნებელი თქვენ და მისი ლიცენზიატმა და ლიცენზიატებმა, და მათ თანამშრომლებმა, კონტრაქტორებმა, აგენტებმა, ოფიცრებმა და დირექტორებმა, ნებისმიერი და ყველა პრეტენზიის, ზიანის ანაზღაურების, ვალდებულებების, ზარალის, ვალდებულებების, ხარჯების ან დავალიანებისგან და ხარჯები (ადვოკატის მოსაკრებლების ჩათვლით, მათ შორის, მაგრამ ამით არ გამომდინარეობს) ან თქვენი მოწყობილობისა და პროგრამის გამოყენებით, თქვენი სერვისით სარგებლობა და წვდომა; ბ) ამ T&amp;C&ndash; ის დარღვევა.</b></p>
//
//<p><b>გარანტიის უარყოფა და პასუხისმგებლობის შეზღუდვა</b></p>
//
//<p><b>არანაირი გარანტია არ არის მოცემული მომსახურების ხარისხის, ფუნქციონალურობის ან შესრულების, ან ნებისმიერი შინაარსის ან მომსახურების შესახებ, რომელიც შემოთავაზებულია უსაფრთხო ან სერვისების საშუალებით. თქვენი სერვისის გამოყენება მხოლოდ თქვენს საფრთხეშია. ყველა მომსახურებას უწევს ხარვეზებს &bdquo;როგორც არის&ldquo; და &bdquo;როგორც ხელმისაწვდომი&ldquo;. ჩვენ შეიძლება შეიცვალოს, დაამატოთ ან წაშალოთ ფუნქციები ან მახასიათებლები ჩვენს მომსახურებებში და შეიძლება ჩვენ საერთოდ შეაჩერონ ან შეწყვიტოთ ჩვენი მომსახურება. ჩვენ არ ვიძლევთ გარანტიას, რომ მომსახურება და შინაარსი იქნება უწყვეტი, შეცდომების გარეშე ან შეფერხებების გარეშე. გარდა ამ შეთანხმების პასუხისმგებლობის შეზღუდვისა, ჩვენ ცალსახად ვიღებთ უარი თქვას ფიტნესის რაიმე ვარგისიანობის გარანტია კონკრეტული მიზნისა და გარღვევის გარანტიის გარანტიით.</b></p>
//
//<p><b>ჩვენ არ ვიღებთ პასუხისმგებლობას რაიმე შინაარსის, მონაცემების ან მომსახურების შეძენის, წვდომის, გადმოტვირთვის ან გამოყენების უნარის გამო. არავითარ შემთხვევაში არ უნდა იყოს პასუხისმგებელი უსაფრთხო თქვენ, არც მის დირექტორებს, თანამშრომლებს, პარტნიორებს, აგენტებს, მომწოდებლებს ან შვილობილი კომპანიებს, რომლებიც პასუხისმგებელნი არიან რაიმე არაპირდაპირი, შემთხვევითი, განსაკუთრებული, შედეგობრივი ან სადამსჯელო ზიანისთვის, მათ შორის შეზღუდვის გარეშე, მოგების დაკარგვა, მონაცემები, გამოყენება, კეთილდღეობა. ან სხვა არამატერიალური ზარალი, (i) თქვენი სერვისის წვდომის ან გამოყენების უნარს ან გამოყენებას ან გამოყენების უნარს; (ii) სამსახურის ნებისმიერი მხარის ნებისმიერი ქცევა ან შინაარსი; (iii) მომსახურებიდან მიღებული ნებისმიერი შინაარსი; და (iv) თქვენი გადაცემების ან შინაარსის უნებართვო წვდომა, გამოყენებას ან შეცვლას, გარანტიის, ხელშეკრულების, წამების (დაუდევრობის ჩათვლით) ან რაიმე სხვა იურიდიული თეორიის საფუძველზე, თუ არა ჩვენ ინფორმირებული ვიყავით ასეთი ზიანის ანაზღაურების შესაძლებლობის შესახებ და ა.შ. თუ დადგენილია, რომ ამ მუხლით დადგენილი საშუალება არ აღმოჩნდა მისი არსებითი მიზნისგან.</b></p>
//
//<p><b>შეზღუდვები.</b></p>
//
//<p><b>თქვენ არ შეგიძლიათ: (i) წაშალოთ საავტორო უფლებების, სასაქონლო ნიშნის ან სხვა საკუთრების შესახებ შეტყობინებები მომსახურების ნებისმიერი ნაწილიდან; (ii) ხელახალი ნამუშევრების რეპროდუცირება, შეცვლა, მომზადება, დისტრიბუცია, ლიცენზია, იჯარით გაცემა, გაყიდვა, გაყიდვა, გადაცემა, საჯაროდ ჩვენება, საჯაროდ შესრულება, გადაცემა, ნაკადი, მაუწყებლობა ან სხვაგვარად ექსპლუატაციის მომსახურება, გარდა იმ შემთხვევისა, რაც პირდაპირ ითხოვა უსაფრთხო თქვენმა; (iii) დაშლა, საპირისპირო ინჟინერი ან დაიშალა მომსახურება, გარდა იმ შემთხვევისა, რაც ნებადართულია მოქმედი კანონით; (iv) კავშირების, სარკისებური კავშირის, ან ჩარჩოების სერვისების ნებისმიერ ნაწილთან დაკავშირება; (v) გამოიწვიოს ან წამოიწყოს პროგრამები ან სკრიპტები სერვისების რომელიმე ნაწილის გატაცების, ინდექსების, გამოკითხვების ან სხვაგვარად მონაცემების მოპოვების მიზნით, ან ზედმეტი ტვირთი ან შეფერხება, ოპერაციების ან / და ფუნქციების ნებისმიერი ასპექტის ფუნქციონირების მიზნით; ან (vi) მცდელობა მოიპოვოს უნებართვო დაშვება ან გაუფასურდეს სერვისების ან მისი მასთან დაკავშირებული სისტემების ან ქსელების რაიმე ასპექტი.</b></p>
//
//<p><b>გამორიცხვა</b></p>
//
//<p><b>ზოგიერთი იურისდიქცია არ იძლევა გარკვეული გარანტიების გამორიცხვას ან გამორიცხვას ან პასუხისმგებლობის შეზღუდვას თანმიმდევრული ან შემთხვევითი ზიანისთვის, ასე რომ, ზემოთ ჩამოთვლილი შეზღუდვები არ შეიძლება ეხებოდეს თქვენს თავს.</b></p>
//
//<p><b>მმართველი კანონი</b></p>
//
//<p><b>ამ T&amp;C რეგულირდება და ინტერპრეტირდება სომხეთის რესპუბლიკის კანონების შესაბამისად, მისი კანონის კონფლიქტის გათვალისწინების გარეშე.</b></p>
//
//<p><b>ჩვენი შეუსრულებლობა ამ T&amp;C- ს რაიმე უფლება ან დებულება არ განიხილება ამ უფლებების უგულებელყოფად. თუ ამ T&amp;C&ndash; ის რომელიმე დებულება სასამართლოს მიერ ბათილად ან არასრულად ითვლება, ამ T&amp;C&ndash; ს დანარჩენი დებულებები ძალაში შევა. ეს T&amp;C წარმოადგენს ჩვენს შეთანხმებას ჩვენს სერვისთან დაკავშირებით, და გადაჩერდება და ჩაანაცვლებს წინა ხელშეკრულებებს, რაც შეიძლება გქონოდა ჩვენს შორის მომსახურების შესახებ.</b></p>
//
//<p><b>მომხმარებელი თანახმაა წარუდგინოს იურისდიქცია სომხეთის რესპუბლიკაში და ასევე თანხმდება, რომ ნებისმიერი დავა, რომელიც არ წყდება მოლაპარაკებებით, მოქმედების მიზეზით, რომელიც წარმოიქმნება ამ T&amp;C- ის პირობებში, უნდა წარმოიშვას ექსკლუზიურად სომხეთის რესპუბლიკის კომპეტენტურ სახელმწიფო სასამართლოებში.</b></p>
//
//<p><b>ცვლილებები</b></p>
//
//<p><b>ჩვენი T&amp;C შეიძლება შეიცვალოს. ზოგიერთ იურისდიქციაში არ არის დაშვებული ცალმხრივი განახლებები ან ცვლილებები მომხმარებლის თვალსაზრისით, ასე რომ, ეს პუნქტი შეიძლება არ იყოს გამოყენებული თქვენთვის. ჩვენ შეიძლება დროდადრო განაახლონ ეს T&amp;C. თუ მატერიალური ცვლილება განხორციელდა, ჩვენ გამოვაქვეყნებთ შეტყობინებას. წაიკითხეთ ნებისმიერი ცვლილება და თუ არ ეთანხმებით მათ, გთხოვთ შეწყვიტეთ მომსახურების გამოყენება. თუ თქვენ კვლავაც იყენებთ სერვისის გამოყენებას მას შემდეგ, რაც ჩვენ შეგატყობინებთ ცვლილებებს, თქვენ ჩაითვლება, რომ მიიღეთ განახლებული T&amp;C, გარდა იმ კანონით, რომელიც აკრძალულია მოქმედი კანონით.</b></p>
//
//<p><b>ჩვენ ვიტოვებთ უფლებას, ჩვენი შეხედულებისამებრ, შეცვალონ ან შეცვალონ ეს T&amp;C ნებისმიერ დროს.</b></p>
//
//<p><b>ნებისმიერი სერვისის განახლების ძალაში შესვლის შემდეგ ჩვენს სერვისზე წვდომის გაგრძელებით, თქვენ ეთანხმებით რომ შესწორებული პირობებით იმოქმედებთ. თუ არ ეთანხმებით ახალ პირობებს, თქვენ აღარ ხართ უფლებამოსილი გამოიყენოს მომსახურება.</b></p>
//
//<p><b>დაგვიკავშირდით</b></p>
//
//<p><b>თუ თქვენ გაქვთ რაიმე შეკითხვები ამ კონფიდენციალურობის პოლიტიკასთან დაკავშირებით, დაგვიკავშირდით <a href="mailto:info@eif.am">info@eif.am</a></b></p>
//
//<p dir="ltr"><b id="docs-internal-guid-d9383b9e-7fff-97fc-b789-bb029e99f099">&nbsp;</b></p>
//
//<p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">&nbsp;</p>
//</div>
//',
//                'language_id' => 3,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
//        \App\Models\ContentTranslations::insert([
//            [
//                'content_id' => 1,
//                'content' => '<!doctype html>
//<html lang="en">
//<head>
//    <meta charset="UTF-8">
//    <meta name="viewport"
//          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//    <meta http-equiv="X-UA-Compatible" content="ie=edge">
//    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
//    <title>Terms & Conditions</title>
//</head>
//<body style="margin: 0px; padding: 0px">
//    <div style="background-color: #fff; padding: 0px 30px">
//        <div>
//            <h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">Terms & Conditions Az</h1>
//            <span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Nam a purus non turpis 2019</span>
//            <p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
//                Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
//                Praesent venenatis elementum nulla ac venenatis.
//                Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
//                Morbi justo felis, tempus id quam in, iaculis consequat quam.
//                Praesent cursus sapien eu libero fringilla varius.
//                Sed vestibulum at est ut finibus.
//                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
//                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
//                Proin ornare enim metus, non rutrum dolor vestibulum at.
//                Praesent tincidunt gravida dolor, id sodales dolor posuere ut.
//                Aliquam erat volutpat.Nam a purus non turpis venenatis volutpat hendrerit vitae orci.
//                Praesent venenatis elementum nulla ac venenatis. Morbi vehicula porttitor orci, condimentum tincidunt elit faucibus sed.
//                Morbi justo felis, tempus id quam in, iaculis consequat quam.
//                Praesent cursus sapien eu libero fringilla varius.
//                Sed vestibulum at est ut finibus.
//                Ut blandit, dolor eget viverra maximus, mauris nulla dignissim nibh, id venenatis lorem nisi non eros.
//                Pellentesque orci eros, viverra et quam sed, tincidunt vehicula turpis.
//                Proin ornare enim metus, non rutrum dolor vestibulum at.
//                Praesent tincidunt gravida dolor, id sodales dolor posuere ut. Aliquam erat volutpat.
//            </p>
//        </div>
//    </div>
//</body>
//</html>
//',
//                'language_id' => 4,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
        \App\Models\Contents::insert([
            [
                'title' => 'about_us',
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\ContentTranslations::insert([
            [
                'content_id' => 2,
                'content' => '<meta charset="UTF-8"><meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge">
<link href="https://fonts.googleapis.com/css?family=Roboto&amp;display=swap" rel="stylesheet" />
<title></title>
<div style="background-color: #fff; padding: 0px 30px">
<h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">About us</h1>

<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Our story</span></p>

<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">In 2018, 11 Organizations from different countries won the SVRI and World Bank Group Development Marketplace for Innovation in GBV Prevention and Response grants.&nbsp;<br />
Enterprise Incubator Foundation (EIF) was among the winners with the project &ldquo;Geeks against GBV: unlocking potential of new change MAKERS and leveraging ICT solutions&rdquo;.&nbsp;<br />
Since then, EIF was responsible for coordinating activities aimed at designing a mobile application and liaising with IT sector professionals and GBV experts.</span></p>

<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">The EIF team believes that tech solutions can be the driving force in combating violence against women as well as empowering women. By carefully developing tools that are geared specifically to women and their needs we believe that the worldwide GBV epidemic can be curbed.</span></p>

<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Our GOAL</span></p>

<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">We designed an app for Women with the goal to enhance their safety, empower them and transform their quality of life.<br />
Safe YOU is a virtual Safe Space for women that provides them with easy access to support (Network) and safety services (Help).&nbsp;<br />
We believe that exchange of knowledge, different experiences and success stories will make women stronger and will disrupt the stigma that is blocking their path to empowerment. This is why we emphasize the importance of discussion boards (Forums) and we are grateful to our partner NGOs and professionals for their involvement in the discussions and suggestions to our users.&nbsp;Should you have any&nbsp;questions and suggestions regarding the application, please write to EIF&nbsp;e-mail address: </span><span style="font-size:14px;"><a href="mailto:info@eif.am" target="_blank">info@eif.am</a></span></p>
</div>',
                'language_id' => 1,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
        \App\Models\ContentTranslations::insert([
            [
                'content_id' => 2,
                'content' => '<meta charset="UTF-8"><meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge">
<link href="https://fonts.googleapis.com/css?family=Roboto&amp;display=swap" rel="stylesheet" />
<title></title>
<div style="background-color: #fff; padding: 0px 30px">
<div>
<h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">ՄԵՐ ՄԱՍԻՆ</h1>
<span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Մեր պատմությունը </span>

<p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">2018-ին տարբեր երկրներից 11 կազմակերպություններ շահեցին SVRI- ի և Համաշխարհային բանկի խմբի դրամաշնորհներ`սեռի հիմքով բռնության դեմ պայքարում լուծումներ առաջարկող ծրագրերի համար:&nbsp;<br />
Ձեռնարկությունների ինկուբատոր հիմնադրամը (ՁԻՀ) հաղթողներից մեկն էր ՝&nbsp;<br />
Այդ ժամանակից ի վեր, ՁԻՀ-ը պատասխանատու է բջջային հավելվածի ստեղծման և այդ ընթացքում ՏՏ ոլորտի մասնագետների և կանանց նկատմամբ բռնության հարցերով զբաղվող փորձագետների հետ աշխատանքները համակարգելու գործում:&nbsp;<br />
ՁԻՀ-ի թիմը հավատումէ, որ տեխնոլոգիական լուծումները կարող են լինել շարժիչ ուժ `ինչպես կանանց հզորացման, այնպես էլ կանանց նկատմամբ բռնության դեմ պայքարում: Զարգացնելով գործիքներ, որոնք հատուկ ուղղված են կանանց և նրանց կարիքներին, մենք հավատում ենք, որ կանանց նկատմամբբռնության համաշխարհային համաճարակը հնարավոր է զսպել:</p>
<span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Մեր նպատակը</span>

<p style="color: #1D1D1D; font-size: 17px; font-family: \'Roboto\', Regular; letter-spacing: -0.41px; line-height: 22px">Մենք ստեղծելենք լուծում կանանց համար` նպատակ ունենալով բարձրացնել նրանց անվտանգությունապահովումը, հզորացնել նրանց և վերափոխել նրանց կյանքի որակը:<br />
Safe YOU- ն կանանց համար վիրտուալ ապահով տարածք է, որը նրանց հնարավորություն է տալիս հեշտությամբ օգտվել աջակցության (Ցանց) և անվտանգության ծառայություննեիցր (Կանչ):<br />
Մենք հավատում ենք, որ գիտելիքների, փորձի և հաջողության պատմություննեիփոխանակում կանանց կդարձնեն ավելի ուժեղ և կվերացնեն այն ստիգման, որն արգելափակում է նրանց հզորացման ճանապարհին: Ահա թե ինչու ենք մենք կարևորում քննարկումների (Ֆորումների) կարևորությունը, և երախտապարտ ենք մեր գործընկեր ՀԿ-ներին և մասնագետներին քննարկումներին ներգրավվելու և մեր օգտատերերին կարևոր խորհուրդներ տալու համար:&nbsp;Հավելվածի հետ կապված հարցերի և առաջարկությունների դեպքում խնդրում ենք գրել ՁԻՀ-ի էլ-հասցեին`&nbsp;<a href="mailto:info@eif.am" target="_blank">info@eif.am</a>&nbsp;&nbsp;</p>
</div>
</div>',
                'language_id' => 2,
                "created_at" => $faker->dateTimeThisMonth(),
            ]
        ]);
//        \App\Models\ContentTranslations::insert([
//            [
//                'content_id' => 2,
//                'content' => '<meta charset="UTF-8"><meta name="viewport"
//          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge">
//<link href="https://fonts.googleapis.com/css?family=Roboto&amp;display=swap" rel="stylesheet" />
//<title></title>
//<div style="background-color: #fff; padding: 0px 30px">
//<h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">ჩვენს შესახებ</h1>
//
//<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">ჩვენი ამბავი</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">2018 წელს, სხვადასხვა ქვეყნიდან 11 ორგანიზაციამ გაიმარჯვა SVRI და მსოფლიო ბანკის ჯგუფის განვითარების ბაზარი ინოვაციისთვის GBV პრევენციისა და რეაგირების გრანტებში.<br />
//საწარმოთა ინკუბატორის ფონდი (EIF) გამარჯვებულთა შორის იყო პროექტი &quot;Geeks GBV- ს წინააღმდეგ: ახალი ცვლილების შემქმნელთა პოტენციალის განბლოკვა და ICT გადაწყვეტილებების ბერკეტი&quot;.<br />
//მას შემდეგ, EIF იყო პასუხისმგებელი საქმიანობის კოორდინაციისთვის, რომელიც მიზნად ისახავდა მობილური პროგრამის შექმნას და IT სექტორის პროფესიონალებთან და GBV ექსპერტებთან დაკავშირებას.</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">EIF ჯგუფის აზრით, ტექნიკური გადაწყვეტილებები შეიძლება იყოს წამყვანი ძალა ქალთა მიმართ ძალადობის წინააღმდეგ, ისევე როგორც ქალების უფლებამოსილება. ქალთა და მათი საჭიროებების შესახებ სპეციალურად გამზადებული ინსტრუმენტების ყურადღებით შემუშავებით, მიგვაჩნია, რომ მსოფლიოში GBV ეპიდემიის შემცირება შესაძლებელია.</span></p>
//
//<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">ჩვენი მიზანი</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">ჩვენ შევიმუშავეთ აპლიკაცია ქალებისთვის, რომლის მიზანია მათი უსაფრთხოების გაზრდა, მათი გაძლიერება და მათი ცხოვრების ხარისხის გარდაქმნა.<br />
//უსაფრთხო YOU არის ვირტუალური უსაფრთხო სივრცე ქალებისთვის, რომელიც მათ მარტივად მიუწვდება მხარდაჭერას (ქსელი) და უსაფრთხოების სერვისები (დახმარება).<br />
//ჩვენ მიგვაჩნია, რომ ცოდნის გაცვლა, განსხვავებული გამოცდილება და წარმატების ისტორიები ქალებს აძლიერებს და ხელს შეუშლის სტიგმას, რომელიც ბლოკავს მათ გზას გაძლიერებისაკენ. სწორედ ამიტომ, ჩვენ ხაზს ვუსვამთ სადისკუსიო ფორუმების (ფორუმების) მნიშვნელობას და მადლობელი ვართ ჩვენი პარტნიორი არასამთავრობო ორგანიზაციებისა და პროფესიონალებისთვის, რომ მათ მონაწილეობდნენ დისკუსიებში და შემოთავაზებებს ჩვენი მომხმარებლებისთვის. თუ თქვენ გაქვთ შეკითხვები და წინადადებები, გთხოვთ, მოგვწერეთ EIF&ndash; ის ელექტრონულ ფოსტაზე: <a href="mailto:info@eif.am">info@eif.am</a></span></p>
//</div>
//',
//                'language_id' => 3,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);
//        \App\Models\ContentTranslations::insert([
//            [
//                'content_id' => 2,
//                'content' => '<meta charset="UTF-8"><meta name="viewport"
//          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge">
//<link href="https://fonts.googleapis.com/css?family=Roboto&amp;display=swap" rel="stylesheet" />
//<title></title>
//<div style="background-color: #fff; padding: 0px 30px">
//<h1 style="font-size: 28px; color: #000; font-family: \'Roboto\', Bold; margin: 0px">About us Az</h1>
//
//<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Our story</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">In 2018, 11 Organizations from different countries won the SVRI and World Bank Group Development Marketplace for Innovation in GBV Prevention and Response grants.&nbsp;<br />
//Enterprise Incubator Foundation (EIF) was among the winners with the project &ldquo;Geeks against GBV: unlocking potential of new change MAKERS and leveraging ICT solutions&rdquo;.&nbsp;<br />
//Since then, EIF was responsible for coordinating activities aimed at designing a mobile application and liaising with IT sector professionals and GBV experts.</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">The EIF team believes that tech solutions can be the driving force in combating violence against women as well as empowering women. By carefully developing tools that are geared specifically to women and their needs we believe that the worldwide GBV epidemic can be curbed.</span></p>
//
//<p><span style="color: #DCB1E9; font-size: 16px; font-family: \'Roboto\', Regular; letter-spacing: -0.32px; line-height: 21px">Our GOAL</span></p>
//
//<p><span style="color: rgb(29, 29, 29); font-family: Roboto, Regular; font-size: 17px; letter-spacing: -0.41px;">We designed an app for Women with the goal to enhance their safety, empower them and transform their quality of life.<br />
//Safe YOU is a virtual Safe Space for women that provides them with easy access to support (Network) and safety services (Help).&nbsp;<br />
//We believe that exchange of knowledge, different experiences and success stories will make women stronger and will disrupt the stigma that is blocking their path to empowerment. This is why we emphasize the importance of discussion boards (Forums) and we are grateful to our partner NGOs and professionals for their involvement in the discussions and suggestions to our users.&nbsp;Should you have any&nbsp;questions and suggestions regarding the application, please write to EIF&nbsp;e-mail address: </span><span style="font-size:14px;"><a href="mailto:info@eif.am" target="_blank">info@eif.am</a></span></p>
//</div>',
//                'language_id' => 4,
//                "created_at" => $faker->dateTimeThisMonth(),
//            ]
//        ]);


    }
}
