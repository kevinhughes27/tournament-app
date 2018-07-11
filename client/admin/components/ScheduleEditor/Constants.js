import ls from 'local-storage'

export const SCHEDULE_START = 8
export const SCHEDULE_END = 16
export const SCHEDULE_INC = ls.get('SCHEDULE_INC') || 15 // minutes
export const DEFAULT_LENGTH = 90 // minutes

export const ItemTypes = {
  GAME: 'game'
}

export const DIVISION_COLORS = [
  '#a6cee3',
  '#1f78b4',
  '#b2df8a',
  '#33a02c',
  '#fb9a99',
  '#e31a1c',
  '#fdbf6f',
  '#ff7f00',
  '#cab2d6',
  '#6a3d9a',
  '#ffcc00',
  '#ff0066'
]
