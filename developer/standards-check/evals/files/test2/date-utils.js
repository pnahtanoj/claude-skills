const DEFAULT_LOCALE = 'en-US'
const DEFAULT_FORMAT = 'short'

async function fetchServerTime() {
  try {
    const res = await fetch('/api/time')
    const data = await res.json()
    return data.timestamp
  } catch (err) {
    console.error('Failed to fetch server time:', err)
    throw err
  }
}

function formatDate(date, locale = DEFAULT_LOCALE, format = DEFAULT_FORMAT) {
  return new Intl.DateTimeFormat(locale, { dateStyle: format }).format(date)
}

function parseDate(str) {
  return new Date(str)
}

export default { fetchServerTime, formatDate, parseDate }
