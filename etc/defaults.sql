update settings set value="/usr/bin/unrar" where name="unrarpath";
update settings set value="/usr/bin/ffmpeg" where name="ffmpegpath";
update settings set value="/usr/local/bin/mediainfo" where name="mediainfopath";
update settings set value="/usr/bin/7za" where name="7zippath";
update settings set value="/usr/bin/timeout" where name="timeoutpath";
# Has to be turned on for the rest of "additional postprocessing" to work
update settings set value=1 where name="checkpasswordedrar";
update settings set value=1 where name="deletepasswordedrelease";
update settings set value=1 where name="deletepossiblerelease";
update settings set value="http://www.dereferer.org/?" where name="dereferrer_link";
update settings set value=1 where name="processjpg";
update settings set value=1 where name="processthumbnails";
update settings set value=1 where name="compressedheaders";
# 1 = scan back based on # of days, not # of posts
update settings set value=1 where name="newgroupscanmethod";
select name, value from settings where name in (
  'unrarpath', 'ffmpegpath', 'mediainfopath', '7zippath', 'timeoutpath', 'processjpg', 
  'processthumbnails', 'compressedheaders', 'checkpasswordedrar',
  'newgroupscanmethod', 'dereferrer_link', 'deletepasswordedrar', 
  'deletepossiblerelease');

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

update tmux set value=1 where setting="run_ircscraper";

# Safe backfill
update tmux set value=4 where setting="backfill";

# Decrypt hashes
# 0 = Disabled
# 1 = Decrypt hashes
# 2 = PreDB
# 3 = All
update tmux set value=3 where setting="dehash";
