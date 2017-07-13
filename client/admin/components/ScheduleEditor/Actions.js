import GamesStore from '../../stores/GamesStore'

export function schedule (gameId, fieldId, startTime) {
  GamesStore.updateGame({
    id: gameId,
    field_id: fieldId,
    start_time: startTime,
    scheduled: true
  })

  $.ajax({
    type: 'POST',
    url: '/admin/schedule',
    data: {
      game_id: gameId, field_id: fieldId, start_time: startTime
    },
    success: (response) => {
      GamesStore.updateGame({
        id: gameId,
        start_time: response.start_time,
        end_time: response.end_time,
        error: false
      })

      console.log(`game_id: ${gameId} successfully scheduled.`)
    },
    error: (response) => {
      GamesStore.updateGame({
        id: gameId,
        start_time: response.responseJSON.start_time,
        end_time: response.responseJSON.end_time,
        error: true
      })

      if (response.status === 422) {
        Admin.Flash.error(response.responseJSON.error)
      } else {
        Admin.Flash.error('Sorry, something went wrong.')
      }
    }
  })
}

export function unschedule (gameId) {
  GamesStore.updateGame({
    id: gameId,
    scheduled: false
  })

  $.ajax({
    type: 'DELETE',
    url: '/admin/schedule',
    data: { game_id: gameId },
    success: (response) => {
      console.log(`game_id: ${gameId} successfully unscheduled.`)
    },
    error: (response) => {
      GamesStore.updateGame({id: gameId, scheduled: true})
      Admin.Flash.error('Sorry, something went wrong.')
    }
  })
}
