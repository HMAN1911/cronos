used timestamptz to create timezone-aware time entries.

### observations

It is not a Date object, neither is it a time Object. It is a ActiveSupport::TimeWithZone object. One important thing is I need to do a `require 'Date'` for this to work.

We reach a fork in the road here. I think I fully grasp how it works. It looks like saving the time into the database even with time information still eventually 'sanitises' the entry back to UTC. This is actually a good thing. It allows a client to give their 'local' time, and the database will adjust that to UTC on its own, accounting for the time difference. That being said, Once the data is committed, the timezone information is lost.

With the example above, the server commits the time as `2016-04-18 09:23:50 UTC`.

If we run a `.in_time_zone('Wellington')`, this nicely displays the time again in the format we want:

```
Mon, 18 Apr 2016 21:23:50 NZST +12:00
```

The real question here is, do we need to record timezone information in a separate column? If we really wanted to take it a step further, the ideal model would be to have a separate time zone table, storing both the abbreviated time zone 'NZST', and the full reference to it 'Wellington'.

---

## Database Structure

Eventually, I need many-to-many mapping on events and users. But for this initial version, I will limit it to one user has many events.

### Phase 1

tables: Users, Events, Clients

views: Registration, Login, show events, create event, edit event.

### Phase 2

tables: Users, Events, Clients, Companies

views: single page application. Detailed / filterable displays for events.

allow google Oauth login.
https://developers.google.com/identity/sign-in/web/sign-in#specify_your_apps_client_id

## Front-End libraries

Awesome looking progress bar:
http://ricostacruz.com/nprogress/

Super clean and functional date / time pickers:
https://eonasdan.github.io/bootstrap-datetimepicker/#bootstrap-3-datepicker-v4-docs

another decent-looking option:
http://amsul.ca/pickadate.js/

looks like we need to include JQuery, for bootstrap and probably the date-pickers.

how to do a post request with JQuery:
http://api.jquery.com/jquery.post/










### Other Notes

the full mapping:

