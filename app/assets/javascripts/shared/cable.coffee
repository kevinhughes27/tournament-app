#= require cable

window.UT ||= {}

UT.cable = Cable.createConsumer('ws://no-borders.lvh.me:28080')
