@canVibrate = "vibrate" in navigator || "mozVibrate" in navigator

if (@canVibrate && !("vibrate" in navigator))
  navigator.vibrate = navigator.mozVibrate
