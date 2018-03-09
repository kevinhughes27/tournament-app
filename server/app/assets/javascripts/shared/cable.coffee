#= require action_cable

window.UT ||= {}

UT.cable = ActionCable.createConsumer('/cable')