```
MAPPING = { "International Date Line West" => "Pacific/Midway", "Midway Island" => "Pacific/Midway", "Samoa" => "Pacific/Pago_Pago", "Hawaii" => "Pacific/Honolulu", "Alaska" => "America/Juneau", "Pacific Time (US & Canada)" => "America/Los_Angeles", "Tijuana" => "America/Tijuana", "Mountain Time (US & Canada)" => "America/Denver", "Arizona" => "America/Phoenix", "Chihuahua" => "America/Chihuahua", "Mazatlan" => "America/Mazatlan", "Central Time (US & Canada)" => "America/Chicago", "Saskatchewan" => "America/Regina", "Guadalajara" => "America/Mexico_City", "Mexico City" => "America/Mexico_City", "Monterrey" => "America/Monterrey", "Central America" => "America/Guatemala", "Eastern Time (US & Canada)" => "America/New_York", "Indiana (East)" => "America/Indiana/Indianapolis", "Bogota" => "America/Bogota", "Lima" => "America/Lima", "Quito" => "America/Lima", "Atlantic Time (Canada)" => "America/Halifax", "Caracas" => "America/Caracas", "La Paz" => "America/La_Paz", "Santiago" => "America/Santiago", "Newfoundland" => "America/St_Johns", "Brasilia" => "America/Argentina/Buenos_Aires", "Buenos Aires" => "America/Argentina/Buenos_Aires", "Georgetown" => "America/Argentina/San_Juan", "Greenland" => "America/Godthab", "Mid-Atlantic" => "Atlantic/South_Georgia", "Azores" => "Atlantic/Azores", "Cape Verde Is." => "Atlantic/Cape_Verde", "Dublin" => "Europe/Dublin", "Edinburgh" => "Europe/Dublin", "Lisbon" => "Europe/Lisbon", "London" => "Europe/London", "Casablanca" => "Africa/Casablanca", "Monrovia" => "Africa/Monrovia", "UTC" => "Etc/UTC", "Belgrade" => "Europe/Belgrade", "Bratislava" => "Europe/Bratislava", "Budapest" => "Europe/Budapest", "Ljubljana" => "Europe/Ljubljana", "Prague" => "Europe/Prague", "Sarajevo" => "Europe/Sarajevo", "Skopje" => "Europe/Skopje", "Warsaw" => "Europe/Warsaw", "Zagreb" => "Europe/Zagreb", "Brussels" => "Europe/Brussels", "Copenhagen" => "Europe/Copenhagen", "Madrid" => "Europe/Madrid", "Paris" => "Europe/Paris", "Amsterdam" => "Europe/Amsterdam", "Berlin" => "Europe/Berlin", "Bern" => "Europe/Berlin", "Rome" => "Europe/Rome", "Stockholm" => "Europe/Stockholm", "Vienna" => "Europe/Vienna", "West Central Africa" => "Africa/Algiers", "Bucharest" => "Europe/Bucharest", "Cairo" => "Africa/Cairo", "Helsinki" => "Europe/Helsinki", "Kyev" => "Europe/Kiev", "Riga" => "Europe/Riga", "Sofia" => "Europe/Sofia", "Tallinn" => "Europe/Tallinn", "Vilnius" => "Europe/Vilnius", "Athens" => "Europe/Athens", "Istanbul" => "Europe/Istanbul", "Minsk" => "Europe/Minsk", "Jerusalem" => "Asia/Jerusalem", "Harare" => "Africa/Harare", "Pretoria" => "Africa/Johannesburg", "Moscow" => "Europe/Moscow", "St. Petersburg" => "Europe/Moscow", "Volgograd" => "Europe/Moscow", "Kuwait" => "Asia/Kuwait", "Riyadh" => "Asia/Riyadh", "Nairobi" => "Africa/Nairobi", "Baghdad" => "Asia/Baghdad", "Tehran" => "Asia/Tehran", "Abu Dhabi" => "Asia/Muscat", "Muscat" => "Asia/Muscat", "Baku" => "Asia/Baku", "Tbilisi" => "Asia/Tbilisi", "Yerevan" => "Asia/Yerevan", "Kabul" => "Asia/Kabul", "Ekaterinburg" => "Asia/Yekaterinburg", "Islamabad" => "Asia/Karachi", "Karachi" => "Asia/Karachi", "Tashkent" => "Asia/Tashkent", "Chennai" => "Asia/Kolkata", "Kolkata" => "Asia/Kolkata", "Mumbai" => "Asia/Kolkata", "New Delhi" => "Asia/Kolkata", "Kathmandu" => "Asia/Katmandu", "Astana" => "Asia/Dhaka", "Dhaka" => "Asia/Dhaka", "Sri Jayawardenepura" => "Asia/Dhaka", "Almaty" => "Asia/Almaty", "Novosibirsk" => "Asia/Novosibirsk", "Rangoon" => "Asia/Rangoon", "Bangkok" => "Asia/Bangkok", "Hanoi" => "Asia/Bangkok", "Jakarta" => "Asia/Jakarta", "Krasnoyarsk" => "Asia/Krasnoyarsk", "Beijing" => "Asia/Shanghai", "Chongqing" => "Asia/Chongqing", "Hong Kong" => "Asia/Hong_Kong", "Urumqi" => "Asia/Urumqi", "Kuala Lumpur" => "Asia/Kuala_Lumpur", "Singapore" => "Asia/Singapore", "Taipei" => "Asia/Taipei", "Perth" => "Australia/Perth", "Irkutsk" => "Asia/Irkutsk", "Ulaan Bataar" => "Asia/Ulaanbaatar", "Seoul" => "Asia/Seoul", "Osaka" => "Asia/Tokyo", "Sapporo" => "Asia/Tokyo", "Tokyo" => "Asia/Tokyo", "Yakutsk" => "Asia/Yakutsk", "Darwin" => "Australia/Darwin", "Adelaide" => "Australia/Adelaide", "Canberra" => "Australia/Melbourne", "Melbourne" => "Australia/Melbourne", "Sydney" => "Australia/Sydney", "Brisbane" => "Australia/Brisbane", "Hobart" => "Australia/Hobart", "Vladivostok" => "Asia/Vladivostok", "Guam" => "Pacific/Guam", "Port Moresby" => "Pacific/Port_Moresby", "Magadan" => "Asia/Magadan", "Solomon Is." => "Asia/Magadan", "New Caledonia" => "Pacific/Noumea", "Fiji" => "Pacific/Fiji", "Kamchatka" => "Asia/Kamchatka", "Marshall Is." => "Pacific/Majuro", "Auckland" => "Pacific/Auckland", "Wellington" => "Pacific/Auckland", "Nuku'alofa" => "Pacific/Tongatapu"
```
