import GamesStore from '../../stores/GamesStore'

export function schedule (gameId, fieldId, startTime, endTime) {
  GamesStore.updateGame({
    id: gameId,
    field_id: fieldId,
    start_time: startTime,
    end_time: endTime,
    scheduled: true
  })

  $.ajax({
    type: 'POST',
    url: '/admin/schedule',
    data: {
      game_id: gameId,
      field_id: fieldId,
      start_time: startTime,
      end_time: endTime
    },
    success: (response) => {
      GamesStore.updateGame({
        id: response.game_id,
        field_id: response.field_id,
        start_time: response.start_time,
        end_time: response.end_time,
        updated_at: response.updated_at,
        error: false
      })

      console.log(`game_id: ${gameId} successfully scheduled at ${startTime} to ${endTime}`)
    },
    error: (response) => {
      GamesStore.updateGame({
        id: response.responseJSON.game_id,
        field_id: response.responseJSON.field_id,
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

export function resize (gameId, endTime) {
  GamesStore.updateGame({
    id: gameId,
    end_time: endTime
  })
}
