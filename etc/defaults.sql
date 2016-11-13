update settings set value="/usr/bin/unrar" where name="unrarpath";
update settings set value="/usr/bin/ffmpeg" where name="ffmpegpath";
update settings set value="/usr/local/bin/mediainfo" where name="mediainfopath";
update settings set value="/usr/bin/7za" where name="7zippath";
update settings set value="/usr/bin/timeout" where name="timeoutpath";
select name, value from settings where name in ('unrarpath', 'ffmpegpath', 'mediainfopath', '7zippath', 'timeoutpath');
update groups set active=1 where name="alt.binaries.teevee";


