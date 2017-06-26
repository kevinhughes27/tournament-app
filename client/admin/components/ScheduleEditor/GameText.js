import React from 'react'

export default function GameText (game) {
  if (game.bracket) {
    return (
      <div style={{width: '100%'}}>
        <h4>{game.bracket_uid}</h4>
        {game.home_prereq} v {game.away_prereq}
      </div>
    )
  } else {
    return (
      <div style={{width: '100%'}}>
        <h4>{game.pool}</h4>
        {game.home_pool_seed} v {game.away_pool_seed}
      </div>
    )
  }
}
