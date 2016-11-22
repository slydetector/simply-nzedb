update settings set value="/usr/bin/unrar" where name="unrarpath";
update settings set value="/usr/bin/ffmpeg" where name="ffmpegpath";
update settings set value="/usr/local/bin/mediainfo" where name="mediainfopath";
update settings set value="/usr/bin/7za" where name="7zippath";
update settings set value="/usr/bin/timeout" where name="timeoutpath";
update settings set value=1 where name="processjpg";
update settings set value=1 where name="processthumbnails";
select name, value from settings where name in ('unrarpath', 'ffmpegpath', 'mediainfopath', '7zippath', 'timeoutpath', 'processjpg', 'processthumbnails');

update groups set active=1 where name="alt.binaries.teevee";

update tmux set value=1 where setting="binaries";
update tmux set value=1 where setting="releases";

# 0 = Disabled
# 1 = Post process additional
# 2 = Post process NFOs
# 3 = Post process all
update tmux set value=3 where setting="post"; 

update tmux set value=1 where setting="post_amazon";
update tmux set value=1 where setting="post_non";
update tmux set value=1 where setting="fix_names";
update tmux set value=1 where setting="mytop";
update tmux set value=1 where setting="console";

# 0 = Disabled
# 1 = Import - Do not use filenames
# 2 = Import - Use filenames
update tmux set value=1 where setting="import";
update tmux set value="/var/www/nZEDb/resources/import" where setting="nzbs";

