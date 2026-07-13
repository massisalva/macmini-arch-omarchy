// Mac mini 2014: VA-API Haswell acelera H.264, pero no VP9 ni AV1.
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.av1.enabled", false);
